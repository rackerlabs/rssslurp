require_relative 'feed_registry'

class Consumer
  def consume
    FeedRegistry.all.flat_map { |feed| feed.items }
  end
end
