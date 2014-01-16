import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "pages"
import "cover"

ApplicationWindow
{
    id: root

    property bool loadArtistImage: false;
    property int streamQuality: 1;

    Component.onCompleted: {
        loadArtistImage=settings.getBool("loadArtistImages", true);
        streamQuality=settings.getInt("streamQuality", 1);
    }

    onLoadArtistImageChanged: settings.setBool("loadArtistImages", loadArtistImage);
    onStreamQualityChanged: settings.setInt("streamQuality", streamQuality);

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

    Component {
        id: programPage
        ProgramPage {

        }
    }

    Channel {
        id: currentChannel
    }

    function setChannel(cdata, startPlay) {
        var wasPlaying=radioPlayer.playing;

        console.debug("CH: "+cdata.name);
        console.debug("CHUrl:"+cdata.url)
        console.debug(cdata.stream_high);
        console.debug(cdata.stream_medium);
        console.debug(cdata.stream_low);

        currentChannel.name=cdata.name;
        currentChannel.surl_lq=cdata.stream_low;
        currentChannel.surl_mq=cdata.stream_medium;
        currentChannel.surl_hq=cdata.stream_high;
        currentChannel.url=cdata.url;
        currentChannel.songInfoId=cdata.song_info_id;
        currentChannel.programInfoId='';

        radioPlayer.currentChannel=currentChannel;
        radioPlayer.stop();
        // radioPlayer.source=currentChannel.getStreamUrl(streamQuality);
        if (wasPlaying && startPlay)
            radioPlayer.play();        
    }

    property alias radioSource: radioPlayer.source;

    RadioPlayer {
        id: radioPlayer
        source: currentChannel===null ? '' : currentChannel.getStreamUrl(streamQuality);
        onSourceChanged: console.debug("RPSrc: "+source);
    }

    ChannelsModel {
        id: channelsModel
    }
}


