import QtQuick 1.1
import "javascript/util.js" as JsUtil


Item {
    id: faRoot
    property alias font: faIcon.font
    property string iconName: ""
    property alias enableMouseEvents: mouseEvents.visible

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
                color: JsUtil.Theme.ToolButtons.normal
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
        id: mouseEvents
        anchors.fill: parent
        enabled: true
        hoverEnabled: true

        onVisibleChanged: {
            if(!visible) {
                faIcon.color = JsUtil.Theme.ToolButtons.disabledColor
            } else {
                faIcon.color = JsUtil.Theme.ToolButtons.normal
            }
        }

        onClicked: {
            faRoot.clicked()
        }

        onEntered: {
            faIcon.color = JsUtil.Theme.ToolButtons.hover
        }

        onExited: {
            faIcon.color = JsUtil.Theme.ToolButtons.normal
        }
    }
}
