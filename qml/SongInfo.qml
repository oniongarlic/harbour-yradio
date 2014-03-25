import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import "mixradio.js" as NMIX

BackgroundItem {
    id: songinfo;
    property int updateInterval: 180;
    property alias enabled: timer.running;

    property Song curSong;
    property Song nextSong;
    property Song nextNextSong;

    property Program _curProgram;

    property bool hasSong: curSong!==null;
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
        curSong=null;
        nextSong=null;
        nextNextSong=null;
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
            text: ''
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            font.pixelSize: Theme.fontSizeLarge
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Playing now:");
            horizontalAlignment: Text.AlignHCenter            
            width: parent.width
            visible: curSongItem.hasSong;
            font.pixelSize: Theme.fontSizeLarge
        }

        SongItem {
            id: curSongItem
            song: curSong;
            visible: hasSong;
        }

        ArtistImage {
            id: artistImage;
            song: showArtistImage ? curSong : null;
            visible: showArtistImage;
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Playing next:");
            horizontalAlignment: Text.AlignHCenter            
            width: parent.width
            visible: nextSongItem.hasSong || nextNextSongItem.hasSong;
            font.pixelSize: Theme.fontSizeMedium
        }

        SongItem {
            id: nextSongItem
            song: nextSong;
            visible: hasSong;
        }

        SongItem {
            id: nextNextSongItem
            song: nextNextSong;
            visible: hasSong;
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
        onEmpty: curSong=null;
        onUpdated: curSong=getSong();
    }

    SongInfoModel {
        id: songInfoNext
        infoIndex: 1;
        infoId: songinfo.infoId
        onEmpty: nextSong=null;
        onUpdated: nextSong=getSong();
    }

    SongInfoModel {
        id: songInfoNextNext
        infoIndex: 2;
        infoId: songinfo.infoId
        onEmpty: nextNextSong=null;
        onUpdated: nextNextSong=getSong();
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
