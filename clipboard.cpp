#include "clipboard.h"
#include <QApplication>
#include <QMimeData>
#include <QDebug>
#include <KUrl>
#include <kio/copyjob.h>
#include <kio/fileundomanager.h>

Clipboard::Clipboard(QObject *parent)
    : QObject(parent)
    , m_clipboard(QApplication::clipboard())
    , m_urlList()
{
    connect(m_clipboard, SIGNAL(dataChanged()), this, SLOT(dataChanged()));
}

void Clipboard::paste(QString url)
{
    KUrl destUrl(url);

    if(!m_clipboard->mimeData()->hasUrls()) {
        return;
    }

    KUrl::List urlsSource(m_clipboard->mimeData()->urls());

    //Whatever m_cut was set to, we want the real new value from the mimedata object.
    if(m_clipboard->mimeData()->hasFormat("application/x-kde-cutselection")) {
        m_cut = true;
    } else {
        m_cut = false;
    }

    KIO::CopyJob* job;
    if (m_cut) {
        job = KIO::move(urlsSource, destUrl);
    } else {
        job = KIO::copy(urlsSource, destUrl);
    }

    KIO::FileUndoManager::self()->recordCopyJob(job);
}

QString Clipboard::text()
{
    return m_clipboard->text();
}

void Clipboard::cut()
{
    if(m_urlList.count() > 0) {

        // Fill a mimeData object
        QMimeData* mimeData = new QMimeData();
        KUrl::List urls(m_urlList);
        mimeData->setData("application/x-kde-cutselection", QByteArray("1"));
        mimeData->setUrls(urls);

        // Let the clipboard know of our mimeData object
        m_clipboard->setMimeData(mimeData);

        // At this point the clipboard stuff is over. Clear the urllist.
        m_urlList.clear();
    }
}

void Clipboard::copy()
{
    if(m_urlList.count() > 0) {

        // Fill a mimeData object
        QMimeData* mimeData = new QMimeData();
        KUrl::List urls(m_urlList);
        mimeData->setUrls(urls);

        // Let the clipboard know of our mimeData object
        m_clipboard->setMimeData(mimeData);

        // At this point the clipboard stuff is over. Clear the urllist.
        m_urlList.clear();
    }
}

void Clipboard::copy(QString text)
{
    // Fill a mimeData object
    QMimeData* mimeData = new QMimeData();
    mimeData->setText(text);

    // Let the clipboard know of our mimeData object
    m_clipboard->setMimeData(mimeData);
}

void Clipboard::dataChanged()
{
    bool oldCutState = m_cut;
    if(m_clipboard->mimeData()->hasFormat("application/x-kde-cutselection")) {
        m_cut = true;
    } else {
        m_cut = false;
    }

    if(oldCutState != m_cut) {
        emit cutChanged();
    }
}
