require 'minitest/autorun'
require_relative '../models/product.rb'
require 'date'
require_relative '../db/schema.rb'
require_relative '../db/interface.rb'



class TestProductClass < MiniTest::Test

  def setup
    @filename = 'db/test-bangazon.sqlite3'
    Interface.filename = @filename
    Schema.create(@filename)
    @product = Product.new(
      name: "Thing",
      description: "It is a thing",
      price: 3.50,
      customer_id: 1,
      quantity: 2
    )
  end

  def test_number_of_arguments
    assert_instance_of(Product, @product)
  end

  def test_save_returns_db_id
    product_id = @product.save
    assert_operator product_id, :>, 0
  end

  def test_find_returns_single_row_in_db
    product_id = @product.save
    actual = Product.find(product_id)
    assert_equal actual.id, @product.id
    assert_equal actual.name, @product.name
  end

  def test_all_returns_all_Products_in_db
    @product.save
    products = Product.all
    assert_equal products.length, 1
    assert_instance_of Product, products[0]
  end

  def test_update_returns_updated_Product
    @product.save
    @product.name = "new thing"
    updated_Product = @product.update
    assert_equal "new thing", updated_Product.name
  end

  def test_delete_product_when_not_on_order
    @product.id = @product.save
    result = @product.delete
    assert_empty result
  end    


  def teardown
    Schema.delete(@filename)
  end
end