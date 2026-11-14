import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page {
    id: page

    property int listeId: 0
    property string valgtFrist: ""

    function aabenDb() {
        return LocalStorage.openDatabaseSync("todo8", "1.0", "Lister", 10000)
    }

    function dageTil(frist) {
        if (frist === "" || frist === null || frist === undefined) return 9999
        var nu = new Date()
        var f = new Date(frist)
        if (isNaN(f.getTime())) return 9999
        return Math.ceil((f - nu) / 86400000)
    }

    function fristTekst(f) {
        if (f === "" || f === null || f === undefined) return ""
        return " (om " + dageTil(f) + " dage)"
    }

    function hentPunkter() {
        punkter.clear()
        var db = aabenDb()
        db.transaction(function (tx) {
            var r = tx.executeSql("SELECT * FROM punkter WHERE liste_id = ? ORDER BY faerdig, CASE WHEN frist IS NULL OR frist = '' THEN 1 ELSE 0 END, frist", [listeId])
            for (var i = 0; i < r.rows.length; i++) {
                punkter.append({ pid: r.rows.item(i).id, beskrivelse: r.rows.item(i).beskrivelse, faerdig: r.rows.item(i).faerdig === 1, frist: r.rows.item(i).frist === null ? "" : r.rows.item(i).frist })
            }
        })
    }

    function tilfoejPunkt() {
        if (tekstboks.text.length > 0 && listeId > 0) {
            var frist = valgtFrist
            var db = aabenDb()
            db.transaction(function (tx) {
                tx.executeSql("INSERT INTO punkter (liste_id, beskrivelse, faerdig, frist) VALUES (?, ?, 0, ?)", [listeId, tekstboks.text, frist])
            })
            tekstboks.text = ""
            valgtFrist = ""
            hentPunkter()
        }
    }

    function opdaterPunkt(pid, tekst, frist) {
        var db = aabenDb()
        db.transaction(function (tx) {
            tx.executeSql("UPDATE punkter SET beskrivelse = ?, frist = ? WHERE id = ?", [tekst, frist, pid])
        })
        hentPunkter()
    }

    function sletPunkt(pid) {
        var db = aabenDb()
        db.transaction(function (tx) {
            tx.executeSql("DELETE FROM punkter WHERE id = ?", [pid])
        })
        hentPunkter()
    }

    function skiftFaerdig(pid, nyVaerdi) {
        var db = aabenDb()
        db.transaction(function (tx) {
            tx.executeSql("UPDATE punkter SET faerdig = ? WHERE id = ?", [nyVaerdi ? 1 : 0, pid])
        })
        hentPunkter()
    }

    function rydFaerdige() {
        var db = aabenDb()
        db.transaction(function (tx) {
            tx.executeSql("DELETE FROM punkter WHERE liste_id = ? AND faerdig = 1", [listeId])
        })
        hentPunkter()
    }

    function hentListeNavn(listeId) {
        var navn = ""
        var db = aabenDb()
        db.transaction(function (tx) {
            var r = tx.executeSql("SELECT navn FROM lister WHERE id = ?", [listeId])
            if (r.rows.length > 0) navn = r.rows.item(0).navn
        })
        return navn
    }

    Component.onCompleted: hentPunkter()

    ListModel { id: punkter }

    Component {
        id: fristPicker
        DatePickerDialog {}
    }

    Column {
        id: topbar
        anchors.top: parent.top
        width: parent.width

        PageHeader { title: listeId > 0 ? hentListeNavn(listeId) : "" }

        Row {
            width: parent.width - 2 * Theme.horizontalPageMargin
            x: Theme.horizontalPageMargin
            spacing: Theme.paddingMedium

            TextField {
                id: tekstboks
                width: parent.width - fristKnap.width - plusKnap.width - 2 * parent.spacing
                placeholderText: "Nyt gøremål..."
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.onClicked: tilfoejPunkt()
            }

            ValueButton {
                id: fristKnap
                width: 220
                height: Theme.itemSizeMedium
                label: "Frist"
                value: valgtFrist === "" ? "Ingen" : valgtFrist
                onClicked: {
                    var startDato = valgtFrist.length === 10 ? new Date(valgtFrist + "T12:00:00") : new Date()
                    var dialog = pageStack.push(fristPicker, { date: startDato })
                    if (dialog) {
                        dialog.accepted.connect(function () {
                            var m = dialog.month < 10 ? "0" + dialog.month : "" + dialog.month
                            var d = dialog.day < 10 ? "0" + dialog.day : "" + dialog.day
                            valgtFrist = dialog.year + "-" + m + "-" + d
                        })
                    }
                }
            }

            Button {
                id: plusKnap
                text: "+"
                width: Theme.itemSizeSmall
                onClicked: tilfoejPunkt()
            }
        }
    }

    SilicaListView {
        anchors.top: topbar.bottom
        anchors.bottom: rydKnap.top
        width: parent.width
        model: punkter

        ViewPlaceholder {
            enabled: punkter.count === 0
            text: "Ingen gøremål endnu..."
        }

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300 }
            NumberAnimation { property: "scale"; from: 0.7; to: 1; duration: 300 }
        }

        delegate: ListItem {
            id: punkt
            width: parent.width
            contentHeight: Theme.itemSizeMedium

            menu: ContextMenu {
                MenuItem {
                    text: "Rediger"
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("PunktDialog.qml"), {
                            punktId: pid,
                            nuvaerendeTekst: beskrivelse,
                            nuvaerendeFrist: frist
                        })
                        if (dialog) {
                            dialog.gem.connect(function (p, t, f) { opdaterPunkt(p, t, f) })
                        }
                    }
                }
                MenuItem {
                    text: faerdig ? "Marker ikke færdig" : "Marker færdig"
                    onClicked: skiftFaerdig(pid, !faerdig)
                }
                MenuItem {
                    text: "Fjern"
                    onClicked: sletPunkt(pid)
                }
            }

            Label {
                text: beskrivelse + fristTekst(frist)
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: Text.Wrap
                font.strikeout: faerdig
                color: faerdig ? Theme.secondaryColor : (dageTil(frist) < 0 ? "red" : (dageTil(frist) <= 3 ? "orange" : Theme.primaryColor))
            }

            onClicked: skiftFaerdig(pid, !faerdig)
        }
    }

    Button {
        id: rydKnap
        anchors.bottom: parent.bottom
        width: parent.width
        text: "Ryd færdige gøremål"
        onClicked: rydFaerdige()
    }
}
