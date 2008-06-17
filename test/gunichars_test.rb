require File.dirname(__FILE__) + '/test_helper'

require 'gunichars.so'

describe "Gunichars" do
  it "should be defined" do
    lambda {
      Gunichars
    }.should.not.raise
  end
end