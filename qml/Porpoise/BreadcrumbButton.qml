import QtQuick 1.1

Rectangle {
    width: 100
    height: 30

    Text {
        anchors.centerIn: parent
        text: index + " - " + modelData
    }
}
