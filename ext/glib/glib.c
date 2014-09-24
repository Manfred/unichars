#include <ruby.h>
#include <ruby/encoding.h>
#include <glib.h>

#ifndef RSTRING_LEN
#define RSTRING_LEN(string) RSTRING(string)->len
#endif

#ifndef RSTRING_PTR
#define RSTRING_PTR(string) RSTRING(string)->ptr
#endif

/*
 *  call-seq:
 *    utf8_size(string)
 *
 *  Returns the length of the string expressed in codepoints.
 *
 *    Glib.utf8_size('A ehm…, word.') #=> 13
 */
static VALUE utf8_size(VALUE self, VALUE string)
{
  VALUE result;

  Check_Type(string, T_STRING);
  result = ULONG2NUM(g_utf8_strlen(StringValuePtr(string), RSTRING_LEN(string)));

  return result;
}

/*
 *  call-seq:
 *    utf8_upcase(string)
 *
 *  Returns the string in capitals if they are are available for the supplied characters.
 *
 *    Glib.utf8_upcase('Sluß') #=> SLUSS
 */
static VALUE utf8_upcase(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;
  rb_encoding *utf8_enc = rb_enc_find("UTF-8");

  Check_Type(string, T_STRING);
  temp = g_utf8_strup(StringValuePtr(string), RSTRING_LEN(string));
  result = rb_external_str_new_with_enc(temp, strlen(temp), utf8_enc);
  free(temp);

  return result;
}

/*
 *  call-seq:
 *    utf8_downcase(string)
 *
 *  Returns the string in lowercase characters if they are are available for the supplied characters.
 *
 *    Glib.utf8_downcase('ORGANISÉE') #=> organisée
 */
static VALUE utf8_downcase(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;
  rb_encoding *utf8_enc = rb_enc_find("UTF-8");

  Check_Type(string, T_STRING);
  temp = g_utf8_strdown(StringValuePtr(string), RSTRING_LEN(string));
  result = rb_external_str_new_with_enc(temp, strlen(temp), utf8_enc);
  free(temp);

  return result;
}

/*
 *  call-seq:
 *    utf8_reverse(string)
 *
 *  Returns a string with the characters in reverse order.
 *
 *    Glib.utf8_reverse('Comment ça va?') #=> av aç tnemmoC
 */
static VALUE utf8_reverse(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;
  rb_encoding *utf8_enc = rb_enc_find("UTF-8");

  Check_Type(string, T_STRING);
  temp = g_utf8_strreverse(StringValuePtr(string), RSTRING_LEN(string));
  result = rb_external_str_new_with_enc(temp, strlen(temp), utf8_enc);
  free(temp);

  return result;
}


/*
 *  call-seq:
 *    utf_normalize(string, form)
 *
 *  Returns the normalized form of the string. See http://www.unicode.org/reports/tr15/tr15-29.html for more
 *  information about normalization.
 *
 *  <i>form</i> can be one of the following: <tt>:c</tt>, <tt>:kc</tt>, <tt>:d</tt>, or <tt>:kd</tt>.
 *
 *    decomposed = [101, 769].pack('U*')
 *    composed = Glib.utf8_normalize(decomposed, :kc)
 *    composed.unpack('U*') #=> [233]
 */
static VALUE utf8_normalize(VALUE self, VALUE string, VALUE form)
{
  VALUE result;
  gchar *temp;
  GNormalizeMode mode;
  rb_encoding *utf8_enc = rb_enc_find("UTF-8");

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
    rb_raise(rb_eArgError, "%s is not a valid normalization form, options are: :d, :kd, :c, or :kc", RSTRING_PTR(rb_inspect(form)));
  }

  temp = g_utf8_normalize(StringValuePtr(string), RSTRING_LEN(string), mode);
  result = rb_external_str_new_with_enc(temp, strlen(temp), utf8_enc);
  free(temp);

  return result;
}

/*
 *  call-seq:
 *    utf8_titleize(string)
 *
 *  Returns a title case string.
 *
 *    Glib.utf8_titleize('привет всем') #=> Привет Всем
 */
static VALUE utf8_titleize(VALUE self, VALUE string)
{
  VALUE result;
  gchar *temp;
  long index, length_in_bytes, length_in_chars;
  gunichar *chars_as_ucs4, current_char;
  gboolean first_character_of_word = TRUE;

  Check_Type(string, T_STRING);

  length_in_bytes = RSTRING_LEN(string);
  if ((chars_as_ucs4 = g_utf8_to_ucs4(StringValuePtr(string), length_in_bytes, NULL, &length_in_chars, NULL))) {
    rb_encoding *utf8_enc = rb_enc_find("UTF-8");

    for (index = 0; index < length_in_chars; index++) {
      current_char = chars_as_ucs4[index];
      if (first_character_of_word == TRUE && g_unichar_isalpha(current_char)) {
        chars_as_ucs4[index] = g_unichar_totitle(current_char);
        first_character_of_word = FALSE;
      }

      if (g_unichar_isspace(current_char) || g_unichar_ispunct(current_char)) {
        first_character_of_word = TRUE;
      }
    }
    
    temp = g_ucs4_to_utf8(chars_as_ucs4, -1, NULL, NULL, NULL);
    result = rb_external_str_new_with_enc(temp, strlen(temp), utf8_enc);
    g_free(chars_as_ucs4);
    g_free(temp);
    
    return result;
  } else {
    return Qnil;
  }
}


/* The Glib module holds methods which wrap Glib2 functions.
 */
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
  rb_define_module_function(mGlib, "utf8_titleize", utf8_titleize, 1);
}
