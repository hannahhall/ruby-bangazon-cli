require_relative '../models/customer.rb'

class CustomerController

  def list
    Customer.all
  end
  
  def create(customer)
    id = customer.save
    if id > 0 
      customer.id = id
      customer
    end
  end

  def detail(id)
    customer = Customer.find(id)
  end

  def edit(customer)
    updated_customer = customer.update
  end

  

end