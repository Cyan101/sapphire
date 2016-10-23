require 'discordrb'
token = File.read("token.txt")
puts token
bot = Discordrb::Bot.new token: token, client_id: 239802618757644288#, prefix: '.',


bot.message(with_text: ".ping") do |event|
  event.respond "Pong o/ #{event.user.name}!"
end


bot.run
