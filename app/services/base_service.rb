class BaseService
  class ModelResponse < SimpleDelegator

    def success?
      errors.empty?
    end

  end

  private

  def read_config(filename)
    YAML.load_file(Rails.root + 'config' + "#{filename}.yml")[Rails.env]
  end
end
