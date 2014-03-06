import QtQuick 2.0
import harbour.org.tal 1.0

Item {
    id: modelContainer

    property variant date;
    property string programId: ''
    property bool loading: downloader.loading>0.0 && downloader.loading<1.0;

    function getModel() {
        return programsModel;
    }

    function reload() {
        var url=getProgramDataUrl(date);
        if (url) {
            downloader.download(url,'');
        }
    }

    function getProgramDataUrl(d)
    {
        if (!d)
            return '';

        // Live URL
        //return "http://yle.fi/ohjelmat/radio/"+programId+"/"+d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()+".json";

        // Testing URL
        return "http://api.tal.org/0.0/testing/2013-10-8.json"
    }

    onDateChanged: {
        console.debug("New date, reloading model data")
        reload();
    }

    ListModel {
        id: programsModel
    }

    FileDownloader {
        id: downloader
        onComplete: {
            console.debug("Download completed")
            programsModel.clear();
            if (!success)
                return;

            console.debug("Parsing JSON");
            var o=JSON.parse(data);
            if (!o)
                return;

            console.debug(o.date)
            console.debug(o.service)


            try {
                for (var id in o.broadcasts) {
                    console.debug("ID: "+id);
                    var p=o.broadcasts[id];
                    console.debug("Prog:"+p.title);
                    console.debug("Synopsis:"+p.synopsis);
                    programsModel.append({programName: p.title, startTime: p.start, endTime: p.end, description: p.synopsis});
                }
            } catch (e) {
                console.debug("Failed to parse program data: "+e);
            }
        }
        onDataChanged: {
            console.debug("New downloaded data:\n"+data);
        }
    }
}
