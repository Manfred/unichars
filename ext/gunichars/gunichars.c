#include <ruby.h>
#include <glib.h>

static VALUE gunichars_size(VALUE self, VALUE string)
{
  VALUE result;

  Check_Type(string, T_STRING);
  result = ULONG2NUM(g_utf8_strlen(StringValuePtr(string), RSTRING(string)->len));

  return result;
}

static VALUE gunichars_upcase(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;

  Check_Type(string, T_STRING);
  temp = g_utf8_strup(StringValuePtr(string), RSTRING(string)->len);
  result = rb_str_new2(temp);

  return result;
}

static VALUE gunichars_downcase(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;

  Check_Type(string, T_STRING);
  temp = g_utf8_strdown(StringValuePtr(string), RSTRING(string)->len);
  result = rb_str_new2(temp);

  return result;
}

void
Init_gunichars()
{
  VALUE mGunichars;

  mGunichars = rb_define_module("Gunichars");
  rb_define_method(mGunichars, "size", gunichars_size, 1);
  rb_define_method(mGunichars, "upcase", gunichars_upcase, 1);
  rb_define_method(mGunichars, "downcase", gunichars_downcase, 1);
}
