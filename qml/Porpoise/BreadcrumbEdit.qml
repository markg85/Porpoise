import QtQuick 1.1
import Porpoise 0.1

Item {
    id: bcEditRoot

    TextInput {
        id: bcEdit
        anchors.verticalCenter: parent.verticalCenter
        x: 5
        width: parent.width - x

        property string currentValue: ""
        property string lastValue: ""
        property bool fromLeftArrow: false
        focus: true
        text: {
            if(bcBar.urlWrapper.protocol === "file") {
                // For the local filesystem it's easier to just show the path without file:// infront of it.
                return bcBar.urlWrapper.path
            }
            return bcBar.urlWrapper.url
        }

        Keys.onReleased: {
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
            {
                bcBar.urlWrapper.url = text
                bcBar.state = "normal"
            }

            if (event.key === Qt.Key_Escape)
            {
                bcBar.state = "normal"
            }
        }

        Keys.onUpPressed: {
            var searchString = text.substring(text.lastIndexOf("/") + 1)
            currentValue = completionWrapper.previousMatch()
            completerText.text = currentValue.substring(searchString.length)
            setCompleterPosition()
            console.log(currentValue)
        }

        Keys.onDownPressed: {
            var searchString = text.substring(text.lastIndexOf("/") + 1)
            currentValue = completionWrapper.nextMatch()
            completerText.text = currentValue.substring(searchString.length)
            setCompleterPosition()
            console.log(currentValue)
        }

        Keys.onTabPressed: {

            console.log("Keys.onTabPressed: " + currentValue)

            if(currentValue !== "") {
                console.log("Keys.onTabPressed 2: " + currentValue)
                text += completerText.text + "/"
                completerText.text = ""
                currentValue = ""
            }
        }

        Keys.onRightPressed: {
            text += completerText.text.charAt(0)
        }

        Keys.onPressed: {
            if(event.key === Qt.Key_Left || event.key === Qt.Key_Backspace) {
                fromLeftArrow = true
            }
        }

        onTextChanged: {

            console.log("(JS) TextChanged to: " + text)
            console.log("(JS) URL send to KCompletionWrapper: " + text)
            completionWrapper.setUrl(text)
            setCompleterPosition()
        }

        function attemptCompletion() {
            if(text == "") {
                completerText.text = ""
                return;
            }

            var searchString = text.substring(text.lastIndexOf("/") + 1)

            console.log("(JS) attemptCompletion")
            console.log("(JS) -> TEXT: " + text)
            console.log("(JS) -> lastValue: " + lastValue)

            // If we move left (char by char) we eventually hit the "/". Once that happens we use the last known value as completion text.
            if(fromLeftArrow && searchString == "") {
                console.log("(JS) -> fromLeftArrow true. Setting lastValue as completer text: " + lastValue)
                completerText.text = lastValue

            } else {
                console.log("(JS) -> fromLeftArrow false. Setting completer text from nextMatch: " + currentValue)
                completerText.text = currentValue.substring(searchString.length)
            }

            console.log("(JS) -> searchString: " + searchString)

            fromLeftArrow = false

            setCompleterPosition()

            lastValue = currentValue;
        }

        function setCompleterPosition() {
            console.log("(JS) setCompleterPosition")
            var rect = positionToRectangle(cursorPosition);
            completerText.x = rect.x
            console.log("(JS) -> currentValue: " + currentValue)
        }

        Text {
            id: completerText
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.25

            onTextChanged: {
                console.log("(JS) completerText: " + text)
            }
        }

    }

    KCompletionWrapper {
        id: completionWrapper

        onResultsChanged: {
            console.log("results changed!! >> " + results)
            if(results.length > 0) {
                bcEdit.currentValue = nextMatch()
                bcEdit.attemptCompletion()
            } else {
                bcEdit.currentValue = ""
                completerText.text = bcEdit.currentValue
            }
        }
    }

    ListView {
        anchors.top: bcEdit.bottom
        width: parent.width
        height: 100
        clip: true;
        model: completionWrapper.results

        delegate: Text {
            text: modelData
        }
    }
}


