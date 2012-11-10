#include <QApplication>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"

#include "pathmodel.h"
#include "kurlwrapper.h"
#include "kcompletionwrapper.h"
#include "util.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.rootContext()->setContextProperty("Util", Util::instance());
    viewer.rootContext()->setContextProperty("GlobalPathModel", Util::instance()->pathModel());

    qmlRegisterType<KUrlWrapper>("Porpoise", 0, 1, "KUrlWrapper");
    qmlRegisterType<KCompletionWrapper>("Porpoise", 0, 1, "KCompletionWrapper");

    viewer.setMainQmlFile(QLatin1String("qml/Porpoise/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
