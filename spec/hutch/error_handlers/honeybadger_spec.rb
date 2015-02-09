require 'spec_helper'

describe Hutch::ErrorHandlers::Honeybadger do
  let(:error_handler) { Hutch::ErrorHandlers::Honeybadger.new }

  describe '#handle' do
    let(:error) do
      begin
        raise "Stuff went wrong"
      rescue RuntimeError => err
        err
      end
    end

    it "logs the error to Honeybadger" do
      message_id = "1"
      payload = "{}"
      consumer = double
      ex = error
      message = {
        :error_class => ex.class.name,
          :error_message => "#{ ex.class.name }: #{ ex.message }",
          :backtrace => ex.backtrace,
          :context => {
            :message_id => message_id,
            :consumer => consumer
          },
          :parameters => {
            :payload => payload
          }
      }
      expect(::Honeybadger).to receive(:notify_or_ignore).with(message)
      error_handler.handle(message_id, payload, consumer, ex)
    end
  end
end
