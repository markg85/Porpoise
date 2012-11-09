// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {

    id: bcDropdown

    signal closePopup()

    onClosePopup: {
        arrowImage.state = "normal"
    }


    Image {
        id: arrowImage
        anchors.centerIn: parent
        source: "arrowIcon.png"

        states: [
            State {
                name: "normal"
                PropertyChanges { target: arrowImage; rotation: 0 }
                PropertyChanges { target: arrowContainer; popupShown: false }
                PropertyChanges { target: popup; state: "hide" }
            },
            State {
                name: "rotateDown"
                PropertyChanges { target: arrowImage; rotation: 90 }
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
            hoverEnabled: true
            onEntered: {
//                parent.color = "purple"
            }
            onExited: {
                parent.color = "transparent"
            }
            onClicked: {
                if(parent.popupShown) {
                    arrowImage.state = "normal"
                } else {
                    if(bcBar.currentPopup) {
                        bcBar.currentPopup.closePopup()
                    }

                    // This line _must_ be after the lines above! Do not change!
                    arrowImage.state = "rotateDown"
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
}
