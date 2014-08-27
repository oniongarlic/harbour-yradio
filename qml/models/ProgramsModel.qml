import QtQuick 2.0
import harbour.yradio 1.0
import ".."

Item {
    id: modelContainer

    property variant date;
    property string programId: ''
    property alias loading: downloader.loading;
    property ListModel model: programsModel

    function getModel() {
        return programsModel;
    }

    function reload() {
        var url=getProgramDataUrl(date);
        programsModel.clear();
        if (url) {
            console.debug("URL:" +url)
            downloader.download(url,'');
        } else {
            console.debug("URL not set");
        }
    }

    function getProgramDataUrl(d)
    {
        if (!d)
            return '';
        if (programId=='')
            return '';

        // Live URL
        return "http://yle.fi/ohjelmat/radio/"+programId+"/"+d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()+".json";

        // Testing URL
        //return "http://api.tal.org/0.0/testing/2013-10-8.json"
    }

    function getProgramObject(idx) {        
        if (programId=='')
            return null;

        var cdata=programsModel.get(idx);

        if (cdata===null)
            return null;

        return programComponent.createObject(modelContainer, {
                title: cdata.programName,
                description: cdata.description,
                startTime: cdata.startTime,
                endTime: cdata.endTime,
               });
    }

    Component {
        id: programComponent
        Program {

        }
    }

    onDateChanged: {
        console.debug("*** New date, reloading model data");
        reload();
    }

    ListModel {
        id: programsModel
    }

    FileDownloader {
        id: downloader
        cache: true;
        onComplete: {
            console.debug("*** Download completed")
            programsModel.clear();
            if (!success)
                return;

            console.debug("*** Parsing JSON");
            var o=JSON.parse(data);
            if (!o)
                return;

            console.debug(o.date);
            console.debug(o.service);

            try {
                for (var id in o.broadcasts) {                    
                    var p=o.broadcasts[id];

                    console.debug("**********************");
                    console.debug("ID: "+id);
                    console.debug("Prog:"+p.title);
                    console.debug("Synopsis:"+p.synopsis);
                    console.debug("Sstr:"+p.start);
                    console.debug("Estr:"+p.end);

                    // Parse the times to proper Qt dates
                    var st=du.getDateTime(p.start.substring(0,19));
                    var et=du.getDateTime(p.end.substring(0,19));

                    console.debug("ST:"+st);
                    console.debug("ET:"+et);

                    programsModel.append({programName: p.title, startTime: st, endTime: et, description: p.synopsis});
                }
            } catch (e) {
                console.debug("Failed to parse program data: "+e);
            }
            console.debug("*** Program data loaded and model is ready")
        }
        onDataChanged: {
            console.debug("*** Data lodaded, parsing");
        }
    }
}
