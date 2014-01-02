class FeedItem
  attr_accessor :url, :title, :date

  def as_incident
    {
      url: url,
      reporter: 'rssslurp-0.1',
      title: title,
      date: date.to_i
    }
  end

  def self.from_node node
    new.tap do |i|
      i.url = node.at_css('link').content
      i.title = node.at_css('title').content
      i.date = DateTime.parse(node.at_css('pubDate').content)
    end
  end
end
