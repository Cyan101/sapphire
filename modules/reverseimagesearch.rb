module Bot
  module DiscordCommands
    module Rawr
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer
      sauce_desc = "Uses saucenao to reverse image search, run the command for more help"
      command( :sauce, description: sauce_desc, help_available: true) do |event, messageurl=false|
        if event.message.attachments[0]&.url
        url = event.message.attachments[0]&.url
        key = File.read('saucenao.txt').strip #same as the bot token, get this from saucenao.com by registering
        apijson = open("http://saucenao.com/search.php?output_type=2&numres=1&minsim=80&dbmask=8191&api_key=#{key}&url=#{url}")
        output = JSON.parse(apijson.read)
        output = output['results']
        output = output[0]
        output = output['data']
        output = output['pixiv_id']
        event.channel.send_message("Here is the most accurate match http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{output}")
      elsif messageurl
        key = File.read('saucenao.txt').strip
        apijson = open("http://saucenao.com/search.php?output_type=2&numres=1&minsim=80&dbmask=8191&api_key=#{key}&url=#{messageurl}")
        output = JSON.parse(apijson.read)
        output = output['results']
        output = output[0]
        output = output['data']
        output = output['pixiv_id']
        event.channel.send_message("Here is the most accurate match http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{output}")
      else
        "Upload an image with the comment `.sauce` or `.sauce http://randomwebsite.com/image.jpg`"
        end
      end
    end
  end
end
