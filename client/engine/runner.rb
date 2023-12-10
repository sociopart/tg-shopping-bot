require 'telegram/bot'

class BotEngine
  def initialize
    super
    Telegram::Bot::Client.run(BotData::Constants::API_TOKEN) do |bot|
      # Start time variable, for exclude message what was sends before bot starts
      start_bot_time = Time.now.to_i
      # Active socket listener
      bot.listen do |message|
        # Processing the new income message if that message sent after bot run.
        if Listener::Security.message_is_new(start_bot_time,message)
          Listener.catch_new_message(message,bot) 
        end
      end
    end
  end
end