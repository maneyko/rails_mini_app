# frozen_string_literal: true

class A
  include Sidekiq::Worker

  def self.subscribed_events
    @subscribed_events ||= { }
  end

  def self.event(event_name, &block)
    subscribed_events[event_name.to_s] = block
  end

  event "email-sent" do
    Sidekiq.logger.info "Event info: #{event_info}"
  end

  def perform(event_name, event_index)
    @event_name  = event_name
    @event_index = event_index
    event_block  = self.class.subscribed_events[event_name]

    instance_exec(&event_block)
  end

  def event_info
    @event_info ||= Sidekiq.redis do |conn|
      conn.xrange("events", @event_index, "+", count: 1)[0][1]
    end.tap do |info|
      info["data"] = Sidekiq.load_json(info["data"])
    end
  end
end
