#ifndef UTIL_H
#define UTIL_H

#include <QObject>
#include <QDebug>
#include <QWidget>
#include "pathmodel.h"


class Util : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject* pathModel READ pathModel CONSTANT)
public:
    static Util* instance()
    {
        if (!m_Instance)
        {
            m_Instance = new Util;
        }

        return m_Instance;
    }

    static void drop()
    {
        delete m_Instance;
        m_Instance = 0;
    }

    PathModel* pathModel() { return m_pathModel; }
    Q_INVOKABLE QString testString() { return m_test; }
    Q_INVOKABLE QString testSearchString();



signals:
    
public slots:

private:
    Util();

    Util(const Util &); // hide copy constructor
    Util& operator=(const Util &); // hide assign op
                                 // we leave just the declarations, so the compiler will warn us
                                 // if we try to use those two functions by accident

    static Util* m_Instance;

    QString m_test;
    PathModel* m_pathModel;
    QWidget* m_mainWindow;
    
};

#endif // UTIL_H
