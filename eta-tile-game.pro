TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp

lupdate_only {
SOURCES += qml/main.qml \
           qml/tile.qml \
           qml/main.js
}

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri)


TARGET = eta-tile-game

target.path = /usr/bin/

INSTALLS += target

