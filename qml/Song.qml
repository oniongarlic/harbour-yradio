import QtQuick 2.0

QtObject {
    property string artist;
    property string title;
    property string start;
    property int duration: 0;

    property bool validArtist: artist!=='';
    property bool validTitle: title!=='';
}
