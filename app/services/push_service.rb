require 'gcm'
class PushService < BaseService
  def initialize
    api_key = 'AIzaSyAT341Id-gMu465TNTeibQjbl22RqKuYOg'
    @gcm = GCM.new(api_key)
  end

  def send_push
    registration_ids= ['12', '13'] # an array of one or more client registration IDs
    options = {data: {score: '123'}, collapse_key: 'updated_score'}
    response = @gcm.send(registration_ids, options)
  end
end
