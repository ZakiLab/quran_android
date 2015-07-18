#include <QDir>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlFileSelector>
#include <QQmlContext>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include "downloader.h"
#include <QQuickView> //Not using QQmlApplicationEngine because many examples don't have a Window{}
#define DECLARATIVE_EXAMPLE_MAIN(NAME) int main(int argc, char* argv[]) \
{\
    QGuiApplication app(argc,argv);\
    app.setOrganizationName("ZakiLab.");\
    app.setOrganizationDomain("ZakiLab.com");\
    app.setApplicationName(QFileInfo(app.applicationFilePath()).baseName());\
    QQuickView view;\
    if (qgetenv("QT_QUICK_CORE_PROFILE").toInt()) {\
        QSurfaceFormat f = view.format();\
        f.setProfile(QSurfaceFormat::CoreProfile);\
        f.setVersion(4, 4);\
        view.setFormat(f);\
    }\
    view.connect(view.engine(), SIGNAL(quit()), &app, SLOT(quit()));\
    \
    Downloader d;\
    view.rootContext()->setContextProperty("downloader", &d);\
    \
    new QQmlFileSelector(view.engine(), &view);\
    view.setSource(QUrl("qrc:///" #NAME ".qml")); \
    view.setResizeMode(QQuickView::SizeRootObjectToView);\
/*view.showFullScreen();\*/\
    view.show();\
    return app.exec();\
}\

DECLARATIVE_EXAMPLE_MAIN(quran/quran)
