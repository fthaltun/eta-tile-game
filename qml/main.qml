import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.1
import "main.js" as Js

ApplicationWindow {
    visible: true
    width: 550
    height: 740
    title: qsTr("Eta Tile")

    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    Item {
        id: colors
        focus: false
        property var choose: {"bggray": "#383838",
                              "bgorange": "#FF6C00",
                              "fglight": "#EEEEEE"
        }
    }

    color: colors.choose.bggray

    Item {
        width: 500
        height: 700
        anchors.centerIn: parent
        focus: true
        FontLoader { id: localFont; source: "qrc:///fonts/FiraSans-Regular.ttf" }
        Text {
            id: gameName
            font.family: localFont.name
            font.pixelSize: 55
            font.bold: true
            text: "ETA TILE"
            color: colors.choose.fglight
        }

        Row{
            anchors.right: parent.right
            y:5
            spacing: 5
            Repeater {
                id: scoreBoard
                model: 2
                Rectangle {
                    width: (index == 0) ? 125 : 125
                    height: 55
                    radius: 3
                    color: colors.choose.bgorange
                    property string scoreText: (index === 0) ? Js.score.toString() : Js.bestScore.toString()
                    Text {
                        text: (index == 0) ? qsTr("<b>SKOR</b>") : qsTr("<b>EN İYİ SKOR</b>")
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 6
                        font.family: localFont.name
                        font.pixelSize: 17
                        color: colors.choose.fglight
                    }
                    Text {
                        text: scoreText
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 25
                        font.family: localFont.name
                        font.pixelSize: 15
                        font.bold: true
                        color: "white"
                    }
                }
            }
            Text {
                id: addScoreText
                font.family: localFont.name
                font.pixelSize: 25
                font.bold: true
                color: Qt.rgba(119/255, 110/255, 101/255, 0.9);
                anchors.horizontalCenter: parent.horizontalCenter

                property bool runAddScore: false
                property real yfrom: 0
                property real yto: -(parent.y + parent.height)
                property int addScoreAnimTime: 600

                ParallelAnimation {
                    id: addScoreAnim
                    running: false

                    NumberAnimation {
                        target: addScoreText
                        property: "y"
                        from: addScoreText.yfrom
                        to: addScoreText.yto
                        duration: addScoreText.addScoreAnimTime

                    }
                    NumberAnimation {
                        target: addScoreText
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: addScoreText.addScoreAnimTime
                    }
                }

            }

        }

        Text {
            id: banner
            y:110
            height: 40
            text: qsTr("<b>Sayıları birleştir ve 2048 sayısını elde et !</b>")
            color: colors.choose.fglight
            font.family: localFont.name
            font.pixelSize: 16
        }

        Button {
            width: 125
            height: 40
            y:100
            anchors.right: parent.right
            style: ButtonStyle {
                background: Rectangle {
                    color: colors.choose.bgorange
                    radius: 3
                    Text{
                        anchors.centerIn: parent
                        text: qsTr("Yeni Oyun")
                        color: colors.choose.fglight
                        font.family: localFont.name
                        font.pixelSize: 18
                        font.bold: true
                    }
                }
            }
            onClicked: Js.startUp()
        }

        Rectangle {
            y: 185
            width: 500
            height: 500
            color: colors.choose.bgorange
            radius: 6

            Grid {
                id: tileGrid
                x: 15;
                y: 15;
                rows: 4; columns: 4; spacing: 15

                Repeater {
                    id: cells
                    model: 16
                    Rectangle {
                        width: 425/4; height: 425/4
                        radius: 3
                        color: colors.choose.bggray
                    }
                }
            }

            MultiPointTouchArea {
                id: aTouchArea
                anchors.fill: parent
                minimumTouchPoints: 1
                maximumTouchPoints: 1

                onTouchUpdated: {
                    for (var i=0;i<touchPoints.length; i++)
                    {
                        var touch = touchPoints[i];
                        Js.startx = touch.startX
                        Js.endx = touch.x
                        Js.starty = touch.startY
                        Js.endy = touch.y
                    }
                }

                onReleased: {
                    Js.diffx = Js.endx - Js.startx;
                    Js.diffy = Js.endy - Js.starty;
                    Js.m_type = ""
                    if (Math.abs(Js.diffx) > 100 || Math.abs(Js.diffy) > 100) {
                        if (Math.abs(Js.diffx) > Math.abs(Js.diffy)) {
                            if (Js.diffx > 0) {
                                Js.m_type = "right"
                            } else {
                                Js.m_type = "left"
                            }
                        }
                        else {
                            if (Js.diffy > 0) {
                                Js.m_type = "down"
                            } else {
                                Js.m_type = "up"
                            }
                        }
                    }
                    Js.action(Js.m_type)
                }
            }
        }

        MessageDialog {
            id: lostMsg
            title: qsTr("Kaybettiniz")
            text: qsTr("Kaybettiniz!")
            standardButtons: StandardButton.Retry | StandardButton.Abort
            onAccepted: {
                Js.startUp();
            }
            onRejected: Js.cleanUpAndQuit();
        }

        MessageDialog {
            id: winMsg
            title: qsTr("Kazandınız")
            text: qsTr("Kazandınız! Oynamaya devam etmek için Evet'e, Yeni Oyun için Hayır'a basınız")
            standardButtons: StandardButton.Yes | StandardButton.No
            onYes: {
                Js.checkTargetFlag = false;
                close()
            }
            onNo: Js.startUp()
            onRejected: {
                Js.checkTargetFlag = false;
                close()
            }
        }

    }
    Component.onCompleted: Js.startUp();
}
