# frozen_string_literal: true

class Pry
  class Command
    class FilteredBacktrace < Pry::ClassCommand
      match 'filtered-backtrace'
      group 'Context'
      description 'Show the filtered backtrace for the Pry session.'

      banner <<-BANNER
        Filtered backtrace displaying only backtrace parts related to the repository
      BANNER

      def process
        text =
          "#{bold('Filtered Backtrace:')}\n--\n#{pry_instance.backtrace.select { |line| line.include? 'my-media-store' }.join("\n")}"
        pry_instance.pager.page(text)
      end
    end

    Pry::Commands.add_command(Pry::Command::FilteredBacktrace)
  end
end

Pry.commands.alias_command 'fb', 'filtered-backtrace'

Pry.commands.delete '.<shell command>'

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

# rubocop:disable Style/MixinUsage
extend FactoryBot::Syntax::Methods
# rubocop:enable Style/MixinUsage
