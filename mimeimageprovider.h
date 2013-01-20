#ifndef MIMEIMAGEPROVIDER_H
#define MIMEIMAGEPROVIDER_H

#include <KIcon>
#include <KIconLoader>

#include <QPixmap>
#include <QDebug>
#include <QDeclarativeImageProvider>

/**
 * @brief The MimeImageProvider class
 * Perhaps this class should make use of some pixmap caching?
 */
class MimeImageProvider : public QDeclarativeImageProvider
{
public:
    MimeImageProvider()
        : QDeclarativeImageProvider(QDeclarativeImageProvider::Pixmap)
    {
    }

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
        KIcon icon(id);
        if(size)
        {
            *size = QSize(256, 256);
        }

        if(requestedSize.width() > -1)
        {
            return icon.pixmap(requestedSize);
        }
        else
        {
            return icon.pixmap(*size);
        }
    }
};

#endif // MIMEIMAGEPROVIDER_H
