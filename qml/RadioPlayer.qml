import QtQuick 2.0
import QtMultimedia 5.0

Audio {
    id: radioPlayer
    // bug? in that case don't set these, rtsp streams fail
    //autoLoad: false;
    //autoPlay: false;
    property bool playing: false;
    property bool buffering: status==Audio.Buffering || status==Audio.Stalled
    property bool preparing: status==Audio.Loading
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

    onPlaybackStateChanged: {
        switch (playbackState) {
        case Audio.PlayingState:
            console.debug("[PlaybackState] Playing");
            break;
        case Audio.PausedState:
            console.debug("[PlaybackState] Paused");
            break;
        case Audio.StoppedState:
            console.debug("[PlaybackState] Stopped");
            break;
        }
    }

    onBufferProgressChanged: {
        console.debug("*** BUFFERING: "+bufferProgress)
    }

    onStatusChanged: {
        console.debug("*** STATUS: "+status)
        switch (status) {
        case Audio.NoMedia:
            console.debug("[AudioStatus] No media");
            break;
        case Audio.Loading:
            console.debug("[AudioStatus] Loading");
            break;
        case Audio.Loaded:
            console.debug("[AudioStatus] Loaded");
            break;
        case Audio.Buffering:
            console.debug("[AudioStatus] Buffering");
            break;
        case Audio.Stalled:
            console.debug("[AudioStatus] Stalled");
            break;
        case Audio.Buffered:
            console.debug("[AudioStatus] Buffered");
            break;
        case Audio.EndOfMedia:
            console.debug("[AudioStatus] Media end");
            break;
        case Audio.InvalidMedia:
            console.debug("[AudioStatus] Invalid media");
            break;
        }

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
