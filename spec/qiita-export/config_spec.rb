# -*- coding: utf-8 -*-

require File.expand_path(File.join('..', 'spec_helper'), File.dirname(__FILE__))
require 'qiita-export'

describe QiitaExport::Config do
  let(:valid_url)       { 'http://qiita.com/akishin/items/61630d628f4c8e141ef2' }
  let(:valid_team_url)  { 'http://example.qiita.com/foo@github/items/99999999999999999999' }
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

  describe ".user_id" do
    context "with user_id option" do
      subject do
        described_class.configure(['--user-id', 'foo'])
      end
      it { expect(subject.user_id).to eq('foo') }
    end

    context "without user_id option" do
      subject do
        described_class.configure(valid_argv)
      end
      it { expect(subject.user_id).to be_nil }
      it { expect(subject.user_id(valid_url)).to eq('akishin') }
      it { expect(subject.user_id(valid_team_url)).to eq('foo@github') }
    end
  end

  describe ".export_dir_path" do
    subject do
      described_class.configure(['--output-dir', '/tmp/output'])
    end

    it { expect(subject.export_dir_path(valid_url)).to eq('/tmp/output/qiita/akishin') }
    it { expect(subject.export_dir_path(valid_team_url)).to eq('/tmp/output/example/foo@github') }
  end

end


