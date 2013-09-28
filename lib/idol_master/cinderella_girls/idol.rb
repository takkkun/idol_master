module IdolMaster
  module CinderellaGirls
    class Idol
      def initialize(id, name, offence, defence, cost)
        @id = id
        @name = name
        @offence = offence
        @offence_rate = offence / cost
        @defence = defence
        @defence_rate = defence / cost
        @cost = cost
      end

      attr_reader :id, :name, :offence, :offence_rate, :defence, :defence_rate, :cost

      def actual(side, cost = @cost)
        raise ArgumentError unless [:offence, :defence].include?(side.to_sym)
        __send__(side) * cost / @cost
      end

      def to_s
        "[#{@id.to_s.rjust(4)}] #{@name}"
      end
    end
  end
end
