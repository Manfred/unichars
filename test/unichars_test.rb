require File.dirname(__FILE__) + '/test_helper'

describe "A Unichars instance" do
  include TestHelpers
  
  it "should know it's size" do
    chars('').size.should == 0
    chars('Profitérøl').size.should == 10
  end
  
  it "should upcase strings" do
    chars('').upcase.should == ''
    chars('Profitérøl').upcase.should == 'PROFITÉRØL'
  end
  
  it "should downcase strings" do
    chars('').downcase.should == ''
    chars('PROFITÉRØL').downcase.should == 'profitérøl'
  end
  
  it "should raise a TypeError when anything except a string is passed" do
    lambda { chars(nil).size }.should.raise(TypeError)
    lambda { chars(nil).upcase }.should.raise(TypeError)
    lambda { chars(nil).downcase }.should.raise(TypeError)
  end
end