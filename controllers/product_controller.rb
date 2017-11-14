require_relative '../models/product.rb'

class ProductController
  def list
    Product.all
  end
  
  def create(product)
    id = product.save
    if id > 0 
      product.id = id
      product
    end
  end

  def detail(id)
    product = Product.find(id)
  end

  def edit(product)
    updated_product = product.update
  end

  def delete(product)
    product.delete
  end
end