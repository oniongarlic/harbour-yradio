import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../models"

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

    ProgramDialog {
        id: infoDialog
        program: programsModel.getProgramObject(programList.currentIndex);
    }

    ProgramsModel {
        id: programsModel
        programId: channel.programInfoId
    }

    Component.onCompleted: {
        console.debug("Requesting load of data");
        reset();
    }

    function reset() {        
        programsModel.date=new Date();
    }

    SilicaListView {
        id: programList
        anchors.fill: parent;
        clip: true;
        model: programsModel.model;
        header: PageHeader {
            title: qsTr("Programs: ")+Qt.formatDate(programsModel.date, "dd.MM.yyyy");
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
            busy: programsModel.loading ? true : false;
        }

        delegate: Component {
            id: programItem
            ListItem {
                menu: contextMenuComponent
                showMenuOnPressAndHold: true
                onClicked: {
                    programList.currentIndex=index;                    
                    infoDialog.open();
                }
                onPressAndHold: {
                    programList.currentIndex=index;                    
                }
                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: Theme.paddingLarge
                    height: Math.max(nameLabel.paintedHeight, timeLabel.paintedHeight);
                    Label {
                        id: timeLabel
                        text: Qt.formatTime(startTime, "hh:mm"); //  du.formatTime(startTime.substring(0,19));
                        width: parent.width/5;
                        wrapMode: Text.NoWrap;
                        font.pixelSize: Theme.fontSizeLarge;
                    }

                    Label {
                        id: nameLabel                        
                        wrapMode: Text.NoWrap;
                        elide: Text.ElideRight
                        font.pixelSize: Theme.fontSizeMedium;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignLeft
                        text: programName;
                        textFormat: Text.PlainText;
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
            // enabled: false;
            MenuItem {
                text: qsTr("Details");
                visible: false;
                onClicked: {
                    //infoDialog.program=programsModel.getProgramObject(programList.currentIndex);
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
