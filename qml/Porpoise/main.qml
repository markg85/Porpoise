import QtQuick 1.1
import Porpoise 0.1

Rectangle {
    width: 800
    height: 600

    // This one needs to be "above" others. Data from the KUrlWrapper is required in several places.
    // To prevent duplication it's created in the main file and passed to the elements that need is.
    KUrlWrapper {
        id: urlWrapper
        url: "~/aaa/bbb/ccc/ddd/eee/fff/ggg/hhh/iii/jjj/kkk"
    }

    BreadcrumbBar {
        urlWrapper: urlWrapper
        height: 30
    }

    Rectangle {
        x: 100
        y: 100
        width: 100
        height: 20
        color: "green"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                urlWrapper.url = "~"
            }
        }
    }
}
