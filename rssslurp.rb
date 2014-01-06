require 'rufus-scheduler'
require 'json'

require_relative 'rssslurp/consumer'
require_relative 'rssslurp/publisher'
require_relative 'rssslurp/feed'

config = JSON.parse(File.read(File.join __dir__, 'config.json'))

Feed.load_all!

consumer = Consumer.new
publisher = Publisher.new(config)

publisher.publish(consumer.consume)

scheduler = Rufus::Scheduler.new
scheduler.interval '5m' do
  publisher.publish(consumer.consume)
end
scheduler.join
