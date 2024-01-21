require_relative 'pages'

def start_page_non_subscribed(bot, message)
  text = %{
          Здравствуйте, #{message.from.first_name}!%nl%
          %nl%
          Для корректной работы бота, подпишитесь на канал магазина
          по кнопке ниже.%nl%
          После подписки, нажмите <b>«Я подписался»</b>.
        }.gsub(/\s+/, " ").gsub("%nl% ", "\n").strip

  kb = [
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: 'Перейти на канал', url: BotEngine::Constants::CHANNEL_URL)
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '✅ Я подписался', callback_data: 'check_subscription')
    ]
  ]

  markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  bot.api.send_message(chat_id: message.chat.id, text: text, 
                       reply_markup: markup, parse_mode: "html")
end


def menu_main(bot, message)
  text = %{
    Здравствуйте, #{message.from.first_name}!%nl%
    %nl%
    Бот представляет полный ассортимент кроссовок магазина 
    <a href="tg://join?invite=ZuGFlFXtVcwwMTMy">Skidrow</a>. 
    Чтобы оформить заказ, пожалуйста, перейдите в <b>«Каталог»</b>, 
    выберите нужную модель кроссовок и укажите 
    данные получателя. После этого ожидайте сообщение от менеджера для 
    подтверждения заказа.%nl%
    %nl%
    По заказу и вопросам, пишите в специальный бот по кнопке <b>«Поддержка»</b>.
  }.gsub(/\s+/, " ").gsub("%nl% ", "\n").strip

  kb = [
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🛒 Каталог', callback_data: 'main_catalog'),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🔎 Поиск', callback_data: 'main_search')
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '💬 Отзывы', url: BotEngine::Constants::CHANNEL_URL),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🛎 Поддержка', url: BotEngine::Constants::CHANNEL_URL)
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '👟 Мои заказы', callback_data: 'main_orders')
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🛍 Корзина', callback_data: 'main_cart')
    ]
  ]

  markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  bot.api.send(:send_message, chat_id: message.from.id, text: text, 
                reply_markup: markup, parse_mode: "html")
end


def menu_orders(bot, message)
  cb_chat_id = message.message.chat.id
  cb_msg_id  = message.message.message_id

  text = "Ваши активные заказы."
  kb = [
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '⬅️ Назад', callback_data: 'main_menu')
    ]
  ]
  markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  bot.api.send(:edit_message_text, chat_id: cb_chat_id, message_id: cb_msg_id, 
               text: text, reply_markup: markup, parse_mode: "html")
end