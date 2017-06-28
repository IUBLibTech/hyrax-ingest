# Hyrax::Ingest

[![Build Status](https://travis-ci.org/IUBLibTech/hyrax-ingest.svg?branch=master)](https://travis-ci.org/IUBLibTech/hyrax-ingest)

Hyrax::Ingest is an extensible plugin for ingesting content and metadata into
a Hyrax[https://github.com/samvera/hyrax] repository based on a declarative
configuration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hyrax-ingest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hyrax-ingest

## Overview

The Hyrax::Ingest plugin defines "ingest" as the process of mapping content
and data from one or more sources to one or more persistence layers to be used
by a Hyrax application.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

TODO: Add CONTRIBUTING.md per the Samvera standard, and refer to it here.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

