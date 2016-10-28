module Bot
  module DiscordCommands
    module Pictures
      extend Discordrb::Commands::CommandContainer
      
      bot.bucket :pictures, limit: 5, time_span: 60, delay: 5

      
      picscooldown = 'Please wait %time%s before asking for more pics'
      zerg_desc = 'Posts a cute zergling gif'
      cat_desc = 'Posts a random cat'


  command(:zerg, bucket: :pictures, description: zerg_desc, rate_limit_message: picscooldown) do |event|
    event.channel.send_file File.new('images/zerg.gif')
  end

  command(:cat, bucket: :pictures, description: cat_desc, rate_limit_message: picscooldown) do |_event|
    catlink = JSON.parse(RestClient.get('http://random.cat/meow'))
    "Nyaaa~! #{catlink['file'].gsub('.jpg', '')}"
  end
end
end
end