import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    property int quality: root.streamQuality;

    onQualityChanged: root.streamQuality=quality;

    SilicaFlickable {
        anchors.fill: parent

        Column {
            id: cs
            anchors.fill: parent
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            PageHeader {
                title: qsTr("Settings")
            }

            ComboBox {
                label: qsTr("Stream quality");
                currentIndex: quality-1;

                menu: ContextMenu {
                    MenuItem { text: qsTr("Low"); onClicked: page.quality=1; }
                    MenuItem { text: qsTr("Medium"); onClicked: page.quality=2; }
                    MenuItem { text: qsTr("High"); onClicked: page.quality=3; }
                }
            }

            Label {
                id: bitSize
                text: getBits(quality);
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeSmall
                anchors.left: parent.left;
                anchors.right: parent.right;
                function getBits(sq) {
                    switch (sq) {
                    case 1:
                        return "64 - Mono"
                    case 2:
                        return "128 - Stereo"
                    case 3:
                        return "256 - Stereo"
                    default: {
                        return "";
                    }
                    }
                }
            }
            Label {
                text: qsTr("High quality uses more bandwidth! Not recommended if you don't have an unlimited 4G/3G data plan or use WiFi.");
                width: parent.width
                font.pixelSize: Theme.fontSizeSmall
                font.italic: true;
                visible: quality===3;
                wrapMode: Text.WordWrap
            }

            Label {
                text: qsTr("Restart playback to use new quality setting.");
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                wrapMode: Text.WordWrap
            }

            TextSwitch {
                id: loadArtistImages
                checked: root.loadArtistImage;
                text: qsTr("Load artist images");
                description: qsTr("Enabled downloading of a random image of the currently playing artist. Data usage increases.");
                onCheckedChanged: root.loadArtistImage=checked;
            }

            Label {
                text: qsTr("By enabling artist image loading you agree the the Nokia MixRadio <a href='http://www.nokia.com/global/privacy/privacy/service-terms/nokia-service-terms/'>Nokia Service Terms and Privacy Policy</a>");
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                visible: loadArtistImages.checked;
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(link)
            }

            /*
            TextSwitch {
                id: autoPlayLast
                text: qsTr("Autoplay on start");
                description: qsTr("Start playback of last used channel on application startup.");
            }

            TextSwitch {
                id: autoPlayLast
                text: qsTr("Autoplay on start");
                description: qsTr("Start playback of last used channel on application startup.");
            }
            */
        }
    }
}




