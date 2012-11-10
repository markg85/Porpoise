#include "util.h"

Util* Util::m_Instance = 0;

Util::Util()
    : m_test("TEST_STRING...")
    , m_pathModel(new PathModel())
{
}


QString Util::testSearchString()
{
    QString m_url("/var/www/12345678");


    int lastSlashPosition = m_url.lastIndexOf('/');
    QString urlTillLastSlash = m_url.left(lastSlashPosition + 1);
    QString searchString = m_url.right(-1 + m_url.length() - lastSlashPosition);
    return urlTillLastSlash;
}
