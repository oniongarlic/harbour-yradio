import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page

    property Channel channel: null;

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Programs");
                visible: channel.programInfoId==='' ? false : true;
                onClicked: pageStack.push(programPage);
            }
            MenuItem {
                text: qsTr("Songs");
                visible: channel.songInfoId==='' ? false : true;
                onClicked: pageStack.push(songsPage);
            }
        }

        Column {
            id: cs
            anchors.fill: parent
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            PageHeader {
                title: channel.name;
            }

            Button {
                text: qsTr('Facebook');
                visible: channel.social.facebook!=='' ? true : false;
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Qt.openUrlExternally(channel.social.facebook);
            }
        }
    }
}
