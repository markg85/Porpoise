import QtQuick 1.1
import Porpoise 0.1
import org.kde.qtextracomponents 0.1 as QtExtraComponents
import "views"

Rectangle {

    DirModel {
        id: dirModel
        url: urlWrapper.url
    }


//    ListView {
//        anchors.fill: parent
//        model: dirModel
//        cacheBuffer: 100
//        delegate: Text {
//            text: Name
//        }
//    }

    GridView {
        anchors.fill: parent
        model: dirModel
        cacheBuffer: 100
//        delegate: Text {
//            text: IconName
//        }
        delegate: Column {
                QtExtraComponents.QIconItem {
                width: 48
                height: 48
                icon: IconName

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(dirModel.get(index).isDir) {
                            urlWrapper.url = dirModel.get(index).url
                        }



                        console.log("Clicked on index: " + dirModel.get(index).url)
                    }
                }
            }
                Text {
                    text: Name
                }
        }
    }


}
