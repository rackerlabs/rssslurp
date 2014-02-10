require 'fog'

require_relative 'loggable'

class Publisher
  include Loggable

  def initialize
    @last_config = {}
  end

  def reconfigure config
    return unless config_changed? config,
      'rackspace-username', 'rackspace-apikey', 'rackspace-region',
      'queue-name', 'print-only'
    logger.debug "Configuration change detected. Re-acquiring queue."
    @last_config = config

    service = Fog::Rackspace::Queues.new(
      rackspace_username: config["rackspace-username"],
      rackspace_api_key: config["rackspace-apikey"],
      rackspace_region: config["rackspace-region"]
    )

    @print_only = config["print-only"]

    qname = config["queue-name"]
    unless @print_only
      @queue = service.queues.get qname
      raise "Queue #{qname} not found!" unless @queue
      logger.debug "Discovered queue #{qname}."
    end
  end

  def publish items
    raise "Publisher is unconfigured!" unless @queue || @print_only

    logger.info "Publishing #{items.size} items to the queue."
    items.each do |item|
      logger.debug { "Publishing item: #{item.title}" }
      unless @print_only
        @queue.messages.create(body: item.to_incident, ttl: 3600)
      end
    end
  end

  private

  def config_changed? config, *keys
    keys.any? { |k| config[k] != @last_config[k] }
  end
end
