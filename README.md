# Mylookup

Welcome to mylookup gem! 

TODO: It simulates Excel vlookup in Ruby programming language 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mylookup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mylookup

## Usage

TODO: It supports vlooking up with two Excel file, MongoDB collection or
combination of both. It takes Excel filepath/MongoDB database as `:left` and `:right`, Excel
sheetname/MongoDB collection name as `:leftsheet` and `:rightsheet` and `Matching column names` as `:lefton` and
`:righton` as input. It reads both columns data as unique, changes their case
into `:downcase` and executes `set difference`. The recorded
unmatched/difference elements are written as Excel file in current working
directory

## What's new in this version
Instead of writing the unmatched data on to the disc, we can deceive it in a
variable by enabling `:get` switch in command options

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mylookup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mylookup project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/vlookup/blob/master/CODE_OF_CONDUCT.md).
"# mylookup" 
"# mylookup" 
