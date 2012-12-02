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

#include "dirmodel.h"

#include <QFileInfo>
#include <QVariant>
#include <KDirLister>
#include <KDebug>

#include <KImageCache>


DirModel::DirModel(QObject *parent)
    : KDirModel(parent)
    , m_thumbWidth(128)
    , m_thumbHeight(128)

{
    KMimeType::List mimeList = KMimeType::allMimeTypes();

    m_mimeTypes << "inode/directory";
    foreach (KMimeType::Ptr mime, mimeList) {
        if (mime->name().startsWith(QLatin1String("image/"))) {
            m_mimeTypes << mime->name();
        }
    }

    //TODO: configurable mime filter
    //dirLister()->setMimeFilter(m_mimeTypes);

    // Delayed mime detection
    dirLister()->setDelayedMimeTypes(true);

    QHash<int, QByteArray>roleNames;
    roleNames[Qt::DecorationRole] = "decoration";
    roleNames[KDirModel::Name]          = "Name";
//    roleNames[KDirModel::Size]          = "Size";
    roleNames[KDirModel::ModifiedTime]  = "ModifiedTime";
    roleNames[KDirModel::Permissions]   = "Permissions";
    roleNames[KDirModel::Owner]         = "Owner";
    roleNames[KDirModel::Group]         = "Group";
    roleNames[KDirModel::Type]          = "Type"; // Type == item.mimeComment() ... yeah, go figure that one out.
    roleNames[KDirModel::ColumnCount]   = "ColumnCount";
    roleNames[UrlRole]                  = "Url";
    roleNames[MimeTypeRole]             = "MimeType";
    roleNames[Thumbnail]                = "Thumbnail";
    roleNames[IconName]                 = "IconName";
    roleNames[BaseName]                 = "BaseName";
    roleNames[Extension]                = "Extension";
    roleNames[TimeString]               = "TimeString";
    setRoleNames(roleNames);

    //using the same cache of the engine, they index both by url
    m_imageCache = new KImageCache("porpoise_thumbnail_cache_2", 10485760);

    connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)),
            this, SIGNAL(countChanged()));
    connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)),
            this, SIGNAL(countChanged()));
    connect(this, SIGNAL(modelReset()),
            this, SIGNAL(countChanged()));
    connect(dirLister(), SIGNAL(newItems(KFileItemList)), this, SLOT(newItems(KFileItemList)));
}

DirModel::~DirModel()
{
}

int DirModel::columnCount(const QModelIndex &) const
{
    return ColumnCount;
}

QString DirModel::url() const
{
    return dirLister()->url().prettyUrl();
}

void DirModel::setThumbWidth(int thumbWidth)
{
    if(thumbWidth == m_thumbWidth) {
        return;
    }
    m_thumbWidth = thumbWidth;
    emit thumbWidthChanged();
}

void DirModel::setThumbHeight(int thumbHeight)
{
    if(thumbHeight == m_thumbHeight) {
        return;
    }
    m_thumbHeight = thumbHeight;
    emit thumbHeightChanged();
}

void DirModel::setUrl(const QString& url)
{
    KUrl incUrl(url);
    incUrl.adjustPath(KUrl::RemoveTrailingSlash);
    if (incUrl.isEmpty()) {
        return;
    }
    if (dirLister()->url() == incUrl) {
        return;
    }

    beginResetModel();
    dirLister()->openUrl(url);
    endResetModel();
    emit urlChanged();
}

int DirModel::indexForUrl(const QString &url) const
{
    QModelIndex index = KDirModel::indexForUrl(KUrl(url));
    return index.row();
}

QVariantMap DirModel::get(int i) const
{
    QModelIndex modelIndex = index(i, 0);

    KFileItem item = KDirModel::itemForIndex(modelIndex);
    QString url = item.url().prettyUrl();
    QString mimeType = item.mimetype();

    QVariantMap ret;
    ret.insert("isDir", QVariant(item.isDir()));
    ret.insert("url", QVariant(url));
    ret.insert("mimeType", QVariant(mimeType));

    return ret;
}

QObject* DirModel::itemForIndex(int i) const
{
    QModelIndex modelIndex = index(i, 0);
    FileItem* fItem = new FileItem(KDirModel::itemForIndex(modelIndex));
    return fItem;
}

void DirModel::run(int i) const
{
    QModelIndex modelIndex = index(i, 0);

    KFileItem item = KDirModel::itemForIndex(modelIndex);
    item.run();
}

void DirModel::reload()
{
    beginResetModel();
    dirLister()->openUrl(dirLister()->url(), KDirLister::Reload);
    endResetModel();
    emit urlChanged();
}

void DirModel::rebuildUrlToIndex()
{
    m_urlToIndex.clear();

    const int rows = rowCount();
    for(int i = 0; i < rows; ++i) {
        QModelIndex modelIndex = index(i, KDirModel::Name);
        KFileItem item = KDirModel::itemForIndex(modelIndex);
        m_urlToIndex.insert(item.url(), modelIndex);
    }
}

QVariant DirModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    switch (role){
    case UrlRole: {
        KFileItem item = KDirModel::itemForIndex(index);
        return item.url().prettyUrl();
    }
    case MimeTypeRole: {
        KFileItem item = KDirModel::itemForIndex(index);
        return item.mimetype();
    }
    case IconName: {
        KFileItem item = KDirModel::itemForIndex(index);
        return item.iconName();
    }
    case TimeString: {
        KFileItem item = KDirModel::itemForIndex(index);
        return item.timeString();
    }
    case BaseName: {
        KFileItem item = KDirModel::itemForIndex(index);
        if(item.isFile()) {
            QFileInfo fi(item.name());
            return fi.baseName();
        }
        return item.name();
    }
    case Extension: {
        KFileItem item = KDirModel::itemForIndex(index);
        if(item.isFile()) {
            QFileInfo fi(item.name());
            return "." + fi.suffix();
        }
        return QString();
    }
    case Qt::DecorationRole: {
        KFileItem item = KDirModel::itemForIndex(index);

        QPixmap preview;

        if (m_imageCache->findPixmap(item.url().prettyUrl(), &preview)) {
            return preview;
        } else {
            return item.iconName();
        }

    }
    default: {
        // Use the role as "column", then KDirModel will work with it's data(...) function.
        QModelIndex customIndex = KDirModel::index(index.row(), role);
        return KDirModel::data(customIndex, Qt::DisplayRole);
    }
    }
}

void DirModel::updatePreview(const KFileItem &item, const QPixmap &preview)
{
    QPersistentModelIndex index = m_urlToIndex.value(item.url());

    if (!index.isValid()) {
        return;
    }

    m_imageCache->insertPixmap(item.url().prettyUrl(), preview);
    setData(index, preview, Qt::DecorationRole);
}

void DirModel::previewFailed(const KFileItem &)
{
}


void DirModel::newItems(const KFileItemList &list)
{
    rebuildUrlToIndex();
    KIO::PreviewJob* job = new KIO::PreviewJob(list, QSize(thumbWidth(), thumbHeight()));

    job->setIgnoreMaximumSize(true);

    qDebug() << "Created job" << job;
    QObject::connect(job, SIGNAL(gotPreview(KFileItem,QPixmap)), this, SLOT(updatePreview(KFileItem,QPixmap)));
    QObject::connect(job, SIGNAL(failed(KFileItem)), this, SLOT(previewFailed(KFileItem)));
    QObject::connect(job, SIGNAL(result(KJob*)), this, SLOT(result(KJob*)));
}

void DirModel::result(KJob *)
{
    qDebug() << "Result....";
}
