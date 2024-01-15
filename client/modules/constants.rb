class BotEngine
  module Constants
    API_TOKEN = ENV.fetch('CLIENT_BOT_API_KEY')
    CHANNEL_URL = 'https://t.me/sociopart'
    CHANNEL_ID = 
    COMMANDS = {
      "commands": [
        {
          "command": "start",
          "description": "Перезапустить бота"
        }
      ],
      "language_code": ""
    }

    DESCRIPTION = {
      "description": "Бот для оформления заказов в магазине @skidrow_shop. Поддержка бота - @Alexander555vtk",
      "language_code": ""
    }

  end
end