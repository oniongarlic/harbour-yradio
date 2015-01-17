import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    readonly property string versionStr: appVersion;

    readonly property string helpText: qsTr("Unofficial YLE Radio application for Sailfish OS. Listen to the radio streams, see what is playing.")+
                              qsTr("Note: This is a third-party program and is not connected to YLE in any way.")+
                              qsTr("Artist images provided by Nokia MixRadio.");

    readonly property string license: 'This program is free software: you can redistribute it and/or modify ' +
                             'it under the terms of the GNU General Public License as published by ' +
                             'the Free Software Foundation, either version 2 of the License, or ' +
                             '(at your option) any later version.<br /><br />' +

                             'This package is distributed in the hope that it will be useful, ' +
                             'but WITHOUT ANY WARRANTY; without even the implied warranty of ' +
                             'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the ' +
                             'GNU General Public License for more details.<br /><br />' +

                             'You should have received a copy of the GNU General Public License ' +
                             'along with this program. If not, see <a href="http://www.gnu.org/licenses">http://www.gnu.org/licenses</a><br />'


    readonly property string homePage: "http://www.tal.org/projects/y-radio?utm_source=about&utm_medium=app&utm_campaign=jolla"

    readonly property string flattrPage: "https://flattr.com/submit/auto?user_id=oniongarlic&url=http://www.tal.org/projects/y-radio&title=YRadio&language=en_GB&tags=jolla&category=software"

    Dialog {
        id: licenseDialog
        canAccept: false;
        SilicaFlickable {
            anchors.fill: parent

            Column {
                id: cs
                anchors.fill: parent                
                spacing: Theme.paddingLarge
                anchors.margins: Theme.paddingLarge
                PageHeader {
                    title: "License"
                }

                Label {
                    id: nameField
                    text: license
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width;
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }

    SilicaFlickable {
        id: aboutFlickable
        anchors.fill: parent
        contentHeight: aboutColumn.height

        VerticalScrollDecorator { flickable: aboutFlickable }

        Column {
            id: aboutColumn            
            width: parent.width
            spacing: Theme.paddingLarge
            anchors.leftMargin: Theme.paddingMedium
            anchors.rightMargin: Theme.paddingMedium

            PageHeader {
                title: "Y-Radio "+versionStr
            }

            Label
            {
                id: help
                text: helpText
                styleColor: "#fbe369"
                anchors.topMargin: 20
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr('Flattr it!')
                onClicked: {
                    Qt.openUrlExternally(flattrPage);
                }
            }

            Label {
                id: links
                font.pixelSize: Theme.fontSizeMedium
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
                width: parent.width/3                
                text: "<style>a { color: #f0f0ff; display: block; margin-left: auto; margin-right: auto;}</style>"+
                      "<a href='https://twitter.com/oniongarlic'>@oniongarlic</a><br/>"+
                      "<a href='mailto:onion@tal.org'>onion@tal.org</a><br/>"+
                      "<a href='"+homePage+"'>Y-Radio home</a>"
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label
            {
                id: copyrightsgpl
                text: "Copyright 2012-2015\nKaj-Michael Lang";
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                textFormat: Text.RichText
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr('License')
                onClicked: licenseDialog.open()
            }

        }
    }
}
