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
        programId: root.currentChannel.programInfoId
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
                text: qsTr("Pick a date");
                onClicked: pageStack.push(datePicker);
            }
            MenuItem {                
                text: qsTr("Today");
                onClicked: programsModel.date=new Date();
            }
            // busy: (programModel.loading) ? true : false;
        }

        delegate: Component {
            id: programItem
            ListItem {
                menu: contextMenuComponent
                showMenuOnPressAndHold: true
                onClicked: {
                    programList.currentIndex=index;                    
                    // infoDialog.open();
                }
                onPressAndHold: {
                    programList.currentIndex=index;                    
                }
                Row {
                    // width: parent.width
                    x: Theme.paddingLarge
                    Label {
                        id: timeLabel
                        text: du.formatTime(startTime.substring(0,19));
                        width: parent.width/5;
                    }

                    Label {
                        id: nameLabel                        
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeMedium;
                        horizontalAlignment: Text.AlignLeft
                        text: programName;
                        width: parent.width-timeLabel.width
                    }
                }
            }
        }
        VerticalScrollDecorator { flickable: programList }        
    }
    Component {
        id: contextMenuComponent
        ContextMenu {
            id: contextMenu
            MenuItem {
                text: qsTr("Details")
                onClicked: {
                    infoDialog.open();
                }
            }
            // XXX If and when we can access the users calendar in some way
            MenuItem {
                text: qsTr("Add reminder")
                visible: false
                onClicked: {
                    addReminder("",0);
                }
            }
        }
    }
    function addReminder(title, time) {

    }
}
