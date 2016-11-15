# Bot Setup + Connect
#-----------------------
require 'bundler/setup'
require 'discordrb'
require 'open-uri'
require 'time_diff' # For "uptime" command

module Bot
  token = File.read('token.txt').strip
  botid = 239_802_618_757_644_288
  owner = 141_793_632_171_720_704
  bot = Discordrb::Commands::CommandBot.new token: token, client_id: botid, prefix: '.'

  # Buckets
  #-----------------------
  bot.bucket :ping, limit: 1, time_span: 60
  bot.bucket :invite, limit: 1, time_span: 240

  module DiscordCommands; end
  Dir['modules/*.rb'].each { |mod| load mod }
  DiscordCommands.constants.each do |mod|
    bot.include! DiscordCommands.const_get mod
  end

  # Varible Declarations
  #-----------------------
  ping_desc = 'Alive check for the bot'
  invite_desc = 'Invite url to add the bot to another server'
  roll_desc = 'Rolls between 1 and the number specified, or both numbers specified'
  uptime_desc = 'Prints the bots current uptime'
  tada_desc = 'Celebrates!!!'

  # Commands
  #-----------------------
  bot.command(:ping, bucket: :ping, description: ping_desc) do |event|
    "Pong o/ #{event.user.name}!"
  end

  bot.command(:invite, bucket: :invite, description: invite_desc) do |_event|
    "Invite me to any server with #{bot.invite_url}"
  end

  bot.command(:eval, help_available: false) do |event, *code|
    break unless event.user.id == owner
    begin
      eval code.join(' ')
    rescue => e
      "It didn't work :cry: sorry.... ```#{e}```"
    end
  end

  bot.command(:restart, help_available: false) do |event|
    if event.user.id == owner
      event.respond 'Restarting Sir'
      bot.stop
    end
  end
  
  bot.command(:game, help_available: false) do |event, *game|
    if event.user.id == owner
      bot.game=(game.join(' '))
    end
  end
  
  bot.command(:setname, help_available: false) do |event, name|
    if event.user.id == owner
      bot.profile.username=(name)
    end
  end
  
  bot.command(:setavatar, help_available: false) do |event, url|
    if event.user.id == owner
      open(url) { |pic| bot.profile.avatar=(pic) }
    end
  end
  
  bot.command(:tada, description: tada_desc) do |event|
     ":tada::tada::tada::tada::tada:"
  end
  
  bot.command(:clean, help_available: false) do |event, num|
    event.channel.prune(num.to_i + 1) if event.user.id == 141_793_632_171_720_704
  end

  bot.command(:roll, description: roll_desc) do |_event, min = 1, max|
    rand(min.to_i..max.to_i)
  end

  bot.command(:uptime, description: uptime_desc) do |_event|
    uptime = Time.diff(Time.now, START_TIME)
    'Uptime: '\
    "`#{uptime[:day]}days,"\
    " #{uptime[:hour]}hours &"\
    " #{uptime[:minute]}min`"
  end

  # Ready event
  bot.ready do
    START_TIME = Time.now
  end

  bot.run
end
