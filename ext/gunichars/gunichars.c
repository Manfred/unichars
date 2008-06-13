#include <ruby.h>
#include <glib.h>

static VALUE gunichars_size(VALUE self, VALUE string)
{
  VALUE result;

  result = ULONG2NUM(g_utf8_strlen(StringValuePtr(string), RSTRING(string)->len));

  return result;
}

void
Init_gunichars()
{
  VALUE mGunichars;

  mGunichars = rb_define_module("Gunichars");
  rb_define_method(mGunichars, "size", gunichars_size, 1);
}
