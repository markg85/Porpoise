#ifndef PATHMODEL_H
#define PATHMODEL_H

#include <QStringListModel>

class PathModel : public QStringListModel
{
public:
    explicit PathModel(QObject *parent = 0);
};

Q_DECLARE_METATYPE(PathModel*)
#endif // PATHMODEL_H
