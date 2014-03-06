import QtQuick 2.0
import Sailfish.Silica 1.0
import "mixradio.js" as NMIX

Image {
    id: artistImage
    anchors.horizontalCenter: parent.horizontalCenter
    width: 320;
    height: 320;
    fillMode: Image.PreserveAspectFit
    cache: true
    asynchronous: true
    visible: opacity > 0.0;
    source: getArtistImageUrl_NokiaMixRadio(song);

    property Song song;
    property bool isValid: source!=='' && status!==Image.Error;

    onStatusChanged: {

    }
    opacity: isValid ? 1.0 : 0.0;

    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.InOutCubic} }
    // Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.InOutCubic} }
    BusyIndicator {
        anchors.centerIn: parent
        visible: running;
        running: artistImage.status==Image.Loading;
        // size: BusyIndicatorSize.Medium;
    }

    function getArtistImageUrl_NokiaMixRadio(song) {
        if (song===null)
            return '';
        if (song.artist==='')
            return '';

        if (main.loadImages===false)
            return'';

        var url="http://api.mixrad.io/1.x/fi/creators/images/320x320/random/?domain=music&client_id="+NMIX.NOKIA_API_ID;
        url=url.concat("&name=", encodeURIComponent(song.artist));
        // console.debug("ImageURL: "+url)
        return url;
    }
}
