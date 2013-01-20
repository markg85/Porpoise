import QtQuick 1.1
import Porpoise 0.1
import "../javascript/util.js" as JsUtil

// LView because the full name: "ListView" would be confusing with the default QML component ListView.

Item {

    Row {
        id: header
        width: parent.width - 10
        spacing: 5

        Text {
            id: items
            width: parent.width * 0.50
            anchors.verticalCenter: parent.verticalCenter
            font.italic: true
            font.bold: true
            text: dirModel.count + " items"
            color: JsUtil.Theme.ViewContainer.HeaderNames.normal.color
        }

        Text {
            id: date
            width: parent.width * 0.30
            anchors.verticalCenter: parent.verticalCenter
            font.italic: true
            font.bold: true
            text: "date"
            color: JsUtil.Theme.ViewContainer.HeaderNames.normal.color
        }

        Text {
            id: type
            width: parent.width * 0.20
            anchors.verticalCenter: parent.verticalCenter
            font.italic: true
            font.bold: true
            text: "type"
            color: JsUtil.Theme.ViewContainer.HeaderNames.normal.color
        }
    }
    Item {
        anchors.top: header.bottom
        id: spacing
        height: 5
        width: 1
    }

    Rectangle {
        id: divLine
        anchors.top: spacing.bottom
        width: parent.width
        height: 1
        color: JsUtil.Theme.Application.divider.color
    }

    Item {
        anchors.top: divLine.bottom
        id: spacingTwo
        height: 1
        width: 1
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
                    list.mouseEvent()
                    var currentFileItem = dirModel.itemForIndex(index)
                    if(currentFileItem.isDir) {
                        urlWrapper.url = currentFileItem.url
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
                        Image {
                            width: 28
                            height: 28
                            sourceSize.width: width
                            sourceSize.height: height
                            anchors.centerIn: parent
                            source: MimeOrThumb
                            asynchronous: true
                        }
                    }
                    /**
                     *  Note: The Flow below is required to put the filename + extension on one line.
                     *  And that is done in two separate elements because both have a different style.
                     *  The downside here is eliding. It's not working because it are two elements.
                     *  I tried using the HTML eliding way by puttin both text in one html string,
                     *  but that seems to present some issues in terms of width.
                     */
                    Flow {
                        anchors.verticalCenter: parent.verticalCenter
                        width: items.width - imageIcon.width - 10 // that 10 is for 2x spacing
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
                        text: Type
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    Rectangle {
        id: focusColor
        color: parent.parent.parent.viewBackgroundColor
        width: parent.width
        anchors.top: spacingTwo.bottom
        anchors.bottom: parent.bottom

        ListView {

            signal mouseEvent()

            id: list
            clip: true
            anchors.fill: parent
            model: dirModel
            cacheBuffer: 100
            spacing: 5
            boundsBehavior: Flickable.StopAtBounds

            onMouseEvent: {
                parent.parent.parent.parent.activeView = true
            }

//            onContentYChanged: {
//                // toooo much parent....
//                // This causes a lot of needless signals..
//                parent.parent.parent.parent.activeView = true
//            }

            delegate: listDelegate
        }
    }

}
