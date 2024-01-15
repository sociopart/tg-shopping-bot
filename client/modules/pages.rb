require_relative 'constants'

PAGES = [
  # Начальная команда /start
  {
    type: Telegram::Bot::Types::Message,
    command_id: "/start",
    action: lambda { |bot, message|
      # Если пользователь НЕ подписан на канал
      if !BotEngine::Listener::user_subscribed?(bot, "-1001707061142", message.from.id)
        text = "Здравствуйте, #{message.from.first_name}!\n" \
              "Для корректной работы бота, подпишитесь на канал магазина " \
              "по кнопке ниже.\n" \
              "После подписки, нажмите <b>«Я подписался»</b>."
        kb = [
          [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Перейти на канал', url: BotEngine::Constants::CHANNEL_URL)],
          [Telegram::Bot::Types::InlineKeyboardButton.new(text: '✅ Я подписался', callback_data: 'check_subscription')]
        ]
        markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: markup, parse_mode: "html")
      # Если подписан
      else
        bot.api.send_message(chat_id: message.from.id, text: "пук")
      end
    }
  },
  {
    type: Telegram::Bot::Types::CallbackQuery,
    command_id: "check_subscription",
    action: lambda { |bot, message| 
      if message.data == 'check_subscription'
        puts message.from.id.to_s
        subscription_status = bot.api.get_chat_member({
          "chat_id": "-1001707061142",
          "user_id": message.from.id.to_i
        })
        if subscription_status["status"] != "left"
          bot.api.send_message(chat_id: message.from.id, text: "touch me!")
        else
          bot.api.send_message(chat_id: message.from.id, text: "Don't touch me!")
        end
      end
    }
  }
]
