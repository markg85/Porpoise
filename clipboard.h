#ifndef CLIPBOARD_H
#define CLIPBOARD_H

#include <QObject>
#include <QClipboard>
#include <QStringList>

class Clipboard : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool cut READ cutState NOTIFY cutChanged)
public:
    explicit Clipboard(QObject *parent = 0);
    bool cutState() { return m_cut; }

    Q_INVOKABLE void paste(QString url);
    Q_INVOKABLE QString text();
    Q_INVOKABLE void cut();

    /**
     * Normally you "should" provide a urllist here. That isn't possible due to QML limitations
     * so we have to work around that. Fill a stringlist with urls using the function addUrl()
     * from this object in QML. Once the urls are filled, execute this function.
     */
    Q_INVOKABLE void copy();

    /**
     * This is just to put text on the clipboard.
     */
    Q_INVOKABLE void copy(QString text);

    /**
     * Yeah, our workaround function.. It is better in Qt 5 since arrays in properties work
     * properly there.
     */
    Q_INVOKABLE QStringList urlList() { return m_urlList; }
    Q_INVOKABLE void addUrl(QString url) { m_urlList.append(url); }
    
signals:
    void cutChanged();
    
public slots:
    void dataChanged();
    
private:
    QClipboard* m_clipboard;
    bool m_cut;
    QStringList m_urlList; // Required for Qt 4.8 since it can't properly define arrays. It can in JS, not in property ...
};

#endif // CLIPBOARD_H
