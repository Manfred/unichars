require File.dirname(__FILE__) + '/test_helper'

require 'unichars'

describe "A Unichars instance" do
  before do
    @chars = Unichars.new('Profitérøl')
  end
  
  it "should know it's size" do
    @chars.size.should == 10
  end  
end