#include "shortcut.h"
#include <QKeyEvent>
#include <QApplication>
#include <QDebug>

Shortcut::Shortcut(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
    , m_keySequence()
{
    qApp->installEventFilter(this);
}

void Shortcut::setKey(QVariant key)
{
    if(key.canConvert<QKeySequence>()) {
        m_keySequence = key.value<QKeySequence>();
    } else {
        m_keySequence = QKeySequence();
    }
}

bool Shortcut::eventFilter(QObject *obj, QEvent *e)
{
    if(!m_keySequence.isEmpty()) {
        QKeyEvent *keyEvent = static_cast<QKeyEvent*>(e);

        // Just mod keys is not enough for a shortcut, block them just by returning.
        if (keyEvent->key() >= Qt::Key_Shift && keyEvent->key() <= Qt::Key_Alt) {
            return QObject::eventFilter(obj, e);
        }

        int keyInt = keyEvent->modifiers() + keyEvent->key();

        if(e->type() == QEvent::KeyPress && QKeySequence(keyInt).matches(m_keySequence)) {
            emit activated();
        }
    }

    return QObject::eventFilter(obj, e);
}
