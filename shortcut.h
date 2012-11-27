#ifndef SHORTCUT_H
#define SHORTCUT_H

#include <QShortcut>
#include <QKeySequence>
#include <QDeclarativeItem>
#include <QDebug>

class Shortcut : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(int key READ key WRITE setKey)
public:
    explicit Shortcut(QDeclarativeItem *parent = 0);
    void setKey(int key) {
        m_shortcut->setKey(QKeySequence(key));

        qDebug() << "(C++) Key set:" << m_shortcut->key();
    }
    int key() { return m_shortcut->key(); }
    
signals:
    void activated();
    
public slots:

private:
    QShortcut* m_shortcut;
    
};

#endif // SHORTCUT_H
