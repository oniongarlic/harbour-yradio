import QtQuick 2.0
import QtMultimedia 5.0

Audio {
    id: radioPlayer
    //autoLoad: false;
    //autoPlay: false;
    property bool playing: false;
    property bool buffering: (status==Audio.Loading || status==Audio.Buffering || status==Audio.Stalled) ? true : false;
    property Channel currentChannel: null;

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

    onStatusChanged: {
        console.debug("*** STATUS: "+status)
    }

    onSourceChanged: {
        console.debug("*** SOURCE IS: "+source)
    }

    function toggle() {
        if (radioPlayer.playing) {
            radioPlayer.stop();
        } else {
            radioPlayer.play();
        }
    }
}
