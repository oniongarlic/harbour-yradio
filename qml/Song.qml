import QtQuick 2.0

QtObject {
    property string artist;
    property string song;
    property string start;
    property int duration: 0;

    property bool validArtist: artist!=='';
    property bool validSong: song!=='';
}
