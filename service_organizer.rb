module Organizer
  require 'date'
  Dotenv.load
  USER_ID = ENV['HIDE_USER_ID']

  @@notice_current_day = true
  @@current_day = Date.new(2017,01,01)

  @@birthdays = { Date.new(1961,07,03) => 'Patreev Ivan',
                  Date.new(1962,06,28) => 'Patreeva Tamara',
                  Date.new(1958,01,31) => 'Pashyk Valentina Borisovna',
                  Date.new(1958,05,02) => 'Pashyk Sergei Vladimirovich',
                  Date.new(1981,06,24) => 'Soloviova Olga',
                  Date.new(2001,01,28) => 'Soloviov Ilya',
                  Date.new(1986,010,12) => 'Patreeva Alexandra',
                  Date.new(2015,11,19) => 'Patreeva Amalia',
                  Date.new(1986,010,05) => 'Shulgat Tatiana',
                  Date.new(2011,06,07) => 'Shulgat Maxim',
                  Date.new(2011,05,011) => 'Shulgat Gena',
                  Date.new(2011,03,15) => 'Berdnikovich Sergei',
                  Date.new(1987,07,05) => 'Romanov Aleksei',
                  Date.new(1987,010,24) => 'Baranovskiy Edik',
                  Date.new(2014,010,30) => 'Our wedding',
                  Date.new(2013,05,24) => 'The day we met',
                  Date.new(2014,02,24) => 'Began to live together'
                 }

  def notify_birthday
     @@birthdays.each do |date,name|
      if Date.today.to_s[5..-1] == date.to_s[5..-1] and @@notice_current_day == false
        telegram_bot_client do |bot|
          bot.api.send_message(chat_id: USER_ID, text: "Today is the birthday of #{name}")
        end
      end
     end
    @@notice_current_day = true
    change_val_notice_current_day
  end

  def notify_7_days_before_birthday
     @@birthdays.each do |date,name|
      if (Date.today-7).to_s[5..-1] == date.to_s[5..-1] and @@notice_current_day == false
        telegram_bot_client do |bot|
          bot.api.send_message(chat_id: USER_ID, text: "Through 7 days the birthday of #{name}")
        end
      end
     end
    @@notice_current_day = true
    change_val_notice_current_day
  end

  def change_val_notice_current_day
    if @@current_day != Date.today
      @@notice_current_day = false
      @@current_day = Date.today
    end
  end
end
