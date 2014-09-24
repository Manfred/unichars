# Unichars

Unichars is a simple wrapper around Glib2. It was originally written to speed up ActiveSupport::Multibyte on Ruby 1.8 but it can probably used for other things as well.

# Installation

## Max OS X

You have to install Glib2. We suggest Homebrew, but anything goes.

	$ brew install glib

After that you can install the gem:

	$ gem install unichars

## Ubuntu and Debian

	$ apt-get install libglib2.0-dev
	$ gem install unichars

# Examples

## Rails

In you Gemfile add:

	gem 'unichars'

Add config/initializers/unichars.rb:

	ActiveSupport::Multibyte.proxy_class = Unichars

After that you can just use Unichars through the character proxy on String:

	'¡Ay Dios mío!'.chars.reverse

## ActiveSupport without Rails

Note that you probably want to load ActiveSupport before loading Unichars because Unichars subclasses itself from ActiveSupport::Multibyte::Chars when you do so.

	require 'rubygems'
	require 'active_support/all'
	require 'unichars'
	ActiveSupport::Multibyte.proxy_class = Unichars

After that you can just use Unichars through the character proxy on String:

	'¡Ay Dios mío!'.chars.reverse

## Plain Ruby code

Yeah, so, ehm. Yeah.

	require 'rubygems'
	require 'unichars'

After that you can do:

	Unichars.new('¡Ay Dios mío!').reverse

Or possibly:

	class String
	  def mb_chars
	    Unichars.new(self)
	  end
	end
