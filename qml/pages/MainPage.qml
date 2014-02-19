import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import ".."

Page {
    id: page

    property RadioPlayer player: null;
    property ChannelsPage channels: null;

    // Create an attached page of the channels for quick access, this might be a Favorites in the future, lets see how it goes...
    // we do it here as the pageStack is still busy on the onCompleted signal for some odd reason.
    onStatusChanged: {
        if (status===PageStatus.Active && pageStack.depth===1 && channels===null) {
            channels=channelsPage.createObject(root, {currentChannelIndex: root.channelId });
            pageStack.pushAttached(channels);
        }
    }    

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(settingsPage);
            }
            MenuItem {
                text: qsTr("Channels")
                onClicked: pageStack.push(channels);
            }
            /*
            MenuItem {
                text: "Programs"
                onClicked: pageStack.push(programPage);
                enabled: root.currentChannel===null ? false : true;
            }
            */
            busy: (player.status==Audio.Loading || player.status==Audio.Buffering) ? true : false;
        }
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
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
                    text: qsTr("Select a channel to listen to")
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
                visible: true;
                opacity: (player.status==Audio.Buffering || player.status==Audio.Loading) ? 1.0 : 0.0;
                minimumValue: 0;
                maximumValue: 1;
                Behavior on opacity { NumberAnimation { duration: 500; } }
            }

        }
    }
}


