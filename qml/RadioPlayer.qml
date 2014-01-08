import QtQuick 2.0
// import Sailfish.Silica 1.0
import QtMultimedia 5.0

Audio {
    id: radioPlayer
    autoLoad: false;
    autoPlay: false;
    source: "http://stream2.yle.mobi:8000/livex3m128.mp3"
    property bool playing: false;

    onStopped:{
        console.debug("** STOPPED");
        playing=false;
    }

    onError: {
        console.debug("*** ERROR: "+errorString);
    }

    onPlaying: {
        console.debug("*** PLAYING");
        playing=true;
    }

    onBufferProgressChanged: {
        console.debug("*** BUFFERING: "+bufferProgress)
    }

    function toggle() {
        if (radioPlayer.playing)
            radioPlayer.stop();
        else
            radioPlayer.play();
    }

    onStatusChanged: {
        console.debug("*** STATUS: "+status)
    }
}
