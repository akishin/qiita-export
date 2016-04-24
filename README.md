# QiitaExport

export tool for Qiita(http://qiita.com/).

## Installation

Add this line to your Gemfile:

```ruby
gem 'qiita-export'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install qiita-export
```

## Usage

```
Usage: qiita-export [options]
    -u, --url=url                    specify the URL for the Qiita(or Qiita Team).
    -l, --url-list=filepath          specify the file path of the URL list.
    -U, --user-id=user_id            specify the userid for the Qiita.
    -k, --kobito=[Kobito.db]         export Kobito.app database.
    -t, --team=teamname              export Qiita Team articles only.
    -T, --team-all                   export Qiita Team all articles.
    -i, --image                      export with images.
    -h, --html                       export in html format(experimental).
    -o, --output-dir=dirpath         specify the full path of destination directory.
    -a, --api-token=token            specify API token for Qiita.
    -e, --exclude-pattern=regexp     specify the regexp pattern to exclude article title.
```

## Contributing

1. Fork it ( https://github.com/akishin/qiita_export/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT License

