import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "mixradio.js" as NMIX

BackgroundItem {
    id: songinfo;
    property int updateInterval: 180;
    property alias enabled: timer.running;

    property string curSong: ""
    property string curSongArtist: ""

    property string nextSong: ""
    property string nextSongArtist: ""

    property string nextNextSong: ""
    property string nextNextSongArtist: ""

    property bool hasSong: curSong!=='';
    property bool fetching: songInfoCurrent.status===XmlListModel.Loading || songInfoNext.status===XmlListModel.Loading;
    property bool showArtistImage: true;

    property string infoId: null;

    anchors.left: parent.left
    anchors.right: parent.right
    height: c.height;

    onPressAndHold: {
        // songMenu.open();
    }

    onClicked: {

    }

    onInfoIdChanged: {
        reset();
    }

    function reset() {
        curSong=''
        curSongArtist=''
        nextSong=''
        nextSongArtist=''
        nextNextSong=''
        nextNextSongArtist=''
        curProgram.text='';
    }

    /*
    Menu {
        id: songMenu
        // visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Refresh"); onClicked: updateAll(); enabled: !fetching;
            }
            MenuItem {
                text: qsTr("Search"); onClicked: doWebSearch(curSongArtist, curSong);
                enabled: hasSong;
            }
        }
    }
    */

    function doWebSearch(artist, song) {
        var url="http://www.google.com/m/search";
        url=url.concat("?q=", encodeURIComponent(artist)," ", encodeURIComponent(song));
        Qt.openUrlExternally(url);
    }

    Column {
        id: c
        width: parent.width
        spacing: 4;

        Label {
            id: curProgram
            anchors.horizontalCenter: parent.horizontalCenter
            text: ""
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeLarge
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Playing now:");
            horizontalAlignment: Text.AlignHCenter            
            width: parent.width
            visible: curSong!=='';
            font.pixelSize: Theme.fontSizeLarge
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            id: nowPlayingText
            text: curSongArtist+" - "+curSong;
            font.bold: true
            horizontalAlignment: Text.AlignHCenter            
            wrapMode: Text.WordWrap
            width: parent.width
            font.pixelSize: Theme.fontSizeMedium
        }

        Image {
            id: artistImage
            anchors.horizontalCenter: parent.horizontalCenter
            width: 320;
            height: 320;
            fillMode: Image.PreserveAspectFit
            cache: true
            asynchronous: true
            visible: curSongArtist!=='' && status!==Image.Error;
            source: getArtistImageUrl_NokiaMixRadio(curSongArtist);
            onStatusChanged: {

            }
            opacity: visible ? 1.0 : 0.0;
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.InOutCubic} }
            Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.InOutCubic} }
            BusyIndicator {
                anchors.centerIn: parent
                visible: running;
                running: artistImage.status==Image.Loading;
                // size: BusyIndicator.s
            }

            function getArtistImageUrl_NokiaMixRadio(artist) {
                if (artist==='')
                    return '';

                if (main.loadImages==false)
                    return'';

                var url="http://api.mixrad.io/1.x/fi/creators/images/320x320/random/?domain=music&client_id="+NMIX.NOKIA_API_ID;
                url=url.concat("&name=", encodeURIComponent(artist));
                // console.debug("ImageURL: "+url)
                return url;
            }
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Playing next:");
            horizontalAlignment: Text.AlignHCenter            
            width: parent.width
            visible: nextSong!=='';
            font.pixelSize: Theme.fontSizeMedium
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            id: nextSongText;
            text: nextSongArtist+" - "+nextSong;
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            id: nextNextSongText;
            text: nextNextSongArtist+" - "+nextNextSong;
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            width: parent.width
            font.pixelSize: Theme.fontSizeSmall
        }
    }

    function updateAll() {
        if (infoId==='')
            return;
        console.debug("*** SongInfoUpdate");
        updateSongInfo(songInfoCurrent);
        updateSongInfo(songInfoNext);
        updateSongInfo(songInfoNextNext);
    }

    Timer {
        id: timer
        running: false;
        repeat: true;
        interval: updateInterval*1000;
        triggeredOnStart: true
        onTriggered: updateAll();
    }

    /*
    SongInfoModel {
        id: songInfoPrev
        infoIndex: -1;
        infoId: songinfo.infoId
        onEmpty: curSong="";
        onUpdated: curSong=songData.title;
    }
    */
    SongInfoModel {
        id: songInfoCurrent
        infoIndex: 0;
        infoId: songinfo.infoId
        onEmpty: curSong="";
        onUpdated: {
            curSong=songData.title;
            if (songData.performer)
                curSongArtist=songData.performer;
            else if (songData.vocalist)
                curSongArtist=songData.vocalist;
            curProgram.text=songData.program;
        }
    }

    SongInfoModel {
        id: songInfoNext
        infoIndex: 1;
        infoId: songinfo.infoId
        onEmpty: nextSong="";
        onUpdated: {
            nextSong=songData.title;
            if (songData.performer)
                nextSongArtist=songData.performer;
            else if (songData.vocalist)
                nextSongArtist=songData.vocalist;
        }
    }

    SongInfoModel {
        id: songInfoNextNext
        infoIndex: 2;
        infoId: songinfo.infoId
        onEmpty: nextNextSong="";
        onUpdated: {
            nextNextSong=songData.title;
            if (songData.performer)
                nextNextSongArtist=songData.performer;
            else if (songData.vocalist)
                nextNextSongArtist=songData.vocalist;
        }
    }

    function updateSongInfo(model)
    {
        if (model.loading===true) {
            console.debug('Already loading song info, skipping request');
            return;
        }

        console.debug("Loading song info");
        model.reloadSongInfo();
    }

    Timer {
        id: initialLoad
        onTriggered: updateAll();
        interval: 1000;
        repeat: false;
    }

    function loadInitialInfo() {
        initialLoad.start();
    }

}
