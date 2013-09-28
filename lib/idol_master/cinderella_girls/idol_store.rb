require 'open-uri'
require 'nokogiri'
require 'pathname'
require 'yaml'

module IdolMaster
  module CinderellaGirls
    class IdolStore
      CACHE_PATH = File.join(File.dirname(__FILE__), '.idols_cache')

      def self.open(options = {}, &block)
        new(options).open(&block)
      end

      def initialize(options = {})
        @cache = options[:cache_path] ? Cache.new(options[:cache_path]) : Cache::Null.new
      end

      def open
        yield -> (idol_id) { @cache[idol_id] ||= lookup(idol_id) }
      ensure
        @cache.save if @cache.changed?
      end

      private

      def lookup(idol_id)
        raise ArgumentError, 'idol ID should be integer' unless idol_id.is_a?(Integer)

        content       = Kernel.open("http://www5164u.sakura.ne.jp/idols/#{idol_id}").read
        document      = Nokogiri::HTML(content)
        profile       = document.xpath('//div[@id="show"]')
        status        = profile.xpath('.//div[@id="status-tab"]//table')
        lookup_status = -> (position) { status.xpath(".//tr[position()=#{position}]/td").text }

        {
          :name    => profile.xpath('.//h2').text,
          :offence => lookup_status[8].to_i,
          :defence => lookup_status[9].to_i,
          :cost    => lookup_status[3].to_i
        }
      end

      class Cache
        def initialize(path)
          @path = path.is_a?(Pathname) ? path : Pathname.new(path)
          load
        end

        def [](id)
          @cache[id]
        end

        def []=(id, spec)
          @cache[id] = spec
        end

        def load
          @cache    = @path.exist? ? YAML.load(@path.read) : {}
          @checksum = @cache.hash
        end

        def save
          @path.dirname.mkpath unless @path.dirname.exist?
          @path.open('w') { |file| YAML.dump(@cache, file) }
        end

        def changed?
          @checksum != @cache.hash
        end

        class Null < Cache
          def initialize
          end

          def [](id)
            nil
          end

          def []=(id, spec)
            spec
          end

          def load
          end

          def save
          end

          def changed?
            false
          end
        end
      end
    end
  end
end
