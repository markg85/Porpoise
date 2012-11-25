#include "kurlwrapper.h"
#include <QDebug>
#include <KUriFilter>

KUrlWrapper::KUrlWrapper(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
    , m_url()
    , m_separator(QDir::separator())
    , m_util(Util::instance())
    , m_pathModel(m_util->pathModel())
{
}

QString KUrlWrapper::url()
{
    return m_url.url();
}

void KUrlWrapper::setUrl(const QString &url)
{
    KUrl newUrl(KUriFilter::self()->filteredUri(url));

    // Update the url with the newly given one
    if(m_url != newUrl)
    {
        m_url = newUrl;
        m_url.cleanPath();
        emit urlChanged();

        // New url is set, update the model as well.
        updatePathModel();
        qDebug() << "(C++) New URL has been set";
    }

    qDebug() << "(C++) URL:" << m_url;

}

void KUrlWrapper::append(QString entry)
{
    m_pathModel->setData(m_pathModel->index(rowCount() - 1), entry);
    updateUrlPath();
}

void KUrlWrapper::updateUrlBasedOnIndex(int index)
{
    int newIndex = index + 1;
    QStringList currentPath = m_pathModel->stringList();
    while (currentPath.count() > newIndex) {
        currentPath.removeLast();
    }

    m_url.setPath(separator() + currentPath.join(QString(separator())));
    emit urlChanged();
}

void KUrlWrapper::updateUrlModel(int index)
{
    int rowsToRemove = -1 + m_pathModel->rowCount() - index;
    m_pathModel->removeRows(index + 1, rowsToRemove);
}

QString KUrlWrapper::urlTillIndex(int index)
{
    qDebug() << "(C++) urlTillIndex()";
    index++;
    QStringList currentList = m_pathModel->stringList();

    if(index >= currentList.count())
    {
        return QString();
    }

    while(currentList.count() > index)
    {
        currentList.removeLast();
    }

    KUrl newUrl = m_url;
    newUrl.setPath(separator() + currentList.join(QString(separator())) + separator());

    return newUrl.url();
}

void KUrlWrapper::updatePathModel()
{
    m_pathModel->setStringList(path().split(separator(), QString::SkipEmptyParts));
}

void KUrlWrapper::updateUrlPath()
{
    m_url.setPath(separator() + m_pathModel->stringList().join(QString(separator())));
}
