import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import ".."

CoverBackground {

    property RadioPlayer player;    
    property Image artistImage;

    /*
      xxx: hmm, hmm, hmm..
    Image {
        anchors.horizontalCenter: parent.horizontalCenter

    }
    */

    Label {
        text: "Y-Radio"
        font.pixelSize: Theme.fontSizeLarge
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: Theme.highlightColor
    }

    CoverPlaceholder {
        text: player.currentChannel===null ? qsTr("No channel selected") : player.currentChannel.name;
        // icon: artistImage;
    }

    CoverActionList {
        id: coverActions

        // iconBackground: artistImage.visible
        // enabled: player.currentChannel!==null
        enabled: player.source ? true : false;

        CoverAction {
            iconSource: player.playing ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: player.toggle()
        }

        CoverAction {            
            iconSource: "image://theme/icon-cover-next-song"
            onTriggered: root.nextChannel()
        }        
    }
}


