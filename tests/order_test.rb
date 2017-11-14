require 'minitest/autorun'
require_relative '../models/order.rb'
require 'date'
require_relative '../db/schema.rb'
require_relative '../db/interface.rb'



class TestOrderClass < MiniTest::Test

  def setup
    @filename = 'db/test-bangazon.sqlite3'
    Interface.filename = @filename
    Schema.create(@filename)
    @order = Order.new(
      customer_id: 1
    )
  end

  def test_number_of_arguments
    assert_instance_of(Order, @order)
  end

  def test_save_returns_db_id
    order_id = @order.save
    assert_operator order_id, :>, 0
  end

  def test_find_returns_single_row_in_db
    order_id = @order.save
    actual = Order.find(order_id)
    assert_equal actual.id, @order.id
    assert_equal actual.customer_id, @order.customer_id
  end

  def test_all_returns_all_orders_in_db
    @order.save
    orders = Order.all
    assert_equal orders.length, 1
    assert_instance_of Order, orders[0]
  end

  def test_complete_adds_payment_type_to_order
    @order.save
    @order.payment_type_id = 1
    updated_order = @order.complete
    assert_equal 1, updated_order.payment_type_id
  end

  def test_add_product_creates_join_row
    @order.id = @order.save
    product_id = 1
    @order.add_product(1)

  def test_delete_order_when_not_on_order
    @order.id = @order.save
    result = @order.delete
    assert_empty result
  end    


  def teardown
    Schema.delete(@filename)
  end
end