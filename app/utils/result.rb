# this `Result` is a bit weird from usual results
# it has 3 states (instead of 2), a bit like Future/Promise but synchronous
class Result
  # @param value [T, nil]
  # @return [Result<T>]
  def self.success(value)
    new('success', value)
  end

  # @param error [String, StandardError]
  # @return [Result<T>]
  def self.failure(error)
    new('failure', error)
  end

  # @return [Result<T>]
  def self.pending
    new('pending', nil)
  end

  # private constructor, the only way to create a `Result` is using one of the three above methods
  # it guarantees that status always have a correct value and a consistent value
  def initialize(status, value)
    @status = status
    @value = value
  end

  private_class_method :new # private constructor

  # @return [Boolean]
  def success?
    @status == 'success'
  end

  # @return [Boolean]
  def failure?
    @status == 'failure'
  end

  # @return [Boolean]
  def pending?
    @status == 'pending'
  end

  # safely extract `value` if it exists or return the `default` one provided
  # @param default [T]
  # @return [T]
  def get_or_else(default)
    @status == 'success' ? @value : default
  end

  # transform the `value` inside the `Result` if `success`, like `map` (used an other name to avoid IntelliJ type confusion)
  # @yieldparam [T]
  # @yieldreturn [U]
  # @return [Result<U>]
  def then
    success? ? Result.success(yield(@value)) : self
  end

  # same as `flat_map`, transform value inside if `success` but expect a `Result` as return and collapse it
  # @yieldparam [T]
  # @yieldreturn [Result<U>]
  # @return [Result<U>]
  def and_then
    success? ? yield(@value) : self
  end

  # act on `failure` case to eventually correct it, expect a `Result` to collapse it
  # @yieldparam [String, StandardError]
  # @yieldreturn [Result<U>]
  # @return [Result<U>]
  def recover
    failure? ? yield(@value) : self
  end

  # build a value from any state of the `Result`
  # @param if_pending [Proc, U] _ -> U
  # @param if_failure [Proc, U] String, StandardError -> U
  # @param if_success [Proc, U] T -> U
  # @return [U]
  def fold(if_pending:, if_failure:, if_success:)
    return if_success.respond_to?(:call) ? if_success.call(@value) : if_success if success?
    return if_failure.respond_to?(:call) ? if_failure.call(@value) : if_failure if failure?
    if_pending.respond_to?(:call) ? if_pending.call : if_pending
  end

  def to_s
    "Result.#{@status}(#{@value})"
  end

  def inspect
    "Result.#{@status}(#{@value.inspect})"
  end

  def ==(other)
    other.instance_of?(self.class) &&
      @status == other.instance_variable_get(:@status) &&
      @value == other.instance_variable_get(:@value)
  end
end
