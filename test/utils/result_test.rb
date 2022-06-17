require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  test 'create and check' do
    assert Result.pending.pending?
    assert Result.success('a').success?
    assert Result.failure('err').failure?
  end
  test 'cannot be instantiate' do
    assert_raise { Result.new('bad', 'oops') }
  end
  test 'access success value' do
    assert_equal '', Result.pending.get_or_else('')
    assert_equal 'Hi', Result.success('Hi').get_or_else('')
    assert_equal '', Result.failure('Hi').get_or_else('')
  end
  test 'transform content' do
    assert_equal Result.pending, Result.pending.then { |v| v.length }
    assert_equal Result.success(2), Result.success('Hi').then { |v| v.length }
    assert_equal Result.failure('Hi'), Result.failure('Hi').then { |v| v.length }
  end
  test 'transform and flatten content' do
    assert_equal Result.pending, Result.pending.and_then { |v| Result.success(v.length) }
    assert_equal Result.success(2), Result.success('Hi').and_then { |v| Result.success(v.length) }
    assert_equal Result.pending, Result.success('Hi').and_then { Result.pending }
    assert_equal Result.failure('err'), Result.success('Hi').and_then { Result.failure('err') }
    assert_equal Result.failure('Hi'), Result.failure('Hi').and_then { |v| Result.success(v.length) }
  end
  test 'recover from error' do
    assert_equal Result.success(2), Result.failure('ko').recover { |err| Result.success(err.length) }
  end
  test 'build a value' do
    assert_equal 'pending', Result.pending.fold(if_pending: proc { 'pending' }, if_failure: proc { |err| "err: #{err}" }, if_success: proc { |v| v })
    assert_equal 'Hi', Result.success('Hi').fold(if_pending: proc { 'pending' }, if_failure: proc { |err| "err: #{err}" }, if_success: proc { |v| v })
    assert_equal 'err: bad', Result.failure('bad').fold(if_pending: proc { 'pending' }, if_failure: proc { |err| "err: #{err}" }, if_success: proc { |v| v })
  end
end
