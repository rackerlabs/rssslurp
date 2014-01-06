require 'httparty'
require 'nokogiri'

require_relative 'feed_item'
require_relative 'feed_registry'

class Feed

  def initialize url
    @url = url
  end

  def items
    content = HTTParty.get(@url).body
    Nokogiri::XML(content).xpath("//rss/channel/item").map do |node|
      FeedItem.from_node node
    end
  end

  def self.register url
    FeedRegistry.all << new(url)
  end

  def self.load_all!
    Dir[File.join __dir__, 'feeds', '*.rb'].each do |fname|
      load fname
    end
  end

end
