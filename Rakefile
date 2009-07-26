require 'rake/rdoctask'

RUBY_PLATFORM = PLATFORM unless Kernel.const_defined?(:RUBY_PLATFORM)

task :default => :test
task :compile => "extconf:compile"

desc "Run all tests"
task :test => :compile do
  Dir[File.dirname(__FILE__) + '/test/**/*_test.rb'].each do |file|
    load file
  end
end

namespace :profile do
  desc "Profile memory"
  task :memory => :compile do
    sh 'valgrind --tool=memcheck --leak-check=yes --num-callers=10 --track-fds=yes ruby test/profile/memory.rb'
  end
end

task :clean do
  crap = "*.{bundle,so,o,obj,log}"
  ["*.gem", "ext/**/#{crap}", "ext/**/Makefile"].each do |glob|
    Dir.glob(glob).each do |file|
      rm(file)
    end
  end
end

namespace :extconf do
  desc "Compile the Ruby extension"
  task :compile
end

namespace :extconf do
  extension = 'glib'
  ext = "ext/#{extension}"
  ext_so = "#{ext}/#{extension}.#{Config::CONFIG['DLEXT']}"
  ext_files = FileList[
    "#{ext}/*.c",
    "#{ext}/*.h",
    "#{ext}/*.rl",
    "#{ext}/extconf.rb",
    "#{ext}/Makefile"
  ]

  task :compile => extension do
    if Dir.glob("**/#{extension}.{o,so,dll}").length == 0
      $stderr.puts("Failed to build #{extension}.")
      exit(1)
    end
  end

  desc "Builds just the #{extension} extension"
  task extension.to_sym => ["#{ext}/Makefile", ext_so ]

  file "#{ext}/Makefile" => ["#{ext}/extconf.rb"] do
    Dir.chdir(ext) do ruby "extconf.rb" end
  end

  file ext_so => ext_files do
    Dir.chdir(ext) do
      sh(RUBY_PLATFORM =~ /win32/ ? 'nmake' : 'make') do |ok, res|
        if !ok
          require "fileutils"
          FileUtils.rm Dir.glob('*.{so,o,dll,bundle}')
        end
      end
    end
  end
end

namespace :gem do
  desc "Build the gem"
  task :build do
    sh 'gem build unichars.gemspec'
  end
  
  desc "Install the gem"
  task :install => :build do
    sh 'sudo gem install unichars-*.gem'
  end
end

namespace :docs do
  Rake::RDocTask.new('generate') do |rdoc|
    rdoc.title = 'Unichars'
    rdoc.main = "README"
    rdoc.rdoc_files.include('README', 'lib/chars.rb', 'lib/unichars.rb', 'ext/glib/glib.c')
    rdoc.options << "--all" << "--charset" << "utf-8"
  end
end