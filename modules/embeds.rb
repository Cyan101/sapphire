module Bot
  module DiscordCommands
    module Embeds
      extend Discordrb::EventContainer
      extend Discordrb::Commands::CommandContainer

      info_desc = 'Information about Sapphire'

      command(:info, description: info_desc, help_available: true) do |event|
        event.channel.send_embed do |e|
          e.title = 'Cyan'
          e.description = 'The Color thief'
          e.url         = 'http://github.com/cyan101'
          e.timestamp   = Time.now.utc
          e.color       = '00aeef'
          e.thumbnail   = { url: 'https://puu.sh/stDbZ.png' }
          e.image       = { url: 'https://puu.sh/stDbZ.png' }
          e.author      = { name: 'Cyan101', url: 'http://github.com/cyan101', icon_url: 'https://puu.sh/stDbZ.png' }
          e.footer      = { text: '- Cyan', icon_url: 'https://puu.sh/stDbZ.png' }
          e.add_field     ({ name: 'Da Field', value: 'meme land 1700', inline: false })
          e.add_field     ({ name: 'Inline Field', value: 'gotta follow the rules :T', inline: true })
          e.add_field     ({ name: 'New Field 2.0', value: 'only the best freshest dankest memes here', inline: true })
        end
      end
    end
  end
end
