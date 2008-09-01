task :default => :test
task :compile => "extconf:compile"

desc "Run all tests"
task :test => :compile do
  Dir[File.dirname(__FILE__) + '/test/**/*_test.rb'].each do |file|
    ruby file
  end
end

task :clean do
  crap = "*.{bundle,so,obj,log}"
  ["ext/**/#{crap}", "ext/**/Makefile"].each do |glob|
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
      sh(PLATFORM =~ /win32/ ? 'nmake' : 'make') do |ok, res|
        if !ok
          require "fileutils"
          FileUtils.rm Dir.glob('*.{so,o,dll,bundle}')
        end
      end
    end
  end
end