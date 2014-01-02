require 'rufus-scheduler'
require 'json'

require_relative 'feeds'

scheduler = Rufus::Scheduler.new
scheduler.interval '5m' do
  FeedRegistry.all.each do |feed|
    puts feed.items.map(&:inspect).join("\n")
  end
end
scheduler.join
