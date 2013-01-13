#ifndef CNATURALSTRING_H
#define CNATURALSTRING_H


#include <string>
#include <inttypes.h>


//#define CNATURALSTRING_DEBUG
#ifdef __x86_64__
  #define INTTYPE uint64_t
  #define INTSIZE 8
#else
  #define INTTYPE uint32_t
  #define INTSIZE 4
#endif


class CNaturalString
{
public:
  CNaturalString(const char * s);
  ~CNaturalString();

  bool operator< (const CNaturalString & s2) const;
  bool operator<=(const CNaturalString & s2) const;
  bool operator> (const CNaturalString & s2) const;
  bool operator>=(const CNaturalString & s2) const;
  bool operator==(const CNaturalString & s2) const;
  bool operator!=(const CNaturalString & s2) const;

#ifdef CNATURALSTRING_DEBUG
  const std::string & get() const;
#endif

private:
  void addChar(char * str, char c);
  char * skipChar(char * str);
  void align(char * str);

private:
#ifdef CNATURALSTRING_DEBUG
  std::string s_;
#endif

  char * dataLocal_;
  unsigned int iPos_;
  unsigned int iIntLen_;
};


#include "CNaturalString.inl"


#endif
