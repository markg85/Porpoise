import QtQuick 1.1
import Porpoise 0.1

Rectangle {
    width: 800
    height: 600

    // This one needs to be "above" others. Data from the KUrlWrapper is required in several places.
    // To prevent duplication it's created in the main file and passed to the elements that need is.
    KUrlWrapper {
        id: urlWrapper
        url: "~"
    }

    Protocol {
        urlWrapper: urlWrapper
        x: 20
        y: 50
    }

    BreadcrumbBar {
        urlWrapper: urlWrapper
    }


    Rectangle {
        x: 100
        y: 100
        width: 100
        height: 100
        color: "blue"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                urlWrapper.url = "ftp.nluug.nl/pub/bla/blabla"
                parent.color = "red"
            }
        }
    }
}
