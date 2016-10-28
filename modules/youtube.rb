module Bot
  module DiscordCommands
    module Youtube
      extend Discordrb::Commands::CommandContainer

      play_desc = 'Downloads and plays a youtube video (.play <linkhere>)'
      stop_desc = 'Stops the currently playing music'

      command(:play, description: play_desc) do |event, songlink|
        unless event.voice.nil?
          event.respond 'Already playing music'
          break
        end
        channel = event.user.voice_channel
        unless channel.nil?
          voice_bot = event.bot.voice_connect(channel)
          event.send_temp('Downloading...', 7)
          system("youtube-dl --no-playlist --max-filesize 50m -o 'music/#{event.server.id}.%(ext)s' -x --audio-format mp3 #{songlink}")
          event.respond 'Playing'
          voice_bot.play_file("./music/#{event.server.id}.mp3")
          voice_bot.destroy
          break
        end
        event.repond "You're not in any voice channel!"
      end
      command(:stop, description: stop_desc) do |event|
        event.voice.stop_playing
        nil
      end
    end
  end
end
