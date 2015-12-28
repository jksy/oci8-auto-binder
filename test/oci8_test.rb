require File.expand_path('test_helper.rb', File.dirname(__FILE__))

class Oci8Test < Test::Unit::TestCase
  def startup
    raw_connection
  end

  def shutdown
    close_connection
  end

  def db_config
    @db_config ||= YAML::load_file(File.expand_path('db_config.yml', File.dirname(__FILE__)))
  end

  def connection
    OCI8AutoBinder.replace_original_class!
    @connection ||= OCI8.new(db_config['username'], 
                             db_config['password'],
                             db_config['ident'])
  end

  def close_connection
    @connection.logoff unless @raw_connection.nil?
    @connection = nil
  end

  def test_select_one
    connection.exec("select 'asdf' as a, 1 from dual") do |r|
      assert_equal r[0], 'asdf'
      assert_equal r[1], 1
    end
  end
  
  def test_timezone
    connection.exec("select current_timestamp, sysdate, to_timestamp('2008-01-02', 'yyyy-mm-dd') from dual") do |r|
      puts r.join
    end
  end
end
