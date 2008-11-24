require 'glib'

begin
  class Unichars < ActiveSupport::Multibyte::Chars; end
rescue NameError
  require 'chars'
  class Unichars < Chars; end
end

class Unichars
  def size
    Glib.utf8_size(@wrapped_string)
  end
  
  def upcase
    self.class.new(Glib.utf8_upcase(@wrapped_string))
  end
  
  def downcase
    self.class.new(Glib.utf8_downcase(@wrapped_string))
  end
  
  def reverse
    self.class.new(Glib.utf8_reverse(@wrapped_string))
  end
end