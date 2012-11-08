#include "util.h"

Util* Util::m_Instance = 0;

Util::Util()
    : m_test("TEST_STRING...")
    , m_pathModel(new PathModel())
{
}
