import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.1
import "../js/main.js" as Js

ApplicationWindow {
    visible: true
    width: 550
    height: 740
    minimumWidth: 550
    minimumHeight: 740
    maximumWidth: 550
    maximumHeight: 740
    title: qsTr("ETA Tile Game")

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
        Keys.onPressed: Js.action(event)
        FontLoader { id: localFont; source: "qrc:///fonts/FiraSans-Regular.ttf" }
        Text {
            id: gameName
            y:-15
            font.family: localFont.name
            font.pixelSize: 47
            font.bold: true
            text: qsTr("TILE")
            color: colors.choose.fglight
        }
        Text {
            id: gameName1
            y:35
            x:47
            font.family: localFont.name
            font.pixelSize: 47
            font.bold: true
            text: qsTr("GAME")
            wrapMode: Text.WordWrap
            width:45
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
                        text: (index == 0) ? qsTr("<b>SCORE</b>") : qsTr("<b>BEST</b>")
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 6
                        font.family: localFont.name
                        font.pixelSize: 17
                        color: colors.choose.fglight
                    }
                    Text {
                        text: scoreText
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 30
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
            text: qsTr("<b>Join the numbers and get to the 2048 tile!</b>")
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
                        text: qsTr("New Game")
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
                    if (Math.abs(Js.diffx) > 80 || Math.abs(Js.diffy) > 80) {
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

        Dialog {
            id: lostMsg
            visible: false
            title: qsTr("Game Over")
            contentItem: Rectangle {
                color: colors.choose.bggray
                implicitWidth: 500
                implicitHeight: 120
                Text {
                    text: qsTr("Game Over!")
                    color: colors.choose.bgorange
                    anchors.horizontalCenter: parent.horizontalCenter
                    y:20
                    font.bold: true
                    font.pixelSize: 20
                }
                Button {
                    width: 130
                    height: 40
                    anchors.bottomMargin: 15
                    anchors.bottom: parent.bottom
                    x:80
                    style: ButtonStyle {
                        background: Rectangle {
                            color: colors.choose.bgorange
                            radius: 3
                            Text{
                                anchors.centerIn: parent
                                text: qsTr("Retry")
                                color: colors.choose.fglight
                                font.family: localFont.name
                                font.pixelSize: 18
                                font.bold: true
                            }
                        }
                    }
                    onClicked: {
                        Js.startUp();
                        lostMsg.close();
                    }
                }
                Button {
                    width: 130
                    height: 40
                    x:290
                    anchors.bottomMargin: 15
                    anchors.bottom: parent.bottom
                    style: ButtonStyle {
                        background: Rectangle {
                            color: colors.choose.bgorange
                            radius: 3
                            Text{
                                anchors.centerIn: parent
                                text: qsTr("Exit")
                                color: colors.choose.fglight
                                font.family: localFont.name
                                font.pixelSize: 18
                                font.bold: true
                            }
                        }
                    }
                    onClicked: {
                        Qt.quit();
                    }
                }
            }
        }

        Dialog {
            id: winMsg
            visible: false
            title: qsTr("You Win")
            onVisibleChanged: {
                if ( !this.visible ) {
                    Js.checkTargetFlag = false;
                }
            }
            contentItem: Rectangle {
                color: colors.choose.bggray
                implicitWidth: 500
                implicitHeight: 120
                Text {
                    text: qsTr("You win!")
                    color: colors.choose.bgorange
                    anchors.horizontalCenter: parent.horizontalCenter
                    y:5
                    font.bold: true
                    font.pixelSize: 20
                }
                Text {
                    text: qsTr("Continue playing?")
                    color: colors.choose.bgorange
                    anchors.horizontalCenter: parent.horizontalCenter
                    y:30
                    font.bold: true
                    font.pixelSize: 20
                }
                Button {
                    width: 130
                    height: 40
                    anchors.bottomMargin: 13
                    anchors.bottom: parent.bottom
                    x:80
                    style: ButtonStyle {
                        background: Rectangle {
                            color: colors.choose.bgorange
                            radius: 3
                            Text{
                                anchors.centerIn: parent
                                text: qsTr("Yes")
                                color: colors.choose.fglight
                                font.family: localFont.name
                                font.pixelSize: 18
                                font.bold: true
                            }
                        }
                    }
                    onClicked: {
                        Js.checkTargetFlag = false;
                        winMsg.close();
                    }
                }
                Button {
                    width: 130
                    height: 40
                    x:290
                    anchors.bottomMargin: 13
                    anchors.bottom: parent.bottom
                    style: ButtonStyle {
                        background: Rectangle {
                            color: colors.choose.bgorange
                            radius: 3
                            Text{
                                anchors.centerIn: parent
                                text: qsTr("No")
                                color: colors.choose.fglight
                                font.family: localFont.name
                                font.pixelSize: 18
                                font.bold: true
                            }
                        }
                    }
                    onClicked: {
                        winMsg.close();
                        Js.startUp()
                    }
                }


            }
        }
    }
    Component.onCompleted: Js.startUp();
}