require_relative '../db/interface.rb'

class Order < Interface
  attr_accessor :id, :customer_id, :payment_type_id, :created_at, :updated_at

  def initialize(id: nil, customer_id: nil, payment_type_id: nil, created_at: nil, updated_at: nil)
    @id = id
    @customer_id = customer_id
    @payment_type_id = payment_type_id
    @created_at = created_at
    @updated_at = updated_at
  end    

  def save
    @created_at = DateTime.now.to_s
    @updated_at = DateTime.now.to_s
    @id = create "Insert Into orders (created_at, updated_at, customer_id) Values (
      '#{@created_at}', 
      '#{@updated_at}',
      #{@customer_id})"
  end



  def complete
    updated_time = DateTime.now.to_s
    completed = query "Update Orders Set payment_type_id = #{@payment_type_id}, updated_at = '#{updated_time}' Where id = #{@id}"
    self.class.find(@id)
  end

  def delete
    query "Delete from Orders_products where order_id = #{@id}"
    query "Delete from Orders where id = #{@id}"      
  end

  def self.find(id)
    order_db = Order.new.query "Select * from Orders Where id = #{id}"
    self.new(
      created_at: order_db[0]['created_at'],
      updated_at: order_db[0]['updated_at'],
      customer_id: order_db[0]['customer_id'],
      id: order_db[0]['id'],
      payment_type_id: order_db[0]['payment_type_id']
    )
  end

  def self.all
    order_db = Order.new.query "Select * from Orders"
    order_db.map! do |order| 
      self.new(
        created_at: order['created_at'],
        updated_at: order['updated_at'],
        customer_id: order['customer_id'],        
        id: order['id'],
        payment_type_id: order['payment_type_id']
      )
    end
  end

  private
  def completed?
    result = query "Select * from Orders where id = #{@id} and payment_type_id is not null"
    result.any?
  end
end