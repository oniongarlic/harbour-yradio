import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Dialog {
    id: infoDialog
    canAccept: true;

    property Program program;

    SilicaFlickable {
        anchors.fill: parent

        Column {
            id: cs
            anchors.fill: parent
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            PageHeader {
                title: program.title
            }
            Row {
                Label {
                    text: program.startTime
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width/2;
                }
                Label {
                    text: program.endTime
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
