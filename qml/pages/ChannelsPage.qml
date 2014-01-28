import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaListView {
        id: channelList
        anchors.fill: parent;
        //cellWidth: parent.width/2
        //cellHeight: cellWidth/2

        property ContextMenu itemMenu;

        clip: true;
        model: channelsModel
        header: PageHeader {
            title: qsTr("Channels")
        }
        section.property: "category";
        section.criteria: ViewSection.FullString
        section.delegate: SectionHeader {
            text: section
        }
        delegate: Component {
            id: channelItemComponent
            //width: channelList.cellWidth
            //height: channelList.cellHeight
            BackgroundItem {
                id: channelItem
                //width: channelList.cellWidth
                //height: channelList.cellHeight
                onClicked: {
                    channelList.currentIndex=index;
                    root.setChannel(channelsModel.get(index), true);
                    pageStack.pop();
                }
                onPressAndHold: {
                    return;
                    channelList.currentIndex=index;
                    channelList.itemMenu = contextMenuComponent.createObject(channelList);
                    channelList.itemMenu.show(channelItem);
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

    Component {
        id: contextMenuComponent
        ContextMenu {
            id: contextMenu
            MenuItem {
                text: "Add to Favorites"
                onClicked: {
                    console.debug("CurrentIndex is: "+channelList.currentIndex);
                }
            }
        }
    }

}




