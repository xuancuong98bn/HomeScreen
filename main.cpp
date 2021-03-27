#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QMediaPlaylist>
#include <QScreen>
#include "App/Media/playlistmodel.h"
#include "App/Media/langlistmodel.h"
#include "App/Media/langlist.h"
#include "App/Media/mediacontroller.h"
#include <QQmlContext>
#include "App/Climate/climatemodel.h"
#include "applicationsmodel.h"
#include "xmlreader.h"
#include "appconfig.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qRegisterMetaType<QMediaPlaylist*>("QMediaPlaylist*");

    QGuiApplication app(argc, argv);

    //Register Type for PlayListModel and  Register Uncreatable Types
    qmlRegisterType<PlayListModel>("MyMedia", 1, 0, "PlayListModel");
    qmlRegisterType<LangListModel>("MyMedia", 1, 0, "LangListModel");
    qmlRegisterUncreatableType<SongList>("MyMedia", 1, 0, "SongList", QStringLiteral("List Song should not be created in QML"));
    qmlRegisterUncreatableType<LangList>("MyMedia", 1, 0, "LangList", QStringLiteral("List Language should not be created in QML"));
    qmlRegisterUncreatableType<MediaController>("MyMedia", 1, 0, "MediaController", QStringLiteral("Media Controller should not be created in QML"));

    /**Initial needed object for Media project **/
    MediaController controller;
    Translation mTrans(&app);
    LangList langList;

    QQmlApplicationEngine engine;

    ApplicationsModel appsModel;
    XmlReader xmlReader("applications.xml", appsModel);
    engine.rootContext()->setContextProperty("appsModel", &appsModel);

    AppConfig *appConfig = new AppConfig(app.primaryScreen()->size()); //app.primaryScreen()->size()
    engine.rootContext()->setContextProperty("appConfig", appConfig);

    engine.rootContext()->setContextProperty(QStringLiteral("songList"), controller.getSongList());
    engine.rootContext()->setContextProperty(QStringLiteral("myTrans"), &mTrans);
    engine.rootContext()->setContextProperty(QStringLiteral("langList"), &langList);
    engine.rootContext()->setContextProperty(QStringLiteral("mController"), &controller);

    //Initial climate model
    ClimateModel *climate = new ClimateModel();
    engine.rootContext()->setContextProperty("climateModel", climate);

    const QUrl url(QStringLiteral("qrc:/Qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    //notify signal to QML read data from dbus
    emit climate->dataChanged();
    //set up root of project for controller
    controller.setRoot(engine.rootObjects().first());
    controller.start();

    return app.exec();
}
