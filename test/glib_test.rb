# encoding: utf-8

require File.dirname(__FILE__) + '/test_helper'

require 'glib.so'

describe "Glib" do
  it "should be defined" do
    lambda {
      Glib
    }.should.not.raise
  end

  it "returns strings with the UTF-8 encoding" do
    result = Glib.utf8_downcase('Église')
    result.should == 'église'
    result.encoding.to_s.should == 'UTF-8'
  end
end