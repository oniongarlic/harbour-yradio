import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "pages"
import "cover"

ApplicationWindow
{
    id: root
    initialPage: Component {
        MainPage {
            player: radioPlayer
        }
    }

    cover: Component {
        CoverPage {
            player: radioPlayer;
        }
    }

    property alias radioSource: radioPlayer.source;

    RadioPlayer {
        id: radioPlayer
    }

    ChannelsModel {
        id: channelsModel

    }
}


