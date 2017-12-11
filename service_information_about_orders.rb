module Information_about_orders
  Dotenv.load
  GET_ORDERS_LOG_URL          = "https://market.dota2.net/api/GetOrdersLog/?key=#{ENV['SECRET_KEY']}".freeze
  TEXT_MESSAGE_ORDER_COMPLITE = 'Order is complite!'.freeze
  USER_ID                     = ENV['HIDE_USER_ID']
  @@hash_100_last_orders      = {}

  def inform_about_orders
    if @@hash_100_last_orders != list_orders
      send_message_order_complite
      @@hash_100_last_orders = list_orders
    end
  end

  private

  def send_message_order_complite
    telegram_bot_client do |bot|
      bot.api.send_message(chat_id: USER_ID, text: TEXT_MESSAGE_ORDER_COMPLITE)
    end
  end

  def list_orders
    uri      = URI.parse(GET_ORDERS_LOG_URL)
    response = Net::HTTP.get_response(uri)
    my_hash  = JSON.parse(response.body)
  end
end
