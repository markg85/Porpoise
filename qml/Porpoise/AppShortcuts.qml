import QtQuick 1.1
import Porpoise 0.1

/**
  This file defines components that should only be added once.
 */

Item {
    // Clipboard
    Clipboard { id: clip }

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
        id: test
        onActivated: {
            console.log("JS: " + key + " pressed.")
            console.log("JS: StandardKey: " + StandardKey.Save)
            console.log("JS: StandardKey: " + Shortcut.Save)
            console.log("JS: StandardKey: " + test.Save)
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
            clip.paste(urlWrapper.url)
        }
    }
}
