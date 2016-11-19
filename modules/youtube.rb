# frozen_string_literal: true
module Bot
  module DiscordCommands
    module Youtube
      extend Discordrb::Commands::CommandContainer

      play_desc = 'Downloads and plays a youtube video (.play <linkhere>)'
      stop_desc = 'Stops the currently playing music'
      yt_usage = '.play <youtube url>'

      API_KEY = File.readlines('googleapi.txt')[0].chomp
      BASE_URL = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=1&type=video&fields=items%2Fid&key=#{API_KEY}"

      command(:play, usage: yt_usage, description: play_desc) do |event, *songlink|
        unless songlink =~ /((http:|https:)+\/\/youtube\.com|\/\/youtu.be)/i # could also use #match
          query = URI.encode(songlink.join(' '))
          apijson = open(BASE_URL + "&q=#{query}")
          response = JSON.parse(apijson.read)
          event.respond 'Nothing found :scream:' if response.empty?
          break if response.empty?
          songlink = (response['items'][0]['id']['videoId']).to_s
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
