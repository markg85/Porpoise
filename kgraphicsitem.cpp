#include "kgraphicsitem.h"
#include <KIcon>
#include <KIconLoader>
#include <KIconEffect>
#include <QPainter>
#include <QDebug>

KGraphicsItem::KGraphicsItem(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
    , m_smooth(false)
    , m_state(DefaultState)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
}


void KGraphicsItem::setIcon(const QVariant &icon)
{
    if(icon.canConvert<QIcon>()) {
        m_icon = icon.value<QIcon>();
        m_pixmap = m_icon.pixmap(QSize(width(), height()));
    } else if(icon.canConvert<QString>()) {
        m_icon = KIcon(icon.toString());
        m_pixmap = m_icon.pixmap(QSize(width(), height()));
    } else if(icon.canConvert<QPixmap>()) {
        m_pixmap = icon.value<QPixmap>().scaled(QSize(width(), height()), Qt::KeepAspectRatio);;
    } else if(icon.canConvert<QImage>()) {
        m_pixmap = QPixmap::fromImage(icon.value<QImage>().scaled(QSize(width(), height()), Qt::KeepAspectRatio));
    }
    update();
}

KGraphicsItem::~KGraphicsItem()
{
}

QIcon KGraphicsItem::icon() const
{
    return m_icon;
}

KGraphicsItem::State KGraphicsItem::state() const
{
    return m_state;
}

void KGraphicsItem::setState(KGraphicsItem::State state)
{
    if (m_state == state) {
        return;
    }

    m_state = state;
    emit stateChanged(state);
    update();
}

int KGraphicsItem::implicitWidth() const
{
    return KIconLoader::global()->currentSize(KIconLoader::Desktop);
}

int KGraphicsItem::implicitHeight() const
{
    return KIconLoader::global()->currentSize(KIconLoader::Desktop);
}

void KGraphicsItem::setSmooth(const bool smooth)
{
    if (smooth == m_smooth) {
        return;
    }
    m_smooth = smooth;
    update();
}

bool KGraphicsItem::smooth() const
{
    return m_smooth;
}

void KGraphicsItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option);
    Q_UNUSED(widget);

    if (m_pixmap.isNull()) {
        return;
    }

//    QPixmap scaledPixmap = m_pixmap.scaled(QSize(width(), height()), Qt::KeepAspectRatio);

    //do without painter save, faster and the support can be compiled out
    const bool wasAntiAlias = painter->testRenderHint(QPainter::Antialiasing);
    const bool wasSmoothTransform = painter->testRenderHint(QPainter::SmoothPixmapTransform);
    painter->setRenderHint(QPainter::Antialiasing, m_smooth);
    painter->setRenderHint(QPainter::SmoothPixmapTransform, m_smooth);

//    if (m_state == ActiveState) {
//        QPixmap result = m_pixmap.pixmap(boundingRect().size().toSize());
//        result = KIconLoader::global()->iconEffect()->apply(result, KIconLoader::Desktop, KIconLoader::ActiveState);
//        painter->drawPixmap(boundingRect().toRect(), m_pixmap);
//    } else {
//        m_pixmap.paint(painter, boundingRect().toRect(), Qt::AlignCenter, isEnabled() ? QIcon::Normal : QIcon::Disabled);
//        painter->drawPixmap(boundingRect().toRect(), m_pixmap);
//    }

    int xOffset = (width() - m_pixmap.width()) / 2;
    int yOffset = (height() - m_pixmap.height()) / 2;

    painter->drawPixmap(xOffset, yOffset, m_pixmap);

    painter->setRenderHint(QPainter::Antialiasing, wasAntiAlias);
    painter->setRenderHint(QPainter::SmoothPixmapTransform, wasSmoothTransform);
}
