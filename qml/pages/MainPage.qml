import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import ".."

Page {
    id: page

    property RadioPlayer player: null;

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Y-Radio"
            }
            Label {
                x: Theme.paddingLarge
                text: "Welcome to Y-Radio"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Button {
                text: player.playing ? "Stop" : "Play"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    player.toggle();
                }
            }
        }
    }
}


