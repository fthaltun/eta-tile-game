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

# Default rules for deployment.
#include(deployment.pri)

icon.files = eta-tile-game.svg
icon.commands = mkdir -p /usr/share/eta/eta-tile-game
icon.path = /usr/share/eta/eta-tile-game/

TARGET = eta-tile-game

target.path = /usr/bin/

INSTALLS += target icon
