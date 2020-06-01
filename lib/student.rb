require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade
  
  def initialize (id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      );
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL
    
    DB[:conn].execute(sql)
  end

  def save 
    if self.id
      self.update
    else 
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
  def self.create
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end
  
  def self.new_from_db(array) 
    # self.id = array[0]
    # self.name = array[1]
    # self.grade = array[2]
    self.new(array[0], array[1], array[2])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    self.new(result[0], result[1], result[2])
  end
 
end
