require_relative 'rssslurp/feed_registry'

include FeedLanguage

feed "https://community.rackspace.com/developers/rss" do
  accept do |item|
    item.url.start_with? "https://community.rackspace.com/developers/f/7/t"
  end

  transform do |item|
    puts "running on item: #{item.title}"
    item.title.gsub! /^Forum Post: (Re: )?/i, ''
  end
end
