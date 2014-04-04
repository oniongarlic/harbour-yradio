import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: c
    width: parent.width
    spacing: 4;

    property Song song;
    property bool hasSong: song!==null;

    Label {
        id: artistLabel
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeMedium
        text: song!==null ? song.artist : '';
    }
    Label {
        id: songLabel
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
        text: song!==null ? song.title : '';
    }
}
