import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Dialog {
    id: infoDialog
    canAccept: true;

    property Program program;

    SilicaFlickable {
        id: programFlickable
        anchors.fill: parent
        contentHeight: cs.height

        VerticalScrollDecorator { flickable: programFlickable }

        Column {
            id: cs
            anchors.fill: parent
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            PageHeader {
                title: program.title
            }
            Row {
                // spacing: Theme.paddingLarge
                // XXX: disable for now, goes into a strange location ?
                visible: false;
                Label {
                    text: program.startTime // Qt.formatDate(program.startTime, "hh:mm");
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width/2;
                }
                Label {
                    text: program.endTime // Qt.formatDate(program.endTime, "hh:mm");
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width/2;
                }
            }
            Label {
                id: synopsis
                text: program.description
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width;
                // onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }
}
