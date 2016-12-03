require 'open-uri'

module Bot
  module DiscordCommands
    module Youtube
      extend Discordrb::Commands::CommandContainer

      play_desc = 'Downloads and plays a youtube video'
      stop_desc = 'Stops the currently playing music'
      yt_usage = "#{CONFIG.prefix}play <youtube url> ` or a search ` #{CONFIG.prefix}play <what to search for>"

      BASE_URL = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=1&type=video&fields=items%2Fid&key=#{CONFIG.googleapi_key}"

      command([:play, :youtube, :music], usage: yt_usage, description: play_desc, min_args: 1) do |event, *songlink|
        unless songlink =~ /((http:[s]?\/\/)+youtube\.com|youtu.be)/i # could also use #match
          query = URI.encode(songlink.join(' '))
          apijson = open(BASE_URL + "&q=#{query}")
          response = JSON.parse(apijson.read)
          event.respond 'Nothing found :scream:' if response.empty?
          break if response.empty?
          songlink = 'https://www.youtube.com/watch?v=' + response['items'][0]['id']['videoId'].to_s
        end
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
        event.respond "You're not in any voice channel!"
      end
      command(:stop, description: stop_desc) do |event|
        event.voice.stop_playing
        return nil
      end
    end
  end
end
