TEMPLATE = app

QT += qml quick widgets

SOURCES += src/main.cpp \
    src/settings.cpp

lupdate_only {
SOURCES += ui/main.qml
}

HEADERS += \
    src/settings.h

RESOURCES += qml.qrc \
    fonts.qrc \
    translations.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

TRANSLATIONS = translations/eta-tile-game_tr_TR.ts

icon.files = eta-tile-game.svg
icon.commands = mkdir -p /usr/share/eta/eta-tile-game
icon.path = /usr/share/eta/eta-tile-game/

desktop_file.files = eta-tile-game.desktop
desktop_file.path = /usr/share/applications/


TARGET = eta-tile-game

target.path = /usr/bin/

INSTALLS += target desktop_file icon
