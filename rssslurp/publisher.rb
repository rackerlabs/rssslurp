require 'fog'

class Publisher
  def initialize config
    @service = Fog::Rackspace::Queues.new(
      rackspace_username: config["rackspace-username"],
      rackspace_api_key: config["rackspace-apikey"],
      rackspace_region: config["rackspace-region"]
    )

    qname = config["queue-name"]
    @queue = @service.queues.get qname
    raise "Queue #{qname} not found!" unless @queue
  end

  def publish items
    items.each do |item|
      @queue.messages.create(body: item.to_incident, ttl: 3600)
    end
  end
end
