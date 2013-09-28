require 'stringio'

module IdolMaster
  module CinderellaGirls
    class Ensure < Array
      def initialize(idols, side, cost_limit)
        super()

        rate_attr_name = :"#{side}_rate"
        idols = idols.sort_by { |idol| [-idol.send(rate_attr_name), -idol.cost, idol.id] }
        total_value = 0
        total_cost = 0

        output = StringIO.new
        border_index = -1

        idols.each_with_index do |idol, index|
          value = idol.send(side)
          rate = idol.send(rate_attr_name)

          if (total_cost + idol.cost) <= cost_limit
            total_value += idol.actual(side)
          elsif total_cost < cost_limit
            total_value += idol.actual(side, cost_limit - total_cost)
            border_index = index
          else
            border_index = index
          end

          self << idol
          output.print("#{idol.send(rate_attr_name).to_s.rjust(4)}: #{idol}")

          if (total_cost + idol.cost) == cost_limit
            border_index = index
            output.puts
            break
          elsif border_index >= 0
            output.puts(" (ensure #{cost_limit - total_cost}/#{idol.cost})")
            break
          end

          output.puts
          total_cost += idol.cost
        end

        if border_index >= 0
          extra_output = StringIO.new

          idols[border_index + 1, 5].each do |idol|
            extra_output.puts("#{idol.send(rate_attr_name).to_s.rjust(4)}: #{idol}")
          end

          width = (output.string + extra_output.string).lines.map { |line|
            line.chomp.chars.map { |char|
              [0x00..0xff, 0xff61..0xff9f].any? { |range| range.include?(char.ord) } ? 1 : 2
            }.reduce(:+)
          }.max

          output.puts('-' * width)
          output.print(extra_output.string)
        end

        @output = output.string
        @value  = total_value
      end

      attr_reader :output, :value
    end
  end
end
