# -*- coding: utf-8 -*-
require 'fileutils'
require 'uri'

module QiitaExport
  class Image
    attr_reader :key, :url

    IMAGE_DIR = "images"

    def initialize(key, url)
      @key = key
      @url = url
    end

    def self.extract_urls(key, markdown)
      image_urls = markdown.scan(/!\[.*?\]\((.+?)(?: \".*?\")?\)/).flatten
      image_urls.map do |image_url|
        new(key, image_url)
      end
    end

    def require_auth?
      @url !~ /qiita-image-store.s3.amazonaws.com/
    end

    def request_header
      require_auth? ? Config.auth_header : Config.default_header
    end

    def filename
      "#{File.basename(url)}"
    end

    def save(path)
      image_dir = File.join(File.expand_path(path), IMAGE_DIR)

      FileUtils.makedirs(image_dir) unless Dir.exists?(image_dir)

      file_path = File.join(image_dir, filename)

      open(file_path, 'wb') do |out|
        open(@url, request_header) do |image|
          out.write(image.read)
        end
      end
    end
  end
end
