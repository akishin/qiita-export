# -*- coding: utf-8 -*-

require File.expand_path(File.join('..', 'spec_helper'), File.dirname(__FILE__))
require 'qiita-export'

describe QiitaExport::Image do
  let(:valid_key) { '99999999999999999999' }
  let(:valid_url) { 'http://qiita-image-store.s3.amazonaws.com/example.jpg' }

  describe ".new" do

    context "with arguments" do
      let(:arguments) do
        [valid_key, valid_url]
      end

      subject do
        described_class.new(*arguments)
      end

      it "returns a QiitaExport::Image" do
        expect(subject).to be_an_instance_of(QiitaExport::Image)
      end
      it { expect(subject.key).to eq(valid_key) }
      it { expect(subject.url).to eq(valid_url) }
    end

    context "without any arguments" do
      let(:arguments) do
        []
      end

      it "raise ArgumentError" do
        expect {
          described_class.new(*arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  let(:include_images) {
    <<-"EOS"
## Example Markdown
![foo.png](https://example.com/foo.png "foo.png")
![bar.png](https://example.com/bar.png)
    EOS
  }

  let(:not_include_images) {
    <<-"EOS"
## Example Markdown
### Test1
### Test2
    EOS
  }

  describe ".extract_urls" do
    context "when there is image urls" do
      subject do
        described_class.extract_urls(valid_key, include_images)
      end

      it { expect(subject).not_to be_empty }
      it { expect(subject.length).to eq(2) }
      it { expect(subject.first).to be_an_instance_of(QiitaExport::Image) }
      it { expect(subject.first.url).to eq('https://example.com/foo.png') }
      it { expect(subject.last).to be_an_instance_of(QiitaExport::Image) }
      it { expect(subject.last.url).to eq('https://example.com/bar.png') }
    end

    context "when there is no image urls" do
      subject do
        described_class.extract_urls(valid_key, not_include_images)
      end
      it { expect(subject).to be_empty }
    end
  end
end


