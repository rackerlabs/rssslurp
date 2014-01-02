require 'rufus-scheduler'
require 'json'

require_relative 'feeds'
require_relative 'rssslurp/consumer'
require_relative 'rssslurp/publisher'

config = JSON.parse(File.join(__dirname__, 'config.json'))
consumer = Consumer.new
publisher = Publisher.new(config)

scheduler = Rufus::Scheduler.new
scheduler.interval '5m' do
  publisher.publish(consumer.consume)
end
scheduler.join
