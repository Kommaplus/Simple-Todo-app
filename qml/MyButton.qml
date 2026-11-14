import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: root
    width: paret.width
    height: hoejde
    radius: 20

    color: mouse.pressed ? "#404444" : root.buttonColor

    property color buttonColor: "#1009bb"
    property color tekstFarve: "yellow"
    property color kantFarve: "transparent"
    property int tekstStoerrelse: 32
    property int hoejde: 100
    property int bredde: 600
    property string label: "Button"
    property string ikon: ""
    signal clicked

    border.color: kantFarve
    border.width: kantFarve === "transparent" ? 0 : 3

    Row {

        anchors.left: parent.left 
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Text {
            text: root.ikon
            visible: root.ikon !== ""
            color: root.tekstFarve
            font.pixelSize: root.tekstStoerrelse
        }

        Text {
            text: root.label
            visible: root.label !== ""
            color: root.tekstFarve
            font.pixelSize: root.tekstStoerrelse
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Behavior on color { ColorAnimation { duration: 500 } }
}
