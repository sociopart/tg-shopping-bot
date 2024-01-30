require_relative 'engine'
require_relative 'modules/routes'

BotEngine.new(ENV.fetch('CLIENT_BOT_API_KEY'), nil, ROUTES).execute