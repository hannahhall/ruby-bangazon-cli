require 'date'
require_relative '../db/interface.rb'

class Product < Interface
  attr_accessor :name, :description, :price, :created_at, :updated_at, :id, :customer_id, :quantity
  def initialize(
    name: nil, 
    description: nil, 
    price: nil, 
    created_at: nil, 
    updated_at: nil,
    quantity: 0, 
    customer_id: 0, 
    id: 0
  )
    @name = name
    @description = description
    @price = price
    @created_at = created_at
    @updated_at = updated_at
    @customer_id = customer_id
    @quantity = quantity
    @id = id
  end

  def save
    @created_at = DateTime.now.to_s
    @updated_at = DateTime.now.to_s
    @id = create "Insert Into products (name, description, price, created_at, updated_at, customer_id, quantity) Values (
      '#{@name}', 
      '#{@description}', 
      '#{@price}', 
      '#{@created_at}', 
      '#{@updated_at}',
      #{@customer_id},
      #{@quantity})"
  end

  def update
    updated_time = DateTime.now.to_s
    updated = query "Update Products Set name = '#{@name}', price = '#{@price}', description = '#{@description}', updated_at = '#{updated_time}' Where id = #{@id}"
    self.class.find(@id)
  end

  def delete
    if on_order?
      query "Delete from Products where id = #{@id}"
    else 
      "Product can not be deleted"      
    end
  end

  def self.find(id)
    product_db = Product.new.query "Select * from Products Where id = #{id}"
    self.new(
      name: product_db[0]['name'],
      price: product_db[0]['price'],
      description: product_db[0]['description'],
      created_at: product_db[0]['created_at'],
      updated_at: product_db[0]['updated_at'],
      customer_id: product_db[0]['customer_id'],
      id: product_db[0]['id'],
      quantity: product_db[0]['quantity']
    )
  end

  def self.all
    product_db = Product.new.query "Select * from Products"
    product_db.map! do |product| 
      self.new(
        name: product['name'],
        price: product['price'],
        description: product['description'],
        created_at: product['created_at'],
        updated_at: product['updated_at'],
        customer_id: product['customer_id'],        
        id: product['id'],
        quantity: product['quantity']
      )
    end
  end

  private
  def on_order?
    result = query "Select * from orders_products where product_id = #{@id}"
    result.empty?
  end
end