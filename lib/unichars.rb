# encoding: utf-8

require 'glib'

begin
  class Unichars < ActiveSupport::Multibyte::Chars; end
rescue NameError
  require 'chars'
  class Unichars < Chars; end
end

class Unichars
  NORMALIZATION_FORMS = [:c, :kc, :d, :kd]
  
  class << self
    attr_accessor :default_normalization_form
  end
  
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
  
  def normalize(form=Unichars.default_normalization_form)
    self.class.new(Glib.utf8_normalize(@wrapped_string, form))
  end
end

Unichars.default_normalization_form = :kc