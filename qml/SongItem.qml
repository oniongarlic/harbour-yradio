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
        wrapMode: Text.WordWrap
        color: Theme.primaryColor
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
        color: Theme.secondaryColor
        text: song!==null ? song.title : '';
    }
}
