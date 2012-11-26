#include "kurlundoredo.h"
#include <QDebug>

KUrlUndoRedo::KUrlUndoRedo(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
{
}

void KUrlUndoRedo::addUrl(const QString &url)
{
    // Only remove the item after the m_currentUrlIndex
    if(m_currentUrlIndex < (m_urls.count() - 1)) {
        while((m_urls.count() - 1) > m_currentUrlIndex)
        {
            m_urls.removeLast();
        }
    }

    // Append new item
    if(!url.isEmpty()) {
        m_urls.append(url);
        m_currentUrlIndex = m_urls.count() - 1;
        emit countChanged();
    }
}

void KUrlUndoRedo::nextUrl()
{
    if((m_currentUrlIndex + 1) < m_urls.count()) {
        ++m_currentUrlIndex;
        emit countChanged();
        emit currentUrlChanged();
    }
}

void KUrlUndoRedo::previousUrl()
{
    if((m_currentUrlIndex - 1) < m_urls.count() && (m_currentUrlIndex - 1) >= 0) {
        --m_currentUrlIndex;
        emit countChanged();
        emit currentUrlChanged();
    }
}

QString KUrlUndoRedo::currentUrl()
{
    return m_urls.at(m_currentUrlIndex);
}

int KUrlUndoRedo::currentUrlIndex()
{
    return m_currentUrlIndex;
}

int KUrlUndoRedo::count()
{
    return m_urls.count();
}
