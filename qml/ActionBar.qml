import QtQuick 2.0
import Sailfish.Silica 1.0

DockedPanel {
    id: playPanel
    width: parent.width
    height: dpc.height;
    dock: Dock.Bottom
    open: root.currentChannel===null ? false : true;

    property RadioPlayer player;

    // XXX: This is ugly, but force it open
    onOpenChanged: {
        if (open)
            return;
        if (root.currentChannel!==null)
            open=true;
    }

    Column {
        id: dpc
        width: parent.width
        // spacing: Theme.paddingSmall;

        ProgressBar {
            id: buffering
            anchors.horizontalCenter: parent.horizontalCenter;
            value: player.bufferProgress;
            width: parent.width/1.5
            visible: player.buffering;
            opacity: player.buffering ? 1.0 : 0.0;
            minimumValue: 0;
            maximumValue: 1;
            Behavior on opacity { NumberAnimation { duration: 750; } }
        }

        IconButton {
            anchors.horizontalCenter: parent.horizontalCenter
            icon.source: player.playing ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
            enabled: player.source ? true: false;
            onClicked: {
                player.toggle();
            }
            height: Theme.itemSizeExtraLarge
        }

    }
}
