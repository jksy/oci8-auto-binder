# OCI8 Auto binder

Auto binder for ruby-oci8

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oci8-auto-binder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oci8-auto-binder

## Usage

```ruby
OCI8AutoBinder.replace_original_class!
conn = OCI8.new
conn.exec("select * from table1 where column1 = 1") do |r| # use binding
  r.join(',')
end
conn.logoff
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jksy/oci8-auto-binder.
