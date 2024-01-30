require_relative 'controller'

ROUTES = [
  {type: TG_MESSAGE,  id: "/start",            handler: method(:msg_start)},
  {type: TG_CALLBACK, id: "/cb/menu_unlogged", handler: method(:cb_menu_unlogged)},
  {type: TG_CALLBACK, id: "/cb/menu",          handler: method(:cb_menu)},
  {type: TG_CALLBACK, id: "/cb/menu/catalog",  handler: method(:cb_menu_catalog)},
  {type: TG_CALLBACK, id: "/cb/menu/search",   handler: method(:cb_menu_search)},
  {type: TG_CALLBACK, id: "/cb/menu/orders",   handler: method(:cb_menu_orders)},
  {type: TG_CALLBACK, id: "/cb/menu/cart",     handler: method(:cb_menu_cart)}
]