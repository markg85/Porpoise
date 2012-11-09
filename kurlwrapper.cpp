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
    return m_url.path();
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
    m_pathModel->setData(m_pathModel->index(rowCount()- 1), entry);
    updateUrlPath();
}

void KUrlWrapper::updateUrlBasedOnIndex(int index)
{
    if(index == (m_pathModel->rowCount() - 1))
    {
        return;
    }

    int rowsToRemove = -1 + m_pathModel->rowCount() - index;
    m_pathModel->removeRows(index + 1, rowsToRemove);
    updateUrlPath();
}

void KUrlWrapper::updatePathModel()
{
//    m_pathModel = path().split(separator(), QString::SkipEmptyParts);
    m_pathModel->setStringList(path().split(separator(), QString::SkipEmptyParts));

//    qDebug() << m_pathModel->stringList();

    //    emit pathModelChanged();
}

void KUrlWrapper::updateUrlPath()
{
    m_url.setPath(m_pathModel->stringList().join(QString(separator())));
}
