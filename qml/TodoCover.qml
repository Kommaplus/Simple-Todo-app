import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

CoverBackground {
    id: cover

    function antalAabne() {
        var db = LocalStorage.openDatabaseSync("todo8", "1.0", "Lister", 10000)
        var n = 0
        db.transaction(function (tx) {
            var r = tx.executeSql("SELECT COUNT(*) AS c FROM punkter WHERE faerdig = 0")
            if (r.rows.length > 0) n = r.rows.item(0).c
        })
        return n
    }

    Column {
        anchors.centerIn: parent
        spacing: Theme.paddingMedium

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "file:///usr/share/harbour-todoapp/harbour-todoapp.png"
            width: Theme.iconSizeLarge
            height: width
        }

        Label {
            id: talLabel
            anchors.horizontalCenter: parent.horizontalCenter
            text: cover.antalAabne() + " åbne gøremål"
            color: Theme.highlightColor
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: talLabel.text = cover.antalAabne() + " åbne gøremål"
    }
}
