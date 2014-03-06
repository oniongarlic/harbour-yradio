import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page

    property alias currentChannelIndex: channelList.currentIndex;
    property Channel currentChannel: null;

    SilicaListView {
        id: channelList
        anchors.fill: parent;

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
            ListItem {
                id: channelItem
                menu: contextMenuComponent
                showMenuOnPressAndHold: true
                onClicked: {
                    channelList.currentIndex=index;
                    setChannel(index);
                    pageStack.navigateBack();
                }
                onPressAndHold: {
                    channelList.currentIndex=index;
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
                    color: ListView.isCurrentItem ? Theme.highlightColor : Theme.primaryColor
                }
            }
        }        

        VerticalScrollDecorator { flickable: channelList }
    }

    function setChannel(index, autoPlay) {
        root.setChannel(index, autoPlay);        
    }

    function showChannel(index) {                
        pageStack.push(channelPage, { channel: currentChannel } );
    }

    function showChannelPrograms(index) {
        pageStack.push(programPage, { channel: currentChannel } );
    }

    onCurrentChannelIndexChanged: {
        if (currentChannel!==null)
            currentChannel.destroy();
        currentChannel=root.getChannelObjectFromId(currentChannelIndex);
    }

    Component {
        id: contextMenuComponent
        ContextMenu {
            id: contextMenu
            MenuItem {
                text: qsTr("Play")                
                onClicked: {                    
                    setChannel(channelList.currentIndex, true);
                    pageStack.navigateBack();
                }
            }
            MenuItem {
                text: qsTr("Information")
                onClicked: {
                    showChannel(channelList.currentIndex);
                }
            }

            MenuItem {
                text: qsTr("Programs")
                visible: currentChannel!==null && currentChannel.programInfoId==='' ? false : true;
                onClicked: {                    
                    showChannelPrograms(channelList.currentIndex);
                }
            }
        }
    }
}




