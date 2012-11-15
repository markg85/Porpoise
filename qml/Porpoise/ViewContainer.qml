import QtQuick 1.1
import Porpoise 0.1
import org.kde.qtextracomponents 0.1 as QtExtraComponents
import "views"

Rectangle {

    DirModel {
        id: dirModel
        url: urlWrapper.url
    }

    Component {
        id: iconDelegate

        Column {

            width: 80

            Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
            Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

            QtExtraComponents.QIconItem {
                width: 48
                height: 48
                anchors.horizontalCenter: parent.horizontalCenter
                icon: IconName

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(dirModel.get(index).isDir) {
                            urlWrapper.url = dirModel.get(index).url
                        } else {
                            dirModel.run(index)
                        }

                        console.log("Clicked on index: " + dirModel.get(index).url)
                    }
                }
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
//                text: "Name"
                text: Name
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
        }
    }

    GridView {
        anchors.fill: parent
        model: dirModel
        cacheBuffer: 100
        cellWidth: 80
        cellHeight: 80

        delegate: iconDelegate
    }
}