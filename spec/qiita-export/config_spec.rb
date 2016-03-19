# -*- coding: utf-8 -*-

require File.expand_path(File.join('..', 'spec_helper'), File.dirname(__FILE__))
require 'qiita-export'

describe QiitaExport::Config do
  let(:valid_url)       { 'http://qiita.com/akishin/items/61630d628f4c8e141ef2' }
  let(:valid_kobito_db) { File.expand_path(QiitaExport::Config::DEFAULT_KOBITO_DB) }
  let(:valid_team_name) { 'example' }
  let(:valid_argv) {
    [
      '--url', valid_url,
      '--kobito', valid_kobito_db,
      '--image',
      '--html',
      '--team', valid_team_name,
    ]
  }

  describe ".configure" do

    context "with arguments" do
      let(:arguments) do
        valid_argv
      end

      subject do
        described_class.configure(arguments)
      end

      it "returns a QiitaExport::Config" do
        expect(subject).to eq(QiitaExport::Config)
      end
      it { expect(subject.article_urls).to include(valid_url) }
      it { expect(subject.kobito_db).to eq(valid_kobito_db) }
      it { expect(subject.api?).to be_truthy }
      it { expect(subject.image_export?).to be_truthy }
      it { expect(subject.html_export?).to be_truthy }
      it { expect(subject.team?).to be_truthy }
      it { expect(subject.team_name).to eq(valid_team_name) }
    end

  end

end


