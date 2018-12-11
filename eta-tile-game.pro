TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    settings.cpp

lupdate_only {
SOURCES += qml/main.qml \
           qml/tile.qml \
           qml/main.js
}

HEADERS += \
    settings.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

TRANSLATIONS = ts/2048-qt_tr_TR.ts

icon.files = eta-tile-game.svg
icon.commands = mkdir -p /usr/share/eta/eta-tile-game
icon.path = /usr/share/eta/eta-tile-game/

TARGET = eta-tile-game

target.path = /usr/bin/

INSTALLS += target icon
