module Information
  Dotenv.load
  USER_ID = ENV['HIDE_USER_ID']
  TELEGRAMM_TEXT_MESSAGE = 'Item sold!'.freeze
  GET_ITEMS_TO_GIVE_URL = "https://market.dota2.net/api/GetItemsToGive/?key=#{ENV['SECRET_KEY']}"
  @@items_ids = []

  def inform_about_sales
    if get_items_to_give["success"]
      send_message if validation
    end
    delete_old_items_from_items_ids
  end

  private
  def get_items_to_give
    uri = URI.parse(GET_ITEMS_TO_GIVE_URL)
    response = Net::HTTP.get_response(uri)
    my_hash = JSON.parse(response.body)
    # {"success"=>true, "offers"=>[{"ui_id"=>"95899249",                     "i_name"=>"Searing Dominator",
    #                               "i_market_name"=>"Searing Dominator",         "i_name_color"=>"D2D2D2",
    #                               "i_rarity"=>"Immortal", "i_descriptions"=>nil,        "ui_status"=>"2",
    #                               "he_name"=>"Huskar", "ui_price"=>27.47,       "i_classid"=>"949841616",
    #                               "i_instanceid"=>"230145964",             "ui_real_instance"=>"unknown",
    #                               "i_quality"=>"Standard",     "i_market_hash_name"=>"Searing Dominator",
    #                               "i_market_price"=>45.12,  "position"=>1, "min_price"=>0, "ui_bid"=>"0",
    #                               "ui_asset"=>"0", "type"=>"2",  "ui_price_text"=>"27.47<small></small>",
    #                               "min_price_text"=>false, "i_market_price_text"=>"45.12<small></small>",
    #                               "left"=>2903, "placed"=>"12 минут назад"}]}
  end

  def send_message
    telegram_bot_client do |bot|
      bot.api.send_message(chat_id: USER_ID, text: TELEGRAMM_TEXT_MESSAGE)
    end
  end

  def validation
    if @@items_ids[-1] == mass_current_ids.first
      false
    else
      add_new_item_id
      true
    end
  end
  
  def add_new_item_id
    sold_items.each do |item|
      @@items_ids << item["ui_id"]
      break
    end
  end

  def mass_current_ids
    m = []
    sold_items.each do |item|
      m << item["ui_id"]
    end
    m
  end

  def sold_items
    get_items_to_give["offers"]
  end

  def delete_old_items_from_items_ids
    @@items_ids.shift if @@items_ids.size >= 5
  end
end
