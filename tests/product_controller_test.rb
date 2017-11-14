require 'minitest/autorun'
require 'date'
require_relative '../controllers/product_controller.rb'
require_relative '../models/product.rb'
require_relative '../db/schema.rb'

class TestProductController < MiniTest::Test

  def setup
    @filename = 'db/test-bangazon.sqlite3'
    Interface.filename = @filename
    Schema.create(@filename)
    @controller = ProductController.new
    product = Product.new(
      name: "Thing",
      description: "It is a thing",
      price: 3.50,
      customer_id: 1,
      quantity: 2
    )
    @controller.create(product)
    @controller.create(product)
  end

  def test_create_Product_returns_Product_with_id
    product = Product.new(
      name: "Thing",
      description: "It is a thing",
      price: 3.50,
      customer_id: 1,
      quantity: 2
    )
    new_product = @controller.create(product)
    assert_operator new_product.id, :>, 0
    assert_equal product.name, new_product.name
  end

  def test_list_returns_array_of_Products
    products = @controller.list
    assert_instance_of Array, products
    assert_equal products.length, 2
    assert_instance_of Product, products[0]
  end

  def test_edit_returns_Product
    product = @controller.create(Product.new(
      name: "Thing",
      description: "It is a thing",
      price: 3.50,
      customer_id: 1,
      quantity: 2
    ))
    updated_product = @controller.edit(product)
    assert_instance_of Product, updated_product
  end

  def teardown
    Schema.delete(@filename)
  end

end