#include "shortcut.h"
#include <QKeyEvent>
#include <QApplication>

Shortcut::Shortcut(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
    , m_keySequence()
{
    qApp->installEventFilter(this);
}

void Shortcut::setKey(int key)
{
//    if(key.canConvert<QString>()) {
//        m_keySequence = key.value<QString>();
//    } else if(key.canConvert<int>()) {
//        m_keySequence = key.value<int>();
//    } else if(key.canConvert<QKeySequence>()) {
//        m_keySequence = key.value<QKeySequence>();
//    } else {
//        m_keySequence = QKeySequence();
//    }

    m_keySequence = QKeySequence(key);

    qDebug() << "(C++) Key set:" << m_keySequence;
}

bool Shortcut::eventFilter(QObject *obj, QEvent *e)
{
    if(!m_keySequence.isEmpty() && e->type() == QEvent::KeyPress) {
        QKeyEvent *keyEvent = static_cast<QKeyEvent*>(e);
        if(keyEvent->key() == m_keySequence) {
            emit activated();
        }
    }
    return QObject::eventFilter(obj, e);
}
