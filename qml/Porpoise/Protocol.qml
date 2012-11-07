// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    property variant urlWrapper: 0

    Rectangle {
        width: 200
        height: 50
        color: "red"

        Text {
            anchors.centerIn: parent
            text: urlWrapper.protocol
        }
    }
}
