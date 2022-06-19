# allow to parse (validate + transform) a data structure
module Parser
  # abstract class that define common methods and the one that should be extended (see NotImplementedError)
  # the parametric type is the type returned by the parser when executed (`run`)
  class Abstract
    # @return [Parser<T>]
    def initialize
      @required = true
      @default = nil
      @constraints = []
      @transforms = []
      @alternatives = []
    end

    # @param default [T, nil]
    # @return [Parser::Abstract<T, nil>]
    def optional(default: nil)
      @required = false
      @default = default
      self
    end

    # @return [Parser::Abstract<T>]
    def required
      @required = true
      self
    end

    # add validations on the parsed values
    # @param constraints [Array<Constraint<T>>]
    # @return [Parser::Abstract<T>]
    def verifying(*constraints)
      @constraints.concat(constraints)
      self
    end

    # allow to transform the value if it satisfy the constraints
    # @yieldparam [T]
    # @yieldreturn [U]
    # @return [Parser::Abstract<U>]
    def map(&block)
      @transforms.append(block)
      self
    end

    # create a parser from multiple ones, for example to parse incompatible types (string & int)
    # @param parser [Array<Parser::Abstract<U>>]
    # @return [Parser::Abstract<T, U>]
    def or(*parser)
      @alternatives.concat(parser)
      self
    end

    # execute the parser
    # @param value [Object, nil] the object to parse
    # @param path [String] the access path inside the object, keep it empty for root
    # @return [Result<T>]
    def run(value, path = '')
      @alternatives.reduce(compute(value, path)) do |acc, alternative|
        acc.recover do |err|
          alternative.run(value, path).recover do |new_err|
            if err.is_a?(MultiErrors)
              Result.failure(MultiErrors.new(*err.errors, new_err))
            else
              Result.failure(MultiErrors.new(err, new_err))
            end
          end
        end
      end
    end

    private

    # the method to extend to define how to parse a value
    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<T>]
    def compute(value, path)
      raise NotImplementedError
    end

    # helper to handle nil values, can be called by child classes in `compute`
    # @param path [String]
    # @return [Result<T>]
    def nil_value(path)
      @required ? Result.failure(RequiredError.new(path)) : Result.success(@default)
    end

    # helper to handle validation, should be called by child classes in `compute`
    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<T>]
    def validate(value, path)
      failed_constraints = @constraints.filter { |c| !c.valid?(value) }
      if failed_constraints.empty?
        Result.success(@transforms.reduce(value) { |v, transform| transform.call(v) })
      else
        message = "failed on #{failed_constraints.map(&:name).join(', ')} constraint#{failed_constraints.length > 1 ? 's' : ''}"
        Result.failure(InvalidError.new(path, value, message))
      end
    end
  end

  class Text < Abstract
    # @param min [Numeric, nil] string should be longer if specified
    # @param max [Numeric, nil] string should be shorter if specified
    # @param regex [Regexp, nil] string should match it if specified
    # @return [Parser<String>]
    def initialize(min: nil, max: nil, regex: nil)
      super()
      @min = min
      @max = max
      @regex = regex
    end

    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<String>]
    def compute(value, path)
      return nil_value(path) if value.nil?
      if !value.is_a?(String)
        Result.failure(InvalidError.new(path, value, 'is not a string'))
      elsif !@min.nil? && value.length < @min
        Result.failure(InvalidError.new(path, value, "has less than #{@min} characters"))
      elsif !@max.nil? && value.length > @max
        Result.failure(InvalidError.new(path, value, "has more than #{@max} characters"))
      elsif !@regex.nil? && !value.match(@regex)
        Result.failure(InvalidError.new(path, value, "does not match #{@regex.inspect}"))
      else
        validate(value, path)
      end
    end
  end

  class Number < Abstract
    # @param min [Numeric, nil] number should be greater if specified
    # @param max [Numeric, nil] number should be lower if specified
    # @yieldparam [String] a block to parse a string to a number if specified, ex: `&:to_i` or `&:to_f`
    # @yieldreturn [Numeric]
    # @return [Parser<Numeric>]
    def initialize(min: nil, max: nil, &parse_string)
      super()
      @min = min
      @max = max
      @parse_string = parse_string
    end

    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<Numeric>]
    def compute(value, path)
      return nil_value(path) if value.nil?
      value = @parse_string.call(value) if @parse_string.respond_to?(:call)
      if !value.is_a?(Numeric)
        Result.failure(InvalidError.new(path, value, 'is not a number'))
      elsif !@min.nil? && value < @min
        Result.failure(InvalidError.new(path, value, "is lower than #{@min} (minimum)"))
      elsif !@max.nil? && value > @max
        Result.failure(InvalidError.new(path, value, "is higher than #{@max} (maximum)"))
      else
        validate(value, path)
      end
    end
  end

  class Bool < Abstract
    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<Boolean>]
    def compute(value, path)
      return nil_value(path) if value.nil?
      if value.in?([true, false])
        validate(value, path)
      elsif value.in?(%w[true false])
        validate(value == 'true', path)
      else
        Result.failure(InvalidError.new(path, value, 'is not a boolean'))
      end
    end
  end

  class DateTime < Abstract
    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<Time>]
    def compute(value, path)
      return nil_value(path) if value.nil?
      time = Time.zone.parse(value)
      return Result.failure(InvalidError.new(path, value, 'is not a date')) if time.nil?
      validate(time, path)
    rescue ArgumentError
      Result.failure(InvalidError.new(path, value, 'is not a date'))
    end
  end

  class Enum < Abstract
    # @param values [Array<T>]
    # @return [Parser<T>]
    def initialize(values)
      super()
      @values = values
    end

    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<T>]
    def compute(value, path)
      return Result.failure(InvalidError.new(path, value, "is not in values: #{@values.map(&:inspect).join(', ')}")) unless @values.include?(value)
      validate(value, path)
    end
  end

  class List < Abstract
    # @param parser [Parser::Abstract<T>]
    # @return [Parser<Array<T>>]
    def initialize(parser)
      super()
      @parser = parser
    end

    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<Array<T>>]
    def compute(value, path)
      return nil_value(path) if value.nil?
      if value.is_a?(Array)
        value.each_with_index.reduce(Result.success([])) do |acc, entry|
          val, key = entry
          acc.and_then { |a| @parser.run(val, path + (path == '' ? '' : '.') + key.to_s).then { |v| a.concat([v]) } }
        end.and_then { |res| validate(res, path) }
      else
        Result.failure(InvalidError.new(path, value, 'is not an array'))
      end
    end
  end

  class Struct < Abstract
    # @param mappings [Hash<Key, Parser>]
    # @return [Parser<Hash>]
    def initialize(mappings)
      super()
      @mappings = mappings
    end

    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<Hash>]
    def compute(value, path)
      return nil_value(path) if value.nil?
      if value.is_a?(Hash)
        res, errors = @mappings.reduce([{}, []]) do |acc, entry|
          hash, errors = acc
          key, parser = entry
          parser.run(value[key], path + (path == '' ? '' : '.') + key.to_s).fold(
            if_pending: proc { acc },
            if_failure: proc { |err| [hash, errors.concat([err])] },
            if_success: proc { |val| [hash.merge(Hash[key, val]), errors] },
          )
        end
        return Result.failure(MultiErrors.new(*errors)) if errors.length > 1
        return Result.failure(errors.first) if errors.length == 1
        validate(res, path)
      else
        Result.failure(InvalidError.new(path, value, 'is not a hash'))
      end
    end
  end

  # special parser that don't parse but add the given value instead ^^
  class Constant < Abstract
    # @param value [T]
    # @return [Parser<T>]
    def initialize(value)
      super()
      @value = value
    end

    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<T>]
    def compute(value, path)
      validate(@value, path)
    end
  end

  # an other special parser to easily define custom parsing without the need to create a class
  class Custom < Abstract
    # @param error [String, nil] message in case of paring error, needed for reporting and debug
    # @yieldparam [S]
    # @yieldreturn [T]
    # @return [Parser<T>]
    def initialize(error = nil, &block)
      super()
      @error = error
      @block = block
    end

    private

    # @param value [Object, nil]
    # @param path [String]
    # @return [Result<T>]
    def compute(value, path)
      validate(@block.call(value), path)
    rescue ArgumentError
      Result.failure(InvalidError.new(path, value, @error))
    end
  end

  # add a validation on the parsed value, it's applied before the transformations
  class Constraint
    # common and reusable constraints could be defined here for convenience
    class << self
      # @return [Constraint<String>]
      def non_empty
        Constraint.new('non_empty') { |value| !value.empty? }
      end

      # @return [Constraint<String>]
      def length_gt(size)
        Constraint.new("gt_#{size}") { |value| value.length > size }
      end
    end

    attr_reader :name

    # @param name [String] used in error in case of failure, make it explicit
    # @yieldparam [T]
    # @yieldreturn [Boolean]
    # @return [Constraint<T>]
    def initialize(name, &block)
      @name = name
      @block = block
    end

    # @param value [T]
    # @return [Boolean]
    def valid?(value)
      @block.call(value)
    end
  end

  # parent error type for Parser
  class Error < ArgumentError
    # @return [Array<Error>]
    def flatten
      if self.is_a?(MultiErrors)
        self.errors.flat_map(&:flatten)
      else
        [self]
      end
    end
  end

  # used when a value is required but not present
  class RequiredError < Error
    attr_reader :path

    # @param path [String]
    # @return [RequiredError]
    def initialize(path)
      super("missing #{path.present? || 'value'}")
      @path = path
    end

    def ==(other)
      other.instance_of?(self.class) && @path == other.instance_variable_get(:@path)
    end
  end

  # default error holding the value, path and specific message (constraint name or hand made message)
  class InvalidError < Error
    attr_reader :path, :value, :message

    # @param path [String]
    # @param value [Object, nil]
    # @param message [String, nil]
    # @return [InvalidError]
    def initialize(path, value, message = nil)
      super("#{path} #{message || 'is invalid'} (value: #{value.inspect})".strip)
      @path = path
      @value = value
      @message = message
    end

    def ==(other)
      other.instance_of?(self.class) &&
        @path == other.instance_variable_get(:@path) &&
        @value == other.instance_variable_get(:@value) &&
        @message == other.instance_variable_get(:@message)
    end
  end

  # when multiple errors are triggered at some place, this class can hold them all \o/
  class MultiErrors < Error
    attr_reader :errors

    # @param errors [Array<Error>]
    # @return [MultiErrors]
    def initialize(*errors)
      super("errors: #{errors.join(', ')}")
      @errors = errors
    end

    def ==(other)
      other.instance_of?(self.class) && @errors == other.instance_variable_get(:@errors)
    end
  end
end
