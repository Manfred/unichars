# encoding: utf-8

class Chars
  attr_reader :wrapped_string
  alias to_s wrapped_string
  alias to_str wrapped_string
  
  # Creates a new Chars instance by wrapping _string_.
  def initialize(string)
    @wrapped_string = string
  end
  
  # Forward all undefined methods to the wrapped string.
  def method_missing(method, *args, &block)
    if method.to_s =~ /!$/
      @wrapped_string.send(method, *args, &block)
      self
    else
      result = @wrapped_string.send(method, *args, &block)
      result.kind_of?(String) ? self.class.new(result) : result
    end
  end
  
  # Returns +true+ if _obj_ responds to the given method. Private methods are included in the search
  # only if the optional second parameter evaluates to +true+.
  def respond_to?(method, include_private=false)
    super || @wrapped_string.respond_to?(method, include_private) || false
  end
  
  include Comparable
  
  # Returns <tt>-1</tt>, <tt>0</tt> or <tt>+1</tt> depending on whether the Chars object is to be sorted before,
  # equal or after the object on the right side of the operation. It accepts any object that implements +to_s+.
  # See <tt>String#<=></tt> for more details.
  #
  # Example:
  #   'é'.mb_chars <=> 'ü'.mb_chars #=> -1
  def <=>(other)
    @wrapped_string <=> other.to_s
  end

  # Returns a new Chars object containing the _other_ object concatenated to the string.
  #
  # Example:
  #   ('Café'.mb_chars + ' périferôl').to_s #=> "Café périferôl"
  def +(other)
    self << other
  end
end