require File.dirname(__FILE__) + '/test_helper'

describe "A Unichars class subclassed from ActiveSupport::Multibyte::Chars" do
  include TestHelpers
  
  it "should know it's size" do
    chars('').size.should == 0
    chars('Profitérøl').size.should == 10
  end
  
  it "should respond to index" do
    chars('').should.respond_to(:index)
  end
end if active_support_loaded?
