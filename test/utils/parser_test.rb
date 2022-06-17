require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  test 'validates a complex object' do
    user_parser = Parser::Struct.new(
      name: Parser::Struct.new(
        first: Parser::Text.new,
        last: Parser::Text.new.verifying(Parser::Constraint.non_empty),
        middle: Parser::Text.new.optional,
      ).map { |name| "#{name[:first]}#{name[:middle] ? " #{name[:middle]}" : ''} #{name[:last]}" },
      birth: Parser::DateTime.new,
      kind: Parser::Constant.new('patient'),
      score: Parser::Number.new(min: 0, max: 100),
      tags: Parser::List.new(Parser::Text.new),
      role: Parser::Custom.new('is not admin') { |role| role == 'admin' ? 'ADMIN' : raise(ArgumentError) },
    )

    result = user_parser.run({
                               name: { first: 'Loïc', last: 'Knuchel' },
                               birth: '1988-04-09',
                               score: 10,
                               tags: %w[dev code],
                               role: 'admin',
                             })
    expected = {
      name: 'Loïc Knuchel',
      birth: Time.utc(1988, 4, 9),
      kind: 'patient',
      score: 10,
      tags: %w[dev code],
      role: 'ADMIN'
    }
    assert_success expected, result
  end

  test 'parse a string' do
    assert_success 'Loïc', Parser::Text.new.run('Loïc')
    assert_failure Parser::InvalidError.new('', 1, 'is not a string'), Parser::Text.new.run(1)
    assert_failure Parser::InvalidError.new('', 'aaa', 'has less than 4 characters'), Parser::Text.new(min: 4).run('aaa')
    assert_failure Parser::InvalidError.new('', 'aaa', 'has more than 2 characters'), Parser::Text.new(max: 2).run('aaa')
    assert_failure Parser::InvalidError.new('', 'aaa', 'does not match /\d+/'), Parser::Text.new(regex: /\d+/).run('aaa')
    assert_success '123', Parser::Text.new(min: 2, max: 4, regex: /\d+/).run('123')
  end
  test 'parse a number' do
    assert_success 1, Parser::Number.new.run(1)
    assert_success 1, Parser::Number.new(&:to_i).run('1')
    assert_failure Parser::InvalidError.new('', '1', 'is not a number'), Parser::Number.new.run('1')
  end
  test 'parse a boolean' do
    assert_success true, Parser::Bool.new.run(true)
    assert_success true, Parser::Bool.new.run('true')
    assert_failure Parser::InvalidError.new('', '1', 'is not a boolean'), Parser::Bool.new.run('1')
  end
  test 'parse a date' do
    assert_success Time.utc(2022, 05, 01), Parser::DateTime.new.run('2022-05-01')
    assert_success Time.utc(2022, 05, 01, 14, 15, 16), Parser::DateTime.new.run('2022-05-01 14:15:16')
    assert_failure Parser::InvalidError.new('', '1', 'is not a date'), Parser::DateTime.new.run('1')
  end
  test 'parse a constant' do
    assert_success 'Hi', Parser::Constant.new('Hi').run(nil)
  end
  test 'parse in an enum' do
    assert_success 'admin', Parser::Enum.new(%w[admin guest]).run('admin')
    assert_success 1, Parser::Enum.new([1, '2', true]).run(1)
    assert_success '2', Parser::Enum.new([1, '2', true]).run('2')
    assert_failure Parser::InvalidError.new('', 'bad', 'is not in values: "admin", "guest"'), Parser::Enum.new(%w[admin guest]).run('bad')
  end
  test 'parse a list' do
    assert_success %w[Software Design], Parser::List.new(Parser::Text.new).run(%w[Software Design])
    assert_failure Parser::InvalidError.new('', '1', 'is not an array'), Parser::List.new(Parser::Text.new).run('1')
  end
  test 'parse a hash' do
    parser = Parser::Struct.new(name: Parser::Text.new, age: Parser::Number.new)
    assert_success ({ name: 'Loïc', age: 34 }), parser.run({ name: 'Loïc', age: 34 })
    assert_failure Parser::InvalidError.new('', '1', 'is not a hash'), parser.run('1')
    assert_failure Parser::RequiredError.new('age'), parser.run({ name: 'Loïc' })
    assert_failure Parser::MultiErrors.new(
      Parser::RequiredError.new('name'),
      Parser::RequiredError.new('age')
    ), parser.run({})
  end
  test 'add a constraint' do
    assert_success 'Loïc', Parser::Text.new.verifying(Parser::Constraint.non_empty).run('Loïc')
    assert_success 'Loïc', Parser::Text.new.verifying(Parser::Constraint.new('constrain_name') { |value| value.length > 2 }).run('Loïc')
    assert_failure Parser::InvalidError.new('', '', 'failed on non_empty constraint'), Parser::Text.new.verifying(Parser::Constraint.non_empty).run('')
  end
  test 'can be optional' do
    assert_failure Parser::RequiredError.new(''), Parser::Text.new.run(nil)
    assert_success nil, Parser::Text.new.optional.run(nil)
    assert_success 'Hi', Parser::Text.new.optional(default: 'Hi').run(nil)
  end
  test 'can combine parsers' do
    parser = Parser::Text.new(max: 2).or(Parser::Text.new(min: 4), Parser::Number.new)
    assert_success 'aa', parser.run('aa')
    assert_success 'aaaa', parser.run('aaaa')
    assert_success 42, parser.run(42)
    assert_failure Parser::MultiErrors.new(
      Parser::InvalidError.new('', 'aaa', 'has more than 2 characters'),
      Parser::InvalidError.new('', 'aaa', 'has less than 4 characters'),
      Parser::InvalidError.new('', 'aaa', 'is not a number')
    ), parser.run('aaa')
  end
  test 'report error in nested attribute' do
    parser = Parser::Struct.new(
      name: Parser::Struct.new(
        particles: Parser::List.new(Parser::Text.new)
      )
    )
    assert_failure Parser::InvalidError.new('name.particles.2', 4, 'is not a string'), parser.run({ name: { particles: ['de', 'at', 4, 'foo'] } })
  end
  test 'flatten error' do
    error = Parser::MultiErrors.new(
      Parser::InvalidError.new('name', 4, 'is not a string'),
      Parser::MultiErrors.new(
        Parser::RequiredError.new('address.street'),
        Parser::RequiredError.new('address.no')
      ),
      Parser::InvalidError.new('email', 'toto', 'invalid'),
    )
    errors = [
      Parser::InvalidError.new('name', 4, 'is not a string'),
      Parser::RequiredError.new('address.street'),
      Parser::RequiredError.new('address.no'),
      Parser::InvalidError.new('email', 'toto', 'invalid')
    ]
    assert_equal errors, error.flatten
  end

  private

  def assert_success(expected, actual)
    assert_equal Result.success(expected), actual
  end

  def assert_failure(expected, actual)
    assert_equal Result.failure(expected), actual
  end
end
