import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "pages"
import "cover"
import "models"

ApplicationWindow
{
    id: root

    property bool loadArtistImage: false;
    property bool autostartChannel: false;
    property int streamQuality: 1;

    // The saved channel id
    property int previousRadioChannel: -1;
    property alias radioSource: radioPlayer.source;

    property int sleepMinutes: 4;

    // The channel information object of the currently selected channel
    property Channel currentChannel: null;

    // The current channel index id into the channel model
    property int channelId: -1;    

    Component.onCompleted: {
        loadArtistImage=settings.getBool("loadArtistImages", true);
        autostartChannel=settings.getBool("autostartChannel", false);
        streamQuality=settings.getInt("streamQuality", 1);
        sleepMinutes=settings.getInt("sleepMinutes", 4);
        previousRadioChannel=settings.getInt("previousRadioChannel", -1);
    }

    onSleepMinutesChanged: settings.setInt("sleepMinutes", sleepMinutes);
    onLoadArtistImageChanged: settings.setBool("loadArtistImages", loadArtistImage);
    onStreamQualityChanged: settings.setInt("streamQuality", streamQuality);
    onChannelIdChanged: settings.setInt("previousRadioChannel", channelId);
    onPreviousRadioChannelChanged: {
        console.debug("*** Saved channel index is: "+previousRadioChannel);
    }

    allowedOrientations: Orientation.All

    initialPage: Component {
        MainPage {
            id: main
            player: radioPlayer
        }
    }

    cover: Component {
        CoverPage {
            player: radioPlayer;
        }
    }

    Component {
        id: settingsPage
        SettingsPage {

        }
    }

    Component {
        id: channelsPage
        ChannelsPage {

        }
    }

//    Component {
//        id: programPage
//        ProgramPage {

//        }
//    }

    Component {
        id: channelPage
        ChannelPage {

        }
    }

    Component {
        id: songsPage
        SongsPage {

        }
    }

    ChannelsModel {
        id: channelsModel
        onLoadError: {
            errorDialog.errorMsg="Failed to load channel data: "+errorString();
            errorDialog.open();
        }
        onLoaded: {
            if (previousRadioChannel>0) {
                console.debug("Defaulting channel to previously used one: "+previousRadioChannel)
                setChannel(previousRadioChannel, autostartChannel);
            }
        }
    }

    Component {
        id: channelComponent
        Channel {
            id: currentChannel
        }
    }        

    Dialog {
        id: errorDialog;
        canAccept: false;

        property string errorMsg: "";

        SilicaFlickable {
            anchors.fill: parent

            Column {
                id: cs
                anchors.fill: parent
                spacing: Theme.paddingLarge
                anchors.margins: Theme.paddingLarge
                DialogHeader {
                    title: "Error"
                }

                Label {
                    id: errorText
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width;
                    text: "An error occured:\n"+errorDialog.errorMsg;
                }
            }
        }
    }

    RadioPlayer {
        id: radioPlayer
        source: currentChannel===null ? '' : currentChannel.getStreamUrl(streamQuality);

        onError: {            
            switch (status) {
            case 8:
                errorDialog.errorMsg=radioPlayer.errorString;
                errorDialog.open();
                break;
            default:
            }
        }
    }

    bottomMargin: actionBar.visibleSize;

    ActionBar {
        id: actionBar;
        visible: currentChannel===null ? false : true;
        player: radioPlayer
        z: 2
    }

    // Go to next channel in list.
    function nextChannel() {
        console.debug("NextChannel");
        if (channelId<0)
            channelId=0;
        else if (channelId<channelsModel.count) {
            channelId++;
        } else {
            channelId=0;
        }
        setChannel(channelId, true);
    }

    function getChannelObject(cdata) {
        if (cdata===null)
            return null;

        var c=channelComponent.createObject(root, {
                                          name: cdata.name,
                                          surl_lq: cdata.stream_low,
                                          surl_mq: cdata.stream_medium,
                                          surl_hq: cdata.stream_high,
                                          url: cdata.url,
                                          songInfoId: cdata.song_info_id,
                                          programInfoId: cdata.program_info_id
                                      });
        c.social.web=cdata.some_web;
        c.social.twitter=cdata.some_twitter;
        c.social.facebook=cdata.some_facebook;
        c.social.youtube=cdata.some_youtube;
        c.social.instagram=cdata.some_instagram;

        return c;
    }

    function getChannelObjectFromId(id) {
        var cdata=channelsModel.get(id);
        if (cdata===null)
            return null;
        return getChannelObject(cdata);
    }

    function setChannel(cid, startPlay) {
        var wasPlaying=radioPlayer.playing;
        var cdata;

        if (cid<0 || cid>channelsModel.count) {
            console.debug("Invalid channel id");
            return false;
        }

        channelId=cid;
        cdata=channelsModel.get(channelId);

        if (!cdata) {
            console.debug("Channel id outside data range, no data found: "+channelId);
            return false;
        }

        console.debug("CH: "+cdata.name);
        currentChannel=getChannelObject(cdata);

        radioPlayer.stop();
        radioPlayer.currentChannel=currentChannel;

        if (wasPlaying && startPlay)
            radioPlayer.play();
        else if (autostartChannel)
            radioPlayer.play();
        return true;
    }
}


