require 'sqlite3'
require_relative '../db/interface.rb'
class Customer < Interface
  attr_accessor :name, :last_login, :created_at, :updated_at, :id
  def initialize (name: nil, last_login: nil, created_at: nil, updated_at: nil, id: 0)
    @id = id
    @name = name
    @last_login = last_login
    @created_at = created_at
    @updated_at = updated_at
    super()
  end

  def save
    @id = create "Insert Into customers(name, last_login, created_at, updated_at) Values (
      '#{@name}', 
      '#{@last_login}', 
      '#{@created_at}', 
      '#{@updated_at}')"
  end

  def update
    updated_time = DateTime.now.to_s
    updated = query "Update Customers Set name = '#{@name}', last_login = '#{@last_login}', created_at = '#{@created_at}', updated_at = '#{updated_time}' Where id = #{@id}"
    self.class.find(@id)
  end

  def self.find(id)
    customer_db = Customer.new.query "Select * from Customers Where id = #{id}"
    self.new(
      name: customer_db[0]['name'],
      last_login: customer_db[0]['last_login'],
      created_at: customer_db[0]['created_at'],
      updated_at: customer_db[0]['updated_at'],
      id: customer_db[0]['id']
    )
  end

  def self.all
    customer_db = Customer.new.query "Select * from Customers"
    customer_db.map! do |customer| 
      self.new(
        name: customer['name'],
        last_login: customer['last_login'],
        created_at: customer['created_at'],
        updated_at: customer['updated_at'],
        id: customer['id']
      )
    end
  end
end