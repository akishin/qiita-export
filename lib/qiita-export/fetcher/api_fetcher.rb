# -*- coding: utf-8 -*-
require 'json'
require 'uri'

module QiitaExport::Fetcher
  class ApiFetcher < Base

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

    def request_header
      has_api_token? ? auth_header : default_header
    end

  end
end
