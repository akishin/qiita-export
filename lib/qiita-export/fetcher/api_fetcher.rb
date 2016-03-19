# -*- coding: utf-8 -*-
require 'json'
require 'uri'

module QiitaExport::Fetcher
  class ApiFetcher < Base

    DEFAULT_HOST = "qiita.com"

    protected

    def to_article(res)
      key           = res['id']
      url           = res['url']
      title         = res['title']
      raw_body      = res['body']
      rendered_body = res['rendered_body']
      created_at    = res['created_at']
      updated_at    = res['updated_at']
      user_id       = res['user_id']

      ::QiitaExport::Article.new(key, url, title, raw_body, rendered_body, created_at, updated_at, user_id)
    end

    def article_key(url)
      File.basename(url)
    end

    def request_header
      has_api_token? ? auth_header : default_header
    end

    def api_domain(url = nil)
      if url.nil?
        team? ? "#{team_name}.#{DEFAULT_HOST}" : DEFAULT_HOST
      else
        URI.parse(url).host
      end
    end

  end
end
