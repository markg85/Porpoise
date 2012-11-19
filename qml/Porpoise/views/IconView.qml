import QtQuick 1.1
import Porpoise 0.1
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Item {

    Component {
        id: iconDelegate

        Item {
            id: main
            width: grid.itemWidth
            height: grid.itemHeight

            Rectangle {
                parent: grid
                width: grid.itemWidth
                height: grid.itemHeight
                x: main.x - grid.contentX
                y: main.y - grid.contentY

                // uncomment to enable animation. It doesn't look very good thus disabled for now.
//                Behavior on x { NumberAnimation { duration: 250 } }
//                Behavior on y { NumberAnimation { duration: 250 } }

                Column {
                    id: col
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: grid.textWidth
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
        property int textWidth: iconWidth * 2
        property int itemWidth: textWidth + itemHorizontalSpacing
        property int itemHeight: iconHeight + 30 + itemVerticalSpacing
        property int itemHorizontalSpacing: 5
        property int itemVerticalSpacing: 5
        property int newCellWidthValue: 0

        id: grid
        anchors.fill: parent
        model: dirModel
        cellWidth: itemWidth
        cellHeight: itemHeight
        cacheBuffer: 100
        boundsBehavior: Flickable.StopAtBounds

        Behavior on cellWidth { NumberAnimation { duration: 150 } }

        // Use a timer to animate the width changes. This usually happens when the Porpoise window is resized.
        // We do this to prevent big empty white areas.
        Timer {
            id: timer
            interval: 150
            onTriggered: grid.cellWidth = grid.newCellWidthValue
        }

        onWidthChanged: {
            var numOfItemsInRow = width / itemWidth
            var remainderWidth = width % itemWidth
            var additionalWidthPerItem = Math.floor(remainderWidth / numOfItemsInRow)
            newCellWidthValue = itemWidth + additionalWidthPerItem

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

