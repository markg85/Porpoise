import QtQuick 1.1
import Porpoise 0.1
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Item {

    Component {
        id: iconDelegate

        Item {
            id: main
            width: grid.cellWidth
            height: grid.cellHeight

            Rectangle {
                parent: grid
                width: grid.itemWidth
                height: grid.itemHeight
                x: grid.itemHorizontalSpacing + main.x - grid.contentX
                y: grid.itemVerticalSpacing + main.y - grid.contentY
                color: "orange"

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        parent.color = "red"
                    }
                    onExited: {
                        parent.color = "orange"
                    }
                }

                // uncomment to enable animation. It doesn't look very good thus disabled for now.
//                Behavior on x { NumberAnimation { duration: 250 } }
//                Behavior on y { NumberAnimation { duration: 250 } }

                Column {
                    id: col
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: grid.itemWidth
                    spacing: grid.itemVerticalSpacing
                    QtExtraComponents.QIconItem {
                        width: grid.iconWidth
                        height: grid.iconHeight
                        anchors.horizontalCenter: parent.horizontalCenter
                        icon: IconName

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                              var currentFileItem = dirModel.itemForIndex(index)
                                if(currentFileItem.isDir) {
                                    urlWrapper.url = dirModel.get(index).url
                                } else {
                                    currentFileItem.run()
                                }

        //                        console.log("Clicked on index: " + dirModel.get(index).url)
                                console.log("Clicked on index: " + currentFileItem)
                                console.log("isDir: " + currentFileItem.isDir)
                                console.log("Clicked on index: " + currentFileItem)
                            }
                        }
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: grid.textWidth
                        horizontalAlignment: Text.AlignHCenter
                        text: Name
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    GridView {
        property int iconWidth: 48
        property int iconHeight: 48
        property int textWidth: iconWidth * 2 - (itemHorizontalSpacing * 2)
        property int itemWidth: iconWidth * 2
        property int itemHeight: iconHeight + 40
        property int itemHorizontalSpacing: 5
        property int itemVerticalSpacing: 5
        property int newCellWidthValue: 0

        id: grid
        anchors.fill: parent
        model: dirModel
        cellWidth: itemWidth + itemHorizontalSpacing
        cellHeight: itemHeight + itemVerticalSpacing
        cacheBuffer: 100
        boundsBehavior: Flickable.StopAtBounds

        Behavior on cellWidth { NumberAnimation { duration: 150 } }
//        Behavior on itemHorizontalSpacing { NumberAnimation { duration: 150 } }

        // Use a timer to animate the width changes. This usually happens when the Porpoise window is resized.
        // We do this to prevent big empty white areas.
        Timer {
            id: timer
            interval: 150
            onTriggered: grid.cellWidth = grid.newCellWidthValue
//            onTriggered: grid.itemHorizontalSpacing = grid.newCellWidthValue
        }

        onWidthChanged: {
            var numOfItemsInRow = width / itemWidth
            var remainderWidth = width % itemWidth
            var additionalWidthPerItem = Math.floor(remainderWidth / numOfItemsInRow)
            newCellWidthValue = itemWidth + additionalWidthPerItem
//            cellWidth = itemWidth + itemHorizontalSpacing + additionalWidthPerItem

            // Only start the timer if the new width is different
            if(newCellWidthValue != cellWidth) {
                timer.restart()
            } else {
                timer.stop()
            }
        }

        delegate: iconDelegate
    }
}

