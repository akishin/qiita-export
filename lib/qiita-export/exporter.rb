# -*- coding: utf-8 -*-

module QiitaExport
  class Exporter

    def initialize
    end

    def export
      fetcher = create_fetcher
      articles = fetcher.find_articles
      if (Config.file_export?)
        export_file(articles)
      else
        export_console(articles)
      end
    end

    private

    def create_fetcher
      if Config.kobito?
        QiitaExport::Fetcher::KobitoFetcher.new
      elsif Config.user?
        QiitaExport::Fetcher::PaginationFetcher.new(:user)
      elsif Config.team_all?
        QiitaExport::Fetcher::PaginationFetcher.new(:team)
      else
        QiitaExport::Fetcher::UrlFetcher.new
      end
    end

    def export_console(articles)
      articles.each do |article|
        $stdout.puts("key: #{article.key} title: #{article.title} url: #{article.url} created_at: #{article.created_at} updated_at: #{article.updated_at}")
      end
    end

    def export_file(articles)
      $stdout.puts "export articles to #{Config.export_dir_path}"
      FileUtils.makedirs(Config.export_dir_path) unless Dir.exists?(Config.export_dir_path)
      articles.each do |article|
        article.save
      end
    end
  end
end
