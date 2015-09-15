class BaseService
  class ModelResponse < SimpleDelegator

    def success?
      errors.empty?
    end

  end
end
