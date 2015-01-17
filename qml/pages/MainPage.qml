import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page

    property RadioPlayer player: null;
    property ChannelsPage channels: null;
    property ProgramPage programs: null;

    allowedOrientations: Orientation.All

    // Create an attached page of the channels for quick access, this might be a Favorites in the future, lets see how it goes...
    // we do it here as the pageStack is still busy on the onCompleted signal for some odd reason.
    onStatusChanged: {
        if (status===PageStatus.Active && pageStack.depth===1 && channels===null) {
            channels=channelsPage.createObject(root, {currentChannelIndex: root.channelId });
            pageStack.pushAttached(channels);
        }
    }

    Component {
        id: programPage
        ProgramPage {

        }
    }

    RemorsePopup {
        id: sleepStop
    }

    function showProgramsPage() {
        if (programs==null)
            programs=programPage.createObject(page);

        programs.channel=root.currentChannel;
        console.debug("Pushing program page")

        pageStack.push(programs);
        console.debug("Program page pushed");

        programs.reset();
        console.debug("Program page reset");
    }

    SilicaFlickable {
        id: mainFlickable
        anchors.fill: parent        

        VerticalScrollDecorator { flickable: mainFlickable }

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
                text: qsTr("Sleep timer")
                onClicked: {
                    sleepStop.execute(qsTr("Stopping playback"),
                                    function() { player.stop() }
                                    , 1000*60*root.sleepMinutes);
                }
                enabled: player.playing
            }
            MenuItem {
                text: qsTr("Channels")
                onClicked: pageStack.push(channels);
            }
            MenuItem {
                text: qsTr("Programs")                
                onClicked: {
                    showProgramsPage();
                }
                // XXX: Force disable until we have switched over to public YLE API (old one is broken now)
                enabled: false;
                // enabled: root.currentChannel===null ? false : root.currentChannel.hasProgram;
            }            
            busy: player.buffering
        }
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: root.currentChannel===null ? "Y-Radio" : root.currentChannel.name;
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        pageStack.push(channelsPage);
                    }
                }
            }

            BackgroundItem {
                id: noChannelSelected
                visible: root.currentChannel===null;
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

            SongInfo {
                id: songInfo;
                visible: infoId!==''
                infoId: root.currentChannel===null ? '' : root.currentChannel.songInfoId;
                showArtistImage: root.loadArtistImage;
                onInfoIdChanged: {
                    if (infoId!=='')
                        loadInitialInfo();
                }
                enabled: player.playing && infoId!=='';
            }

        }
    }
}


