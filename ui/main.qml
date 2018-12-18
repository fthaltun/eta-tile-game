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

    color: colors.choose.pardus_gray

    property int myMargin:6
    property variant numbers: []
    property int cols: 4
    property int rows: 4
    property int finalValue: 512
    property bool targetFlag: true
    property int score: 0
    property var bestScore : settings.value("bestScore", 0);

    Component {
        id: number

        Rectangle {
            id: colorRect
            color:  number <=    1 ? "white" :
                    number <=    2 ? "#59abe3" :
                    number <=    4 ? "#8bc34a" :
                    number <=    8 ? "#be90d4" :
                    number <=   16 ? "#bcaaa4" :
                    number <=   32 ? "#e91e63" :
                    number <=   64 ? "#006442" :
                    number <=  128 ? "#003171" :
                    number <=  256 ? "#5b3256" :
                    number <=  512 ? "#6c7a89" :
                    number <= 1024 ? "#795548" :
                    number <= 2048 ? "#800000" :
                                     "#000000"

            property int col
            property int row

            property int number: Math.random() > 0.9 ? 4 : 2

            x: cells.getAt(col, row).x
            y: cells.getAt(col, row).y
            width: cells.getAt(col, row).width
            height: cells.getAt(col, row).height
            radius: cells.getAt(col, row).radius

            function move(h, v) {
                if (h === col && v === row)
                    return false
                if (numberAt(h, v)) {
                    number += numberAt(h, v).number
                    score += number
                    if (number === finalValue){
                        root.victory()
                    }
                    root.popNumberAt(h, v)
                }
                col = h
                row = v
                return true
            }

            Text {
                id: text
                width: parent.width * 0.9
                height: parent.height * 0.9
                anchors.centerIn: parent
                smooth: true
                color:colors.choose.pardus_white
                font.family: firaFont.name
                font.pixelSize: parent.height /2
                fontSizeMode: Text.Fit
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: parent.number > 1 ? parent.number : ""
            }

            Behavior on x {
                NumberAnimation {
                    duration: 50
                    easing {
                        type: Easing.InOutQuad
                    }
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: 50
                    easing {
                        type: Easing.InOutQuad
                    }
                }
            }

            transform: Scale {
                id: zoomIn
                origin.x: colorRect.width / 2
                origin.y: colorRect.height / 2
                xScale: 0
                yScale: 0
                Behavior on xScale {
                    NumberAnimation {
                        duration: 200
                        easing {
                            type: Easing.InOutQuad
                        }
                    }
                }
                Behavior on yScale {
                    NumberAnimation {
                        duration: 200
                        easing {
                            type: Easing.InOutQuad
                        }
                    }
                }
            }

            Component.onCompleted: {
                zoomIn.xScale = 1
                zoomIn.yScale = 1
            }
        }
    }

    function numberAt(col, row) {
        for (var i = 0; i < numbers.length; i++) {
            if (numbers[i].col === col && numbers[i].row === row)
                return numbers[i]
        }
    }
    function popNumberAt(col, row) {
        var tmp = numbers
        for (var i = 0; i < tmp.length; i++) {
            if (tmp[i].col === col && tmp[i].row === row) {
                tmp[i].destroy()
                tmp.splice(i, 1)
            }
        }
        numbers=tmp
    }
    function gen2() {
        var tmp = numbers
        var cell = cells.getRandomFree()
        var newNumber = number.createObject(cellGrid,{"col":cell.col,"row":cell.row})
        tmp.push(newNumber)
        numbers = tmp
    }
    function purge() {
        score = 0
        var tmp = numbers
        for (var i = 0; i < tmp.length; i++) {
            tmp[i].destroy()
        }
        tmp = []
        numbers = tmp
        gen2();
        gen2();
        updateScore(0);
        addScoreText.parent = scorePanel.itemAt(0);
    }
    function checkNotStuck() {
        for (var i = 0; i < root.cols; i++) {
            for (var j = 0; j < root.rows; j++) {
                if (!numberAt(i, j))
                    return true
                if (numberAt(i+1,j) && numberAt(i,j).number === numberAt(i+1,j).number)
                    return true
                if (numberAt(i-1,j) && numberAt(i,j).number === numberAt(i-1,j).number)
                    return true
                if (numberAt(i,j+1) && numberAt(i,j).number === numberAt(i,j+1).number)
                    return true
                if (numberAt(i,j-1) && numberAt(i,j).number === numberAt(i,j-1).number)
                    return true
            }
        }
        return false
    }
    function victory() {
        console.log("you win")
    }
    function defeat() {
        console.log("you lost")
    }

    function updateScore(oldScore) {
        if (score > oldScore) {
            addScoreText.text = "+" + (score-oldScore).toString();
            addScoreAnim.running = true;
        }

        scorePanel.itemAt(0).scoreText = score.toString();
        scorePanel.itemAt(1).scoreText = "";
    }

    function move(col, row) {
        var somethingMoved = false
        var tmp = numbers
        var oldScore = score;
        var filled
        var canMerge
        if (col > 0) {
            for (var j = 0; j < root.rows; j++) {
                filled = 0
                canMerge = false
                for (var i = root.cols - 1; i >= 0; i--) {
                    if (numberAt(i,j)) {
                        if (canMerge) {
                            if (numberAt(i,j).number === numberAt(root.cols-filled,j).number) {
                                canMerge = false
                                filled--
                            }
                        }
                        else {
                            canMerge = true
                        }
                        if (numberAt(i,j).move(root.cols-1-filled,j))
                            somethingMoved = true
                        filled++
                    }
                }
            }
        }
        if (col < 0) {
            for (var j = 0; j < root.rows; j++) {
                filled = 0
                canMerge = false
                for (var i = 0; i < root.cols; i++) {
                    if (numberAt(i,j)) {
                        if (canMerge) {
                            if (numberAt(i,j).number === numberAt(filled-1,j).number) {
                                canMerge = false
                                filled--
                            }
                        }
                        else {
                            canMerge = true
                        }
                        if (numberAt(i,j).move(filled,j))
                            somethingMoved = true
                        filled++
                    }
                }
            }
        }
        if (row > 0) {
            for (var i = 0; i < root.cols; i++) {
                filled = 0
                canMerge = false
                for (var j = root.rows - 1; j >= 0; j--) {
                    if (numberAt(i,j)) {
                        if (canMerge) {
                            if (numberAt(i,j).number === numberAt(i,root.rows-filled).number) {
                                canMerge = false
                                filled--
                            }
                        }
                        else {
                            canMerge = true
                        }
                        if (numberAt(i,j).move(i,root.rows-1-filled))
                            somethingMoved = true
                        filled++
                    }
                }
            }
        }
        if (row < 0) {
            for (var i = 0; i < root.cols; i++) {
                filled = 0
                canMerge = false
                for (var j = 0; j < root.rows; j++) {
                    if (numberAt(i,j)) {
                        if (canMerge) {
                            if (numberAt(i,j).number === numberAt(i,filled-1).number) {
                                canMerge = false
                                filled--
                            }
                        }
                        else {
                            canMerge = true
                        }
                        if (numberAt(i,j).move(i,filled))
                            somethingMoved = true
                        filled++
                    }
                }
            }
        }
        if (somethingMoved){
            gen2()
            if (oldScore !== score) {
                updateScore(oldScore);
            }
        }
        if (!checkNotStuck()){
            root.defeat()
        }
    }

    Rectangle{
        id:cover
        color:colors.choose.pardus_gray
        width: root.width - 2*myMargin
        height: header1.height + header2.height + canvas.height + 4*myMargin
        anchors.centerIn: parent

        Rectangle {
            id:header1
            color:colors.choose.pardus_gray
            width:cover.width-2*myMargin
            height:root.height/6
            anchors{
                top:parent.top
                topMargin: myMargin
                horizontalCenter: parent.horizontalCenter
            }

            Row{
                anchors{
                    leftMargin: myMargin
                    verticalCenter:header1.verticalCenter
                    left:header1.left

                }

                Text {
                    id: gameName
                    font.family: firaFont.name
                    font.pixelSize: root.height/13
                    font.bold: true
                    text: qsTr("TILE GAME")
                    color: colors.choose.pardus_orange
                    wrapMode: Text.WordWrap
                    width:root.width/2.3
                }
            }

            Row{
                anchors{
                    verticalCenter:header1.verticalCenter
                    right: header1.right
                    rightMargin: myMargin
                }
                spacing: myMargin
                Repeater {
                    id: scorePanel
                    model: 2
                    Rectangle {
                        width: (index == 0) ? root.width/4 : root.width/4
                        height: root.height/11
                        radius: 3
                        color: colors.choose.pardus_orange
                        property string scoreText: (index === 0) ? root.score : "0"
                        Text {
                            text: (index == 0) ? qsTr("<b>SCORE</b>") : qsTr("<b>BEST</b>")
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: root.height/120
                            font.family: firaFont.name
                            font.pixelSize: root.height/33
                            color: colors.choose.pardus_white
                        }
                        Text {
                            text: scoreText
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: root.height/21
                            font.family: firaFont.name
                            font.pixelSize: root.height/35
                            font.bold: true
                            color: "white"
                        }
                    }
                }
                Text {
                    id: addScoreText
                    font.family: firaFont.name
                    font.pixelSize: root.height/20
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
        }

        Rectangle {
            id:header2
            color:colors.choose.pardus_gray
            width:cover.width-2*myMargin
            height:root.height/9
            anchors{
                top:header1.bottom
                topMargin: myMargin
                horizontalCenter: parent.horizontalCenter
            }
            Text {
                id: banner
                anchors{
                    verticalCenter: header2.verticalCenter
                    left:header2.left
                    leftMargin: myMargin
                }
                text: qsTr("Join the numbers and get to the 2048 tile!")
                color: colors.choose.pardus_white
                font.family: firaFont.name
                font.pixelSize: root.height/41
                font.bold: true
            }

            Button {
                width: root.width/4
                height: root.height/15
                anchors{
                    verticalCenter:header2.verticalCenter
                    right: header2.right
                    rightMargin: myMargin
                }
                style: ButtonStyle {
                    background: Rectangle {
                        color: colors.choose.pardus_orange
                        radius: 3
                        Text{
                            anchors.centerIn: parent
                            text: qsTr("New Game")
                            color: colors.choose.pardus_white
                            font.family: firaFont.name
                            font.pixelSize: root.height/35
                            font.bold: true
                        }
                    }
                }
                onClicked: {
                    purge()
                }
            }
        }

        Rectangle {
            id:canvas
            color: colors.choose.pardus_orange
            height:root.height-header1.height-header2.height-4*myMargin <= cover.width-2*myMargin ? root.height-header1.height-header2.height-4*myMargin : cover.width-2*myMargin
            width: height
            radius: 10
            focus: true
            anchors{
                top:header2.bottom
                topMargin: myMargin
                horizontalCenter: parent.horizontalCenter
            }
            Grid {
                id: cellGrid
                width: canvas.width - spacing*2
                height: canvas.height - spacing*2
                anchors{
                    centerIn: canvas
                }
                rows: root.rows
                columns: root.cols
                spacing: (parent.width + parent.height) / root.rows / root.cols / 4

                property real cellWidth: (width - (columns - 1) * spacing) / columns
                property real cellHeight: (height - (rows - 1) * spacing) / rows

                Repeater {
                    id: cells
                    model: root.cols * root.rows
                    function getAt(h, v) {
                        return itemAt(h + v * root.cols)
                    }
                    function getRandom() {
                        return itemAt(Math.floor((Math.random() * 16)%16))
                    }
                    function getRandomFree() {
                        var free = []
                        for (var i = 0; i < root.cols; i++) {
                            for (var j = 0; j < root.rows; j++) {
                                if (!root.numberAt(i, j)) {
                                    free.push(getAt(i, j))
                                }
                            }
                        }
                        return free[Math.floor(Math.random()*free.length)]
                    }
                    Rectangle {
                        width: parent.cellWidth
                        height: parent.cellHeight
                        color: colors.choose.pardus_gray
                        radius: 10
                        property int col : index % root.cols
                        property int row : index / root.cols
                    }
                }
            }
        }

        Keys.onPressed: {

            if (event.key === Qt.Key_Left)
                root.move(-1, 0)
            if (event.key === Qt.Key_Right)
                root.move(1, 0)
            if (event.key === Qt.Key_Up)
                root.move(0, -1)
            if (event.key === Qt.Key_Down)
                root.move(0, 1)

            if (event.key === Qt.Key_Space) {
                root.purge()
            }
        }

        MultiPointTouchArea {
            id: aTouchArea
            anchors.fill: canvas
            minimumTouchPoints: 1
            maximumTouchPoints: 1

            property real startx:0
            property real starty:0
            property real endx:0
            property real endy:0
            property real diffx:0
            property real diffy:0

            onTouchUpdated: {

                for (var i=0;i<touchPoints.length; i++)
                {
                    var touch = touchPoints[i];
                    startx = touch.startX
                    endx = touch.x
                    starty = touch.startY
                    endy = touch.y
                }
            }

            onReleased: {
                diffx = endx - startx;
                diffy = endy - starty;
                if (Math.abs(diffx) > 80 || Math.abs(diffy) > 80) {
                    if (Math.abs(diffx) > Math.abs(diffy)) {
                        if (diffx > 0) {
                            root.move(1, 0)
                        } else {
                            root.move(-1, 0)
                        }
                    }
                    else {
                        if (diffy > 0) {
                            root.move(0, 1)
                        } else {
                            root.move(0, -1)
                        }
                    }
                }
            }
        }
        Component.onCompleted: {
            root.purge()
        }
    }
}
