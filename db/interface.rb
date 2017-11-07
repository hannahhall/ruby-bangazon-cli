class Interface
  attr_accessor :filename
  @@filename = 'db/bangazon.sqlite3'
  
  def self.filename= (filename)
    @@filename = filename
  end

  def self.filename
    @@filename
  end

  def create(cmd)
    begin
      db = SQLite3::Database.new @@filename
      db.execute cmd
      id = db.last_insert_row_id
    rescue SQLite3::Exception => e 
      puts "Exception occurred"
      puts e
    ensure
      db.close if db
    end
  end

  def query(cmd)
    begin
      db = SQLite3::Database.new @@filename
      db.results_as_hash = true
      db.execute cmd
    rescue SQLite3::Exception => e 
      puts "Exception occurred"
      puts e
    ensure
      db.close if db
    end
  end
end