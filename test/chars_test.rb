# encoding: utf-8

require File.expand_path('../test_helper', __FILE__)

describe "A Chars instance" do
  it "should wrap a string" do
    chars('Wrapped').wrapped_string.should == 'Wrapped'
  end
  
  it "should coerce to a string" do
    chars('Wrapped').to_s.should == 'Wrapped'
  end
  
  it "should cast to a string" do
    chars('Wrapped').to_str.should == 'Wrapped'
  end
  
  it "should delegate undefined methods to the wrapped string" do
    first_letter = chars('Wrapped')[0,1]
    first_letter.should == 'W'
    first_letter.class.should == Chars
  end
  
  it "should delegate undefined bang methods to the wrapped string" do
    spacious = chars('  Spacious!  ')
    a = spacious.strip!
    spacious.should == 'Spacious!'
    spacious.class.should == Chars
  end
  
  it "should respond to it's own methods" do
    chars('Wrapped').should.respond_to(:<=>)
  end
  
  it "should respond to the wrapped string's methods" do
    chars('Wrapped').should.respond_to(:strip)
  end
  
  it "should compare to other Chars instances" do
    chars('a').should < chars('b')
    chars('b').should > chars('a')
    chars('a').<=>(chars('b')).should == -1
  end
  
  it "should compare to strings" do
    chars('a').should < 'b'
    chars('b').should > 'a'
    chars('a').<=>('b').should == -1
  end
  
  it "should concatenate itself to other Chars instances" do
    name = chars('Julian') + chars(' ') + chars('Wright')
    name.should == 'Julian Wright'
  end
  
  it "should concatenate itself to strings" do
    name = chars('Julian') + ' ' + 'Wright'
    name.should == 'Julian Wright'
  end
  
  def chars(string)
    Chars.new(string)
  end
end unless active_support_loaded?