import QtQuick 2.0
import QtQuick.XmlListModel 2.0

XmlListModel {
    id: songInfoModel    
    query: "/RMPADEXPORT/ITEM"

    property int infoIndex: 0;
    property string infoId: null;
    property variant songData: null;

    property bool loading: false;

    signal updated();
    signal empty();

    XmlRole { name: "title"; query: "@TITLE/string()" }
    XmlRole { name: "performer"; query: "@PERFORMER/string()" }
    XmlRole { name: "vocalist"; query: "@VOCALIST/string()" }
    XmlRole { name: "start"; query: "@STARTING_TIME/string()" }
    XmlRole { name: "duration"; query: "PUBLISH-DATA/@DURATION/string()"; }
    XmlRole { name: "program"; query: "@PLAYOUT_PROGRAMME_NAME/string()"; }

    // We load the information manually, as the server stupidly sends a 404 + redirection if the information is not available and the
    // model is stuck with the url.
    function reloadSongInfo()
    {
        if (infoId==='')
            return;
        if (infoIndex>2)
            return;
        if (infoIndex<-2)
            return;

        loading=true;
        var doc = new XMLHttpRequest();
        var url="http://yle.fi/radiomanint/LiveXML/"+infoId+"/item("+infoIndex+").xml";

        doc.onreadystatechange = function() {
                    if (doc.readyState === XMLHttpRequest.DONE && doc.status===200) {
                        // console.debug(doc.responseText);
                        songInfoModel.xml=doc.responseText;
                    }
                    if (doc.readyState === XMLHttpRequest.DONE)
                        loading=false;
                }
        doc.open("GET", url);       
        doc.send();
    }

    onLoadingChanged: console.debug("Loading: "+loading)

    onStatusChanged: {
        console.debug("MS: "+status);
        console.debug("Source: "+source)
        if (status==XmlListModel.Ready) {
            console.debug("MSC: "+count);
            if (count===0) {
                songData=null;
                empty();
                return;
            }

            var data=songInfoModel.get(0);
            songData=data;           

            updated();
        } else if (status==XmlListModel.Error) {
            console.debug("MSError")
            songData=null;
            empty();
        }
    }
}
