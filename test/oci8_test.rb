require File.expand_path('test_helper.rb', File.dirname(__FILE__))
require 'logger'

class Oci8Test < Test::Unit::TestCase
  @@connection = nil
  def self.startup
    OCI8AutoBinder.replace_original_class!
    OCI8AutoBinder.logger = Logger.new(File.expand_path('test.log', File.dirname(__FILE__)))
    OCI8AutoBinder.logger.level = Logger::DEBUG
  end

  def self.shutdown
    close_connection
  end

  def self.db_config
    return @db_config if defined? @db_config

    path = File.expand_path('db_config.yml', File.dirname(__FILE__))
    if File.readable? path
      @db_config = YAML::load_file(File.expand_path('db_config.yml', File.dirname(__FILE__)))
    else
      @db_config = {
        'username' => ENV['ORACLE_USERNAME'],
        'password' => ENV['ORACLE_PASSWORD'],
        'ident' => ENV['ORACLE_IDENT'],
      }
    end
    @db_config
  end

  def self.connection
    @@connection ||= OCI8.new(db_config['username'],
                              db_config['password'],
                              db_config['ident'])
  end

  def connection
    self.class.connection
  end

  def self.close_connection
    @@connection.logoff unless @@connection.nil?
    @@connection = nil
  end

  def test_select_one
    connection.exec("select 'asdf', 1 from dual") do |r|
      assert_equal r[0], 'asdf'
      assert_equal r[1], 1
    end
  end

  def test_timezone
    connection.exec("select current_timestamp, sysdate, to_timestamp('2008-01-02', 'yyyy-mm-dd') from dual") do |r|

    end
  end
end
