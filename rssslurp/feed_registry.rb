require_relative 'feed'

class FeedRegistry

  def self.all
    @feeds ||= []
  end

end

module FeedLanguage

  def feed url
    @current = Feed.new(url)
    yield if block_given?
    FeedRegistry.all << @current
    @current = nil
  end

  def accept &block
    @current.accept_item(&block)
  end

  def transform &block
    @current.transform_item(&block)
  end

end
