import QtQuick 1.1
import Porpoise 0.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import "javascript/util.js" as JsUtil

Rectangle {
    id: root
    width: 800
    height: 600
    color: JsUtil.Theme.Application.background.color

    // Load the "FontAwesome" font for the monochrome icons.
    FontLoader {
        source: "fonts/fontawesome-webfont.ttf"
    }

    // This one needs to be "above" others. Data from the KUrlWrapper is required in several places.
    // To prevent duplication it's created in the main file and passed to the elements that need is.
    KUrlWrapper {
        id: urlWrapper
        url: "~/"
//        url: "/home/mark/Images/"
        property bool preventUndoRedoAdd: false

        onUrlChanged: {
            // We should only add the url changes if they didn't come from KUrlUndoRedo.
            if(!preventUndoRedoAdd) {
                undoRedo.addUrl(url)
            }


            console.log("*************** onUrlChanged: " + url)
        }
        Component.onCompleted: {
            undoRedo.addUrl(url)
        }
    }

    KUrlUndoRedo {
        id: undoRedo

        onCurrentUrlChanged: {
            console.log("JS: onCurrentUrlChanged to: " + currentUrl)
            urlWrapper.preventUndoRedoAdd = true
            urlWrapper.url = currentUrl
            urlWrapper.preventUndoRedoAdd = false
        }

    }

    Item {
        id: head
        height: 75
        width: parent.width
        z: 2


        Item {
            width: parent.width
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            Item {
                id: leftButtons
                width: 99
                height: 30
                Row {
                    width: parent.width
                    height: parent.height
                    FontAwesomeIcon {
                        id: backButton
                        width: parent.width / 3
                        height: parent.height
                        iconName: JsUtil.FA.ChevronLeft
                        enableMouseEvents: (undoRedo.currentUrlIndex > 0)

                        onClicked: {
                            undoRedo.previousUrl()
                        }
                    }
                    FontAwesomeIcon {
                        id: forwardButton
                        width: parent.width / 3
                        height: parent.height
                        iconName: JsUtil.FA.ChevronRight
                        enableMouseEvents: (undoRedo.currentUrlIndex < (undoRedo.count - 1))

                        onClicked: {
                            undoRedo.nextUrl()
                        }
                    }
                    FontAwesomeIcon {
                        width: parent.width / 3
                        height: parent.height
                        iconName: JsUtil.FA.Refresh

                        onClicked: {
                            viewContainer.reload()
                        }
                    }
                }
            }

            BreadcrumbBar {
                id: breadCrumbBar
                urlWrapper: urlWrapper
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: leftButtons.right
                anchors.right: rightButtons.left
            }

            FontAwesomeIcon {
                id: rightButtons
                width: 30
                height: 30
                anchors.right: parent.right
                iconName: JsUtil.FA.Cog
            }
        }
    }

    Item {
        id: leftContainer
        anchors.left: parent.left
        anchors.right: divederContainer.left
        anchors.top: head.bottom
        anchors.bottom: parent.bottom
    }

    Item {
        id: divederContainer
        width: 5
        anchors.top: head.bottom
        anchors.bottom: parent.bottom

        x: JsUtil.Theme.LeftContainer.width

        Rectangle {
            width: 1
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            color: JsUtil.Theme.Application.divider.color
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis
        }
    }

    ViewContainer {
        id: viewContainer
        anchors.left: divederContainer.right
        anchors.right: parent.right
        anchors.top: head.bottom
        anchors.bottom: parent.bottom
        clip: true
        z: 1
    }
}
