import QtQuick 1.1

Item {
    id: bcButton
    width: 100
    height: 30
    transformOrigin: Item.Left

    property string test: modelData
    property int angle: 0 // just to keep the rotate animation silent..
    property int animationTime: 0
    property int pauseTime: 0
    property bool lastItem: false

    signal bottonPressed(int modelIndex)

    function removeElement(iAnimationTime, iPrePauseTime) {
        bcButton.animationTime = iAnimationTime
        bcButton.pauseTime = iPrePauseTime
        animation.start()
    }

    SequentialAnimation {
        id: animation
        PauseAnimation { duration: bcButton.pauseTime }
        ParallelAnimation {
            NumberAnimation { target: bcButton; properties: "opacity,width"; to: 0; duration: bcButton.animationTime; }
            NumberAnimation { target: bcButton; property: "y"; to: 50; duration: bcButton.animationTime; }
            NumberAnimation { target: bcButton; property: "scale"; to: 0; duration: bcButton.animationTime; }
            RotationAnimation { target: bcButton; to: 180; }
        }
    }

    Text {
        anchors.centerIn: parent
        text: index + " - " + modelData
        font.bold: bcButton.lastItem

        MouseArea {
            anchors.fill: parent
            onClicked: {
                bcButton.lastItem = true
                bcButton.parent.parent.breadcrumbButtonPressed(index)
            }
        }
    }
}
