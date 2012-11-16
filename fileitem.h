#ifndef FILEITEM_H
#define FILEITEM_H

#include <QObject>
#include <KFileItem>

class FileItem : public QObject, public KFileItem
{
    Q_OBJECT
    Q_PROPERTY(bool isLink READ isLink CONSTANT)
    Q_PROPERTY(bool isDir READ isDir CONSTANT)
    Q_PROPERTY(bool isFile READ isFile CONSTANT)
    Q_PROPERTY(bool isReadable READ isReadable CONSTANT)
    Q_PROPERTY(bool isWritable READ isWritable CONSTANT)
    Q_PROPERTY(bool isHidden READ isHidden CONSTANT)
    Q_PROPERTY(bool isSlow READ isSlow CONSTANT)
    Q_PROPERTY(bool isDesktopFile READ isDesktopFile CONSTANT)
    Q_PROPERTY(bool isMarked READ isMarked CONSTANT)
    Q_PROPERTY(bool isRegularFile READ isRegularFile CONSTANT)
    Q_PROPERTY(qulonglong size READ size CONSTANT)
    Q_PROPERTY(QString url READ url CONSTANT)
    Q_PROPERTY(QString mimetype READ mimetype CONSTANT)
    Q_PROPERTY(QString user READ user CONSTANT)
    Q_PROPERTY(QString group READ group CONSTANT)
    Q_PROPERTY(QString text READ text CONSTANT)
    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString iconName READ iconName CONSTANT)
    Q_PROPERTY(QString comment READ comment CONSTANT)
    Q_PROPERTY(QStringList overlays READ overlays CONSTANT)

public:
    explicit FileItem(const KFileItem& parent)
       : KFileItem(parent)
    {
    }
    
    QString url() { return KFileItem::url().prettyUrl(); }

signals:
    
public slots:
    void run() { KFileItem::run(); }
};

#endif // FILEITEM_H
