import QtQuick 1.1
import Porpoise 0.1

/**
  This file defines the application wide shortcuts and acts on them.
  This file should only be used ONCE!
 */

Item {
    // refresh
    Shortcut {
        key: "F5"
        onActivated: {
            splitView.activeViewContainer.reload()
        }
    }

    // copy
    Shortcut {
        key: "Ctrl+C"
        onActivated: {
            console.log("JS: " + key + " pressed.")
        }
    }

    // cut
    Shortcut {
        key: "Ctrl+X"
        onActivated: {
            console.log("JS: " + key + " pressed.")
        }
    }

    // paste
    Shortcut {
        key: "Ctrl+V"
        onActivated: {
            console.log("JS: " + key + " pressed.")
        }
    }
}
