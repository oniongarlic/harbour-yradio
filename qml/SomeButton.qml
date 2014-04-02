import QtQuick 2.0
import Sailfish.Silica 1.0

Button {
    property string url;

    anchors.horizontalCenter: parent.horizontalCenter
    text: '';
    visible: url!=='' ? true : false;
    onClicked: Qt.openUrlExternally(url);
}
