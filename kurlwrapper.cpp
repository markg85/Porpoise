#include "kurlwrapper.h"
#include <QDebug>
#include <KUriFilter>

KUrlWrapper::KUrlWrapper(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
    , m_url()
    , m_separator(QDir::separator())
    , m_pathStringList()
{
}

QString KUrlWrapper::url()
{
    return m_url.path();
}

void KUrlWrapper::setUrl(const QString &url)
{
    // Update the url with the newly given one
    m_url = KUriFilter::self()->filteredUri(url);
    m_url.cleanPath();
    emit urlChanged();

    // New url is set, update the model as well.
    updateUrlModel();

    qDebug() << "(C++) URL:" << m_url;
}

void KUrlWrapper::updateUrlModel()
{
    m_pathStringList = path().split(separator(), QString::SkipEmptyParts);
    emit urlModelChanged();
}
