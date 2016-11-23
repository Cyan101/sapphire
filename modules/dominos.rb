# frozen_string_literal: true
require 'json'
require 'nokogiri'
require 'rest-client'
require 'rufus-scheduler'
require 'terminal-table'

module Bot
  module DiscordCommands
    module Dominos
      module_function

      extend Discordrb::Commands::CommandContainer
      scheduler = Rufus::Scheduler.new

      pizza_desc = 'Prints out pizza vouchers (Aussie)'
      pizza_usage = "#{CONFIG.prefix}pizza"

      command(:update_pizza, help_available: false) do |event|
        break unless event.user.id == CONFIG.owner
        update_pizza
        return 'done'
      end

      command(:pizza, description: pizza_desc, usage: pizza_usage, help_available: true) do |event|
        file = File.read('pizza.json')
        yaypizza = JSON.parse(file, symbolize_names: true)
        rows = []
        yaypizza[:retailmenot][0..5].each do |x|
          rows << [x[:title][0..62] + '...', x[:success].to_s + '%', x[:code]]
        end
        yaypizza[:ozdiscount][0..5].each do |x|
          rows << [x[:title][0..62] + '...', 'N/A', x[:code]]
        end
        yaypizza[:ozbargain][0..5].each do |x|
          rows << [x[:title][0..62] + '...', 'N/A', x[:code]]
        end
        event.respond '```' + Terminal::Table.new(headings: ['Title', 'Success rate', 'Code'], rows: rows).to_s + '```'
      end

      scheduler.cron '0 6 * * *' do
        update_pizza
      end
      scheduler.cron '0 12 * * *' do
        update_pizza
      end
      scheduler.cron '0 18 * * *' do
        update_pizza
      end
      scheduler.cron '0 1 * * *' do
        update_pizza
      end

      def update_pizza
        dominos = Nokogiri::HTML RestClient.get('https://www.retailmenot.com/view/dominos.com.au')
        keys = %i(title success code)
        retailmenot = dominos.css('.offer.js-offer.code').map do |x|
          keys.zip([
                     x.css('.title').text.strip,
                     x.css('.js-percent').text.to_i,
                     x.css('.code-text').text
                   ]).to_h
        end
        retailmenot.sort_by! { |x| x[:success] }.reverse!
        #------------------------------------------------------
        dominos = Nokogiri::HTML RestClient.get('http://www.ozdiscount.com/store/dominos.com.au')
        keys = %i(title code)
        ozdiscount = dominos.css('.promo_wrapper.clear').map do |x|
          keys.zip([
                     x.css('.code_clr').text.strip,
                     x.css('.code').text
                   ]).to_h
        end
        ozdiscount.sort_by! { |x| x[:title] }.reverse!
        #-------------------------------------------------------puts '~~~~~~~~~Oz Bargain~~~~~~~~~'
        dominos = Nokogiri::HTML RestClient.get('https://www.ozbargain.com.au/deals/dominos.com.au')
        keys = %i(title code)
        ozbargain = dominos.css('.domaincoupons').css('ul').css('li').map do |x|
          keys.zip([
                     x.css('.desc').css('a').text,
                     x.css('.couponcode').css('strong').text
                   ]).to_h
        end
        # Output Stuff
        #-------------------------------------------------------
        vouchers = { retailmenot: retailmenot, ozdiscount: ozdiscount, ozbargain: ozbargain }
        file = File.open('pizza.json', 'w') do |f|
          f.write(vouchers.to_json)
        end
      end
    end
  end
end
