# -*- coding: utf-8 -*-

module QiitaExport::Fetcher
  class ApiEndPoint

    MAX_PER_PAGE = 100

    def initialize
      @config = ::QiitaExport::Config
    end

    def url(article_url: nil, page: 1)
      raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
    end

    def self.instance(end_point_sym)
      case end_point_sym
      when :item
        ItemEndPoint.new
      when :user
        UserEndPoint.new
      when :team
        TeamEndPoint.new
      else
        raise ArgumentError("unsupported endpont: #{end_point_sym}")
      end
    end
  end

  class ItemEndPoint < ApiEndPoint
    def url(article_url: nil, page: 1)
      "https://#{@config.api_domain(article_url)}/api/v2/items/#{@config.article_key(article_url)}"
    end
  end

  class UserEndPoint < ApiEndPoint
    def url(article_url: nil, page: 1)
      "https://#{@config.api_domain}/api/v2/users/#{@config.user_id}/items?page=#{page}&per_page=#{MAX_PER_PAGE}"
    end
  end

  class TeamEndPoint < ApiEndPoint
    def url(article_url: nil, page: 1)
      "https://#{@config.api_domain}/api/v2/items?page=#{page}&per_page=#{MAX_PER_PAGE}"
    end
  end
end
