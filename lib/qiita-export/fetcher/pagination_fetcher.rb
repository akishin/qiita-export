# -*- coding: utf-8 -*-
require 'json'
require 'open-uri'

module QiitaExport::Fetcher
  class PaginationFetcher < ApiFetcher

    PER_PAGE = 100

    def initialize(endpoint_sym)
      super()
      @endpoint = ApiEndPoint.instance(endpoint_sym)
    end

    def find_articles
      articles = []
      page = 1
      while true
        api_responses = paginate_articles(page)
        break if api_responses.empty?

        api_responses.each do |api_response|
          article = to_article(api_response)
          articles << article unless exclude?(article.title)
        end

        page += 1
        sleep(0.3)
      end
      articles.sort { |a, b| a.created_at <=> b.created_at }
    end

    private

    def paginate_articles(page)
      url = @endpoint.next_page(page)
      open(@endpoint.next_page(page), request_header) do |io|
        JSON.parse(io.read)
      end
    rescue => e
      $stderr.puts "#{e} : #{url}"
      raise
    end
  end
end
