# ProntoForms

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fpaulholden2%2Fprontoforms%2Fbadge%3Fref%3Dmaster&style=flat)](https://actions-badge.atrox.dev/paulholden2/prontoforms/goto?ref=master) [![Gem Version](https://badge.fury.io/rb/prontoforms.svg)](https://badge.fury.io/rb/prontoforms) [![Inline docs](http://inch-ci.org/github/paulholden2/prontoforms.svg?branch=master)](http://inch-ci.org/github/paulholden2/prontoforms) [![Maintainability](https://api.codeclimate.com/v1/badges/e47cd40058313e1c1c38/maintainability)](https://codeclimate.com/github/paulholden2/prontoforms/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/e47cd40058313e1c1c38/test_coverage)](https://codeclimate.com/github/paulholden2/prontoforms/test_coverage)

A library for interacting with the ProntoForms REST API in Ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prontoforms'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install prontoforms

## Usage

To get started, first [create a ProntoForms API key] in your ProntoForms
account. Then you can begin using the API client in your Ruby application:

```rb
client = ProntoForms::Client.new(api_key_id, api_key_secret)
client.form_spaces # Returns all FormSpaces in your account
```

Review [the documentation](https://rubydoc.info/github/paulholden2/prontoforms)
for more information on how to use this library to interact with ProntoForms.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paulholden2/prontoforms.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[create a ProntoForms API key]: https://support.prontoforms.com/hc/en-us/articles/217496468-Setup-an-API-Application-on-ProntoForms#Create
