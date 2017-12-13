module Control_time_trading
  DELETE_OLD_ORDERS_URL = "https://market.dota2.net/api/DeleteOrders/?key=#{ENV['SECRET_KEY']}".freeze

  def time_trade_control
    if check_status == false and Time.now.utc.hour < 21 and Time.now.utc.hour >= 3
      #puts "Use to trade_on" 
      trade_on
    elsif check_status == true and Time.now.utc.hour >= 21
      #puts "Use to trade_off" 
      trade_off
      delete_old_orders
    else
      #puts "Trading continue" 
    end
  end

  def check_status
    url = "https://market.dota2.net/api/Test/?key=#{ENV['SECRET_KEY']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    my_hash = JSON.parse(response.body)
    my_hash["status"]["site_online"]
  end

  def trade_on
    url = "https://market.dota2.net/api/PingPong/?key=#{ENV['SECRET_KEY']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    my_hash = JSON.parse(response.body)
  end

  def trade_off
    url = "https://market.dota2.net/api/GoOffline/?key=#{ENV['SECRET_KEY']}"
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    my_hash = JSON.parse(response.body)
  end

  def delete_old_orders
    url = DELETE_OLD_ORDERS_URL
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    my_hash = JSON.parse(response.body)
  end
end
