import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page

    property Channel channel: null;

    SilicaFlickable {
        anchors.fill: parent

        Column {
            id: cs
            anchors.fill: parent
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            PageHeader {
                title: "Songs";
            }

        }
    }
}
