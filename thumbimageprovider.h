#ifndef THUMBIMAGEPROVIDER_H
#define THUMBIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>
#include <QDebug>
#include <KImageCache>
#include "util.h"

class ThumbImageProvider : public QDeclarativeImageProvider
{
public:
    ThumbImageProvider()
        : QDeclarativeImageProvider(QDeclarativeImageProvider::Pixmap)
    {
        m_imageCache = Util::instance()->imageCache();
    }

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
        Q_UNUSED(size)
        Q_UNUSED(requestedSize)

        QPixmap preview;
        if(!m_imageCache->findPixmap(id, &preview)) {
            qWarning() << "Image not found in cache. Image ID:" << id;
        }

        return preview;
    }

private:
    KImageCache* m_imageCache;
};

#endif // THUMBIMAGEPROVIDER_H
