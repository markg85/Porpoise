#include "kcompletionwrapper.h"

#include <QDebug>

KCompletionWrapper::KCompletionWrapper(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
    , m_url()
    , m_urlTillLastSlash()
    , m_searchString()
    , m_completion()
    , m_entryList(new QStringList())
    , m_hiddenEntryList(new QStringList())
    , m_matches()
    , m_internalListIndex(-1)
{
    m_completion.setIgnoreCase(true);
    QObject::connect(&m_completion, SIGNAL(match(QString)), this, SLOT(storeMatches(QString)));
}

void KCompletionWrapper::setUrl(const QString &url)
{
    qDebug() << "(C++) setUrl()";
    m_url = url;

    int lastSlashPosition = m_url.lastIndexOf('/');
    QString urlTillLastSlash = m_url.left(lastSlashPosition + 1);
    m_searchString = m_url.right(-1 + m_url.length() - lastSlashPosition);

    qDebug() << "(C++) Search String:" << m_searchString;

    if(m_url.length() >= 2 && m_url.endsWith("//"))
    {
        // The user is typing slashes. We only call KIO on the first slash entered. If the user types multiple then just ignore.
        return;
    }

    if(m_urlTillLastSlash != urlTillLastSlash || m_url.endsWith('/'))
    {
        m_urlTillLastSlash = urlTillLastSlash;
        attemptFetchNewCompletionStrings();
    }

    if(m_searchString.startsWith("."))
    {
        m_completion.insertItems(*m_hiddenEntryList);
    }

    m_completion.makeCompletion(m_searchString);
}

// Returns an entry from bottom to top till m_internalListIndex = 0. Then resets itself to the last entry again.
QString KCompletionWrapper::previousMatch()
{
    qDebug() << "(C++) previousMatch()";
    m_internalListIndex--;
    if(m_searchString.isEmpty() && m_matches.isEmpty() && !m_entryList->isEmpty())
    {
        // If the m_internalListIndex is not set before (so -1) then set it to the last item in this list
        if(m_internalListIndex == -1 || m_internalListIndex >= m_entryList->count())
        {
           m_internalListIndex = m_entryList->count() - 1;
        }

        // Return an entry from m_entryList
        return m_entryList->at(m_internalListIndex);
    }
    else if(!m_matches.isEmpty())
    {
        // If the m_internalListIndex is not set before (so -1) then set it to the last item in this list
        if(m_internalListIndex == -1 || m_internalListIndex >= m_matches.count())
        {
           m_internalListIndex = m_matches.count() - 1;
        }

        // Return an entry from m_matches
        return m_matches.at(m_internalListIndex);
    }
    else
    {
        return QString();
    }
}

// Returns an entry from top to top till m_internalListIndex = list size. Then resets itself to the first entry again.
QString KCompletionWrapper::nextMatch()
{
    qDebug() << "(C++) nextMatch()";
    m_internalListIndex++;
    if(m_searchString.isEmpty() && m_matches.isEmpty() && !m_entryList->isEmpty())
    {
        // If the m_internalListIndex is not set before (so -1) then set it to the last item in this list
        if(m_internalListIndex == -1 || m_internalListIndex >= m_entryList->count())
        {
           m_internalListIndex = 0;
        }

        // Return an entry from m_entryList
        return m_entryList->at(m_internalListIndex);
    }
    else if(!m_matches.isEmpty())
    {
        // If the m_internalListIndex is not set before (so -1) then set it to the last item in this list
        if(m_internalListIndex == -1 || m_internalListIndex >= m_matches.count())
        {
           m_internalListIndex = 0;
        }

        // Return an entry from m_matches
        return m_matches.at(m_internalListIndex);
    }
    else
    {
        return QString();
    }
}

void KCompletionWrapper::attemptFetchNewCompletionStrings()
{
    m_internalListIndex = -1;

    KIO::ListJob* job = KIO::listDir(KUrl(m_urlTillLastSlash));
    job->addMetaData("details", "0");
    qDebug() << "(C++) URL send to KIO:" << m_urlTillLastSlash;
    qDebug() << "(C++) m_job:" << job;
    qDebug() << "(C++) cleared entry lists";
    m_entryList->clear();
    m_hiddenEntryList->clear();
    m_completion.clear();

    if(m_matches.count() > 0)
    {
        qDebug() << "(C++) cleared m_matches";
        m_matches.clear();
        emit resultsChanged();
    }

    job->connect(job, SIGNAL(entries(KIO::Job*, KIO::UDSEntryList)), this, SLOT(storeFolderEntries(KIO::Job*, KIO::UDSEntryList)));

    // Apparently it is possible that the listDir for the home folder returns TWICE! Thus storeFolderEntries. However, the result is only
    // emited once so i just use the result to indicate that the entries are in and can be send to QML.
    job->connect(job, SIGNAL(result(KJob*)), this, SLOT(jobResults(KJob*)));
}

void KCompletionWrapper::storeFolderEntries(KIO::Job *job, const KIO::UDSEntryList &list)
{
    Q_UNUSED(job)
    KIO::SimpleJob* simpleJob = qobject_cast<KIO::SimpleJob *>(job);
    qDebug() << "------------------------------------------------------------------------------";
    qDebug() << "(C++) storeFolderEntries() ------------- SLOT FROM entries EMIT -------------" << simpleJob->url() << "job:" << job;
    qDebug() << "------------------------------------------------------------------------------";

    foreach(const KIO::UDSEntry& entry, list)
    {
        if(entry.isDir() && (entry.stringValue(KIO::UDSEntry::UDS_NAME) != "." && entry.stringValue(KIO::UDSEntry::UDS_NAME) != ".."))
        {
            if(entry.stringValue(KIO::UDSEntry::UDS_NAME).startsWith("."))
            {
                *m_hiddenEntryList << entry.stringValue(KIO::UDSEntry::UDS_NAME);
            }
            else
            {
                *m_entryList << entry.stringValue(KIO::UDSEntry::UDS_NAME);
            }
        }
    }
}

void KCompletionWrapper::jobResults(KJob *job)
{
    qDebug() << "(C++) jobResults()";
    Q_UNUSED(job)
    m_completion.setItems(*m_entryList);
    if(m_completion.makeCompletion(m_searchString).isEmpty())
    {
        m_matches = *m_entryList;
        emit resultsChanged();
    }
}

void KCompletionWrapper::storeMatches(QString)
{
    qDebug() << "(C++) storeMatches QString";
    m_matches = m_completion.allMatches();
    m_internalListIndex = -1;

    emit resultsChanged();
}
