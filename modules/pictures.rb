module Bot
  module DiscordCommands
    module Pictures
      extend Discordrb::Commands::CommandContainer

      bucket :pictures, limit: 3, time_span: 60, delay: 20

      picscooldown = 'Please wait %time%s before asking for more pics'
      zerg_desc = 'Posts a cute zergling gif'
      cat_desc = 'Posts a random cat'

      command(:zerg, bucket: :pictures, description: zerg_desc, rate_limit_message: picscooldown) do |event|
        event.channel.send_file File.new('images/zerg.gif')
      end

      command(:cat, bucket: :pictures, description: cat_desc, rate_limit_message: picscooldown) do |_event|
        catlink = JSON.parse(open('http://random.cat/meow').read)
        # RestClient.get('http://random.cat/meow') also works if you require('rest-client')
        "Nyaaa~! #{catlink['file'].gsub('.jpg', '')}"
      end
    end
  end
end
