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
    Settings settings(0, "pardus", "Eta-Tile");

    QString locale;
    if (settings.contains("language")) {
        locale = settings.value("language").toString();
    } else {
        locale = QLocale::system().name();
        settings.setValue("language", locale);
    }

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("settings", &settings);

    engine.load(QUrl(QStringLiteral("qrc:///qml/main.qml")));

    return app.exec();
}
