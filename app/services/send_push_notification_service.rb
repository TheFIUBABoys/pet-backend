require 'gcm'

class SendPushNotificationService < BaseService

  def initialize
    @gcm = GCM.new(api_key)
  end

  def call(user, options)
    return if user.device_id.empty?

    gcm_response = @gcm.send(Array(user.device_id), options)

    ModelResponse.new(gcm_response)
  end

  private

  def api_key
    @api_key ||= gcm_config[:api_key]
  end

  def gcm_config
    @gcm_config ||= read_config("gcm")
  end

end
