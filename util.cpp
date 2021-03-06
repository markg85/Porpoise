#include "util.h"

Util* Util::m_Instance = 0;

Util::Util()
    : m_test("TEST_STRING...")
    , m_pathModel(new PathModel())
    , m_imageCache(new KImageCache("porpoise_thumbnail_cache_2", 10485760))
{
    // KImageCache settings
    m_imageCache->setPixmapCaching(true);
    m_imageCache->setPixmapCacheLimit(65536); // 64KB
}


QString Util::testSearchString()
{
    QString m_url("/var/www/12345678");


    int lastSlashPosition = m_url.lastIndexOf('/');
    QString urlTillLastSlash = m_url.left(lastSlashPosition + 1);
    QString searchString = m_url.right(-1 + m_url.length() - lastSlashPosition);
    return urlTillLastSlash;
}
