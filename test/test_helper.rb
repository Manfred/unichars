# encoding: utf-8

$:.unshift(File.expand_path('../../ext/glib', __FILE__))
$:.unshift(File.expand_path('../../lib', __FILE__))

$KCODE = 'UTF8' unless 'string'.respond_to?(:encoding)

require 'rubygems' rescue LoadError
require 'peck/flavors/vanilla'

def active_support_loaded?; false; end
unless ENV['WITHOUT_ACTIVESUPPORT']
  begin
    require 'active_support'
    require 'active_support/multibyte'
    def active_support_loaded?; true; end
  rescue LoadError
  end
end

require 'unichars'

module TestHelpers
  def chars(string)
    Unichars.new(string)
  end
  
  def inspect_codepoints(str)
    str.to_s.unpack("U*").map{|cp| cp.to_s(16) }.join(' ')
  end
  
  def assert_equal_codepoints(expected, actual, message=nil)
    inspect_codepoints(actual).should == inspect_codepoints(expected)
  end
end

Peck::Context.once do |context|
end