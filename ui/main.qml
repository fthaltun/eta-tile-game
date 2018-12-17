import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.1

ApplicationWindow {
    id: root
    visible: true
    width: Screen.width/4
    height: Screen.height*2/3
    minimumHeight: 740
    minimumWidth: 530
    title: qsTr("ETA Tile Game")
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    Item {
        id: colors
        focus: false
        property var choose: {"pardus_gray": "#383838",
                              "pardus_orange": "#FF6C00",
                              "pardus_white": "#EEEEEE"
        }
    }

    FontLoader { id: firaFont; source: "qrc:///fonts/FiraSans-Regular.ttf" }

    color: "white"

    property int myMargin:6

    Rectangle{
        id:cover
        color:"red"
        width: root.width - 2*myMargin
        height: rect2.height + rect3.height + canvas.height + 4*myMargin
        anchors.centerIn: parent

        Rectangle {
            id:rect2
            color:"blue"
            width:cover.width-2*myMargin
            height:root.height/6
            anchors{
                top:parent.top
                topMargin: myMargin
                horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle {
            id:rect3
            color:"orange"
            width:cover.width-2*myMargin
            height:root.height/10
            anchors{
                top:rect2.bottom
                topMargin: myMargin
                horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle {
            id:canvas
            color: "yellow"
            height:root.height-rect2.height-rect3.height-4*myMargin <= cover.width-2*myMargin ? root.height-rect2.height-rect3.height-4*myMargin : cover.width-2*myMargin
            width: height

            anchors{
                top:rect3.bottom
                topMargin: myMargin
                horizontalCenter: parent.horizontalCenter
            }
        }

    }

}
