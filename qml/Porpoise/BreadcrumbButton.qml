import QtQuick 1.1
import "javascript/util.js" as JsUtil

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
    property int arrawRectHeightAndWidth: 10 // The height is also the width
    property int textRectWidth: buttonText.width + (additionalTextMargin * 2)

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

    Item {
        id: textRect
        width: textRectWidth + ((lastItem) ? 0 : arrawRectHeightAndWidth)
        height: bcButton.height

        Item {
            width: textRectWidth
            height: parent.height
            Text {
                id: buttonText
                anchors.centerIn: parent
                text: modelData
                font.bold: bcButton.lastItem
                color: {
                    if(bcButton.lastItem) {
                        return JsUtil.Theme.BreadCrumb.fontColorActive.normal
                    } else {
                        return JsUtil.Theme.BreadCrumb.fontColorInactive.normal
                    }
                }


                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        bcButton.lastItem = true
                        repeaterElement.parent.breadcrumbButtonPressed(index)
                        if(bcBar.currentPopup) {
                            bcBar.currentPopup.closePopup()
                        }

                        console.log("BreadcrumbButton Clicked")
                    }
                    onEntered: {
                        if(bcButton.lastItem) {
                            buttonText.color = JsUtil.Theme.BreadCrumb.fontColorActive.hover
                        } else {
                            buttonText.color = JsUtil.Theme.BreadCrumb.fontColorInactive.hover
                        }
                    }
                    onExited: {
                        if(bcButton.lastItem) {
                            buttonText.color = JsUtil.Theme.BreadCrumb.fontColorActive.normal
                        } else {
                            buttonText.color = JsUtil.Theme.BreadCrumb.fontColorInactive.normal
                        }
                    }
                }
            }
        }

        BreadcrumbDropdown {
            onEntryClicked: {
                repeaterElement.parent.breadcrumbButtonAddAfterIndex(index, entryName)

                var obj = repeaterElement.contentItem.children[index + 1]
                if(obj) {
                    obj.lastItem = true
                }
            }

            anchors.right: textRect.right
            height: bcButton.height
            width: arrawRectHeightAndWidth
            visible: !lastItem
        }
    }
}
