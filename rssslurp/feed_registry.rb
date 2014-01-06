require_relative 'feed'

class FeedRegistry

  def self.all
    @feeds ||= []
  end

end
