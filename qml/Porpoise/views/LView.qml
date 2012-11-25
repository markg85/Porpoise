import QtQuick 1.1
import Porpoise 0.1
import "../javascript/util.js" as JsUtil

// LView because the full name: "ListView" would be confusing with the default QML component ListView.

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

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    itemBackground.color = JsUtil.Theme.ViewContainer.ItemStates.hover.color
                    itemBackground.border.color = JsUtil.Theme.ViewContainer.ItemStates.hover.borderColor
                    content.color = JsUtil.Theme.ViewContainer.ContentStates.hover.highlight
                    normalTextOne.color = JsUtil.Theme.ViewContainer.ContentStates.hover.color
                    normalTextTwo.color = JsUtil.Theme.ViewContainer.ContentStates.hover.color
                    normalTextThree.color = JsUtil.Theme.ViewContainer.ContentStates.hover.color
                    imageIcon.color = JsUtil.Theme.ViewContainer.ItemStates.hover.imageBackground
                    imageIcon.border.color = JsUtil.Theme.ViewContainer.ItemStates.hover.imageBorderColor
                }
                onExited: {
                    itemBackground.color = JsUtil.Theme.ViewContainer.ItemStates.normal.color
                    itemBackground.border.color = JsUtil.Theme.ViewContainer.ItemStates.normal.borderColor
                    content.color = JsUtil.Theme.ViewContainer.ContentStates.normal.highlight
                    normalTextOne.color = JsUtil.Theme.ViewContainer.ContentStates.normal.color
                    normalTextTwo.color = JsUtil.Theme.ViewContainer.ContentStates.normal.color
                    normalTextThree.color = JsUtil.Theme.ViewContainer.ContentStates.normal.color
                    imageIcon.color = JsUtil.Theme.ViewContainer.ItemStates.normal.imageBackground
                    imageIcon.border.color = JsUtil.Theme.ViewContainer.ItemStates.normal.imageBorderColor
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
                id: itemBackground
                width: parent.width - 1 // needed for the border. The entire border should be "inline" in Qt5. Not so in Qt4.
                height: parent.height
                color: JsUtil.Theme.ViewContainer.ItemStates.normal.color
                border.color: JsUtil.Theme.ViewContainer.ItemStates.normal.borderColor
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
                        color: JsUtil.Theme.ViewContainer.ItemStates.normal.imageBackground
                        border.color: JsUtil.Theme.ViewContainer.ItemStates.normal.imageBorderColor
                        border.width: 1
                        KGraphicsItem {
                            width: 28
                            height: 28
                            anchors.centerIn: parent
                            icon: decoration
                        }
                    }
                    Flow {
                        anchors.verticalCenter: parent.verticalCenter
                        width: items.width - imageIcon.width
                        Text {
                            id: content
                            color: JsUtil.Theme.ViewContainer.ContentStates.normal.highlight
                            text: BaseName
                            font.bold: true
                            elide: Text.ElideRight
                        }
                        Text {
                            id: normalTextOne
                            color: JsUtil.Theme.ViewContainer.ContentStates.normal.color
                            text: Extension
                        }
                    }
                    Text {
                        id: normalTextTwo
                        width: date.width
                        anchors.verticalCenter: parent.verticalCenter
                        color: JsUtil.Theme.ViewContainer.ContentStates.normal.color
                        text: TimeString
                        elide: Text.ElideRight
                    }
                    Text {
                        id: normalTextThree
                        width: type.width
                        anchors.verticalCenter: parent.verticalCenter
                        color: JsUtil.Theme.ViewContainer.ContentStates.normal.color
                        text: MimeComment
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    ListView {

        id: list
        clip: true
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
