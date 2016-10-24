#Bot Setup + Connect
#-----------------------
require 'discordrb'
require 'rest-client' #For "cat" command
require 'time_diff' #For "uptime" command

module Bot
token = File.read('token.txt')
bot = Discordrb::Commands::CommandBot.new token: token, client_id: 239802618757644288, prefix: '.'

#Buckets
#-----------------------
bot.bucket :pictures, limit: 5, time_span: 60, delay: 5
bot.bucket :ping, limit: 1, time_span: 60
bot.bucket :invite, limit: 1, time_span: 240

module DiscordCommands; end
Dir['modules/*.rb'].each { |mod| load mod }
DiscordCommands.constants.each do |mod|
  bot.include! DiscordCommands.const_get mod
end

#Varible Declarations
#-----------------------
picscooldown = 'Please wait %time%s before asking for more pics'
ping_desc = 'Alive check for the bot'
zerg_desc = "Posts a cute zergling gif"
invite_desc = 'Invite url to add the bot to another server'
cat_desc = 'Posts a random cat'
roll_desc = "Rolls between 1 and the number specified, or both numbers specified"
uptime_desc = 'Prints the bots current uptime'
play_desc = 'Downloads and plays a youtube video (.play <linkhere>)'
stop_desc = 'Stops the currently playing music'

#Commands
#-----------------------
bot.command( :ping, bucket: :ping, description: ping_desc) do |event|
    "Pong o/ #{event.user.name}!"
end

bot.command( :zerg, bucket: :pictures, description: zerg_desc,  rate_limit_message: picscooldown) do |event|
    event.channel.send_file File.new('images/zerg.gif')
end

bot.command( :invite, bucket: :invite, description: invite_desc) do |event|
    "Invite me to any server with #{bot.invite_url}"
end

bot.command( :cat, bucket: :pictures, description: cat_desc, rate_limit_message: picscooldown) do |event|
     catlink = JSON.parse(RestClient.get('http://random.cat/meow'))
    "Nyaaa~! #{catlink['file'].gsub('.jpg','')}"
end

bot.command(:eval, help_available: false) do |event, *code|
  break unless event.user.id == 141793632171720704
  begin
    eval code.join(' ')
  rescue => e
    "Sorry Sir: ```#{e}``` :cry:"
  end
end

bot.command(:restart, help_available: false) do |event|
  if event.user.id == 141793632171720704 then
    event.respond 'Restarting Sir'
    bot.stop
  end
end 

bot.command(:clean, help_available: false) do |event, num|
  if event.user.id == 141793632171720704 then
  event.channel.prune(num.to_i + 1)
end
end 

bot.command( :roll, description: roll_desc) do |event, min = 1, max|
  rand(min.to_i .. max.to_i)
end


bot.command(:uptime, description: uptime_desc) do |event|
  uptime = Time.diff(Time.now, START_TIME)
  'Uptime: '\
  "`#{uptime[:day]}days,"\
  " #{uptime[:hour]}hours &"\
  " #{uptime[:minute]}minutes`"
end

#Non-Commands
#----------------------

# Ready event
bot.ready do
  START_TIME = Time.now
end

#Non-Commands
#----------------------
bot.message(contains: /(sapphire)/i) do |event|
  event.respond "Do you need me #{event.user.mention}?"
end

bot.message(contains: /(fuck)|(cunt)|(asshole)|(whore)|(bitch)/i) do |event|
  event.message.delete
  event.respond "Language!?! #{event.user.mention}"
end

#testing area -----------------
bot.command(:play, description: play_desc) do |event, songlink|
  if !event.voice.nil?
    event.respond 'Already playing music'
    break
  end
  channel = event.user.voice_channel
  unless channel.nil?
    voice_bot = bot.voice_connect(channel)
    event.send_temp('Downloading...', 7)
    system("youtube-dl --no-playlist --max-filesize 50m -o 'music/#{event.server.id}.%(ext)s' -x --audio-format mp3 #{songlink}")
    event.respond "Playing"
    voice_bot.play_file("./music/#{event.server.id}.mp3")
    voice_bot.destroy
    break
  end
  event.repond "You're not in any voice channel!"
end
bot.command(:stop, description: stop_desc) do |event|
  event.voice.stop_playing
  nil
end

bot.run
end