import QtQuick 2.0

// The current channel
QtObject {
    property string name;
    property string url;
    property string surl_lq;
    property string surl_mq;
    property string surl_hq;
    property string songInfoId;
    property string programInfoId;
    property bool hasProgram: programInfoId!=='';
    property bool hasSongInfo: songInfoId!=='';

    property SocialMedia social: SocialMedia { }

    // Ok, for now all channels have low/med/high
    function getStreamUrl(quality) {
        // XXX: Sailfish OS 2.0/gst 1.0: Force HLS streams (High quality)
        return surl_hq;
        /*
        switch (quality) {
        case 1:
            return surl_lq;
        case 2:
            return surl_mq;
        case 3:
            return surl_hq;
        }
        return surl_mq;
        */
    }
}
