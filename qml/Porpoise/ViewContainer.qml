import QtQuick 1.1
import Porpoise 0.1

Rectangle {

    DirModel {
        id: dirModel
        url: urlWrapper.url
    }

    state: "list"

    states: [
        State {
            name: "icon"
            PropertyChanges { target: viewContainer; source: "views/IconView.qml" }
        },
        State {
            name: "list"
            PropertyChanges { target: viewContainer; source: "views/LView.qml" }
        },
        State {
            name: "tree"
            PropertyChanges { target: viewContainer; source: "views/TreeView.qml" }
        }
    ]

    Loader {
        anchors.fill: parent
        id: viewContainer
    }
}
