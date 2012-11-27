import QtQuick 1.1
import Porpoise 0.1

/**
  This file defines the application wide shortcuts and acts on them.
  This file should only be used ONCE!
 */

Item {
    Shortcut {
        key: Qt.Key_F5
        onActivated: {
            splitView.activeViewContainer.reload()
        }
    }
}
