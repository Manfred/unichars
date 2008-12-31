# encoding: utf-8

require 'glib'

begin
  class Unichars < ActiveSupport::Multibyte::Chars; end
rescue NameError
  require 'chars'
  class Unichars < Chars; end
end

# Unichars is a proxy class for String. It wraps a String and implements UTF-8 safe versions of various String operations.
# Unimplemented methods are forwarded to the wrapped string.
#
# Unichars uses ActiveSupport::Multibyte::Chars as a superclass if it's loaded. Otherwise it will use it's own Chars class
# which is basically a trimmed down version of ActiveSupport's Chars class.
#
#   require 'unichars'
#   Unichars.superclass #=> Chars
#
#   require 'active_support'
#   require 'unichars'
#   Unichars.superclass #=> ActiveSupport::Multibyte::Chars
#
# Note that all the operations on strings are implemented using Glib2, so the outcome of the methods will be influenced by the
# Glib2 version installed on your system.
class Unichars
  # Valid normalization forms
  NORMALIZATION_FORMS = [:c, :kc, :d, :kd]
  
  class << self
    attr_accessor :default_normalization_form
  end
  
  # Returns the length of the string expressed in codepoints.
  #
  #   Unichars.new('A ehm…, word.').size #=> 13
  def size
    Glib.utf8_size(@wrapped_string)
  end
  
  # Returns a Unichars instance with the string in capitals if they are are available for the supplied string.
  #
  #   Unichars.new('Sluß').upcase.to_s #=> SLUSS
  def upcase
    self.class.new(Glib.utf8_upcase(@wrapped_string))
  end
  
  # Returns a Unichars instance with the string in lowercase characters if they are are available for the supplied string.
  #
  #   Unichars.new('ORGANISÉE').downcase.to_s #=> organisée
  def downcase
    self.class.new(Glib.utf8_downcase(@wrapped_string))
  end
  
  # Returns a Unichars instance with the string in reverse order.
  #
  #   Unichars.new('Comment ça va?').reverse.to_s #=> av aç tnemmoC
  def reverse
    self.class.new(Glib.utf8_reverse(@wrapped_string))
  end
  
  # Returns a Unichars instance with the string in normalize form. See http://www.unicode.org/reports/tr15/tr15-29.html
  # for more information about normalization.
  #
  # <i>form</i> can be one of the following: <tt>:c</tt>, <tt>:kc</tt>, <tt>:d</tt>, or <tt>:kd</tt>.
  #
  #   decomposed = [101, 769].pack('U*')
  #   composed = Unichars.new(decomposed).normalize(:kc)
  #   composed.to_s.unpack('U*') #=> [233]
  def normalize(form=Unichars.default_normalization_form)
    self.class.new(Glib.utf8_normalize(@wrapped_string, form))
  end
end

Unichars.default_normalization_form = :kc