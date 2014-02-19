import QtQuick 2.0
import QtQuick.XmlListModel 2.0

XmlListModel {
    query: "/rss/channel/item"

    XmlRole { name: "uid"; query: "guid/string()" }
    XmlRole { name: "title"; query: "title/string()" }
    XmlRole { name: "link"; query: "link/string()" }
    XmlRole { name: "description"; query: "description/string()" }
    XmlRole { name: "dateString"; query: "pubDate/string()" }
}
