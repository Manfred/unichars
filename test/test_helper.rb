$:.unshift(File.expand_path('../../ext/glib', __FILE__))
$:.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems' rescue LoadError
require 'test/spec'


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
end