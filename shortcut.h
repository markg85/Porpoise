#ifndef SHORTCUT_H
#define SHORTCUT_H

#include <QDeclarativeItem>
#include <QDebug>

class Shortcut : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(int key READ key WRITE setKey)
public:
    explicit Shortcut(QDeclarativeItem *parent = 0);

    void setKey(int key);
    int key() { return m_keySequence; }

    bool eventFilter(QObject *obj, QEvent *e);
    
signals:
    void activated();
    
public slots:

private:
    QKeySequence m_keySequence;
};

#endif // SHORTCUT_H
