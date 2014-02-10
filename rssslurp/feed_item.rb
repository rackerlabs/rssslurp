require 'date'

class FeedItem
  attr_accessor :url, :title, :time, :body, :tags

  def to_incident
    {
      url: url,
      reporter: "rssslurp-#{VERSION}",
      title: title,
      tags: tags,
      incident_date: time.to_i
    }
  end

  def self.from_node node
    new.tap do |i|
      i.url = node.at_css('link').content
      i.title = node.at_css('title').content
      i.body = node.at_css('description').content
      i.time = DateTime.parse(node.at_css('pubDate').content).to_time
      i.tags = []
    end
  end
end
