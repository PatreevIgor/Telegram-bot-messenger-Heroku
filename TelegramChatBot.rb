require 'telegram/bot'
require 'dotenv'
require 'i18n'
Dotenv.load
I18n.load_path = Dir['*.yml']
I18n.default_locale = :ru

class TelegramChatBot
  USER_ID = ENV['HIDE_USER_ID']
  MATCH_LAUGHT = I18n.translate(:laught).freeze
  MASSIVE_MATCH_TEXT = I18n.translate(:val_for_massive_match_text).freeze

  def listen_chat
    telegram_bot_client do |bot|
      bot.listen do |message|
        bot_responses(bot, message)
      end
    end
  end

  private
  def telegram_bot_client(&block)
     Telegram::Bot::Client.run(ENV['HIDE_TOKEN'], &block)
  end

  def bot_responses(bot, message)
    response_bot_to_user(bot, message)
    response_bot_on_find_match_laugh(bot, message)
    response_to_default_requests(bot,message)
  end

  def response_bot_to_user(bot,message)
    response_text = "Just had a mention of you in the group: #{message.chat.title} \n
                     The content of the message: #{message.text}"
    MASSIVE_MATCH_TEXT.each do |text_val|
      bot.api.send_message(chat_id: USER_ID, text: response_text) if message.text.include?(text_val)
    end
  end

  def response_bot_on_find_match_laugh(bot, message)
    bot.api.send_message(chat_id: message.chat.id, text: ":)") if message.text.include?(MATCH_LAUGHT)
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
end

TelegramChatBot.new.listen_chat
