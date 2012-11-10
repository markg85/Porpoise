import QtQuick 1.1

Item {

    id: bcBar


    property variant urlWrapper: 0
    property variant currentPopup: 0

    state: "normal"

    states: [
        State {
            name: "normal"
            PropertyChanges { target: crumbContentLoader; source: "BreadcrumbCrumbs.qml" }
        },
        State {
            name: "edit"
            PropertyChanges { target: crumbContentLoader; source: "BreadcrumbEdit.qml" }
        }
    ]

    Loader {

        anchors.fill: parent
        id: crumbContentLoader
    }

    Component.onCompleted: {
        console.log("1: GlobalPathModel " + GlobalPathModel)
        console.log("2: Util " + Util.pathModel())
        console.log("3: Search test: " + Util.testSearchString())
    }
}

