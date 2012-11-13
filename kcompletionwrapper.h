#ifndef KCOMPLETIONWRAPPER_H
#define KCOMPLETIONWRAPPER_H

#include <QDeclarativeItem>
#include <KCompletion>
#include <KUrl>
#include <kio/global.h>
#include <kio/job.h>

class KCompletionWrapper : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QStringList results READ results NOTIFY resultsChanged)

public:
    explicit KCompletionWrapper(QDeclarativeItem *parent = 0);
    
    QStringList results() { return m_matches; }

    Q_INVOKABLE void setUrl(const QString& url);
    Q_INVOKABLE QString previousMatch();
    Q_INVOKABLE QString nextMatch();

private:
    void attemptFetchNewCompletionStrings();

signals:
    void resultsChanged();
    
public slots:

private slots:
    void storeFolderEntries(KIO::Job * job, const KIO::UDSEntryList &list);
    void jobResults(KJob * job);
    void storeMatches(QString);
    
private:
    QString m_url;
    QString m_urlTillLastSlash;
    QString m_searchString;
    KCompletion m_completion;
    QStringList* m_entryList;
    QStringList* m_hiddenEntryList;
    QStringList m_matches;
    int m_internalListIndex;
};

#endif // KCOMPLETIONWRAPPER_H
