#include "pathmodel.h"

PathModel::PathModel(QObject *parent)
    : QStringListModel(parent)
{
    QHash<int,QByteArray> roleNames;
    roleNames.insert(Qt::DisplayRole, "modelData");
    setRoleNames(roleNames);
}
