require 'httparty'
require 'nokogiri'

require_relative 'feed_item'

class Feed

  def initialize url
    @url = url
    @accept_item = ->(i){ true }
    @transform_item = ->(i){ i }
  end

  def accept_item &block
    @accept_item = block
  end

  def transform_item &block
    @transform_item = block
  end

  def items
    content = HTTParty.get(@url).body
    Nokogiri::XML(content).xpath("//rss/channel/item").map do |node|
      FeedItem.from_node node
    end.select(&@accept_item).each(&@transform_item)
  end

end
