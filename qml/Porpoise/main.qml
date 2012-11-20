import QtQuick 1.1
import Porpoise 0.1
import org.kde.plasma.components 0.1 as PlasmaComponents

Rectangle {
    width: 800
    height: 600

    // Load the "FontAwesome" font for the monochrome icons.
    FontLoader {
        source: "fonts/fontawesome-webfont.ttf"
    }

    // This one needs to be "above" others. Data from the KUrlWrapper is required in several places.
    // To prevent duplication it's created in the main file and passed to the elements that need is.
    KUrlWrapper {
        id: urlWrapper
        url: "~/"

        onUrlChanged: {
            console.log("*************** onUrlChanged: " + url)
        }
    }

    BreadcrumbBar {
        id: breadCrumbBar
        urlWrapper: urlWrapper
        height: 30
        width: parent.width
        z: 2
    }

    ViewContainer {
        width: parent.width
        anchors.top: breadCrumbBar.bottom
        anchors.bottom: parent.bottom
        z: 1
    }
}
