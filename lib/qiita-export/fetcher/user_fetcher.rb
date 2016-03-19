# -*- coding: utf-8 -*-
require 'json'
require 'open-uri'

module QiitaExport::Fetcher
  class UserFetcher < ApiFetcher

    PER_PAGE = 100

    def find_articles
      articles = []
      page = 1
      while true
        user_articles = find_user_articles(page)
        break if user_articles.empty?

        user_articles.each do |user_article|
          articles << to_article(user_article)
        end

        page += 1
        sleep(0.3)
      end
      articles.sort { |a, b| a.created_at <=> b.created_at }
    end

    private

    def find_user_articles(page)
      open("https://#{api_domain}/api/v2/users/#{user_id}/items?page=#{page}&per_page=#{PER_PAGE}", request_header) do |io|
        JSON.parse(io.read)
      end
    end
  end
end
