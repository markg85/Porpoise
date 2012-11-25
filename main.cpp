#include <QApplication>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"

#include "pathmodel.h"
#include "kurlwrapper.h"
#include "kcompletionwrapper.h"
#include "dirmodel.h"
#include "kgraphicsitem.h"
#include "kurlundoredo.h"
#include "util.h"
#include "testclass.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.rootContext()->setContextProperty("Util", Util::instance());

    qmlRegisterType<KUrlWrapper>("Porpoise", 0, 1, "KUrlWrapper");
    qmlRegisterType<KCompletionWrapper>("Porpoise", 0, 1, "KCompletionWrapper");
    qmlRegisterType<DirModel>("Porpoise", 0, 1, "DirModel");
    qmlRegisterType<KGraphicsItem>("Porpoise", 0, 1, "KGraphicsItem");
    qmlRegisterType<KUrlUndoRedo>("Porpoise", 0, 1, "KUrlUndoRedo");

    viewer.setMainQmlFile(QLatin1String("qml/Porpoise/main.qml"));
    viewer.showExpanded();

//    TestClass test;
//    test.folderThumbnails("/home/mark/Images/");
//    test.fetchFolder("/home/mark/massive_files/");
//    test.fetchFolder("/home/mark/lesser_massive");

//    qDebug() << "-- START";
//    DirModel dir;
//    dir.setUrl("/home/mark/massive_files/");
//    qDebug() << "-- END";

    return app->exec();
}
