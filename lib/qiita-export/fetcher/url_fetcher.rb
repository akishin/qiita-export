# -*- coding: utf-8 -*-
require 'json'
require 'open-uri'

module QiitaExport::Fetcher
  class UrlFetcher < ApiFetcher

    def find_articles
      articles = []
      article_urls.each do |url|
        articles << to_article(find_article(url))
      end
      articles
    end

    private

    def find_article(url)
      open("https://#{api_domain(url)}/api/v2/items/#{article_key(url)}", request_header) do |io|
        JSON.parse(io.read)
      end
    end
  end
end
