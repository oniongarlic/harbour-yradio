import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import harbour.yradio 1.0
import ".."

Item {
    id: songInfo
    property XmlListModel model: songInfoModel
    property int infoIndex: 0;
    property string infoId: null;
    property variant songData: null;

    signal updated();
    signal empty();

    property bool busy: songInfoModel.status==XmlListModel.Loading;

    Component {
        id: songComponent
        Song {

        }
    }

    FileDownloader {
        id: downloader
        cache: false;
        onComplete: {
            console.debug("*** Download completed")

            if (!success) {
                songInfoModel.xml=''
                return;
            }

            console.debug(data);
            songInfoModel.xml=data;
        }
        onDataChanged: {
            console.debug("*** Song data lodaded");
        }
    }

    function getSong() {
        if (songData===null)
            return null;

        return songComponent.createObject(songInfoModel, {
                                              title: songData.title,
                                              artist: songData.performer ? songData.performer : songData.vocalist ? songData.vocalist : '',
                                                                                                                    start: songData.start,
                                                                                                                    duration: songData.duration
                                          });
    }

    function reloadSongInfo()
    {
        if (infoIndex<-2)
            return false;
        if (infoIndex>2)
            return false;
        if (infoId=='')
            return false;

        var url="http://yle.fi/radiomanint/LiveXML/"+infoId+"/item("+infoIndex+").xml";
        downloader.download(url,'');

        return true;
    }

    XmlListModel {
        id: songInfoModel
        query: "/RMPADEXPORT/ITEM"

        property bool loading: false;

        XmlRole { name: "title"; query: "@TITLE/string()" }
        XmlRole { name: "performer"; query: "@PERFORMER/string()" }
        XmlRole { name: "vocalist"; query: "ROLES/ROLE[1]/PERSON_NAME/string()" }
        XmlRole { name: "start"; query: "@STARTING_TIME/string()" }
        XmlRole { name: "duration"; query: "PUBLISH-DATA/@DURATION/string()"; }
        XmlRole { name: "program"; query: "@PLAYOUT_PROGRAMME_NAME/string()"; }
        XmlRole { name: "type"; query: "@TYPE/string()" }

        onStatusChanged: {
            console.debug("MS: "+status);
            if (status==XmlListModel.Ready) {
                console.debug("MSC: "+count);
                if (count===0) {
                    songData=null;
                    empty();
                    return;
                }

                songData=songInfoModel.get(0);
                updated();
            } else if (status==XmlListModel.Error) {
                console.debug("MSError")
                songData=null;
                empty();
            }
        }
    }
}
