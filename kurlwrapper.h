#ifndef KURLWRAPPER_H
#define KURLWRAPPER_H

#include <QDeclarativeItem>
#include "pathmodel.h"
#include "util.h"
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
    Q_PROPERTY(QChar seperator READ separator)
    Q_PROPERTY(QObject* pathModel READ pathModel CONSTANT)

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
    PathModel* pathModel() { return m_pathModel; }
    Q_INVOKABLE int rowCount() { return m_pathModel->rowCount(); }
    Q_INVOKABLE void append(QString entry);

    // Convenient function that returns the separator.
    QChar separator() { return m_separator; }

    // This function gets called from QML. It will update the m_pathStringList
    // to the index passed to this function. It basically reconstructs the URL till this index and calls setUrl.
    Q_INVOKABLE void updateUrlBasedOnIndex(int index);

    // Calling this will update the path model till a given index.
    Q_INVOKABLE void updateUrlModel(int index);

    // This returns the current URL till the given index.
    Q_INVOKABLE QString urlTillIndex(int index);

private:
    void updatePathModel();
    void updateUrlPath();
    
signals:
    void urlChanged();
    void pathModelChanged();
    
public slots:
    
private:
    KUrl m_url;
    QChar m_separator;
    Util* m_util;
    PathModel* m_pathModel;
};

#endif // KURLWRAPPER_H
