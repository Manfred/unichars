require 'gunichars.so'

class Unichars
  extend Gunichars
  
  def initialize(string)
    @wrapped_string = string
  end
  
  def size
    self.class.size(@wrapped_string)
  end
  
  def upcase
    self.class.upcase(@wrapped_string)
  end
  
  def downcase
    self.class.downcase(@wrapped_string)
  end
end