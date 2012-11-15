import QtQuick 1.1

Rectangle {

    // This timer fires to update the url path model _after_ the animations have been run.
    Timer {
        property int index: 0
        id: pathModelCleanupTimer
        running: false
        repeat: false
        onTriggered: urlWrapper.updateUrlModel(index)
    }


    function breadcrumbButtonPressed(index) {

        urlWrapper.updateUrlBasedOnIndex(index)
        var newIndex = index + 1 // +1 because the first element in the list is for QML internal stuff.
        var iAnimationOffsetPerItem = 10 // in ms
        var iIemsToAnimateOut = urlWrapper.rowCount() - newIndex
        var iItemsCountdown = iIemsToAnimateOut
        var iAnimationTime = 150

        for(var i = newIndex + 1; i < repeaterElement.contentItem.children.length; ++i) {
            repeaterElement.contentItem.children[i].removeElement(iAnimationTime, iItemsCountdown * iAnimationOffsetPerItem)
            iItemsCountdown--
        }

        pathModelCleanupTimer.interval = iAnimationTime + (iIemsToAnimateOut * iAnimationOffsetPerItem)
        pathModelCleanupTimer.index = index
        pathModelCleanupTimer.start()
    }

    function breadcrumbButtonAddAfterIndex(index, entryName) {

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


    ListView {
        id: repeaterElement
        interactive: false
        anchors.fill: parent
        orientation: ListView.Horizontal
        model: urlWrapper.pathModel
        delegate: BreadcrumbButton { lastItem: (index === (urlWrapper.rowCount() - 1)) ? true : false }
    }
}
