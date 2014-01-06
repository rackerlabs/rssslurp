require 'rufus-scheduler'
require 'json'
require 'log4r'

require_relative 'rssslurp/consumer'
require_relative 'rssslurp/publisher'
require_relative 'rssslurp/feed'

# Load the configuration parameters.
CONFIG = JSON.parse(File.read(File.join __dir__, 'config.json'))
VERSION = File.read(File.join __dir__, 'VERSION').chomp

# Initialize the logger.
logger = Log4r::Logger.new 'default'
logger.outputters = Log4r::Outputter.stdout
logger.level = Log4r.const_get(CONFIG['log-level'] || 'INFO')

logger.info "Launching RSSslurp version #{VERSION}."

# Load all known Feeds. Feeds are defined as subclasses of Feed in rsslurp/feeds.
Feed.load_all!

# Create the feed consumer and the queue publisher.
consumer = Consumer.new
publisher = Publisher.new(CONFIG)

publisher.publish(consumer.consume)

logger.info "Launching scheduler."

scheduler = Rufus::Scheduler.new
scheduler.interval '5m' do
  publisher.publish(consumer.consume)
end
scheduler.join
