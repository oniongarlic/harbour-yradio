#include <QtQuick>

#include <QTranslator>
#include <QTextCodec>
#include <QLocale>

#include <sailfishapp.h>
#include "settings.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QTranslator translator;
    Settings *settings;

    app->setApplicationName("harbour-yradio");
    app->setApplicationVersion("1.0.2");
    app->setOrganizationDomain("org.tal");
    app->setOrganizationName("TalOrg");

    // QTextCodec::setCodecForTr(QTextCodec::codecForName("utf8"));
    QString locale(QLocale::system().name());

    qDebug() << "Locale is: " << locale;
    if (translator.load("yradio." + locale, ":/nls")) {
        app->installTranslator(&translator);
    } else {
        qDebug() << "Failed to load translation";
    }

    settings = new Settings();
    view->rootContext()->setContextProperty("settings", settings);

    view->setSource(SailfishApp::pathTo("qml/harbour-yradio.qml"));
    view->showFullScreen();

    return app->exec();
}

