require 'optparse'

module QiitaExport
  class Config

    HOME_CONFIG_FILE = "~/.qiita-exportrc"
    LOCAL_CONFIG_FILE = "./.qiita-exportrc"

    DEFAULT_USER_AGENT = "QiitaExport Gem #{QiitaExport::VERSION}"

    DEFAULT_HEADER = {
      "User-Agent" => DEFAULT_USER_AGENT
    }

    DEFAULT_KOBITO_DB = "~/Library/Containers/com.qiita.Kobito/Data/Library/Kobito/Kobito.db"

    class << self
      def configure(argv)
        @option = {}
        @parser = OptionParser.new do |opt|
          opt.version = QiitaExport::VERSION
          opt.on('-u', '--url=url',            'specify the URL for the Qiita(or Qiita Team).')   { |v| @option[:url] = v }
          opt.on('-l', '--url-list=filepath',  'specify the file path of the URL list.')          { |v| @option[:'url-list'] = v }
          opt.on('-U', '--user-id=user_id',    'specify the userid for the Qiita.')               { |v| @option[:'user-id'] = v }
          opt.on('-k', '--kobito=[Kobito.db]', 'export Kobito.app database.')                     { |v| @option[:kobito] = v }
          opt.on('-t', '--team=teamname',      'export Qiita Team articles only.')                { |v| @option[:team] = v }
          opt.on('-i', '--image',              'export with images.')                             { |v| @option[:image] = v }
          opt.on('-h', '--html',               'export in html format(experimental).')            { |v| @option[:html] = v }
          opt.on('-o', '--output-dir=dirpath', 'specify the full path of destination directory.') { |v| @option[:'output-dir'] = v }
          opt.on('-a', '--api-token=token',    'specify API token for Qiita.')                    { |v| @option[:'api-token'] = v }
        end

        # load home config
        @parser.load(File.expand_path(HOME_CONFIG_FILE))

        # load local config
        @parser.load(File.expand_path(LOCAL_CONFIG_FILE))

        # parse argv
        @parser.parse!(argv)

        self
      end

      def empty?
        @option.empty?
      end

      def help
        @parser.help
      end

      def validate!
        if present?(@option[:'url-list']) && !File.exist?(@option[:'url-list'])
          fail ArgumentError.new("-l (#{@option[:'url-list']}) does not exist.")
        end

        if kobito? && !File.exist?(kobito_db)
          fail ArgumentError.new("#{kobito_db} does not exist.")
        end

        if kobito? && api?
          fail ArgumentError.new("if you specify option --kobito, you cannot specify option --url, --url-list and --user-id.")
        end
      end

      def kobito?
        @option.key?(:kobito)
      end

      def api?
        present?(@option[:url]) || present?(@option[:'url-list']) || present?(@option[:'user-id'])
      end

      def user?
        present?(@option[:'user-id'])
      end

      def team?
        present?(@option[:team])
      end

      def file_export?
        present?(@option[:'output-dir'])
      end

      def html_export?
        @option[:html]
      end

      def image_export?
        @option[:image]
      end

      def team_url?(url)
        url !~ /^https?:\/\/qiita\.com/
      end

      DOMAIN_PATTERN = Regexp.new("https?://([^/]+)/")
      def team_name(url = nil)
        if (kobito? || user?) && team?
          @option[:team]
        elsif api? && team_url?(url)
          url.match(DOMAIN_PATTERN)[1].split('.')[0]
        else
          ""
        end
      end

      def article_urls
        urls = []
        urls << @option[:url] if present?(@option[:url])

        if present?(@option[:'url-list'])
          open(@option[:'url-list']) { |io|
            io.each_line { |line|
              url = line.chop
              next if blank?(url)
              urls << url
            }
          }
        end
        urls
      end

      def kobito_db
        if blank?(@option[:kobito])
          File.expand_path(DEFAULT_KOBITO_DB)
        else
          File.expand_path(@option[:kobito])
        end
      end

      def api_token
        @option[:'api-token']
      end

      def has_api_token?
        present?(@option[:'api-token'])
      end

      def default_header
        DEFAULT_HEADER.clone
      end

      def auth_header
        header = default_header
        header["Authorization"] = "Bearer #{api_token}"
        header
      end

      def user_id
        @option[:'user-id']
      end

      def export_dir_path
        if user?
          File.join(File.expand_path(@option[:'output-dir'].strip), user_id)
        else
          File.expand_path(@option[:'output-dir'].strip)
        end
      end

      def filename(title)
        return "" if !html_export? && blank?(title)
        if html_export?
          "index.html"
        else
          "#{title.gsub(/\//, ':')}.md"
        end
      end

      private

      def blank?(str)
        str.nil? || str.empty?
      end

      def present?(str)
        !blank?(str)
      end
    end
  end
end
