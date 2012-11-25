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

        onCountChanged: {
            var newCount = count - 1;

            // Change the back button if needed
            if(currentUrlIndex > 0) {
                backButton.normalColor = JsUtil.Theme.ToolButtons.normal
                backButton.hoverColor = JsUtil.Theme.ToolButtons.hover
            } else {
                backButton.normalColor = JsUtil.Theme.ToolButtons.disabledColor
                backButton.hoverColor = backButton.normalColor
            }

            console.log("JS: currentUrlIndex = " + currentUrlIndex + " count = " + (newCount + 1))

            // Change the forward button if needed
            if(currentUrlIndex < newCount ) {
                forwardButton.normalColor = JsUtil.Theme.ToolButtons.normal
                forwardButton.hoverColor = JsUtil.Theme.ToolButtons.hover
            } else {
                forwardButton.normalColor = JsUtil.Theme.ToolButtons.disabledColor
                forwardButton.hoverColor = forwardButton.normalColor
            }
        }

        onCurrentUrlChanged: {
            console.log("JS: onCurrentUrlChanged to: " + currentUrl)
            urlWrapper.preventUndoRedoAdd = true
            urlWrapper.url = currentUrl
            urlWrapper.preventUndoRedoAdd = false
        }

    }

    Item {
        id: head
        height: 100
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
                        normalColor: JsUtil.Theme.ToolButtons.disabledColor

                        onClicked: {
                            // First go to the previous URL
                            undoRedo.previousUrl()
                        }

//                        normalColor: JsUtil.Theme.ToolButtons.normal
//                        hoverColor: JsUtil.Theme.ToolButtons.hover
                    }
                    FontAwesomeIcon {
                        id: forwardButton
                        width: parent.width / 3
                        height: parent.height
                        iconName: JsUtil.FA.ChevronRight
                        normalColor: JsUtil.Theme.ToolButtons.disabledColor

                        onClicked: {
                            undoRedo.nextUrl()
                        }

//                        normalColor: JsUtil.Theme.ToolButtons.normal
//                        hoverColor: JsUtil.Theme.ToolButtons.hover
                    }
                    FontAwesomeIcon {
                        width: parent.width / 3
                        height: parent.height
                        iconName: JsUtil.FA.Refresh
                        normalColor: JsUtil.Theme.ToolButtons.normal
                        hoverColor: JsUtil.Theme.ToolButtons.hover

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
                normalColor: JsUtil.Theme.ToolButtons.normal
                hoverColor: JsUtil.Theme.ToolButtons.hover
            }
        }
    }

    ViewContainer {
        id: viewContainer
        width: parent.width
        anchors.top: head.bottom
        anchors.bottom: parent.bottom
        clip: true
        z: 1
    }
}
