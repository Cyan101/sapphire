module Bot
  module DiscordCommands
    module React
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer

      poll_desc = 'Does a poll that ends after 120s, can have up to 5 options seperated with a \'-\''
      poll_usage = "#{CONFIG.prefix}poll <option 1> - <option 2> - <option 3>"

      command(:waifu, help_available: false) do |event|
        event.message.react '🇦'
        event.message.react '🇱'
        event.message.react '🇹'
        event.message.react '🇪'
        event.message.react '🇷'
      end

      command :newtada, help_available: false do |event|
        event.message.react '🎉'
      end

      command :america, help_available: false do |event|
        event.message.react '🇹'
        event.message.react '🇷'
        event.message.react '🇺'
        event.message.react '🇲'
        event.message.react '🇵'
      end

      message(contains: /.{5,}\?$/i) do |event|
        random = rand(1..3)
        event.message.react '✅' if random == 1
        event.message.react '❌' if random == 2
        event.message.react '❓' if random == 3
      end

      command :alter, help_available: false do |event|
        event.message.react '🍕'
      end

      command :poll, help_available: true, description: poll_desc, usage: poll_usage do |event, *message|
        reactions = %w(🇦 🇧 🇨 🇩 🇪)
        message = message.join(' ')
        options = message.split('-')
        next event.respond 'I can only count up to 5 options :stuck_out_tongue_closed_eyes:' if options.length > 5
        next event.respond 'I need at least one option :thinking:' if options.empty?
        eachoption = options.map.with_index { |x, i| "#{reactions[i]}. #{x.strip.capitalize}" }
        output = eachoption.join("\n")
        poll = event.respond "Starting poll for: (expires in 120s)\n#{output}"
        reactions[0...options.length].each do |r|
          poll.react r
        end
        sleep 120
        values = event.channel.message(poll.id).reactions.values
        winning_score = values.collect(&:count).max
        winners = values.select { |r| r.count == winning_score if reactions.include? r.name }
        result = ''
        result << 'Options: '
        reactions[0...options.length].each_with_index do |x, i|
          result << "#{x} = `#{options[i].strip.capitalize}`  "
        end
        result << "\n"
        result << 'Winner(s):'
        winners.each do |x|
          result << " #{x.name} with #{x.count-1} vote(s)"
        end
        #reactions[0...options.length].each_with_index do |x, i|
          #result << "#{x} `#{options[i].strip.capitalize}` had #{event.channel.message(poll.id).reactions[x].count} vote(s)  "
        #end
        #result << "\n"
        event.respond result
      end
    end
  end
end
