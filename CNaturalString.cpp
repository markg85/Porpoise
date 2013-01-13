#include "CNaturalString.h"
#include <cstring>
#include <algorithm>


#define MAX_STRING_LENGTH 256
#define MAX_DATA_SIZE     (MAX_STRING_LENGTH * 2)


//---------------------------------------------------------------------------
inline bool is_number(char c)
{
  return (c >= '0' && c <= '9');
}

//---------------------------------------------------------------------------
CNaturalString::CNaturalString(const char * str)
 :
#ifdef CNATURALSTRING_DEBUG
   s_(str),
#endif
   dataLocal_(NULL)
 , iPos_(0)
 , iIntLen_(0)
{
  char data[MAX_DATA_SIZE];
  unsigned int iStringSize = strlen(str);

  for(unsigned int i = 0; i < iStringSize;)
  {
    if(is_number(str[i]))
    {
      unsigned char * pChar;
      unsigned char iLength = 0;
      bool bFirstIsZero = str[i] == '0';

      // Leading zero, so numbers will always be sorted above non-numbers
      addChar(data, 0);

      // Number of numbers, for sorting from smaller numbers above bigger ones
      pChar = (unsigned char *)skipChar(data);

      // Add numbers
      do
      {
        addChar(data, str[i]);
        iLength++;
        i++;
      } while(is_number(str[i]) && i < iStringSize);

      // Number of numbers
      if(bFirstIsZero)
        *pChar = 0;
      else
        *pChar = iLength;
    }
    else
    {
      // Add non-numbers
      do
      {
        addChar(data, str[i]);
        i++;
      } while(!is_number(str[i]) && i < iStringSize);
    }
  }
  // Add trailing zeroes for fast aligned integer compare
  align(data);

  dataLocal_ = new char[iIntLen_ * INTSIZE];
  for(unsigned int i = 0; i < iIntLen_; i++)
    ((INTTYPE *)dataLocal_)[i] = ((INTTYPE *)data)[i];
}

//---------------------------------------------------------------------------
CNaturalString::~CNaturalString()
{
  if(dataLocal_ != NULL)
    delete[] dataLocal_;
}

#ifdef CNATURALSTRING_DEBUG
//---------------------------------------------------------------------------
const std::string &
CNaturalString::get() const
{
  return s_;
}
#endif
