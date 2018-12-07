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

    updateAvailableCells();
    createNewTileItems(true);


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

function updateAvailableCells() {
    availableCells = [];
    for (var i = 0; i < gridSize; i++) {
        for (var j = 0; j < gridSize; j++) {
            if (cellValues[i][j] === 0) {
                availableCells.push(i * gridSize + j);
            }
        }
    }
}

function createNewTileItems(isStartup) {
    var i, sub, nTiles;

    if (isStartup) {
        nTiles = 2;
    } else {
        nTiles = 1;
    }

    // Popup a new number
    for (i = 0; i < nTiles; i++) {
        var oneOrTwo = Math.random() < 0.9 ? 1: 2;
        var randomCellId = availableCells[Math.floor(Math.random() * availableCells.length)];

        sub = ind2sub(randomCellId);
        cellValues[sub[0]][sub[1]] = oneOrTwo;

        tileItems[randomCellId] = createTileObject(randomCellId, oneOrTwo, isStartup);

        // Mark this cell as unavailable
        var idx = availableCells.indexOf(randomCellId);
        availableCells.splice(idx, 1);
    }
}

function ind2sub(ind) {
    var sub = [0, 0];
    sub[0] = Math.floor(ind / gridSize);
    sub[1] = ind % gridSize;
    return sub;
}

function createTileObject(ind, n, isStartup) {
    var tile;
    var tileText = labelFunc[label](n);
    var sty = computeTileStyle(n, tileText);

    tile = tileComponent.createObject(tileGrid, {"x": cells.itemAt(ind).x, "y": cells.itemAt(ind).y, "color": sty.bgColor, "tileColor": sty.fgColor, "tileFontSize": sty.fontSize, "tileText": tileText});
    if (! isStartup) {
        tile.runNewTileAnim = true;
    }

    if (tile === null) {
        console.log("Error creating a new tile");
    }
    return tile;
}

function computeTileStyle(n, tileText) {
    var fgColors = ["#FF6C00", "#FF6C00"];
    var bgColors = ["white", "white", "white", "white", "white", "white", "white", "white", "white", "white", "white", "white"];
    var sty = {bgColor: colors.choose.bggray,
        fgColor: fgColors[0],
        fontSize: 55 };
    if (n > 0) {
        if (n > 2)
            sty.fgColor = fgColors[1];
        if (n <= bgColors.length)
            sty.bgColor = bgColors[n-1];
        else
            sty.bgColor = bgColors[bgColors.length-1];
    }
    return sty;
}

