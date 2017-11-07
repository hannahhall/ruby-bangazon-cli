require 'minitest/autorun'
require 'date'
require_relative '../controllers/customer_controller.rb'
require_relative '../models/customer.rb'
require_relative '../db/schema.rb'

class TestCustomerController < MiniTest::Test

  def setup
    @filename = 'db/test-bangazon.sqlite3'
    Interface.filename = @filename
    Schema.create(@filename)
    @controller = CustomerController.new
    customer = Customer.new(
      name: "Name",
      last_login: DateTime.now,
      created_at: DateTime.now,
      updated_at: DateTime.now
    )
    @controller.create(customer)
    @controller.create(customer)
  end

  def test_create_customer_returns_customer_with_id
    customer = Customer.new(
      name: "Name2",
      last_login: DateTime.now,
      created_at: DateTime.now,
      updated_at: DateTime.now
    )
    new_customer = @controller.create(customer)
    assert_operator new_customer.id, :>, 0
    assert_equal customer.name, new_customer.name
  end

  def test_list_returns_array_of_customers
    customers = @controller.list
    assert_instance_of Array, customers
    assert_equal customers.length, 2
    assert_instance_of Customer, customers[0]
  end

  def test_edit_returns_Customer
    customer = @controller.create(Customer.new(
      name: "Name2",
      last_login: DateTime.now,
      created_at: DateTime.now,
      updated_at: DateTime.now
    )
    updated_customer = @controller.edit(@customer)
    assert_instance_of Customer, updated_customer
  end

  

  def teardown
    Schema.delete(@filename)
  end

end