# -*- coding: utf-8 -*-
require 'json'
require 'open-uri'

module QiitaExport::Fetcher
  class UrlFetcher < ApiFetcher

    def initialize
      super()
      @endpoint = ApiEndPoint.instance(:item)
    end

    def find_articles
      articles = []
      article_urls.each do |url|
        article = to_article(find_article(url))
        articles << article unless exclude?(article.title)
      end
      articles
    end

    private

    def find_article(article_url)
      url = @endpoint.url(article_url: article_url)
      open(url, request_header) do |io|
        JSON.parse(io.read)
      end
    rescue => e
      $stderr.puts "#{e} : #{url}"
      raise
    end
  end
end
