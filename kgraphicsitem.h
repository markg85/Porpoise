#ifndef KGRAPHICSITEM_H
#define KGRAPHICSITEM_H

#include <QDeclarativeItem>

class KGraphicsItem : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QVariant icon READ icon WRITE setIcon)
    Q_PROPERTY(bool smooth READ smooth WRITE setSmooth)
    Q_PROPERTY(int implicitWidth READ implicitWidth CONSTANT)
    Q_PROPERTY(int implicitHeight READ implicitHeight CONSTANT)
    Q_PROPERTY(State state READ state WRITE setState NOTIFY stateChanged)

    Q_ENUMS(State)

public:
    enum State {
        DefaultState, ///The default state.
        ActiveState, ///Icon is active.
        DisabledState ///Icon is disabled.
    };

    KGraphicsItem(QDeclarativeItem *parent=0);
    ~KGraphicsItem();

    void setIcon(const QVariant &icon);
    QIcon icon() const;

    KGraphicsItem::State state() const;
    void setState(State state);

    void setSmooth(const bool smooth);
    bool smooth() const;

    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

Q_SIGNALS:
    void stateChanged(State state);

private:
    QIcon m_icon;
    bool m_smooth;
    State m_state;
    QPixmap m_pixmap;
    int m_xOffset;
    int m_yOffset;
};

#endif // KGRAPHICSITEM_H
