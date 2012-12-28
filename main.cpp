#include <QApplication>
#include <QDeclarativeContext>
#include <QClipboard>
#include "qmlapplicationviewer.h"

#include "pathmodel.h"
#include "kurlwrapper.h"
#include "kcompletionwrapper.h"
#include "dirmodel.h"
#include "kgraphicsitem.h"
#include "kurlundoredo.h"
#include "shortcut.h"
#include "clipboard.h"
#include "util.h"
#include "testclass.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    qmlRegisterType<KUrlWrapper>("Porpoise", 0, 1, "KUrlWrapper");
    qmlRegisterType<KCompletionWrapper>("Porpoise", 0, 1, "KCompletionWrapper");
    qmlRegisterType<DirModel>("Porpoise", 0, 1, "DirModel");
    qmlRegisterType<KGraphicsItem>("Porpoise", 0, 1, "KGraphicsItem");
    qmlRegisterType<KUrlUndoRedo>("Porpoise", 0, 1, "KUrlUndoRedo");
    qmlRegisterType<Shortcut>("Porpoise", 0, 1, "Shortcut");
    qmlRegisterType<Clipboard>("Porpoise", 0, 1, "Clipboard");

    viewer.setMainQmlFile(QLatin1String("qml/Porpoise/main.qml"));
    viewer.showExpanded();



//    TestClass test;

//    QClipboard* clip = QApplication::clipboard();

//    QObject::connect(clip, SIGNAL(dataChanged()), &test, SLOT(dumpTestString()));

//    QShortcut* reload = new QShortcut(QKeySequence(Qt::Key_F5), &viewer);
//    QObject::connect(reload, SIGNAL(activated()), &test, SLOT(dumpTestString()));


//    test.folderThumbnails("/home/mark/Images/");
//    test.fetchFolder("/home/mark/massive_files/");
//    test.fetchFolder("/home/mark/lesser_massive");
//    test.fetchFolder("ftp://ftp.mirror.aarnet.edu.au/pub/archlinux/extra/os/x86_64/");

//    qDebug() << "-- START";
//    DirModel dir;
//    dir.setUrl("/home/mark/massive_files/");
//    qDebug() << "-- END";

    return app->exec();
}
