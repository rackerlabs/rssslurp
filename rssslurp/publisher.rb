require 'fog'

require_relative 'loggable'

class Publisher
  include Loggable

  def initialize config
    @service = Fog::Rackspace::Queues.new(
      rackspace_username: config["rackspace-username"],
      rackspace_api_key: config["rackspace-apikey"],
      rackspace_region: config["rackspace-region"]
    )

    qname = config["queue-name"]
    @queue = @service.queues.get qname
    raise "Queue #{qname} not found!" unless @queue
    logger.debug "Discovered queue #{qname}."
  end

  def publish items
    logger.info "Publishing #{items.size} items to the queue."
    items.each do |item|
      logger.debug { "Publishing item: #{item.inspect}" }
      @queue.messages.create(body: item.to_incident, ttl: 3600)
    end
  end
end
