#include "abstractplayer.h"
#include "rtspplayer.h"
#include <glib.h>
#include <glib/gthread.h>
#include <gst/gst.h>

static GstElement *get_rtsp_source_element()
{
    GstElement *src;

    src=gst_element_factory_make("rtspsrc", "rtsp");
    g_assert(src);

    g_object_set(src, "retry", 4,
                 "latency", 5000,
                 "protocols", 4,
                 NULL);

    return src;
}

RTSPPlayer::RTSPPlayer(QObject *parent) :
    AbstractPlayer(get_rtsp_source_element(), parent)
{

}
