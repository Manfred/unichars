require 'rubygems'

Gem::Specification.new do |spec|
  spec.name = 'unichars'
  spec.version = '0.3'
  
  spec.author = "Manfred Stienstra"
  spec.email = "manfred@fngtps.com"
  
  spec.description = <<-EOF
    Unichars is a wrapper around Glib2 UTF8 functions.
  EOF
  spec.summary = <<-EOF
    Unichars is a wrapper around Glib2 UTF8 functions. It was written to speed up ActiveSupport::Multibyte, but I'm sure
    people can find other uses for it.
  EOF
  
  spec.files = Dir['lib/**/*.rb'] + Dir['ext/**/*']
  
  spec.extensions << 'ext/glib/extconf.rb'
  spec.require_paths = ['lib']
  
  spec.has_rdoc = true
  spec.extra_rdoc_files = ['README', 'LICENSE', 'ext/glib/glib.c']
  spec.rdoc_options << "--charset=utf-8"
end
