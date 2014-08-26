import QtQuick 2.0
import QtMultimedia 5.0
import harbour.yradio.player 1.0

RtspPlayer {
    id: radioPlayer
    property Channel currentChannel: null;

    function toggle() {
        if (radioPlayer.playing) {
            radioPlayer.stop();
        } else {
            radioPlayer.play();
        }
    }
}
