import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import ".."

CoverBackground {

    property string currentArtist;
    property string currentSong;
    property string currentProgram;
    property string currentChannel;

    property RadioPlayer player;
    property Image artistImage;

    anchors.fill: parent

    Label {
        id: label
        anchors.centerIn: parent
        text: "YLE"
    }

    CoverActionList {
        id: coverActions

        iconBackground: artistImage.visible
        // enabled: player.playing

        CoverAction {
            iconSource: player.playing ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: player.toggle()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next-song"
            onTriggered: player.playNext()
        }
    }


}


