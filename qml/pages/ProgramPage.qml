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
        programId: channel ? channel.programInfoId : ''
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

                // XXX: Add when we can do something with the data (aka add to calendar)
                //menu: contextMenuComponent
                //showMenuOnPressAndHold: true

                property bool isSelected: programList.currentIndex==index && index>0
                contentHeight: Theme.paddingMedium*2 + (isSelected ? programBaseInfo.height+programSummary.height : programBaseInfo.height);

                onClicked: {
                    if (programList.currentIndex==index) {
                        programList.currentIndex=-1;
                        return;
                    }

                    var p=programsModel.getProgramObject(index);
                    programSummary.text=p.description;
                    programList.currentIndex=index;
                    // infoDialog.open();
                }
                onPressAndHold: {
                    programList.currentIndex=index;                    
                }

                anchors.margins: Theme.paddingMedium;

                Row {
                    id: programBaseInfo;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.margins: Theme.paddingMedium;
                    // anchors.verticalCenter: parent.verticalCenter;
                    Label {
                        id: timeLabel
                        text: "<b>"+Qt.formatTime(startTime, "hh:mm")+"</b>"; // XXX: Use user locale format
                        //text: "<b>"+Qt.formatTime(startTime)+"</b>"; // XXX: is this ok? Nope, no need for seconds
                        width: parent.width/5;
                        wrapMode: Text.NoWrap;
                        font.pixelSize: Theme.fontSizeMedium;
                    }

                    Label {
                        id: nameLabel                        
                        wrapMode: Text.NoWrap;
                        elide: Text.ElideRight
                        font.pixelSize: Theme.fontSizeMedium;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignLeft;
                        text: programName;
                        textFormat: Text.PlainText;
                        width: parent.width-timeLabel.width                        
                    }
                }
                Label {
                    id: programSummary
                    visible: programList.currentIndex==index ? true : false;
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                    anchors.top: programBaseInfo.bottom
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    horizontalAlignment: Text.AlignJustify;
                    anchors.margins: Theme.paddingMedium;
                    anchors.left: parent.left
                    anchors.right: parent.right
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
