import QtQuick 1.1

Rectangle {

    // This timer fires to update the url path model _after_ the animations have been run.
    Timer {
        property int index: 0
        id: pathModelCleanupTimer
        running: false
        repeat: false
        onTriggered: urlWrapper.updateUrlBasedOnIndex(index)
    }


    function breadcrumbButtonPressed(index) {

        var iAnimationOffsetPerItem = 10 // in ms
        var iIemsToAnimateOut = urlWrapper.rowCount() - (index + 1)
        var iItemsCountdown = iIemsToAnimateOut
        var iAnimationTime = 150

        for(var num = index + 1; num < urlWrapper.rowCount(); ++num) {
            repeaterElement.children[num].removeElement(iAnimationTime, iItemsCountdown * iAnimationOffsetPerItem)
            iItemsCountdown--
        }

        pathModelCleanupTimer.interval = iAnimationTime + (iIemsToAnimateOut * iAnimationOffsetPerItem)
        pathModelCleanupTimer.index = index
        pathModelCleanupTimer.start()
    }

    function breadcrumbButtonAddAfterIndex(index, entryName) {

//        breadcrumbButtonPressed(index)
        urlWrapper.updateUrlBasedOnIndex(index + 1)
        urlWrapper.append(entryName)
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            parent.color = "red"
        }
        onExited: {
            parent.color = "transparent"
        }
        onClicked: {
            bcBar.state = "edit"
        }
    }

    Row {
        id: repeaterElement

        Repeater {
            id: bcRepeater
            model: urlWrapper.pathModel
            delegate: BreadcrumbButton {lastItem: (index === (urlWrapper.rowCount() - 1)) ? true : false }
        }
    }
}