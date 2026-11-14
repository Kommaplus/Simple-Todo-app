import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property int punktId: 0
    property string nuvaerendeTekst: ""
    property string nuvaerendeFrist: ""
    property string valgtFrist: ""

    signal gem(int punktId, string tekst, string frist)

    Component.onCompleted: valgtFrist = nuvaerendeFrist

    Component {
        id: fristPicker
        DatePickerDialog {}
    }

    Column {
        width: parent.width
        DialogHeader { title: "Rediger gøremål" }

        TextField {
            id: tekstfelt
            width: parent.width
            text: dialog.nuvaerendeTekst
            placeholderText: "Gøremål..."
            inputMethodHints: Qt.ImhNoPredictiveText
        }

        ValueButton {
            width: parent.width
            label: "Frist"
            value: dialog.valgtFrist === "" ? "Ingen" : dialog.valgtFrist
            onClicked: {
                var startDato = dialog.valgtFrist.length === 10 ? new Date(dialog.valgtFrist + "T12:00:00") : new Date()
                var d = pageStack.push(fristPicker, { date: startDato })
                if (d) {
                    d.accepted.connect(function () {
                        var m = d.month < 10 ? "0" + d.month : "" + d.month
                        var dag = d.day < 10 ? "0" + d.day : "" + d.day
                        dialog.valgtFrist = d.year + "-" + m + "-" + dag
                    })
                }
            }
        }
    }

    onAccepted: {
        if (tekstfelt.text.length > 0) {
            dialog.gem(dialog.punktId, tekstfelt.text, dialog.valgtFrist)
        }
    }
}
