import QtQuick 1.1
import Porpoise 0.1
import "javascript/util.js" as JsUtil

Item {

    signal reload()
    signal updateUrl(string externalUrl)
    property string initUrl: ""
    property bool activeView: true
    property color viewBackgroundColor: (activeView) ? JsUtil.Theme.ViewContainer.Views.active : JsUtil.Theme.ViewContainer.Views.inactive

    onReload: {
        dirModel.reload()
    }

    onUpdateUrl: {
        dirModel.url = externalUrl
    }

    onInitUrlChanged: {
        if(enabled) {
            dirModel.url = initUrl
        }
    }

    DirModel {
        id: dirModel

        // It's advised to set the tumbnail with and height to the max size that the thumbnail will ever be.
        // Then scale it down further in KGraphicsItem by setting the width and height in there to a smaller or equal size as the ones you set here.
        // Doing this will make the same thumbnail usable in multiple views with different sizes.
        thumbWidth: 128
        thumbHeight: 128
    }

    state: "list"

    /**
      In the most ideal situation this list should also be build up dynamically. Either based on a config file or by reading the folder that contains the views.
      I guess a config file would be best. in that case it should have at least the following per view:
      - Name (icon, list, tree, ...)
      - Icon (the FontAwesome icon to use for the view
      - File (IconView.qml for icon ... you get the point)
     */
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
