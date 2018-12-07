var startx = 0
var endx = 0

var starty = 0
var endy = 0

var diffx = 0
var diffy = 0

var m_type

var score = 0;
var bestScore = settings.value("bestScore", 0);

var gridSize = 4;
var cellValues;
var tileItems = [];
var availableCells;
var targetLevel = 1;
var checkTargetFlag = true;
var tileComponent = Qt.createComponent("tile.qml");

var label = settings.value("label", "2048");
var labelFunc = {
    "2048":
    function(n) {
        return Math.pow(2, n).toString();
    }
}

function startUp() {

    score = 0;
    checkTargetFlag = true;
    var i;
    var j;

    cellValues = new Array(gridSize);
    for (i = 0; i < gridSize; i++) {
        cellValues[i] = new Array(gridSize);
        for (j = 0; j < gridSize; j++)
            cellValues[i][j] = 0;
    }

    for (i = 0; i < Math.pow(gridSize, 2); i++) {
        try {
            tileItems[i].destroy();
        } catch(e) {
        }
        tileItems[i] = null;
    }


    if (bestScore > settings.value("bestScore", 0)) {
        console.log("Updating new high score...");
        settings.setValue("bestScore", bestScore);
    }

    settings.setValue("label", "2048");

    console.log("Started a new game");
}

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
