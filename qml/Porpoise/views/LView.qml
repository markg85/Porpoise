import QtQuick 1.1
import Porpoise 0.1
import org.kde.qtextracomponents 0.1 as QtExtraComponents

// LView because the full name: "ListView" would be confusion with the default QML component ListView.

Item {

    Row {
        id: header
        width: parent.width - 10
        height: 30
        spacing: 5

        Text {
            id: items
            width: parent.width * 0.50
            anchors.verticalCenter: parent.verticalCenter
            font.italic: true
            font.bold: true
            text: dirModel.count + " items"
        }

        Text {
            id: date
            width: parent.width * 0.30
            anchors.verticalCenter: parent.verticalCenter
            font.italic: true
            font.bold: true
            text: "date"
        }

        Text {
            id: type
            width: parent.width * 0.20
            anchors.verticalCenter: parent.verticalCenter
            font.italic: true
            font.bold: true
            text: "type"
        }
    }

    Component {
        id: listDelegate
        Item {
            id: itemRow
            width: list.width
            height: 32 + 10

            property color background: "transparent"
            property color bordercolor: "transparent"
            property color highlightcolor: "#676664"
            property color textcolor: "#A4A3A1"
            property color imageBorderColor: "#EFE9EB"
            property color imageBackground: "#FFFEFF"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    itemRow.background = "#F9EBE8"
                    itemRow.bordercolor = "#F0E2DF"
                    itemRow.highlightcolor = "#E05B3C"
                    itemRow.textcolor = "#E79685"
                    itemRow.imageBorderColor = "#F0E2DF"
                    itemRow.imageBackground = "#FFFCFD"
                }
                onExited: {
                    itemRow.background = "transparent"
                    itemRow.bordercolor = "transparent"
                    itemRow.highlightcolor = "#676664"
                    itemRow.textcolor = "#A4A3A1"
                    itemRow.imageBorderColor = "#EFE9EB"
                    itemRow.imageBackground = "#FFFEFF"
                }
                onClicked: {
                    var currentFileItem = dirModel.itemForIndex(index)
                    if(currentFileItem.isDir) {
                        urlWrapper.url = dirModel.get(index).url
                    } else {
                        currentFileItem.run()
                    }
                }
            }

            Rectangle {
                width: parent.width - 1 // needed for the border. The entire border should be "inline" in Qt5. Not so in Qt4.
                height: parent.height
                color: itemRow.background
                border.color: itemRow.bordercolor
                border.width: 1
                radius: 5

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    spacing: 5
                    Item {
                        width: 0.1
                        height: 32
                    }
                    Rectangle {
                        id: imageIcon
                        width: 32
                        height: 32
                        color: itemRow.imageBackground
                        border.color: itemRow.imageBorderColor
                        border.width: 1
                        KGraphicsItem {
                            width: 24
                            height: 24
                            anchors.centerIn: parent
                            icon: decoration
                        }
                    }
                    Flow {
                        anchors.verticalCenter: parent.verticalCenter
                        width: items.width - imageIcon.width
                        Text {
                            color: itemRow.highlightcolor
                            text: BaseName
                            font.bold: true
                            elide: Text.ElideRight
                        }
                        Text {
                            color: itemRow.textcolor
                            text: Extension
                        }
                    }
                    Text {
                        width: date.width
                        anchors.verticalCenter: parent.verticalCenter
                        color: itemRow.textcolor
                        text: TimeString
                        elide: Text.ElideRight
                    }
                    Text {
                        width: type.width
                        anchors.verticalCenter: parent.verticalCenter
                        color: itemRow.textcolor
                        text: MimeComment
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    ListView {
        property int iconWidth: 48
        property int iconHeight: 48
        property int textWidth: iconWidth * 2 - (itemHorizontalSpacing * 2)
        property int itemWidth: iconWidth * 2
        property int itemHeight: iconHeight + 40
        property int itemHorizontalSpacing: 5
        property int itemVerticalSpacing: 5
        property int newCellWidthValue: 0

        id: list
        clip: true
//        anchors.fill: parent
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        model: dirModel
        cacheBuffer: 100
        spacing: 5
        boundsBehavior: Flickable.StopAtBounds

        delegate: listDelegate
    }
}
