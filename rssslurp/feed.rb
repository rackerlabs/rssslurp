require 'httparty'
require 'nokogiri'

require_relative 'loggable'
require_relative 'feed_item'
require_relative 'feed_registry'

class Feed
  include Loggable
  extend Loggable

  def initialize url
    @url = url
  end

  def items
    logger.info "Fetching items for feed <#{@url}>."
    content = HTTParty.get(@url).body
    Nokogiri::XML(content).xpath("//rss/channel/item").map do |node|
      FeedItem.from_node node
    end.tap { |items| logger.info "Retrieved #{items.size} items." }
  end

  def self.register url
    FeedRegistry.all << new(url)
    logger.debug "Registered feed for URL: <#{url}>"
  end

  def self.load_all!
    logger.info "Loading feeds."
    Dir[File.join __dir__, 'feeds', '*.rb'].each do |fname|
      logger.debug "Discovered feed class at path: #{fname}"
      load fname
    end
  end

end
