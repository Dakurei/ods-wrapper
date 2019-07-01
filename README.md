# OdsWrapper

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ods_wrapper`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ods_wrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ods_wrapper

## Usage

You can search siret and informations about companies with method :

```ruby
OdsWrapper::Siret.query(name, zipcode = '')
```
Return a JSON array of companies in case it matches existing companies.

Example:
```ruby
OdsWrapper::Siret.query('crisalid', '57160')
```
Return:
```json
{
  "siret":[
    {
      "name":"CRISALID",
      "address":"40 AVENUE DE LA LIBERATION",
      "zipcode":"57160",
      "city":"CHATEL ST GERMAIN",
      "siret":"38785601600028",
      "ape":"5829C"
    },
    {
      "name":"CRISALID EST",
      "address":"40 AVENUE DE LA LIBERATION",
      "zipcode":"57160",
      "city":"CHATEL ST GERMAIN",
      "siret":"53422349000010",
      "ape":"4669C"
    }
  ]
}
```

```ruby
OdsWrapper::Siret.reverse_query(siret)
```
Return a JSON array of companies in case it matches existing companies (But there should be only one)

Example:
```ruby
OdsWrapper::Siret.reverse_query('38785601600028')
```
Return:
```json
{
  "siret":[
    {
      "name":"CRISALID",
      "address":"40 AV DE LA LIBERATION",
      "zipcode":"57160",
      "city":"CHATEL SAINT GERMAIN",
      "siret":"38785601600028",
      "ape":"5829C"
    }
  ]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Dakurei/ods_wrapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ODS::Wrapper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Dakurei/ods_wrapper/blob/master/CODE_OF_CONDUCT.md).
