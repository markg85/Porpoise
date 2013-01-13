#include <QtGlobal>
#include "CNaturalString.h"
#include <cstring>
#include <algorithm>

#if Q_BYTE_ORDER == Q_LITTLE_ENDIAN
#  define ENDIAN_POS(p) (((p) & ~(INTSIZE-1)) + (INTSIZE-1) - ((p) & (INTSIZE-1)))
#else
#  define ENDIAN_POS(p) (p)
#endif

//---------------------------------------------------------------------------
inline bool
CNaturalString::operator<(const CNaturalString & s2) const
{
  unsigned int iMaxIntLen = iIntLen_ <= s2.iIntLen_ ? iIntLen_ : s2.iIntLen_;
  INTTYPE * pData1 = (INTTYPE *)dataLocal_;
  INTTYPE * pData2 = (INTTYPE *)s2.dataLocal_;

  while(iMaxIntLen--)
  {
    if(*pData1 != *pData2)
      return *pData1 < *pData2;
    pData1++;
    pData2++;
  }

  return iIntLen_ < s2.iIntLen_;
}

//---------------------------------------------------------------------------
inline bool
CNaturalString::operator<=(const CNaturalString & s2) const
{
  return !(*this > s2);
}

//---------------------------------------------------------------------------
inline bool
CNaturalString::operator>(const CNaturalString & s2) const
{
  unsigned int iMaxIntLen = iIntLen_ <= s2.iIntLen_ ? iIntLen_ : s2.iIntLen_;
  INTTYPE * pData1 = (INTTYPE *)dataLocal_;
  INTTYPE * pData2 = (INTTYPE *)s2.dataLocal_;

  while(iMaxIntLen--)
  {
    if(*pData1 != *pData2)
      return *pData1 > *pData2;
    pData1++;
    pData2++;
  }

  return iIntLen_ > s2.iIntLen_;
}

//---------------------------------------------------------------------------
inline bool
CNaturalString::operator>=(const CNaturalString & s2) const
{
  return !(*this < s2);
}

//---------------------------------------------------------------------------
inline bool
CNaturalString::operator==(const CNaturalString & s2) const
{
  unsigned int iMaxIntLen = iIntLen_;
  INTTYPE * pData1 = (INTTYPE *)dataLocal_;
  INTTYPE * pData2 = (INTTYPE *)s2.dataLocal_;

  if(iIntLen_ != s2.iIntLen_)
    return false;

  while(iMaxIntLen--)
  {
    if(*pData1 != *pData2)
      return false;
    pData1++;
    pData2++;
  }

  return true;
}

//---------------------------------------------------------------------------
inline bool
CNaturalString::operator!=(const CNaturalString & s2) const
{
  return !(*this == s2);
}

//---------------------------------------------------------------------------
inline void
CNaturalString::addChar(char * str, char c)
{
  str[ENDIAN_POS(iPos_)] = c;
  iPos_++;
}

//---------------------------------------------------------------------------
inline char *
CNaturalString::skipChar(char * str)
{
  iPos_++;
  return &str[ENDIAN_POS(iPos_ - 1)];
}

//---------------------------------------------------------------------------
inline void
CNaturalString::align(char * str)
{
  while((iPos_ & (INTSIZE-1)) != 0)
    addChar(str, 0);
  iIntLen_ = iPos_ / INTSIZE;
}
