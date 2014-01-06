require 'fog'

require_relative 'loggable'

class Publisher
  include Loggable

  def initialize
    @last_config = {}
  end

  def reconfigure config
    return unless config_changed? config,
      'rackspace-username', 'rackspace-apikey', 'rackspace-region', 'queue-name'
    logger.debug "Configuration change detected. Re-acquiring queue."
    @last_config = config

    service = Fog::Rackspace::Queues.new(
      rackspace_username: config["rackspace-username"],
      rackspace_api_key: config["rackspace-apikey"],
      rackspace_region: config["rackspace-region"]
    )

    qname = config["queue-name"]
    @queue = service.queues.get qname
    raise "Queue #{qname} not found!" unless @queue
    logger.debug "Discovered queue #{qname}."
  end

  def publish items
    raise "Publisher is unconfigured!" unless @queue

    logger.info "Publishing #{items.size} items to the queue."
    items.each do |item|
      logger.debug { "Publishing item: #{item.inspect}" }
      @queue.messages.create(body: item.to_incident, ttl: 3600)
    end
  end

  private

  def config_changed? config, *keys
    keys.any? { |k| config[k] != @last_config[k] }
  end
end
