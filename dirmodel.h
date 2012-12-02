/*
    Copyright (C) 20111 Marco Martin <mart@kde.org>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

*/

#ifndef DIRMODEL_H
#define DIRMODEL_H

#include <KDirModel>
#include "fileitem.h"
#include <QVariant>
#include <KIO/PreviewJob>

class QTimer;

class KImageCache;

/**
 * This class provides a QML binding to KDirModel
 * Provides an easy way to navigate a filesystem from within QML
 *
 * @author Marco Martin <mart@kde.org>
 */
class DirModel : public KDirModel
{
    Q_OBJECT

    /**
     * @property string The url we want to browse. it may be an absolute path or a correct url of any protocol KIO supports
     */
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(int thumbWidth READ thumbWidth WRITE setThumbWidth NOTIFY thumbWidthChanged)
    Q_PROPERTY(int thumbHeight READ thumbHeight WRITE setThumbHeight NOTIFY thumbHeightChanged)

    /**
     * @property count Total number of rows
     */
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum Roles {
        UrlRole = Qt::UserRole + 1,
        MimeTypeRole,
        Thumbnail,
        IconName,
        BaseName,
        Extension,
        TimeString,
        ColumnCount
    };

    DirModel(QObject* parent=0);
    virtual ~DirModel();
    virtual int columnCount ( const QModelIndex & parent = QModelIndex() ) const;

    void setUrl(const QString& url);
    QString url() const;

    void setThumbWidth(int thumbWidth);
    int thumbWidth() { return m_thumbWidth; }

    void setThumbHeight(int thumbHeight);
    int thumbHeight() { return m_thumbHeight; }

    QVariant data(const QModelIndex &index, int role) const;
    int count() const {return rowCount();}

    Q_INVOKABLE int indexForUrl(const QString &url) const;

    Q_INVOKABLE QVariantMap get(int index) const;
    Q_INVOKABLE QObject* itemForIndex(int index) const;
    Q_INVOKABLE void run(int index) const;
    Q_INVOKABLE void reload();

    void rebuildUrlToIndex();

protected Q_SLOTS:
    void updatePreview(const KFileItem &item, const QPixmap &preview);
    void previewFailed(const KFileItem &item);
    void newItems(const KFileItemList& list);
    void result(KJob*);

Q_SIGNALS:
    void countChanged();
    void urlChanged();
    void thumbWidthChanged();
    void thumbHeightChanged();

private:
    QStringList m_mimeTypes;

    //previews
    QTimer *m_previewTimer;
    QHash<KUrl, QPersistentModelIndex> m_filesToPreview;
    QHash<KUrl, QPersistentModelIndex> m_urlToIndex;
    KImageCache* m_imageCache;
    int m_thumbWidth;
    int m_thumbHeight;
};

#endif // DIRMODEL_H
