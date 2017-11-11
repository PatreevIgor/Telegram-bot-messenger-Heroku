module Information
  USER_ID = ENV['HIDE_USER_ID']
  items_ids = []

  def inform_about_sales
    if get_items_to_give["success"] == true and validation_send == true
      send_message if get_items_to_give["success"] == true
    end
  end

  def send_message
    telegram_bot_client do |bot|
      bot.api.send_message(chat_id: USER_ID, text: "Item sold!")
    end
  end

  def get_items_to_give
    url = "https://market.dota2.net/api/GetItemsToGive/?key=#{ENV['SECRET_KEY']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    my_hash = JSON.parse(response.body)
  end

  private
  def validation_send
    sold_items.each do |item|
      if items_ids.include?(item["ui_id"])
        false
      else
        items_ids << item["ui_id"]
        true
      end
    end
    delete_old_ui_ids
  end

  def sold_items
    get_items_to_give["offers"]
  end

  def delete_old_ui_ids
    items_ids.рор if items_ids.size >= 20
  end
end

