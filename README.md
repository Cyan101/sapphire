#Sapphire
Sapphire is a general multi-purpose "modularized" bot for discord, built with Ruby and the
https://github.com/meew0/discordrb gem

![Sapphire](http://i.imgur.com/dy1krGTt.jpg)

##Info
Version = 1.0

Ruby version 2.2+ required

##Install/Guide
```
gem install bundler
bundle
```
Lots of audio stuff is needed for this, depends on your linux system and repo's
```
python3
libsodium (python3-nacl and libsodium-dev worked for me)
libopus (libopusfile0 and libopus0 and libopusfile-dev worked for me)
ffmpeg
```

Install https://github.com/rg3/youtube-dl
(Feel free to set this up to work with the Gem and PR me)
```
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```

Setup the [token.txt](https://discordapp.com/developers/applications/me) and [saucenao.txt](https://saucenao.com/user.php)

Into a config.yaml file (see example below)
```
---
  bot_key: M------------------rw
  bot_id: 23---------88
  prefix: ','
  owner: 14----------04
  googleapi_key: AI------------------8w
  search_key: 00--------------------l8q
  saucenao_key: 49------------------1a
```


##Misc
MIT License 2016 Jos Spencer
