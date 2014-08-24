#include "abstractplayer.h"
#include "httpplayer.h"
#include <glib.h>
#include <glib/gthread.h>
#include <gst/gst.h>

static GstElement *get_http_source_element()
{
    GstElement *src;

    src=gst_element_factory_make("souphttpsrc", "http");
    g_assert(src);
    g_object_set(src, "is-live", TRUE, "timeout", 10, "iradio-mode", TRUE, NULL);

    return src;
}

HTTPPlayer::HTTPPlayer(QObject *parent) :
    AbstractPlayer(get_http_source_element(), parent)
{

}

