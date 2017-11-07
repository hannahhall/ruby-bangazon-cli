require 'sqlite3'

class Schema
  def self.create(filename = "db/bangazon.sqlite3")
    begin  
      db = SQLite3::Database.new filename
        
      db.execute "CREATE TABLE IF NOT EXISTS `customers` (
        `id`	        INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `name`	      varchar NOT NULL,
        `last_login`	date NOT NULL,                
        `created_at`	datetime NOT NULL,
        `updated_at`	datetime NOT NULL
      );"

      db.execute "CREATE TABLE IF NOT EXISTS `product_types` (
        `id`	        INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `name`	      varchar NOT NULL,
        `created_at`	datetime NOT NULL,
        `updated_at`	datetime NOT NULL
      );"

      db.execute "CREATE TABLE IF NOT EXISTS `products` (
        `id`	            INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `name`	          varchar NOT NULL,
        `product_type_id`	integer NOT NULL,
        `price`	          integer NOT NULL,
        `description`	    text NOT NULL,
        `customer_id`	    integer NOT NULL,
        `quantity`	      integer NOT NULL,
        `created_at`	    datetime NOT NULL,
        `updated_at`	    datetime NOT NULL
      );"

      db.execute "CREATE TABLE IF NOT EXISTS `payment_types` (
        `id`	            INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `account_number`	varchar NOT NULL,
        `customer_id`	    integer NOT NULL,
        `name`	          varchar NOT NULL,
        `created_at`	    datetime NOT NULL,
        `updated_at`	    datetime NOT NULL
      );"
      
      db.execute "CREATE TABLE IF NOT EXISTS `orders` (
        `id`	            INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `customer_id`	    integer NOT NULL,
        `created_at`	    datetime NOT NULL,
        `updated_at`	    datetime NOT NULL,
        `payment_type_id`	integer
      );"

      db.execute "CREATE TABLE IF NOT EXISTS `orders_products` (
        `id`	        INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        `order_id`	  integer NOT NULL,
        `product_id`	integer NOT NULL,
        `created_at`	datetime NOT NULL,
        `updated_at`	datetime NOT NULL
      );"

    rescue SQLite3::Exception => e 
      puts "Exception occurred"
      puts e   
    ensure
      db.close if db
    end
  end

  def self.delete(filename = "db/bangazon.sqlite3")
    begin  
      db = SQLite3::Database.new filename
      db.execute "Drop Table orders_products" 
      db.execute "Drop Table orders" 
      db.execute "Drop Table payment_types"
      db.execute "Drop Table products"
      db.execute "Drop Table product_types" 
      db.execute "Drop Table customers"
    rescue SQLite3::Exception => e 
      puts "Exception occurred"
      puts e
    ensure
      db.close if db
    end
  end
end

