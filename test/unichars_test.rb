# encoding: utf-8

require File.dirname(__FILE__) + '/test_helper'

describe "Unichars" do
  it "should have a default normalization form" do
    Unichars.default_normalization_form.should.not.be.nil
  end
  
  it "should remember the default normalization form" do
    before = Unichars.default_normalization_form
    begin
      Unichars::NORMALIZATION_FORMS.each do |form|
        Unichars.default_normalization_form = form
        Unichars.default_normalization_form.should == form
      end
    ensure
      Unichars.default_normalization_form = before
    end
  end
end

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
  
  it "should reverse strings" do
    chars('').upcase.should == ''
    chars('Profitérøl').reverse.should == 'lørétiforP'
  end
  
  it "should normalize empty strings" do
    Unichars::NORMALIZATION_FORMS.each do |form|
      chars('').normalize(form).should == ''
    end
  end

  it "should titleize strings" do
    chars('').titleize.should == ''
    chars('привет всем').titleize.should == 'Привет Всем'
    chars('пока.всем').titleize.should == 'Пока.Всем'
    chars("the sorcerors apprentice").titleize.should == 'The Sorcerors Apprentice'
  end
  
  it "should perform simple normalization" do
    comp_str = [
      44,  # LATIN CAPITAL LETTER D
      307, # COMBINING DOT ABOVE
      328, # COMBINING OGONEK
      323  # COMBINING DOT BELOW
    ].pack("U*")
    
    assert_equal_codepoints [44,105,106,328,323].pack("U*"), chars(comp_str).normalize(:kc).to_s
    assert_equal_codepoints [44,307,328,323].pack("U*"), chars(comp_str).normalize(:c).to_s
    assert_equal_codepoints [44,307,110,780,78,769].pack("U*"), chars(comp_str).normalize(:d).to_s
    assert_equal_codepoints [44,105,106,110,780,78,769].pack("U*"), chars(comp_str).normalize(:kd).to_s
  end
  
  it "should raise an argument error for unknown normalization forms" do
    lambda {
      chars('').normalize(:unknown)
    }.should.raise(ArgumentError)
  end
  
  it "should explain what the normalization options when supplying a wrong one" do
    begin
      chars('').normalize(:unknown)
    rescue ArgumentError => e
      e.message.should == ':unknown is not a valid normalization form, options are: :d, :kd, :c, or :kc'
    end
  end
  
  it "should use the default normalization form when none was supplied" do
    string = 'A… ehm, word'
    chars(string).normalize().should == Unichars.new(Glib.utf8_normalize(string, Unichars.default_normalization_form))
  end
  
  it "should return an instance of itself" do
    chars('').upcase.class.should == Unichars
    chars('').downcase.class.should == Unichars
    chars('').reverse.class.should == Unichars
    chars('').normalize.class.should == Unichars
    chars('').titleize.class.should == Unichars
  end
  
  if RUBY_VERSION >= "1.9" and !active_support_loaded?
    it "should raise a TypeError when anything except a string is passed" do
      lambda { chars(nil).size }.should.raise(TypeError)
      lambda { chars(nil).upcase }.should.raise(TypeError)
      lambda { chars(nil).downcase }.should.raise(TypeError)
      lambda { chars(nil).reverse }.should.raise(TypeError)
      lambda { chars(nil).normalize }.should.raise(TypeError)
      lambda { chars(nil).titleize }.should.raise(TypeError)
    end
  end
end
