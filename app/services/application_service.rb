class ApplicationService
  def self.call(**opts)
    new(**opts).call
  end

  private

  def missing_attribute(attribute)
    raise NotImplementedError, "{#{attribute}} missing from parameters"
  end
end
