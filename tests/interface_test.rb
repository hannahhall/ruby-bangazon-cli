require 'minitest/autorun'
require 'date'
require_relative '../db/schema.rb'
require_relative '../db/interface.rb'

class TestInterface < MiniTest::Test
  
  def setup
    @filename = 'db/test-bangazon.sqlite3'
    Interface.filename = @filename
    @interface = Interface.new
    Schema.create(@filename)
  end

  def test_filename_is_correct
    assert_equal @filename, Interface.filename
  end


  def test_create_adds_row_to_db_query
    query = @interface.query "Select * from Customers"
    assert_empty query
    @interface.create "Insert into Customers(name, last_login, created_at, updated_at) Values (
      'Name', 
      '#{DateTime.now.to_s}', 
      '#{DateTime.now.to_s}', 
      '#{DateTime.now.to_s}')"
    query2 = @interface.query "Select * from Customers"
    assert_equal 1, query2.length
  end

  def teardown
    Schema.delete(@filename)
  end
  
end
    
