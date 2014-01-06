require_relative '../feed'

class DevForumFeed < Feed
  register "https://community.rackspace.com/developers/rss"

  def items
    super.select do |item|
      item.url.start_with? "https://community.rackspace.com/developers/f/7/t"
    end.each do |item|
      item.title.gsub! /^Forum Post: (Re: )?/i, ''
    end
  end
end
