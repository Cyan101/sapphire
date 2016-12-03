require 'open-uri'

module Bot
  module DiscordCommands
    module Pictures
      extend Discordrb::Commands::CommandContainer

      bucket :pictures, limit: 3, time_span: 60, delay: 20
      bucket :trash, limit: 1, time_span: 60

      zerg_desc = 'Posts a cute zergling gif'
      trash_desc = 'Insults someone :T'
      weout_desc = 'Shows everyone that you are out of here!'
      cat_desc = 'Posts a random cat'

      pics_cooldown = 'Please wait %time%s before asking for more pics'
      trash_cooldown = 'Please stop being mean to people for just %time%s'

      command(:zerg, bucket: :pictures, description: zerg_desc, rate_limit_message: pics_cooldown) do |event|
        event.channel.send_file File.new('images/zerg.gif')
      end

      command(:trash, bucket: :trash, description: trash_desc, rate_limit_message: trash_cooldown) do |event|
        next event.respond('I need the `bully` role to use this command') unless event.bot.profile.on(event.server).roles.map {|x| x.name }.join.include? 'bully'
        event.channel.send_file File.new('images/trash_mean.gif')
      end

      command([:weout, :outofhere, :weareoutofhere, :fuckthis],
              bucket: :pictures, description: weout_desc, rate_limit_message: pics_cooldown) do |event|
        event.channel.send_file File.new('images/weoutofhere.gif')
      end

      command([:cat, :kitten, :pussy], bucket: :pictures, description: cat_desc, rate_limit_message: pics_cooldown) do |_event|
        catlink = JSON.parse(open('http://random.cat/meow').read)
        # RestClient.get('http://random.cat/meow') also works if you require('rest-client')
        "Nyaaa~! #{catlink['file'].gsub('.jpg', '')}"
      end
    end
  end
end
