# encoding: utf-8

$:.unshift(File.expand_path('../../../ext/glib', __FILE__))
$:.unshift(File.expand_path('../../../lib', __FILE__))

$KCODE = 'UTF8' unless 'string'.respond_to?(:encoding)

require 'unichars'

class MemoryTest
  DATA = File.read(File.expand_path('../data/rshmn10j.txt', __FILE__)).freeze
  
  def test_size
    chars(DATA).size
  end
  
  def test_upcase
    chars(DATA).upcase
  end
  
  def test_downcase
    chars(DATA).downcase
  end
  
  def test_reverse
    chars(DATA).reverse
  end
  
  def test_normalize
    Unichars::NORMALIZATION_FORMS.each do |form|
      chars(DATA).normalize(form)
    end
  end
  
  private
  
  def chars(string)
    Unichars.new(string)
  end
  
  def self.run
    suite = MemoryTest.new
    suite.methods.grep(/^test_/).each do |test|
      (ENV['TIMES'] || 1).to_i.times do
        suite.send(test)
      end
    end
  end
end

if __FILE__ == $0
  at_exit do
    MemoryTest.run
  end
end