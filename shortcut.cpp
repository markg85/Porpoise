#include "shortcut.h"

#include <QWidget>
#include "util.h"

Shortcut::Shortcut(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
    m_shortcut = new QShortcut(Util::instance()->mainWindow());
    QObject::connect(m_shortcut, SIGNAL(activated()), this, SIGNAL(activated()));
}
