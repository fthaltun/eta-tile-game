var startx = 0
var endx = 0

var starty = 0
var endy = 0

var diffx = 0
var diffy = 0

var m_type


var gridSize = 4;
var cellValues;
var tileItems = [];
var availableCells;
var targetLevel = 1;
var checkTargetFlag = true;
var tileComponent = Qt.createComponent("tile.qml");

function action(m_type) {

    if (m_type == "right"){
        console.log("swiped right");
    }
    else if (m_type == "left") {
        console.log("swiped left");
    }
    else if (m_type == "up") {
        console.log("swiped up");
    }
    else if (m_type == "down") {
        console.log("swiped down");
    }

}
