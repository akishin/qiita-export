# -*- coding: utf-8 -*-

require 'sqlite3'
require 'time'

module QiitaExport::Fetcher
  class KobitoFetcher < Base

    SELECT =<<-"EOS"
      SELECT
        i.zurl,
        i.ztitle,
        i.zraw_body,
        i.zbody,
        i.zposted_at,
        i.zcreated_at,
        i.zupdated_at,
        i.zupdated_at_on_qiita,
        t.zurl_name
      FROM 
        zitem i left outer join zteam t on i.zteam = t.z_pk
      WHERE
        zin_trash is null
    EOS

    ORDER = " ORDER BY i.zcreated_at"

    def find_articles
      where = if team?
                " and zurl_name = :team"
              else
                " and zteam is null"
              end
      query = "#{SELECT}#{where}#{ORDER}"

      db = SQLite3::Database.new(kobito_db)
      db.results_as_hash = true

      stmt = db.prepare(query)
      stmt.bind_param("team", team_name) if team?
      rs = stmt.execute

      articles = []
      while(row = rs.next)
        article =  to_article(row)
        articles << article unless exclude?(article.title)
      end
      articles
    ensure
      stmt.close if stmt
      db.close   if db
    end

    private

    def to_article(row)
      key           = article_key(row['ZURL'])
      url           = row['ZURL']
      title         = row['ZTITLE']
      raw_body      = row['ZRAW_BODY']
      rendered_body = row['ZBODY']

      zposted_at           = convert_timestamp(row['ZPOSTED_AT'])
      zcreated_at          = convert_timestamp(row['ZCREATED_AT'])
      zupdated_at_on_qiita = convert_timestamp(row['ZUPDATED_AT_ON_QIITA'])
      zupdated_at          = convert_timestamp(row['ZUPDATED_AT'])

      # puts "key: #{key} zposted_at: #{zposted_at} zcreated_at: #{zcreated_at} zupdated_at_on_qiita: #{zupdated_at_on_qiita} zupdated_at: #{zupdated_at}"
      ::QiitaExport::Article.new(key, url, title, raw_body, rendered_body, zcreated_at, zupdated_at, 'kobito_user')
    end

    BASE_DATE = Time.new(2001, 1, 1, 0, 0, 0, 0).to_i
    def convert_timestamp(timestamp)
      Time.at(timestamp + BASE_DATE).iso8601
    end
  end
end


