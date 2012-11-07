#ifndef KURLWRAPPER_H
#define KURLWRAPPER_H

#include <QDeclarativeItem>
#include <QString>
#include <QDir>
#include <KUrl>

class KUrlWrapper : public QDeclarativeItem
{
    Q_OBJECT

    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString path READ path NOTIFY urlChanged)
    Q_PROPERTY(QString host READ host NOTIFY urlChanged)
    Q_PROPERTY(int port READ port NOTIFY urlChanged)
    Q_PROPERTY(QString protocol READ protocol NOTIFY urlChanged)
    Q_PROPERTY(QStringList pathModel READ pathModel NOTIFY urlModelChanged)
    Q_PROPERTY(QChar seperator READ separator)

public:
    explicit KUrlWrapper(QDeclarativeItem *parent = 0);

    // URL
    QString url(); // returns KUrl::path()
    void setUrl(const QString& url);

    // path, host and port
    QString path() { return m_url.path(); }
    QString host() { return m_url.host(); }
    int port() { return m_url.port(); }

    // protocol
    QString protocol() { return m_url.protocol(); }

    // URL list model (QStringList). Splits the url by derectory seperator.
    QStringList pathModel() { return m_pathStringList; }

    // Convenient function that returns the separator.
    QChar separator() { return m_separator; }

private:
    void updateUrlModel();
    
signals:
    void urlChanged();
    void urlModelChanged();
    
public slots:
    
private:
    KUrl m_url;
    QChar m_separator;
    QStringList m_pathStringList;
};

#endif // KURLWRAPPER_H
