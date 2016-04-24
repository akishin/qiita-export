# -*- coding: utf-8 -*-

module QiitaExport::Fetcher
  class ApiEndPoint

    def initialize
      @config = ::QiitaExport::Config
    end

    def next_page(page)
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def self.instance(end_point_sym)
      case end_point_sym
      when :user
        UserEndPoint.new
      when :team
        TeamEndPoint.new
      else
        raise ArgumentError("unsupported endpont: #{end_point_sym}")
      end
    end
  end

  class UserEndPoint < ApiEndPoint
    PER_PAGE = 100

    def next_page(page)
      "https://#{@config.api_domain}/api/v2/users/#{@config.user_id}/items?page=#{page}&per_page=#{PER_PAGE}"
    end
  end

  class TeamEndPoint < ApiEndPoint
    PER_PAGE = 100

    def next_page(page)
      "https://#{@config.api_domain}/api/v2/items?page=#{page}&per_page=#{PER_PAGE}"
    end
  end
end
