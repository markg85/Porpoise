#include <QApplication>
#include <QDeclarativeContext>
#include <QDeclarativeEngine>
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
#include "mimeimageprovider.h"
#include "thumbimageprovider.h"
#include "util.h"

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

    QDeclarativeEngine* engine = viewer.engine();
    engine->addImageProvider(QLatin1String("mime"), new MimeImageProvider);
    engine->addImageProvider(QLatin1String("thumb"), new ThumbImageProvider);

    viewer.setMainQmlFile(QLatin1String("qml/Porpoise/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
