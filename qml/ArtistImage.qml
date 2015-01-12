import QtQuick 2.0
import Sailfish.Silica 1.0
import "mixradio.js" as NMIX

Image {
    id: artistImage    
    width: size;
    height: size;
    fillMode: Image.PreserveAspectFit
    cache: true
    asynchronous: true    
    source: enabled ? getArtistImageUrl_NokiaMixRadio(song) : '';
    visible: enabled && isValid;

    property Song song;
    property bool isValid: source!=='' && status!==Image.Error;
    property bool enabled: false;

    property bool showAnonymous: false

    property int size: 320

    opacity: isValid ? 1.0 : 0.0;

    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.InOutCubic} }
    // Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.InOutCubic} }
    BusyIndicator {
        anchors.centerIn: parent
        visible: running;
        running: artistImage.status==Image.Loading;
        // size: BusyIndicatorSize.Medium;
    }

    onStatusChanged: {        
        console.debug("ArtistImage status: "+status)
        if (status==Image.Error && showAnonymous) {
            // XXX: Use a dummy image in case loading fails
        }
    }

    function getArtistImageUrl_NokiaMixRadio(song) {
        if (song===null)
            return '';
        if (song.artist==='')
            return '';

        if (root.loadArtistImage===false)
            return'';

        var url="http://api.mixrad.io/1.x/fi/creators/images/320x320/random/?domain=music&client_id="+NMIX.NOKIA_API_ID;
        url=url.concat("&name=", encodeURIComponent(song.artist));
        // console.debug("ImageURL: "+url)
        return url;
    }
}
