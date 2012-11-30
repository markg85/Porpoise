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
    , m_xOffset(0)
    , m_yOffset(0)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
}


void KGraphicsItem::setIcon(const QVariant &icon)
{
    QSize imageSize = QSize(width(), height());
    if(icon.canConvert<QIcon>()) {
        m_icon = icon.value<QIcon>();
        imageSize = m_icon.actualSize(imageSize);
        m_pixmap = m_icon.pixmap(imageSize);
    } else if(icon.canConvert<QString>()) {
        m_icon = KIcon(icon.toString());
        imageSize = m_icon.actualSize(imageSize);
        m_pixmap = m_icon.pixmap(imageSize);
    } else if(icon.canConvert<QPixmap>()) {
        m_pixmap = icon.value<QPixmap>().scaled(imageSize, Qt::KeepAspectRatio);
        imageSize = m_pixmap.size();
    } else if(icon.canConvert<QImage>()) {
        m_pixmap = QPixmap::fromImage(icon.value<QImage>().scaled(imageSize, Qt::KeepAspectRatio));
        imageSize = m_pixmap.size();
    }

    QDeclarativeItem::setImplicitHeight(imageSize.height());
    QDeclarativeItem::setImplicitWidth(imageSize.width());

    // Calculate offsets. They (one or both) or > 0 if the source image is smaller then the rectangle in which they are painted.
    m_xOffset = (width() - m_pixmap.width()) / 2;
    m_yOffset = (height() - m_pixmap.height()) / 2;

    /*
    qDebug() << "----------------------------------------------------------";
    qDebug() << "m_xOffset:" << m_xOffset;
    qDebug() << "m_yOffset:" << m_yOffset;
    qDebug() << "i width:" << width();
    qDebug() << "i height:" << height();
    qDebug() << "p width:" << m_pixmap.width();
    qDebug() << "p height:" << m_pixmap.height();
    qDebug() << "----------------------------------------------------------";
    */

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

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing, m_smooth);
    painter->setRenderHint(QPainter::SmoothPixmapTransform, m_smooth);
    painter->drawPixmap(m_xOffset, m_yOffset, m_pixmap);
    painter->restore();
}
