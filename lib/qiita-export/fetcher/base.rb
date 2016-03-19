# -*- coding: utf-8 -*-
require 'forwardable'

module QiitaExport::Fetcher
  class Base
    extend Forwardable

    def_delegators :@config, :kobito?, :kobito_db, :file_export?,
                             :export_dir_path, :team?, :team_name,
                             :article_urls, :has_api_token?, :api_token,
                             :user_id, :default_header, :auth_header

    def initialize
      @config = ::QiitaExport::Config
    end

    def find_articles
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

  end
end
