import QtQuick 1.1

Item {
    id: bcButton
    width: textRectWidth + ((lastItem) ? 0 : arrawRectHeightAndWidth)
    height: bcBar.height

    transformOrigin: Item.Left

    property string test: modelData
    property int angle: 0 // just to keep the rotate animation silent..
    property int animationTime: 0
    property int pauseTime: 0
    property bool lastItem: false

    // Used for calculationg the width of this button. This included the ">" arrow.
    property int additionalTextMargin: 5 // left and right
    property int arrawRectHeightAndWidth: height // The height is also the width
    property int textRectWidth: 0

    Component.onCompleted: {
        // Doing this "binding" (assigning) in here so that the value isn't bound to buttonText.width.
        textRectWidth = buttonText.width + (additionalTextMargin * 2)
    }

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

    Rectangle {
        id: textRect
        width: textRectWidth + ((lastItem) ? 0 : arrawRectHeightAndWidth)
        height: bcButton.height
        color: "orange"

        Item {
            width: textRectWidth
            height: parent.height
            Text {
                id: buttonText
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
    }
}
