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
class DirModelPrivate;

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

    /**
     * @property count Total number of rows
     */
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum Roles {
        UrlRole = Qt::UserRole + 1,
        MimeTypeRole,
        IconName,
        BaseName,
        Extension,
        TimeString,
        MimeOrThumb,
        ColumnCount
    };

    DirModel(QObject* parent=0);
    virtual ~DirModel();
    virtual int columnCount ( const QModelIndex & parent = QModelIndex() ) const;

    void setUrl(const QString& url);
    QString url() const;

    QVariant data(const QModelIndex &index, int role) const;
    int count() const {return rowCount();}

    Q_INVOKABLE int indexForUrl(const QString &url) const;

    Q_INVOKABLE QObject* itemForIndex(int index) const;
    Q_INVOKABLE void reload();

protected Q_SLOTS:
    void updatePreview(const KFileItem &item, const QPixmap &preview);
    void newItems(const KFileItemList& list);
    void listenerCompleted();

signals:
    void countChanged();
    void urlChanged();
    void killCurrentJobs();

private:

    friend class DirModelPrivate;
    DirModelPrivate *const d;

    QStringList m_mimeTypes;

    //previews

    QHash<QString, KIO::PreviewJob*> m_previewJobs;
    KImageCache* m_imageCache;
};

#endif // DIRMODEL_H
