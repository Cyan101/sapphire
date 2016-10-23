#Bot Setup + Connect
#-----------------------
require 'discordrb'
token = File.read("token.txt")
bot = Discordrb::Commands::CommandBot.new token: token, client_id: 239802618757644288, prefix: '.'

#Buckets
#-----------------------
bot.bucket :zerg, limit: 2, time_span: 60, delay: 15


#Commands
#-----------------------
bot.command( :ping, description: "Alive check for the bot", help_available: true) do |event|
    "Pong o/ #{event.user.name}!"
end

bot.command( :zerg, bucket: :zerg, description: "Posts a cute zergling gif", help_available: true) do |event|
    event.channel.send_file File.new("images/zerg.gif")
end

#Non-Commands
#----------------------
bot.message(contains: /(sapphire)/i) do |event|
  event.channel.send_message "Do you need me #{event.user.mention}?"
end

bot.run
