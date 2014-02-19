import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page

    property Channel channel: null;

    DatePickerDialog {
        id: datePicker
        date: new Date();
        onAccepted: {
            console.debug("*** Date: "+datePicker.dateText)
            // programModel.load(datePicker.date);
        }
    }

    ProgramsModel {
        id: programsModel
    }

    SilicaListView {
        id: programList
        anchors.fill: parent;
        clip: true;
        model: programsModel
        header: PageHeader {
            title: "Program"
        }

        PullDownMenu {
            MenuItem {
                text: "Date"
                onClicked: pageStack.push(datePicker);
            }
            // busy: (programModel.loading) ? true : false;
        }

        delegate: Item {
            id: programItem
            BackgroundItem {
                onClicked: {
                    //channelList.currentIndex=index;
                    //root.setChannel(channelsModel.get(index), true);
                    //pageStack.pop();
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
                    //text: name;
                }
            }
        }
        VerticalScrollDecorator { flickable: programList }
    }
}




