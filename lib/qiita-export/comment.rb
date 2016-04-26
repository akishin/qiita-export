# -*- coding: utf-8 -*-
require 'fileutils'
require 'uri'

module QiitaExport
  class Comment
    attr_reader :key

    def initialize(url)
      @endpoint = Fetcher::ApiEndPoint.instance(:comment)
      @url = url
    end

    def request_header
      Config.has_api_token? ? Config.auth_header : Config.default_header
    end

    def filename
      "comments.json"
    end

    def save(path)
      comments = find_comments
      return if comments =~ /^\[\]$/i

      file_path = File.join(File.expand_path(path), filename)
      open(file_path, 'wb') do |out|
        out.write(comments)
      end
    end

    def find_comments
      url = @endpoint.url(article_url: @url)
      open(url, request_header) do |io|
        io.read
      end
    rescue => e
      $stderr.puts "#{e} : #{url}"
      raise
    end
  end
end
