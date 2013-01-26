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
#include "util.h"

#include <QFileInfo>
#include <QVariant>
#include <KDirLister>
#include <KDebug>

#include <KImageCache>


class DirModelPrivate
{
public:
    DirModelPrivate( DirModel* model )
        : q(model)
        , m_urlToIndex()
    {
    }
    ~DirModelPrivate()
    {
    }

    void rebuildUrlToIndex();

    DirModel* q;
    QHash<KUrl, QPersistentModelIndex> m_urlToIndex;
};



DirModel::DirModel(QObject *parent)
    : KDirModel(parent)
    , d(new DirModelPrivate(this))
    , m_previewJobs()

{
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
    roleNames[IconName]                 = "IconName";
    roleNames[BaseName]                 = "BaseName";
    roleNames[Extension]                = "Extension";
    roleNames[TimeString]               = "TimeString";
    roleNames[MimeOrThumb]              = "MimeOrThumb";
    setRoleNames(roleNames);

    //using the same cache of the engine, they index both by url
    m_imageCache = Util::instance()->imageCache();

    connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)),
            this, SIGNAL(countChanged()));
    connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)),
            this, SIGNAL(countChanged()));
    connect(this, SIGNAL(modelReset()),
            this, SIGNAL(countChanged()));
    connect(dirLister(), SIGNAL(newItems(KFileItemList)), this, SLOT(newItems(KFileItemList)));
    connect(dirLister(), SIGNAL(completed()), this, SLOT(listenerCompleted()));
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

    emit killCurrentJobs();
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

QObject* DirModel::itemForIndex(int i) const
{
    QModelIndex modelIndex = index(i, 0);
    FileItem* fItem = new FileItem(KDirModel::itemForIndex(modelIndex));
    return fItem;
}

void DirModel::reload()
{
    emit killCurrentJobs();
    beginResetModel();
    dirLister()->openUrl(dirLister()->url(), KDirLister::Reload);
    endResetModel();
    emit urlChanged();
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
    case MimeOrThumb: {
        KFileItem item = KDirModel::itemForIndex(index);
        if(m_imageCache->contains(item.url().prettyUrl())) {
            return item.url().prettyUrl().prepend("image://thumb/");
        } else {
            // Somehow it needs to fill a list or queue or whatever that builds the thumbnails.
            // TODO i guess..
            return item.iconName().prepend("image://mime/");
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
    QPersistentModelIndex index = d->m_urlToIndex.value(item.url());

    if (!index.isValid()) {
        return;
    }

    m_imageCache->insertPixmap(item.url().prettyUrl(), preview);
    setData(index, preview, Qt::DecorationRole);
}

void DirModel::newItems(const KFileItemList &list)
{
    KFileItemList listToUpdate;
    foreach(const KFileItem& item, list) {
        if(!m_imageCache->contains(item.url().prettyUrl())) {
            listToUpdate << item;
        }
    }

    if(listToUpdate.count() > 0) {
        // this size part should be resolved in another way.
        KIO::PreviewJob* job = new KIO::PreviewJob(list, QSize(256, 256));

        job->setIgnoreMaximumSize(true);

        QObject::connect(job, SIGNAL(gotPreview(KFileItem,QPixmap)), this, SLOT(updatePreview(KFileItem,QPixmap)));
        QObject::connect(this, SIGNAL(killCurrentJobs()), job, SLOT(kill()));
    }
}

void DirModel::listenerCompleted()
{
    // We need a KUrl -> QPersistentModelIndex index which isn't there by default. Create it for relative fast lookup.
    // The index is used to update the preview once it comes in from the PreviewJob.
    d->rebuildUrlToIndex();

    qDebug() << "DirModel::listenerCompleted Listener finished.......";
}


void DirModelPrivate::rebuildUrlToIndex()
{
    m_urlToIndex.clear();

    KDirModel* temp = q;

    const int rows = q->rowCount();
    for(int i = 0; i < rows; ++i) {
        QModelIndex modelIndex = q->index(i, KDirModel::Name);

        KFileItem item = temp->itemForIndex(modelIndex);
        m_urlToIndex.insert(item.url(), modelIndex);
    }
}
