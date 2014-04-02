import QtQuick 2.0
import QtQuick.XmlListModel 2.0

XmlListModel {
    id: model
    source: "../yle.xml"
    query: "/radio/channels/channel"

    XmlRole { name: "name"; query: "name/string()"; isKey: true; }
    XmlRole { name: "category"; query: "category/string()"; }
    XmlRole { name: "url"; query: "somes/some[@type='web']/string()" }
    XmlRole { name: "url_program"; query: "url/string()" }
    XmlRole { name: "url_news_rss"; query: "news[@type='rss']/string()" }
    // XmlRole { name: "url_songs"; query: "data/high/string()" }
    XmlRole { name: "stream_high"; query: "streams/stream[@quality='high']/string()" }
    XmlRole { name: "stream_medium"; query: "streams/stream[@quality='medium']/string()" }
    XmlRole { name: "stream_low"; query: "streams/stream[@quality='low']/string()" }
    XmlRole { name: "song_info_id"; query: "songInfo/string()" }
    XmlRole { name: "program_info_id"; query: "progInfo/string()" }

    // Social media data
    XmlRole { name: "some_web"; query: "somes/some[@type='web']/string()" }
    XmlRole { name: "some_facebook"; query: "somes/some[@type='facebook']/string()" }
    XmlRole { name: "some_twitter"; query: "somes/some[@type='twitter']/string()" }
    XmlRole { name: "some_youtube"; query: "somes/some[@type='youtube']/string()" }
    XmlRole { name: "some_instagram"; query: "somes/some[@type='instagram']/string()" }
    // XmlRole { name: "some_"; query: "somes/some[@type='']/string()" }

    function isValidId(id) {
        if (id<0)
            return false;
        if (id>model.count)
            return false;
        return true;
    }
}
