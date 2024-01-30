#require 'google_drive'
require_relative '../engine'
require_relative 'constants'

#session = GoogleDrive::Session.from_service_account_key("../gapi_secret.json")
#spreadsheet = session.spreadsheet_by_title('Прайс-лист "Sneaker Club"')
# ==============================================================================
# route: /start
def msg_start(bot, message, params)
  if BotEngine.user_subscribed?(bot, "-1001707061142", message.from.id)
    cb_menu(bot, message, params)
  else
    cb_menu_unlogged(bot, message, params)
  end
end
# ==============================================================================
# route: /cb/menu_unlogged
def cb_menu_unlogged(bot, message, params)
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
# ==============================================================================
# route: /cb/menu
def cb_menu(bot, message, params)
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
        text: '🛒 Каталог', callback_data: '/cb/menu/catalog'),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🔎 Поиск', callback_data: '/cb/menu/search')
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '💬 Отзывы', url: BotEngine::Constants::CHANNEL_URL),
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🛎 Поддержка', url: BotEngine::Constants::CHANNEL_URL)
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '👟 Мои заказы', callback_data: '/cb/menu/orders')
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🛍 Корзина', callback_data: '/cb/menu/cart')
    ]
  ]

  markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  bot.api.send(:send_message, chat_id: message.from.id, text: text, 
                reply_markup: markup, parse_mode: "html")
end
# ==============================================================================
# route: /cb/menu/orders
def cb_menu_orders(bot, message, params)
  cb_chat_id = message.message.chat.id
  cb_msg_id  = message.message.message_id

  text = "Ваши активные заказы."
  kb = [
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '⬅️ Назад', callback_data: '/cb/menu')
    ]
  ]
  markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  bot.api.send(:edit_message_text, chat_id: cb_chat_id, message_id: cb_msg_id, 
               text: text, reply_markup: markup, parse_mode: "html")
end
# ==============================================================================
# route: /cb/menu/catalog
def cb_menu_catalog(bot, message, params)
  cb_chat_id = message.message.chat.id
  cb_msg_id  = message.message.message_id

  text = "Ваши активные заказы."
  kb = [
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '👟 Все бренды', callback_data: '/cb/catalog_info?all_brends')
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🔥 Новинки', callback_data: '/cb/catalog_info?new_ones&sales')
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '📉 Скидки и акции', callback_data: '/cb/catalog_info?sales')
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '🔎 Поиск', callback_data: '/cb/menu/search')
    ],
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(
        text: '⬅️ Назад', callback_data: '/cb/menu')
    ]
  ]
  markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  bot.api.send(:edit_message_text, chat_id: cb_chat_id, message_id: cb_msg_id, 
               text: text, reply_markup: markup, parse_mode: "html")
end
# ==============================================================================
# route: /cb/catalog_info?(all_brends|new_ones|sales)
def cb_catalog_info(bot, message, params)
  worksheet = spreadsheet.worksheets.first
  worksheet.rows.first(10).each { |row| puts row.first(6)}
end
# ==============================================================================
# route: /cb/menu/search
def cb_menu_search(bot, message, params)
end
# ==============================================================================
# route: /cb/menu/cart
def cb_menu_cart(bot, message, params)
end