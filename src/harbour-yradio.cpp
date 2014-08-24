#include <QtQuick>

#include <QTranslator>
#include <QTextCodec>
#include <QLocale>

#include <sailfishapp.h>
#include "settings.h"

#include "FileDownloader.h"
#include "DateUtils.h"
#include "gst/httpplayer.h"
#include "gst/rtspplayer.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));    
    QTranslator translator;
    Settings *settings;
    DateUtils *dateutils;
    const QString applicationVersion("1.1.0");

    qmlRegisterType<FileDownloader>("harbour.yradio", 1, 0, "FileDownloader");
    qmlRegisterType<HTTPPlayer>("harbour.yradio.player", 1, 0, "HttpPlayer");
    qmlRegisterType<RTSPPlayer>("harbour.yradio.player", 1, 0, "RtspPlayer");

    app->setApplicationName("harbour-yradio");
    app->setApplicationVersion(applicationVersion);
    // Note: DO NOT SET THESE EVEN IF IT WOULD MAKE SENSE TO DO SO.. stupid sailfishapp
    // app->setOrganizationDomain("org.tal");
    // app->setOrganizationName("TalOrg");

    // QTextCodec::setCodecForTr(QTextCodec::codecForName("utf8"));
    QString locale(QLocale::system().name());

    qDebug() << "Locale is: " << locale;
    if (translator.load("yradio." + locale, ":/nls")) {
        app->installTranslator(&translator);
    } else {
        qDebug() << "Failed to load translation";
    }

    settings = new Settings();
    dateutils = new DateUtils();

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->rootContext()->setContextProperty("settings", settings);
    view->rootContext()->setContextProperty("du", dateutils);
    view->rootContext()->setContextProperty("appVersion", applicationVersion);
    view->setSource(SailfishApp::pathTo("qml/harbour-yradio.qml"));
    view->showFullScreen();

    return app->exec();
}

