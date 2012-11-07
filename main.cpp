#include <QApplication>
#include "qmlapplicationviewer.h"

#include "kurlwrapper.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    qmlRegisterType<KUrlWrapper>("Porpoise", 0, 1, "KUrlWrapper");

    viewer.setMainQmlFile(QLatin1String("qml/Porpoise/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
