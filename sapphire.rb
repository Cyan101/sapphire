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
bot.bucket :zerg, limit: 2, time_span: 60, delay: 15

module DiscordCommands; end
Dir['modules/*.rb'].each { |mod| load mod }
DiscordCommands.constants.each do |mod|
  bot.include! DiscordCommands.const_get mod
end

#Commands
#-----------------------
bot.command( :ping, description: 'Alive check for the bot', help_available: true) do |event|
    "Pong o/ #{event.user.name}!"
end

bot.command( :zerg, bucket: :zerg, description: 'Posts a cute zergling gif', help_available: true) do |event|
    event.channel.send_file File.new('images/zerg.gif')
end

bot.command( :invite, description: 'Invite url for the bot', help_available: true) do |event|
    "Invite me to any server with #{bot.invite_url}!"
end

bot.command( :cat, description: 'Posts a random cat', help_available: true) do |event|
     catlink = JSON.parse(RestClient.get('http://random.cat/meow'))
    "Nyaaa~! #{catlink["file"].gsub('.jpg','')}"
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

bot.command(:uptime, description: 'Prints the bots current uptime', help_available: true) do |event|
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
bot.message(contains: /(sapphire)/i) do |event|
  event.channel.send_message "Do you need me #{event.user.mention}?"
end

bot.message(contains: /(fuck)|(cunt)|(asshole)|(whore)|(bitch)/i) do |event|
  event.message.delete
  event.channel.send_message "Language!?! #{event.user.mention}"
end

bot.run
end