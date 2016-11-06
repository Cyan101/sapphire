#Sapphire
Sapphire is/will be a general purpose "modularized" bot for discord, built with Ruby and the
https://github.com/meew0/discordrb gem

##Info
Version = 0.5

Ruby version 2.2+ required

Audio playback works on multiple servers, but all modules are loaded and affect all connected servers

##Install/Guide
```
gem install bundler
bundler
```
Lots of audio stuff is needed for this, depends on your linux system and repo's
(No help from me for windows/mac users, sorry)
```
python3
libsodium (python3-nacl and libsodium-dev worked for me)
libopus (libopusfile0 and libopus0 and libopusfile-dev worked for me)
ffmpeg
```

Install https://github.com/rg3/youtube-dl
(Yes, I am aware there are a few gems but I found working directly with it was so much easier.
Feel free to change this and send me a PR)
```
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```

Setup the [token.txt](https://discordapp.com/developers/applications/me) and [saucenao.txt](https://saucenao.com/user.php) (signup and then go to api)



##Misc
MIT License 2016 Jos Spencer
