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

            Label {
                text: "On the web"
            }

            SomeButton { text: qsTr('Web'); url: channel.social.web; }
            SomeButton { text: qsTr('Facebook'); url: channel.social.facebook; }
            SomeButton { text: qsTr('Twitter'); url: channel.social.twitter; }
            SomeButton { text: qsTr('YouTube'); url: channel.social.youtube; }
            SomeButton { text: qsTr('Instagram'); url: channel.social.instagram; }
        }
    }
}
