import QtQuick 1.1
import "javascript/util.js" as JsUtil


Item {
    id: faRoot
    property alias font: faIcon.font
    property string iconName: ""
    property color normalColor: "purple" // Purple, just so you know that you didn't set a color using normalColor and hoverColor.
    property color hoverColor: faIcon.color

    onNormalColorChanged: {
        faIcon.color = normalColor
    }

    signal clicked()

    states: [
        State {
            name: "normal"
            PropertyChanges { target: faIconAnimation; scale: 0.0 }
            PropertyChanges { target: faIconAnimation; opacity: 1.0 }
        },
        State {
            name: "pressed"
            PropertyChanges { target: faIconAnimation; scale: 2.0 }
        }
    ]
    transitions: [
        Transition {
            to: "pressed"

            ParallelAnimation {
                id: parAnim
                NumberAnimation { target: faIconAnimation; properties: "scale"; from: 0.0; to: 3.0; duration: 150 }
                NumberAnimation { target: faIconAnimation; properties: "opacity"; to: 0.0; duration: 150 }
            }
        }
    ]

    Item {
        y: 2
        height: parent.height
        width: parent.width

        Item {
            anchors.fill: parent
            Text {
                smooth: true
                anchors.centerIn: parent
                id: faIcon
                text: faRoot.iconName
                color: faRoot.normalColor
                font.family: "FontAwesome"
                font.pointSize: 15 // 15 seems like a nice default
            }
            Text {
                smooth: true
                opacity: 1.0
                scale: 0.0
                anchors.centerIn: parent
                id: faIconAnimation
                text: faRoot.iconName
                font: faIcon.font
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            faRoot.clicked()
//            faRoot.state = "pressed"
        }

        onEntered: {
            faIcon.color = faRoot.hoverColor
        }

        onExited: {
            faIcon.color = faRoot.normalColor
//            faRoot.state = "normal"
        }
    }
}
