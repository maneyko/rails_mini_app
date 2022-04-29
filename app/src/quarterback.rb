# frozen_string_literal: true

require_relative "a"
require_relative "emailer"

class Quarterback
  include Sidekiq::Worker

  sidekiq_options queue: "global", retry: false

  GLOBAL_EVENT_STREAM = "events"

  def perform(current_index = "0")
    redis.without_reconnect do
      events = redis.xread(GLOBAL_EVENT_STREAM, current_index, block: 2_000)[GLOBAL_EVENT_STREAM]
      if events
        current_index, event_info = events[0]
        event_name = event_info["event"]
        event_data = Sidekiq.load_json(event_info["data"])

        subscribed_workers = self.class.sidekiq_workers.select { |w| w.subscribed_events.key?(event_name) }
        subscribed_workers.each do |subscribed_worker|
          subscribed_worker.perform_async(event_name, current_index)
        end
      end
    end

    self.class.perform_async(current_index)
  end

  def redis
    @redis ||= Redis.new(redis_options)
  end

  def redis_options
    @redis_options ||= Sidekiq.redis { |conn| conn }._client.options
  end

  def self.sidekiq_workers
    ObjectSpace.each_object(Class).select do |klass|
      klass.included_modules.include?(Sidekiq::Worker) &&
        klass.respond_to?(:subscribed_events)
    end
  end
end
