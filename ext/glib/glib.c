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

static VALUE utf8_reverse(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;

  Check_Type(string, T_STRING);
  temp = g_utf8_strreverse(StringValuePtr(string), RSTRING(string)->len);
  result = rb_str_new2(temp);

  return result;
}

static VALUE utf8_normalize(VALUE self, VALUE string, VALUE form)
{
  VALUE result;
  gchar *temp;
  GNormalizeMode mode;

  Check_Type(string, T_STRING);
  Check_Type(form, T_SYMBOL);

  if (ID2SYM(rb_intern("d")) == form) {
    mode = G_NORMALIZE_NFD;
  } else if (ID2SYM(rb_intern("c")) == form) {
    mode = G_NORMALIZE_NFC;
  } else if (ID2SYM(rb_intern("kd")) == form) {
    mode = G_NORMALIZE_NFKD;
  } else if (ID2SYM(rb_intern("kc")) == form) {
    mode = G_NORMALIZE_NFKC;
  } else {
    rb_raise(rb_eArgError, "%s is not a valid normalization form, options are: :d, :kd, :c, or :kc", RSTRING(rb_inspect(form))->ptr);
  }

  temp = g_utf8_normalize(StringValuePtr(string), RSTRING(string)->len, mode);
  result = rb_str_new2(temp);

  return result;
}

void
Init_glib()
{
  VALUE mGlib;

  mGlib = rb_define_module("Glib");
  rb_define_module_function(mGlib, "utf8_size", utf8_size, 1);
  rb_define_module_function(mGlib, "utf8_upcase", utf8_upcase, 1);
  rb_define_module_function(mGlib, "utf8_downcase", utf8_downcase, 1);
  rb_define_module_function(mGlib, "utf8_reverse", utf8_reverse, 1);
  rb_define_module_function(mGlib, "utf8_normalize", utf8_normalize, 2);
}
