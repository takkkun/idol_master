require 'idol_master/cinderella_girls/idol'
require 'idol_master/cinderella_girls/idol_store'
require 'idol_master/cinderella_girls/ensure'
require 'yaml'

module IdolMaster
  module CinderellaGirls
    class User
      def initialize(path, options = {})
        @options = options
        data     = YAML.load_file(path)
        @status  = Status.new(data['status'])
        @idols   = fetch_idols(data['idols'])
      end

      attr_reader :status, :idols

      def ensure_idols(side)
        Ensure.new(@idols, side, @status.send(side))
      end

      private

      def fetch_idols(idols)
        idol_store = @options[:idol_store] || {}
        idol_store = IdolStore.new(idol_store) if idol_store.is_a?(Hash)

        idol_store.open do |store|
          idols.map do |fields|
            fields = case fields
                     when Integer then {id: fields}
                     when Hash    then Hash[fields.map { |k, v| [k.to_sym, v] }]
                                  else {}
                     end

            idol_id = fields.delete(:id)
            fields = (idol_id ? store[idol_id] : {}).merge(fields)
            Idol.new(idol_id || 0, *[:name, :offence, :defence, :cost].map { |key| fields[key] })
          end
        end
      end

      class Status
        def initialize(status)
          @offence = status['offence']
          @defence = status['defence']
        end

        attr_reader :offence, :defence
      end
    end
  end
end
