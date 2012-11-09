import QtQuick 1.1

Item {

    id: bcBar

    property variant urlWrapper: 0
    property variant currentPopup: 0

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

    Row {
        id: repeaterElement

        Repeater {
            id: bcRepeater
            model: GlobalPathModel
            delegate: BreadcrumbButton {lastItem: (index === (urlWrapper.rowCount() - 1)) ? true : false }
        }
    }

    Component.onCompleted: {
        console.log("1: GlobalPathModel " + GlobalPathModel)
        console.log("2: Util " + Util.pathModel())
    }
}

