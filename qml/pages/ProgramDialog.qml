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
        // contentHeight: cs.height

        VerticalScrollDecorator { flickable: programFlickable }        

        Column {
            id: cs
            anchors.fill: parent
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            PageHeader {
                title: program.title
            }
            Label {
                text: Qt.formatDate(program.startTime, "dd.MM.yyyy")+
                      " "+
                      Qt.formatTime(program.startTime, "hh:mm")+
                      " - "+
                      Qt.formatTime(program.endTime, "hh:mm");

                font.pixelSize: Theme.fontSizeSmall
            }
            Label {
                id: synopsis
                text: program.description
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeMedium
                width: parent.width;
            }
        }
    }
}
