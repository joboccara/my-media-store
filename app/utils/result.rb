class Result
  # @param value [T]
  # @return [Result<T>]
  def self.success(value)
    new('success', value)
  end

  # @param error [String]
  # @return [Result<T>]
  def self.failure(error)
    new('failure', error)
  end

  # @return [Result<T>]
  def self.pending
    new('pending', nil)
  end

  def initialize(status, content)
    @status = status
    @content = content
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

  # @param default [T]
  # @return [T]
  def get_or_else(default)
    @status == 'success' ? @content : default
  end

  # @yieldparam [T]
  # @yieldreturn [U]
  # @return [Result<U>]
  def then
    success? ? Result.success(yield(@content)) : self
  end

  # @param if_pending [Proc] _ -> U
  # @param if_failure [Proc] String -> U
  # @param if_success [Proc] T -> U
  # @return [U]
  def fold(if_pending:, if_failure:, if_success:)
    return if_success.call(@content) if success?
    return if_failure.call(@content) if failure?
    if_pending.call
  end
end
