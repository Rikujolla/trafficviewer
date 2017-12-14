import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: updateBox
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 0.6
        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        id: dialogWindow
        width: Screen.width*8/9
        height: Screen.height*4/10
        anchors.centerIn: parent
        IconButton {
            id: aboutIcon
            anchors.top: parent.top
            anchors.right: parent.right
            icon.source: "image://theme/icon-m-close?" + (pressed
                                                          ? Theme.highlightColor
                                                          : Theme.secondaryHighlightColor)
            onClicked: {
                updateBox.destroy()
            }
        }
    }

    Rectangle{
        width: Screen.width*7/9
        height:Screen.height*2/10
        anchors.centerIn: parent
        Text {
            height: parent.height
            width: parent.width*8/9
            wrapMode: Text.Wrap
            text: qsTr("Due to the change in data source the database has to be edited before the use of the app. Press Make history button from settings to be able to continue the app usage.")
        }
    }

}
