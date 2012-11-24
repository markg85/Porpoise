import QtQuick 1.1
import Porpoise 0.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import "javascript/fontawesome.js" as FontAwesome

Rectangle {
    id: root
    width: 800
    height: 600

    // Load the "FontAwesome" font for the monochrome icons.
    FontLoader {
        source: "fonts/fontawesome-webfont.ttf"
    }

    // This one needs to be "above" others. Data from the KUrlWrapper is required in several places.
    // To prevent duplication it's created in the main file and passed to the elements that need is.
    KUrlWrapper {
        id: urlWrapper
        url: "~/"

        onUrlChanged: {
            console.log("*************** onUrlChanged: " + url)
        }
    }

    Rectangle {
        id: head
        height: 100
        width: parent.width
        color: "grey"
        z: 2


        Item {
            width: parent.width
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            Rectangle {
                id: leftButtons
                width: 99
                height: 30
                color: "red"
                Row {
                    width: parent.width
                    height: parent.height
                    Item {
                        width: parent.width / 3
                        height: parent.height
                        FontAwesomeIcon {
                            anchors.fill: parent
                            iconName: FontAwesome.Icon.ChevronLeft
                            font.pointSize: 15
                        }
                    }
                    Item {
                        width: parent.width / 3
                        height: parent.height
                        FontAwesomeIcon {
                            anchors.fill: parent
                            iconName: FontAwesome.Icon.ChevronRight
                            font.pointSize: 15
                        }
                    }
                    Item {
                        width: parent.width / 3
                        height: parent.height

                        FontAwesomeIcon {
                            anchors.fill: parent
                            iconName: FontAwesome.Icon.Refresh
                            font.pointSize: 15
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

            Item {
                id: rightButtons
                width: 30
                height: 30
                anchors.right: parent.right

                FontAwesomeIcon {
                    anchors.fill: parent
                    iconName: FontAwesome.Icon.Cog
                    font.pointSize: 15
                }
            }
        }
    }

    ViewContainer {
        width: parent.width
        anchors.top: head.bottom
        anchors.bottom: parent.bottom
        clip: true
        z: 1
    }




}
