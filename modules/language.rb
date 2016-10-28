module Bot
  module DiscordCommands
    module Language
      extend Discordrb::EventContainer
      
      message(contains: /(sapphire)/i) do |event|
  event.respond "Do you need me #{event.user.mention}?"
end

message(contains: /(fuck)|(cunt)|(asshole)|(whore)|(bitch)/i) do |event|
  event.message.delete
  event.respond "Language!?! #{event.user.mention}"
end
end
end
end