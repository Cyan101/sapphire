require 'open-uri'

module Bot
  module DiscordCommands
    module Rawr
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer
      sauce_desc = "Uses saucenao to reverse image search, run the command for more help"
      sauce_usage = "#{CONFIG.prefix}sauce <imageurl> ` or on an uploaded image comment: `#{CONFIG.prefix}sauce"
      command( :sauce, description: sauce_desc, usage: sauce_usage, help_available: true) do |event, messageurl=false|
        if event.message.attachments[0]&.url
        url = event.message.attachments[0]&.url
        apijson = open("http://saucenao.com/search.php?output_type=2&numres=1&minsim=80&dbmask=32&api_key=#{CONFIG.saucenao_key}&url=#{url}")
        response = JSON.parse(apijson.read)
        output = response['results'][0]['data']['pixiv_id']
        event.channel.send_message("Here is the most accurate match http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{output}")
      elsif messageurl
        apijson = open("http://saucenao.com/search.php?output_type=2&numres=1&minsim=80&dbmask=32&api_key=#{CONFIG.saucenao_key}&url=#{messageurl}")
        response = JSON.parse(apijson.read)
        output = response['results'][0]['data']['pixiv_id']
        event.channel.send_message("Here is the most accurate match http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{output}")
      else
        "Upload an image with the comment `.sauce` or `.sauce http://randomwebsite.com/image.jpg`"
        end
      end
    end
  end
end
