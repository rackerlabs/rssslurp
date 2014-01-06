require 'date'

class FeedItem
  attr_accessor :url, :title, :time

  def to_incident
    {
      url: url,
      reporter: "rssslurp-#{VERSION}",
      title: title,
      incident_date: time.to_i
    }
  end

  def self.from_node node
    new.tap do |i|
      i.url = node.at_css('link').content
      i.title = node.at_css('title').content
      i.time = DateTime.parse(node.at_css('pubDate').content).to_time
    end
  end
end
