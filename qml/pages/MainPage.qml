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
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: "Settings"
                onClicked: pageStack.push(settingsPage);
            }
            MenuItem {
                text: "Channels"
                onClicked: pageStack.push(channelsPage);
            }
            busy: (player.status==Audio.Loading || player.status==Audio.Buffering) ? true : false;
        }
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Y-Radio"
            }

            BackgroundItem {
                id: noChannelSelected
                visible: player.currentChannel===null;
                width: parent.width
                height: l.height
                Label {
                    id: l
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "Select a channel to listen to"
                    font.pixelSize: Theme.fontSizeExtraLarge
                    wrapMode: Text.WordWrap
                    width: parent.width/2
                }
                onClicked: pageStack.push(channelsPage);
            }

            BackgroundItem {
                visible: player.currentChannel!==null;
                width: parent.width
                height: cl.height
                Label {
                    id: cl
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: player.currentChannel===null ? '' : player.currentChannel.name;
                    font.pixelSize: Theme.fontSizeLarge
                    wrapMode: Text.WordWrap
                    width: parent.width/2
                }
                onClicked: pageStack.push(channelsPage);
            }

            SongInfo {
                id: songInfo;
                visible: infoId!==''
                infoId: player.currentChannel===null ? '' : player.currentChannel.songInfoId;
                showArtistImage: root.loadArtistImage;
                onInfoIdChanged: {
                    if (infoId!=='')
                        loadInitialInfo();
                }
                enabled: player.playing && infoId!=='';
                onClicked: {
                    panel.show();
                }
            }
        }
    }
    DockedPanel {
        id: panel
        width: parent.width
        height: Theme.itemSizeExtraLarge + Theme.paddingLarge
        dock: Dock.Bottom
        open: true;

        Column {
            width: parent.width
            IconButton {
                anchors.horizontalCenter: parent.horizontalCenter
                icon.source: player.playing ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                enabled: player.source ? true: false;
                onClicked: {
                    player.toggle();                    
                }
            }

            ProgressBar {
                id: buffering
                anchors.horizontalCenter: parent.horizontalCenter;
                value: player.bufferProgress;
                width: parent.width/1.5
                visible: player.status==Audio.Buffering || player.status==Audio.Loading;
                minimumValue: 0;
                maximumValue: 1;
            }
        }
    }
}


