import QtQuick 2.0
import QtQuick.XmlListModel 2.0

XmlListModel {
    id: model
    source: "yle.xml"
    query: "/radio/channels/channel"
    XmlRole { name: "name"; query: "name/string()" }
    XmlRole { name: "url"; query: "url/string()" }
    XmlRole { name: "url_program"; query: "url/string()" }
    XmlRole { name: "url_songs"; query: "data/high/string()" }
    XmlRole { name: "stream_high"; query: "streams/high/string()" }
    XmlRole { name: "stream_medium"; query: "streams/medium/string()" }
    XmlRole { name: "stream_low"; query: "streams/low/string()" }
}
