import QtQuick 1.1

Item {

    property variant urlWrapper: 0

    Row {
        Repeater {
            model: urlWrapper.pathModel
            delegate: BreadcrumbButton {}
        }
    }
}
