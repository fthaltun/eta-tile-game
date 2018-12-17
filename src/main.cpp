#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QDebug>
#include <QIcon>
#include "settings.h"

#define ICONPATH "/usr/share/eta/eta-tile-game/eta-tile-game.svg"

int main(int argc, char *argv[])
{
    QApplication::setWindowIcon( QIcon(ICONPATH) );
    QApplication app(argc, argv);
    Settings settings(0, "pardus", "Eta-Tile-Game");

    QString locale;
    if (settings.contains("language")) {
        locale = settings.value("language").toString();
    } else {
        locale = QLocale::system().name();
        settings.setValue("language", locale);
    }

    QTranslator translator;
    if (! locale.startsWith("en")) {
        QString tsFile = "eta-tile-game_" + locale;

        if (translator.load(tsFile, ":/translations")) {
            qDebug() << "Successfully loaded " + tsFile;
            app.installTranslator(&translator);
        } else {
            qDebug() << "Failed to load " + tsFile;
        }
    }

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("settings", &settings);

    engine.load(QUrl(QStringLiteral("qrc:///ui/main.qml")));

    return app.exec();
}
