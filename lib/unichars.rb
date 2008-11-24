require 'glib'

begin
  class Unichars < ActiveSupport::Multibyte::Chars; end
rescue NameError
end

class Unichars
  def initialize(string)
    @wrapped_string = string
  end
  
  def size
    Glib.utf8_size(@wrapped_string)
  end
  
  def upcase
    Glib.utf8_upcase(@wrapped_string)
  end
  
  def downcase
    Glib.utf8_downcase(@wrapped_string)
  end
  
  def reverse
    Glib.utf8_reverse(@wrapped_string)
  end
end