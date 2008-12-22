# encoding: utf-8

require File.dirname(__FILE__) + '/test_helper'

require 'glib.so'

describe "Glib" do
  it "should be defined" do
    lambda {
      Glib
    }.should.not.raise
  end
end