import QtQuick 1.1
import "javascript/util.js" as JsUtil

Item {
    property bool splitView: false
    property int contentWidth: width / ((splitView) ? 2 : 1)
    property ViewContainer activeViewContainer: leftView
    property string initUrl: ""

    ViewContainer {
        id: leftView
        anchors.left: parent.left
        anchors.right: viewSplitter.left
        height: parent.height
        initUrl: parent.initUrl
        clip: true

        onActiveViewChanged: {
            if(activeView) {
                activeViewContainer.activeView = false
                activeViewContainer = leftView
            }
        }
    }

    Item {
        id: viewSplitter
        width: 5
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        height: parent.height
        visible: parent.splitView

        x: parent.contentWidth

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
        id: rightView
        anchors.left: viewSplitter.right
        anchors.right: parent.right
        height: parent.height
        initUrl: parent.initUrl
        enabled: parent.splitView
        clip: true
        activeView: false // There can only be one view active at any given time.

        onActiveViewChanged: {
            if(activeView) {
                activeViewContainer.activeView = false
                activeViewContainer = rightView
            }
        }
    }
}
