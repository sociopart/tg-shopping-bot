require 'telegram/bot'
require_relative 'constants'
require_relative 'pages'

class BotEngine
  def initialize
    @bot_handle = Telegram::Bot::Client.new(Constants::API_TOKEN)

    @bot_handle.api.delete_my_commands
    @bot_handle.api.set_my_commands(Constants::COMMANDS)
    
    # TODO: name, description, short description ....
  end

  def execute
    loop do
      begin
        @bot_handle.run do |bot|
          start_bot_time = Time.now.to_i
          bot.listen do |rqst|
            Thread.start(rqst) do |current_rqst|
              begin
                if Listener.message_is_new(start_bot_time, current_rqst) 
                  Listener.process_message(bot, current_rqst)
                end
              rescue => error
                puts error
              end
            end
          end
        end
      rescue => error
        error.backtrace
      end
    end
  end


  module Listener
    attr_accessor :message, :bot

    def message_is_new(start_time, message)
      message_time = (defined? message.date) ? message.date : message.message.date
      message_time.to_i > start_time
    end

    def message_too_far(message)
      message_date = (defined? message.date) ? message.date : message.message.date
      message_delay = Time.now.to_i - message_date.to_i
      # if message delay less then 5 min then processing message, else ignore
      message_delay > (5 * 60)
    end

    def user_subscribed?(bot, chat_id, user_id)
      subscription_status = bot.api.get_chat_member({
          "chat_id": chat_id,
          "user_id": user_id
      })
      return (subscription_status["status"] != "left")
    end

    def process_message(bot, message)
      return false if message_too_far(message)
      message_info = 
        if message.class == Telegram::Bot::Types::CallbackQuery
          message.data
        elsif message.class == Telegram::Bot::Types::Message
          message.text
        else
          nil
        end
      result_page = PAGES.find { |page| page[:type] == message.class && \
                                        page[:command_id] == message_info}
      result_page[:action].call(bot, message) if !result_page.nil?
    end

    module_function(
      :process_message,
      :message_too_far,
      :message_is_new,
      :user_subscribed?,
      :bot,
      :bot=,
      :message,
      :message=
    )
  end
end
