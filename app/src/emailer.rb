# frozen_string_literal: true

class Emailer
  include Sidekiq::Worker


  def email
    publish("email-sent", {foo: :bar})
  end

  def publish(event, data)
    Sidekiq.redis do |conn|
      conn.multi do |multi|
        multi.xadd   "events", {event: event, data: Sidekiq.dump_json(data)}
        multi.expire "events", 30.minutes
      end
    end
  end
end
