import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: c
    width: parent.width
    spacing: 4;

    property alias song: song.text;
    property alias artist: artist.text

    Label {
        id: artist
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeMedium
    }
    Label {
        id: song
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
    }
}
