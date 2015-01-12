import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: bi
    width: parent.width

    property Song song;
    property bool hasSong: song!==null;

    signal requestUpdate();

    onPressAndHold: {
        songMenu.show(bi);
    }

    onClicked: {
        console.debug("Song info clicked!")
    }

    // Behavior on height { NumberAnimation { duration: 100; easing.type: Easing.InOutCubic} }
    height: songMenu.active ? songMenu.height + c.height : c.height

    Column {
        id: c
        width: parent.width

        DetailItem {
            id: di
            label: song!==null ? song.artist : '';
            value: song!==null ? song.title : '';
        }

        ArtistImage {
            id: artistImage;
            anchors.horizontalCenter: parent.horizontalCenter
            song: bi.song;
            enabled: showArtistImage && hasSong;
        }
    }


    ContextMenu {
        id: songMenu
        /*
        MenuItem {
            text: qsTr("Refresh");
            onClicked: requestUpdate();
        }
        */
        MenuItem {
            text: qsTr("Song search");
            onClicked: doWebSearch(song.artist, song.title);
            enabled: hasSong;
        }
    }
}
