module Bot
  module DiscordCommands
    module Rawr
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer
      sauce_desc = "Uses a bunch of reverse image search tools/sites"
      command( :sauce, description: sauce_desc, help_available: true) do |event|
        if event.message.attachments[0]&.url
        url = event.message.attachments[0]&.url
        key = File.read('saucenao.txt').strip #same as the bot token, get this from saucenao.com by registering
        apijson = open("http://saucenao.com/search.php?output_type=2&numres=1&minsim=80&dbmask=8191&api_key=#{key}&url=#{url}")
        output = JSON.parse(apijson.read)
        output = output['results']
        output = output[0]
        output = output['data']
        output = output['pixiv_id']
        return "Here is the most accurate match http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{output}"
        else
        "Upload an image with the comment `.sauce`"
        end
      end
    end
  end
end
