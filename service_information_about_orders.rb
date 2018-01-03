module Information_about_orders
  Dotenv.load
  GET_ORDERS_LOG_URL          = "https://market.dota2.net/api/GetOrdersLog/?key=#{ENV['SECRET_KEY']}".freeze
  TEXT_MESSAGE_ORDER_COMPLITE = 'Order is complite!'.freeze
  USER_ID                     = ENV['HIDE_USER_ID']
   @@classids_worked_orders   = []

  def inform_about_orders
    if list_orders['success']
      send_message_order_complite if validation_for_worked_orders
    end
    delete_old_classid_from_classids_worked_orders
  end

  private

  def list_orders
    uri      = URI.parse(GET_ORDERS_LOG_URL)
    response = Net::HTTP.get_response(uri)
    my_hash  = JSON.parse(response.body)
    # let(:get_orders_log) { {"success"=>true, "log"=>[{"status"=>true, 
    #                                                   "classid"=>487251205, 
    #                                                   "instanceid"=>0, 
    #                                                   "name"=>"Treasure of the Cloven World", 
    #                                                   "market_hash_name"=>"Treasure of the Cloven World", 
    #                                                   "color"=>"D2D2D2", 
    #                                                   "quality"=>"Standard", 
    #                                                   "rarity"=>"Uncommon", 
    #                                                   "image"=>"https://cdn.dota2.net/item/Treasure+of+the+Cloven+World/150.png", 
    #                                                   "price"=>3343, 
    #                                                   "comment"=>nil, 
    #                                                   "executed"=>1513773075},

    #                                                  {"status"=>true, 
    #                                                   "classid"=>1169458911, 
    #                                                   "instanceid"=>230145964, 
    #                                                   "name"=>"Huntling", 
    #                                                   "market_hash_name"=>"Huntling", 
    #                                                   "color"=>"D2D2D2", 
    #                                                   "quality"=>"Standard", 
    #                                                   "rarity"=>"Immortal", 
    #                                                   "image"=>"https://cdn.dota2.net/item/Huntling/150.png", 
    #                                                   "price"=>5600, "comment"=>nil, "executed"=>1513543670}
    #                                                 ]} }
  end

  def send_message_order_complite
    telegram_bot_client do |bot|
      bot.api.send_message(chat_id: USER_ID, text: TEXT_MESSAGE_ORDER_COMPLITE)
    end
  end

  def validation_for_worked_orders
    if @@classids_worked_orders[-1] == mass_classids_of_worked_orders.first
      false
    else
      add_new_classid_order
      true
    end
  end

  def add_new_classid_order
    worked_orders.each do |item|
      @@classids_worked_orders << item["classid"]
      break
    end
  end

  def mass_classids_of_worked_orders
    m = []
    worked_orders.each do |item|
      m << item["classid"]
    end
    m
  end

  def worked_orders
    list_orders["log"]
  end

  def delete_old_classid_from_classids_worked_orders
    @@classids_worked_orders.shift if @@classids_worked_orders.size >= 5
  end
end
