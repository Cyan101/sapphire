require 'vmstat'

module Bot
  module DiscordCommands
    module Embeds
      extend Discordrb::EventContainer
      extend Discordrb::Commands::CommandContainer

      info_desc = 'Information about Sapphire'

      command(:info, description: info_desc, help_available: true) do |event|
        sys = Vmstat.snapshot
        res_mem = (sys.task.resident_size.to_f / 1000).to_s
        free_mem = (sys.memory.free_bytes / 1_073_000_000).to_s + '.' + (sys.memory.free_bytes % 1_073_000_000).to_s
        cpus = sys.cpus.map do |x|
          (x.system + x.user).to_f / (x.user + x.system + x.idle).to_f
        end
        all_cpus = cpus.map.with_index { |x, y| "**#{y + 1}.** #{x.to_s[0..3]}%" }
        event.channel.send_embed do |e|
          e.author = {name: event.bot.profile.name, url: 'http://github.com/cyan101/sapphire', icon_url: event.bot.profile.avatar_url}
          e.color = '3498db'
          e.thumbnail = {url: event.bot.profile.avatar_url}
          # e.title = 'System report'
          # e.description = 'Sapphire system information report'
          # e.url         = 'http://github.com/cyan101'
          # e.timestamp   = Time.now.utc
          # e.image       = { url: 'https://puu.sh/stDbZ.png' }
          # e.footer      = { text: '- Created by Cyan', icon_url: event.bot.profile.avatar_url }
          e.add_field name: 'CPU Cores Usage:', value: all_cpus.join("\n"), inline: true
          e.add_field name: 'Servers/Users:', value: "**Servers:** #{event.bot.servers.count}\n**Users:** #{event.bot.users.count}", inline: true
          e.add_field name: 'Server\'s inactive Memory: ', value: "`#{free_mem[0..3]}GB`", inline: true
          e.add_field name: "#{event.bot.profile.name} is using:", value: "`#{res_mem[0..4]}MB`", inline: true
          e.add_field name: 'Version info:',
                      value: "**Ruby:** `#{RUBY_VERSION}`\n**Discordrb:** `#{Discordrb::VERSION}`\n**Sapphire:** `#{CONFIG.bot_vers}`",
                      inline: true
          e.add_field name: 'Invite Link', value: "[Click here to Invite #{event.bot.profile.name} to your server!](#{event.bot.invite_url})", inline: true
        end
      end
    end
  end
end
