require_relative 'feeds'

class Consumer
  def consume
    FeedRegistry.all.flat_map { |feed| feed.items }
  end
end
