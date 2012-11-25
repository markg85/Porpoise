#ifndef KURLUNDOREDO_H
#define KURLUNDOREDO_H

#include <QDeclarativeItem>
#include <QStringList>

class KUrlUndoRedo : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QString currentUrl READ currentUrl NOTIFY countChanged)
    Q_PROPERTY(int currentUrlIndex READ currentUrlIndex NOTIFY countChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    explicit KUrlUndoRedo(QDeclarativeItem *parent = 0);
    Q_INVOKABLE void addUrl(const QString& url);
    Q_INVOKABLE void nextUrl();
    Q_INVOKABLE void previousUrl();

    QString currentUrl();
    int currentUrlIndex();
    int count();
    
signals:
    void currentUrlChanged();
    void countChanged();
    
public slots:
    
private:
    QStringList m_urls;
    int m_currentUrlIndex;
};

#endif // KURLUNDOREDO_H
