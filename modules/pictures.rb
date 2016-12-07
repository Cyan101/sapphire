require 'open-uri'
require 'rmagick'
include Magick

module Bot
  module DiscordCommands
    module Pictures
      extend Discordrb::Commands::CommandContainer

      bucket :pictures, limit: 3, time_span: 60, delay: 20
      bucket :trash, limit: 1, time_span: 60

      zerg_desc = 'Posts a cute zergling gif'
      trash_desc = 'Insults someone :T'
      weout_desc = 'Shows everyone that you are out of here!'
      pew_desc = 'Fires a volley of energy attacks at someone with a custom message'
      cat_desc = 'Posts a random cat'
      pew_usage = "#{CONFIG.prefix}pew @someone your message here"

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

      command([:pew, :pewpew, :pewpewpew, :attack],
              bucket: :trash, description: pew_desc, min_args: 2,
              rate_limit_message: trash_cooldown, usage: pew_usage) do |event, *text|
        next event.respond 'No one was mentioned :/' if event.message.mentions.empty?
        avatarurl = event.message.mentions[0].avatar_url
        id = event.message.mentions[0].id
        giflist = Magick::ImageList.new('images/pewpewpew.gif')
        `mkdir /tmp/SapphireBot`
        open("/tmp/SapphireBot/#{id}.jpg", 'wb') do |file|
          file << open(avatarurl).read
        end
        avatar = Magick::Image.read("/tmp/SapphireBot/#{id}.jpg").first
        message = text.each_with_index { |x, y| text.delete_at(y) if x.include?(id.to_s) }
        drawmessage = Draw.new  {
            self.font_family = 'arial.ttf'
            self.fill = 'black'
            self.stroke = 'transparent'
            self.pointsize = 32
            self.font_weight = BoldWeight
            self.gravity = NorthGravity
        }
        giflist.each do |image|
          image.composite!(avatar, NorthWestGravity, 2, 86, OverCompositeOp)
          drawmessage.annotate(image, 20, 20, 270, 260, message.join(' '))
        end
        giflist.write("/tmp/SapphireBot/#{id}.gif")
        event.channel.send_file File.new("/tmp/SapphireBot/#{id}.gif")
      end

      command([:cat, :kitten, :pussy], bucket: :pictures, description: cat_desc, rate_limit_message: pics_cooldown) do |_event|
        catlink = JSON.parse(open('http://random.cat/meow').read)
        # RestClient.get('http://random.cat/meow') also works if you require('rest-client')
        "Nyaaa~! #{catlink['file'].gsub('.jpg', '')}"
      end
    end
  end
end
