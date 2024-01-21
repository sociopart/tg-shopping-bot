require_relative 'constants'
require_relative 'controller'


def menu_handler(bot, message, current_page = nil)
  
  case current_page
  when "catalogue"
  when "search"
  when "orders"
    menu_orders(bot, message)
  when "cart"
  when "main"
    menu_main(bot, message)
  else
    # main page
    menu_main(bot, message)
  end
end



PAGES = [
  # Начальная команда /start
  {
    type: Telegram::Bot::Types::Message,
    command_id: "/start",
    action: lambda { |bot, message|
      # Если пользователь НЕ подписан на канал
      if !BotEngine::Listener::user_subscribed?(bot, "-1001707061142", message.from.id)
        menu_non_subscribed(bot, message)
      # Если подписан
      else
        menu_handler(bot, message)
      end
    }
  },
  {
    type: Telegram::Bot::Types::CallbackQuery,
    command_id: "main_orders",
    action: lambda { |bot, message| 
      menu_handler(bot, message, "orders")
    }
  },
  {
    type: Telegram::Bot::Types::CallbackQuery,
    command_id: "main_menu",
    action: lambda { |bot, message| 
      menu_handler(bot, message, "main")
    }
  },
  {
    type: Telegram::Bot::Types::CallbackQuery,
    command_id: "check_subscription",
    action: lambda { |bot, message| 
      puts message.from.id.to_s
      subscription_status = bot.api.get_chat_member({
        "chat_id": "-1001707061142",
        "user_id": message.from.id.to_i
      })
      if subscription_status["status"] != "left"
        # Снова вызываем стартовую
        result_page = PAGES.find { |page| page[:command_id] == "/start"}
        result_page[:action].call(bot, message) if !result_page.nil?
      end
    }
  }
]
