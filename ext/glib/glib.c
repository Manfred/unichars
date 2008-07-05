#include <ruby.h>
#include <glib.h>

static VALUE utf8_size(VALUE self, VALUE string)
{
  VALUE result;

  Check_Type(string, T_STRING);
  result = ULONG2NUM(g_utf8_strlen(StringValuePtr(string), RSTRING(string)->len));

  return result;
}

static VALUE utf8_upcase(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;

  Check_Type(string, T_STRING);
  temp = g_utf8_strup(StringValuePtr(string), RSTRING(string)->len);
  result = rb_str_new2(temp);

  return result;
}

static VALUE utf8_downcase(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;

  Check_Type(string, T_STRING);
  temp = g_utf8_strdown(StringValuePtr(string), RSTRING(string)->len);
  result = rb_str_new2(temp);

  return result;
}

void
Init_glib()
{
  VALUE mGlib;

  mGlib = rb_define_module("Glib");
  rb_define_method(mGlib, "utf8_size", utf8_size, 1);
  rb_define_method(mGlib, "utf8_upcase", utf8_upcase, 1);
  rb_define_method(mGlib, "utf8_downcase", utf8_downcase, 1);
}
