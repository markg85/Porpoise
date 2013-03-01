import QtQuick 1.1
import Porpoise 0.1
import "javascript/util.js" as JsUtil

Item {

    id: bcDropdown

    signal closePopup()
    signal entryClicked(string entryName)

    onClosePopup: {
        arrowSymbol.state = "normal"
    }

    Text {
        id: arrowSymbol
        property int pointSize: 6
        y: (parent.height / 2) + 3 - pointSize // Somehow this font is some "points" off... Thus centering manually.
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "FontAwesome"
        text: JsUtil.FA.ChevronRight
        font.pointSize: pointSize

        states: [
            State {
                name: "normal"
                PropertyChanges { target: arrowSymbol; rotation: 0 }
                PropertyChanges { target: arrowContainer; popupShown: false }
                PropertyChanges { target: popup; state: "hide" }
            },
            State {
                name: "rotateDown"
                PropertyChanges { target: arrowSymbol; rotation: 90 }
                PropertyChanges { target: arrowContainer; popupShown: true }
                PropertyChanges { target: popup; state: "show" }
                PropertyChanges { target: bcBar; currentPopup: bcDropdown }
            }
        ]
        transitions: [
            Transition {
                to: "normal"
                RotationAnimation { duration: 150; direction: RotationAnimation.Counterclockwise }
            },
            Transition {
                to: "rotateDown"
                RotationAnimation { duration: 150; direction: RotationAnimation.Clockwise }
            }
        ]
    }

    Rectangle {
        id: arrowContainer
        anchors.fill: parent
        color: "transparent"
        property bool popupShown: false

        MouseArea {
            anchors.fill: parent
            onEntered: {
//                parent.color = "purple"
            }
            onExited: {
                parent.color = "transparent"
            }
            onClicked: {
                if(parent.popupShown) {
                    arrowSymbol.state = "normal"
                } else {
                    if(bcBar.currentPopup) {
                        bcBar.currentPopup.closePopup()
                    }

                    // This line _must_ be after the lines above! Do not change!
                    arrowSymbol.state = "rotateDown"
                }
            }
        }
    }

    Rectangle {
        id: popup
        opacity: 0.0
        anchors {
            left: bcDropdown.left
            top: bcDropdown.bottom
        }
        width: 200
        height: 0
        color: "red"
        clip: true

        ListView {
            anchors.fill: parent
            model: completionForDirList.results

            delegate: Text {
                text: modelData
            }
        }

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                // This is obviously stub. The text of the elemant that is "selected" should be send to entryClicked.
//                //bcDropdown.entryClicked("some_test_text_to_test_if_this_works")
//                console.log("Current URL till index: " + urlWrapper.urlTillIndex(index))
//            }
//        }

        states: [
            State {
                name: "hide"
            },
            State {
                name: "show"
            }
        ]
        transitions: [
            Transition {
                to: "show"
                NumberAnimation { target: popup; properties: "opacity"; to: 1.0; duration: 150 }
                NumberAnimation { target: popup; properties: "height"; to: 300; duration: 150 }
            },
            Transition {
                to: "hide"
                NumberAnimation { target: popup; properties: "opacity"; to: 0.0; duration: 150 }
                NumberAnimation { target: popup; properties: "height"; to: 0; duration: 150 }
            }
        ]
    }

    KCompletionWrapper {
        id: completionForDirList
        Component.onCompleted: {
            setUrl(urlWrapper.urlTillIndex(index))
        }
    }
}
