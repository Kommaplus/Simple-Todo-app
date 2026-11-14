import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page {
    id: page

    function aabenDb() {
        return LocalStorage.openDatabaseSync("todo8", "1.0", "Lister", 10000)
    }

    function setupDb() {
        var db = aabenDb()
        db.transaction(function (tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS lister (id INTEGER PRIMARY KEY AUTOINCREMENT, navn TEXT)")
            tx.executeSql("CREATE TABLE IF NOT EXISTS punkter (id INTEGER PRIMARY KEY AUTOINCREMENT, liste_id INTEGER, beskrivelse TEXT, faerdig INTEGER, frist TEXT)")
        })
    }

    function hentLister() {
        lister.clear()
        var db = aabenDb()
        db.transaction(function (tx) {
            var r = tx.executeSql("SELECT * FROM lister ORDER BY id")
            for (var i = 0; i < r.rows.length; i++) {
                lister.append({ lid: r.rows.item(i).id, navn: r.rows.item(i).navn })
            }
        })
    }

    function tilfoejListe(navn) {
        if (navn.length > 0) {
            var db = aabenDb()
            db.transaction(function (tx) {
                tx.executeSql("INSERT INTO lister (navn) VALUES (?)", [navn])
            })
            nyListeInput.text = ""
            hentLister()
        }
    }

    function sletListe(listeId) {
        var db = aabenDb()
        db.transaction(function (tx) {
            tx.executeSql("DELETE FROM punkter WHERE liste_id = ?", [listeId])
            tx.executeSql("DELETE FROM lister WHERE id = ?", [listeId])
        })
        hentLister()
    }

    Component.onCompleted: { setupDb(); hentLister() }

    ListModel { id: lister }

    Column {
        id: topbar
        anchors.top: parent.top
        width: parent.width

        PageHeader { title: "Mine lister" }

        Row {
            width: parent.width - 2 * Theme.horizontalPageMargin
            x: Theme.horizontalPageMargin
            spacing: Theme.paddingMedium

            TextField {
                id: nyListeInput
                width: parent.width - plusKnap.width - parent.spacing
                placeholderText: "Ny liste..."
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.onClicked: tilfoejListe(text)
            }

            Button {
                id: plusKnap
                text: "+"
                width: Theme.itemSizeSmall
                onClicked: tilfoejListe(nyListeInput.text)
            }
        }
    }

    SilicaListView {
        anchors.top: topbar.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        model: lister

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300 }
            NumberAnimation { property: "scale"; from: 0.7; to: 1; duration: 300 }
        }

        delegate: ListItem {
            id: listePunkt
            width: parent.width
            contentHeight: Theme.itemSizeMedium

            menu: ContextMenu {
                MenuItem {
                    text: "Slet liste"
                    onClicked: sletListe(lid)
                }
            }

            Label {
                text: navn
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                color: listePunkt.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"), { listeId: lid })
        }
    }
}
