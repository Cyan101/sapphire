require 'rest-client'
require 'open-uri'
require "rubygems"
require "json"
kittens = open('http://random.cat/meow')
puts kittens.status
puts kittens.read
cat = RestClient.get('http://random.cat/meow')
puts cat

key = '138e045c350136a17b4e32527b5e04d2053637f2'
url = 'https://cdn.discordapp.com/attachments/244446768735977472/244463701778759680/rawr.jpg'

apijson = open("http://saucenao.com/search.php?output_type=2&numres=1&minsim=80&dbmask=8191&api_key=#{key}&url=#{url}")

output = JSON.parse(apijson.read)
output = output['results']
output = output[0]
output = output['data']
output = output['pixiv_id']
puts "http://www.pixiv.net/member_illust.php?mode=medium&illust_id=#{output}"
puts '----'
#puts blah