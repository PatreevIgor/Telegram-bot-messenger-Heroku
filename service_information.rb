module Information
  USER_ID = ENV['HIDE_USER_ID']

  def inform_about_sales
    if get_items_to_give["success"] == true
      telegram_bot_client do |bot|
        bot.api.send_message(chat_id: USER_ID, text: "Item sold!")
      end
    end
  end

  def get_items_to_give
    url = "https://market.dota2.net/api/GetItemsToGive/?key=#{ENV['SECRET_KEY']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    my_hash = JSON.parse(response.body)
  end  
end

