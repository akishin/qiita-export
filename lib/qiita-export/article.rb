# -*- coding: utf-8 -*-
require 'erb'

module QiitaExport
  class Article
    attr_reader :key, :url, :title, :raw_body, :rendered_body, :created_at,
                :updated_at, :user_id, :images

    HTML_TEMPLATE =<<-"EOS"
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8" />
          <title><%= @title %></title>
        </head>
        <body>
          <h1><%= @title %></h1>
          <%= @rendered_body %>
        </body>
      </html>
    EOS

    def initialize(key, url, title, raw_body, rendered_body, created_at, updated_at, user_id)
      @key           = key
      @url           = url
      @title         = title
      @raw_body      = raw_body
      @rendered_body = rendered_body
      @created_at    = created_at
      @updated_at    = updated_at
      @user_id       = user_id
      @images        = Image.extract_urls(@key, @raw_body)
    end

    def save
      save_dir  = File.join(Config.export_dir_path(@url), @key)

      FileUtils.makedirs(save_dir) unless Dir.exists?(save_dir)

      file_path = File.join(save_dir, Config.filename(title))
      File.open(file_path, "w") { |f| f.write export_content }
      if (Config.image_export?)
        @images.each { |image| image.save(save_dir) }
      end
    end

    private

    def export_content
      if Config.html_export?
        replace_img_src!(@rendered_body)
        ERB.new(HTML_TEMPLATE).result(binding)
      else
        @raw_body
      end
    end

    def replace_img_src!(html)
      image_urls = html.scan(/<img[^src]+src="([^"]+)"[^>]+>/).flatten
      image_urls.each do |image_url|
        html.gsub!(image_url, "./#{Image::IMAGE_DIR}/#{File.basename(image_url)}")
      end
    end
  end
end
