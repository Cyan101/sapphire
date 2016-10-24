#Bot Setup + Connect
#-----------------------
require 'discordrb'
require 'rest-client' #For "cat" command
require 'rufus-scheduler' #For "uptime" command
$scheduler = Rufus::Scheduler.new
$uptime = 0

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

#Commands
#-----------------------
bot.command( :ping, bucket: :ping, description: ping_desc, help_available: true) do |event|
    "Pong o/ #{event.user.name}!"
end

bot.command( :zerg, bucket: :pictures, description: zerg_desc, help_available: true,  rate_limit_message: picscooldown) do |event|
    event.channel.send_file File.new('images/zerg.gif')
end

bot.command( :invite, bucket: :invite, description: invite_desc, help_available: true) do |event|
    "Invite me to any server with #{bot.invite_url}!"
end

bot.command( :cat, bucket: :pictures, description: cat_desc, help_available: true, rate_limit_message: picscooldown) do |event|
     catlink = JSON.parse(RestClient.get('http://random.cat/meow'))
    "Nyaaa~! #{catlink['file'].gsub('.jpg','')}"
end

bot.command(:eval, help_available: false) do |event, *code|
  break unless event.user.id == 141793632171720704
  begin
    eval code.join(' ')
  rescue
    'Sorry Sir, I ran into an error :cry:'
  end
end

bot.command(:exit, help_available: false) do |event|
  if event.user.id == 141793632171720704 then exit
  end
end

bot.command(:restart, help_available: false) do |event|
  if event.user.id == 141793632171720704 then
    event.channel.send_message('Restarting Sir')
    sleep 3
    bot.stop
    exec 'ruby sapphire.rb'
  end
end

bot.command( :roll, description: roll_desc) do |event, min = 0, max|
  rand(min.to_i .. max.to_i)
end

bot.command(:uptime, description: uptime_desc, help_available: true) do |event|
  if $uptime > 1440
    'uptime: ' + ($uptime/1440).to_s + 'day/s & ' + ($uptime/60).to_s + 'hour/s & ' + ($uptime%60).to_s + 'min'
  elsif $uptime > 60
    'uptime: ' + ($uptime/60).to_s + 'hour/s & ' + ($uptime%60).to_s + 'min'
  else
    "uptime: #{$uptime}min"
  end
  #$uptime > 60 ? "Uptime: " + ($uptime/60).to_s + "hour/s & " + ($uptime%60).to_s + "min" : "Uptime: #{$uptime}min"
end

$scheduler.every '1m' do
  $uptime += 1
end

#Non-Commands
#----------------------

# Ready event
bot.ready do
  START_TIME = Time.now
end

bot.message(contains: /(sapphire)/i) do |event|
  event.channel.send_message "Do you need me #{event.user.mention}?"
end

bot.message(contains: /(fuck)|(cunt)|(asshole)|(whore)|(bitch)/i) do |event|
  event.message.delete
  event.channel.send_message "Language!?! #{event.user.mention}"
end

#testing area -----------------
bot.command(:connect) do |event|
  channel = event.user.voice_channel

  next "You're not in any voice channel!" unless channel

  bot.voice_connect(channel)
  "Connected to voice channel: #{channel.name}"
end
bot.command(:play_mp3) do |event|
  voice_bot = event.voice
  voice_bot.play_file('./music/Burning Bright.mp3')
end

bot.run
end
