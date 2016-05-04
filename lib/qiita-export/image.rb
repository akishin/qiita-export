# -*- coding: utf-8 -*-
require 'fileutils'
require 'uri'

module QiitaExport
  class Image
    attr_reader :key, :url, :filename, :org_filename

    IMAGE_DIR = "images"

    def initialize(key, url, filename, org_filename)
      @key          = key
      @url          = url
      @filename     = filename
      @org_filename = org_filename
    end

    def self.extract_urls(key, markdown)
      image_urls = markdown.scan(/!\[(.*?)\]\((.+?)(?: \".*?\")?\)/)
      image_urls.map do |image_url|
        url          = image_url[1]
        filename     = File.basename(url)
        org_filename = if image_url[0].nil? || image_url[0].empty?
                         filename
                       else
                         image_url[0]
                       end
        new(key, url, filename, org_filename)
      end
    end

    def output_filename
      Config.original_image_filename? ? @org_filename : @filename
    end

    def require_auth?
      @url !~ /qiita-image-store.s3.amazonaws.com/
    end

    def request_header
      require_auth? ? Config.auth_header : Config.default_header
    end

    def save(path)
      image_dir = File.join(File.expand_path(path), IMAGE_DIR)

      FileUtils.makedirs(image_dir) unless Dir.exists?(image_dir)

      file_path = File.join(image_dir, output_filename)

      open(file_path, 'wb') do |out|
        open(@url, request_header) do |image|
          out.write(image.read)
        end
      end
    end
  end
end
