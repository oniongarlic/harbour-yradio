import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaGridView {
        id: channelList
        anchors.fill: parent;
        cellWidth: parent.width/2
        cellHeight: cellWidth/2
        clip: true;
        model: channelsModel
        header: PageHeader {
            title: "Channels"
        }
        delegate: Item {
            id: channelItem
            width: channelList.cellWidth
            height: channelList.cellHeight
            BackgroundItem {
                width: channelList.cellWidth
                height: channelList.cellHeight
                onClicked: {
                    channelList.currentIndex=index;
                    root.setChannel(channelsModel.get(index), true);
                    pageStack.pop();
                }
                onPressAndHold: {
                    // XXX: Add context menu
                }
                Label {
                    // XXX: For now, until we load more channel data
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter;
                    width: parent.width;
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeMedium;
                    horizontalAlignment: Text.AlignHCenter
                    text: name;
                }
            }
        }
        VerticalScrollDecorator { flickable: channelList }
    }
}




