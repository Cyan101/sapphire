require 'vmstat'

module Bot
  module DiscordCommands
    module Embeds
      extend Discordrb::EventContainer
      extend Discordrb::Commands::CommandContainer

      info_desc = 'Information about Sapphire'

      command(:info, description: info_desc, help_available: true) do |event|
        sys = Vmstat.snapshot
        virtual_mem = "`#{(sys.task.virtual_size.to_f / 1000).to_s[0..4]}MB`"
        res_mem = "`#{(sys.task.resident_size.to_f / 1000).to_s[0..4]}MB`"
        free_mem = "#{Vmstat::memory::free_bytes / 1073000000}.#{Vmstat::memory::free_bytes % 1073000000}"
        cpus = sys.cpus.map do |x|
          (x.system + x.user).to_f / (x.user + x.system + x.idle).to_f
        end
        all_cpus = cpus.map.with_index { |x, y| "**#{y + 1}.** #{x.to_s[0..3]}%"}
        cpu_usage = (cpus.reduce(:+).to_f / cpus.length).to_s[0..3]     
        time_taken = sys.at.utc
        event.channel.send_embed do |e|
          e.author      = { name: event.bot.profile.name, url: 'http://github.com/cyan101/sapphire', icon_url: event.bot.profile.avatar_url }
          #e.title = 'System report'
          #e.description = 'Sapphire system information report'
          #e.url         = 'http://github.com/cyan101'
          #e.timestamp   = Time.now.utc
          e.color        = '3498db'
          e.thumbnail   = { url: event.bot.profile.avatar_url }
          #e.image       = { url: 'https://puu.sh/stDbZ.png' }
          #e.footer      = { text: '- Created by Cyan', icon_url: event.bot.profile.avatar_url }
          e.add_field     name: 'CPU Cores Usage:', value: all_cpus.join("\n"), inline: true
          e.add_field     name: 'Servers/Users:', value: "**Servers:** #{event.bot.servers.count}\n**Users:** #{event.bot.users.count}", inline: true 
          e.add_field     name: 'Total Memory:', value: virtual_mem, inline: true 
          e.add_field     name: 'In-Use Memory:', value: res_mem, inline: true 
          e.add_field     name: 'Free System Memory: ', value: '`' + free_mem[0..3] + 'GB`', inline: true
          e.add_field     name: 'Invite Link', value: "[Click here to Invite #{event.bot.profile.name} to your server!](#{event.bot.invite_url})", inline: false
        end
      end
    end
  end
end
