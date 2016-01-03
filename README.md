# OCI8 Auto binder
[![Build Status](https://travis-ci.org/jksy/oci8-auto-binder.svg?branch=master)](https://travis-ci.org/jksy/oci8-auto-binder)

This library changes the query to parameterized query automatically.

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
conn = OCI8.new(username, password, ident)
conn.exec("select * from table1 where column1 = 1") do |r|
  # change to prarameterized query automatically in exec method
  # query = "select * from table1 where column1 = :a0", params = {:a0 => 1}
  puts r.join(',')
end
conn.logoff
```

## logging parameterized query and parameters
```ruby
OCI8AutoBinder.replace_original_class!
OCI8AutoBinder.logger = Logger.new(log_file_name)
OCI8AutoBinder.logger.level = Logger::INFO    # save all log(FOUND_BINDVARS, PARSE_ERROR, NO_PARAMS, PARSE_SUCCESS)
OCI8AutoBinder.logger.level = Logger::ERROR   # save parse error log(PARSE_ERROR)
OCI8AutoBinder.logger = nil                   # do not save logging
```


## Contributing

Bug reports and pull requests and PARSE_ERROR query are welcome on GitHub at https://github.com/jksy/oci8-auto-binder.
