require 'mkmf'

unless pkg_config('glib-2.0')
  abort "Gunichars requires glib-2.0 and pkg_config"
end

dir_config("gunichars")

create_makefile("gunichars")
