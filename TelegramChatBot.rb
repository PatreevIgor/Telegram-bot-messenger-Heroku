require 'telegram/bot'
require 'dotenv'
require 'net/http'
require 'uri'
require 'json'
require 'dotenv'
require './service_control_time_trading'
require './service_information'
require './service_organizer'
Dotenv.load

class TelegramChatBot
  include Control_time_trading
  include Information
  include Organizer

  def run
    telegram_bot_client do |bot|
      loop do
        sleep(5)
        inform_about_sales
        time_trade_control
        notify_birthday
      end
    end
  end

  private
  def telegram_bot_client(&block)
     Telegram::Bot::Client.run(ENV['HIDE_TOKEN'], &block)
  end
end

TelegramChatBot.new.run
