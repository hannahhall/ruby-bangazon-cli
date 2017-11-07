require 'minitest/autorun'
require_relative '../models/customer.rb'
require 'date'
require_relative '../db/schema.rb'


class TestCustomerClass < MiniTest::Test

  def setup
    @filename = 'db/test-bangazon.sqlite3'
    Interface.filename = @filename
    Schema.create(@filename)
    @customer = Customer.new(
      name: "Name",
      last_login: DateTime.now.to_s,
      created_at: DateTime.now.to_s,
      updated_at: DateTime.now.to_s
    )
  end

  def test_number_of_arguments
    assert_instance_of(Customer, @customer)
  end

  def test_save_returns_db_id
    customer_id = @customer.save
    assert_operator customer_id, :>, 0
  end

  def test_find_returns_single_row_in_db
    customer_id = @customer.save
    actual = Customer.find(customer_id)
    assert_equal actual.id, @customer.id
    assert_equal actual.name, @customer.name
  end

  def test_all_returns_all_customers_in_db
    @customer.save
    customers = Customer.all
    assert_equal customers.length, 1
    assert_instance_of Customer, customers[0]
  end

  def test_update_returns_updated_customer
    @customer.save
    @customer.name = "new name"
    updated_customer = @customer.update
    assert_equal "new name", updated_customer.name
  end


  def teardown
    Schema.delete(@filename)
  end
end