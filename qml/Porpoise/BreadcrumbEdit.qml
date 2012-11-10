import QtQuick 1.1
import Porpoise 0.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtraComponents

Item {
    id: bcEditRoot

    PlasmaComponents.TextField {
        id: bcEdit
        anchors.fill: parent
        property string currentValue: ""
        property string lastValue: ""
        clearButtonShown: true
        focus: true
        text: {
            if(bcBar.urlWrapper.protocol === "file") {
                // For the local filesystem it's easier to just show the path without file:// infront of it.
                return bcBar.urlWrapper.path
            }
            return bcBar.urlWrapper.url
        }

        Keys.onReleased:
        {

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
            currentValue = completionWrapper.previousMatch()
            console.log(currentValue)
        }
        Keys.onDownPressed: {
            currentValue = completionWrapper.nextMatch()
            console.log(currentValue)
        }
        Keys.onTabPressed: {

    //        currentValue = completionWrapper.nextMatch()
            console.log("Keys.onTabPressed: " + currentValue)

            if(currentValue !== "") {
                console.log("Keys.onTabPressed 2: " + currentValue)
                select(text.lastIndexOf("/") + 1, text.length)
                cut()
                text += currentValue + "/"
                currentValue = ""
            }

        }

        Keys.onLeftPressed: {
            text = text.slice(0, -1)
        }

        Keys.onRightPressed: {
            var searchString = text.substring(text.lastIndexOf("/") + 1)
            text += currentValue.charAt(searchString.length)
            attemptCompletion()
        }

        onTextChanged: {
            console.log("(JS) TextChanged")
            completionWrapper.setUrl(text)

            var searchString = text.substring(text.lastIndexOf("/") + 1)

            if(searchString == "" && text != "") {
                var rect = positionToRectangle(cursorPosition);
                completerText.x = rect.x + 6
                completerText.text = lastValue
            }

            if(text == "") {
                completerText.text = ""
            }
        }

        function attemptCompletion() {
            var searchString = text.substring(text.lastIndexOf("/") + 1)

            lastValue = currentValue;
            console.log("(JS) attemptCompletion")
            console.log("(JS) -> TEXT: " + text)
            console.log("(JS) -> lastValue: " + lastValue)

            currentValue = completionWrapper.nextMatch()
            completerText.text = currentValue.substring(searchString.length)

            var rect = positionToRectangle(cursorPosition);
            completerText.x = rect.x + 6
            console.log("(JS) -> searchString: " + searchString)
            console.log("(JS) -> currentValue: " + currentValue)

        }

        Text {
            id: completerText
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.25
        }

        KCompletionWrapper {
            id: completionWrapper

            onResultsChanged: {
                console.log("results changed!! >> " + results)
                bcEdit.attemptCompletion()
            }
        }
    }

    Column {
        anchors.top: bcEdit.bottom
        Repeater {
            model: completionWrapper.results
            Text {
                text: modelData
            }
        }
    }
}


