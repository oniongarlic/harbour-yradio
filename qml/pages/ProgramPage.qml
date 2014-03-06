import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: page

    property Channel channel: null;
    property alias date: programsModel.date;

    DatePickerDialog {
        id: datePicker
        date: page.date;
        onAccepted: {
            console.debug("*** Date: "+datePicker.dateText)
            programsModel.date=datePicker.date;
        }
    }

    Dialog {
        id: infoDialog
        canAccept: true;
        property string title;
        property string synopsis;
        property string startTime;
        property string length;
        property string url;

        SilicaFlickable {
            anchors.fill: parent

            Column {
                id: cs
                anchors.fill: parent
                spacing: Theme.paddingLarge
                anchors.margins: Theme.paddingLarge
                PageHeader {
                    title: infoDialog.title
                }
                Label {
                    text: infoDialog.startTime
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width;
                }
                Label {
                    id: synopsis
                    text: infoDialog.synopsis
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width;
                    // onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }

    ProgramsModel {
        id: programsModel
    }

    Component.onCompleted: {
        console.debug("Requesting load of data");
        programsModel.date=new Date();
    }

    SilicaListView {
        id: programList
        anchors.fill: parent;
        clip: true;
        model: programsModel.getModel();
        header: PageHeader {
            title: qsTr("Programs")
        }

        PullDownMenu {
            MenuItem {
                text: "Pick a date"
                onClicked: pageStack.push(datePicker);
            }
            MenuItem {
                text: "Today"
                onClicked: programsModel.date=new Date();
            }
            // busy: (programModel.loading) ? true : false;
        }

        delegate: Component {
            id: programItem
            ListItem {
                onClicked: {
                    programList.currentIndex=index;
                    //root.setChannel(channelsModel.get(index), true);
                    infoDialog.open();
                }
                onPressAndHold: {
                    programList.currentIndex=index;
                    // XXX: Add context menu
                }
                Row {
                    width: parent.width
                    Label {
                        id: timeLabel
                        text: startTime
                        width: parent.width/4;
                    }

                    Label {
                        id: nameLabel                        
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeMedium;
                        horizontalAlignment: Text.AlignHCenter
                        text: programName;
                    }
                }
            }
        }
        VerticalScrollDecorator { flickable: programList }
    }
}
