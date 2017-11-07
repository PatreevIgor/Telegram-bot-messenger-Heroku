require 'telegram/bot'
require 'dotenv'
require 'i18n'
require 'net/http'
require 'uri'
require 'json'
require 'dotenv'

Dotenv.load
I18n.load_path = Dir['*.yml']
I18n.default_locale = :ru

class TelegramChatBot
  USER_ID = ENV['HIDE_USER_ID']

  def run
    telegram_bot_client do |bot|
      loop do
        sleep(30)
        inform_about_sales
        time_trade_control
      end
    end
  end

  private
  def telegram_bot_client(&block)
     Telegram::Bot::Client.run(ENV['HIDE_TOKEN'], &block)
  end

  def response_to_default_requests(bot, message)
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    when '/show_my_id'
      bot.api.send_message(chat_id: message.chat.id, text: "You ID #{message.from.id}")
    when '/help'
      bot.api.send_message(chat_id: message.chat.id, text: "All available commands:\n
                                                            /help\n
                                                            /start\n
                                                            /stop\n
                                                            /show_my_id\n ")
    end
  end

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

  def time_trade_control
    if check_status == false and Time.now.utc.hour < 21 and Time.now.utc.hour >= 3
      #puts "Использование trade_on" 
      trade_on
    elsif check_status == true and Time.now.utc.hour >= 21
      #puts "Использование trade_off" 
      trade_off
    else
      #puts "Торговля продолжается" 
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

end

TelegramChatBot.new.run
