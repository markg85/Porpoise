import QtQuick 1.1

Item {

    Component.onCompleted: {
        console.log("... Crumbs created.")
    }

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
        onClicked: {
            bcBar.state = "edit"
        }
    }


    ListView {
        id: repeaterElement
        interactive: false
        width: parent.width
        height: parent.height
        orientation: ListView.Horizontal
        model: urlWrapper.pathModel
        delegate: BreadcrumbButton { lastItem: (index === (urlWrapper.rowCount() - 1)) ? true : false }

        onContentWidthChanged: {
            if(contentItem.width > width) {
                behContentX.enabled = false
                contentX = Math.abs((width - contentItem.width))
                behContentX.enabled = true
            }
        }

        onWidthChanged: {
            if(contentItem.width > width) {
                behContentX.enabled = false
                contentX = Math.abs((width - contentItem.width))
                behContentX.enabled = true
            }
        }

        Behavior on contentX {
            id: behContentX
            NumberAnimation { duration: 150 }
        }
    }
}
