#include "abstractplayer.h"
#include <glib.h>
#include <glib/gthread.h>
#include <gst/gst.h>

static void
player_on_decoder_pad_added_cb (GstElement *decodebin, GstPad *pad, gpointer data)
{
    GstElement *e=GST_ELEMENT(data);
    GstPad *sinkpad;

    qDebug("New decoder pad");

    sinkpad=gst_element_get_pad(e, "sink");
    if (GST_PAD_IS_LINKED(sinkpad)) {
        g_object_unref(sinkpad);
        qDebug("Already linked!");
        return;
    }
    gst_pad_link(pad, sinkpad);
    gst_object_unref(sinkpad);
}

static void
src_on_pad_added_cb(GstElement *element, GstPad *pad, gpointer data)
{
    GstElement *e=GST_ELEMENT(data);
    GstPad *sinkpad;

    Q_UNUSED(element)
    qDebug("Add pad");

    sinkpad=gst_element_get_pad(e, "sink");
    gst_pad_link(pad, sinkpad);
    gst_object_unref(sinkpad);
}

static gboolean has_sometimes_template (GstElement * element)
{
  GstElementClass *klass = GST_ELEMENT_GET_CLASS (element);
  GList *l;

  for (l = klass->padtemplates; l != NULL; l = l->next) {
    if (GST_PAD_TEMPLATE (l->data)->presence == GST_PAD_SOMETIMES)
      return TRUE;
  }

  return FALSE;
}


gpointer pipeline_play(gpointer data)
{
    AbstractPlayer *m_this=static_cast<AbstractPlayer *>(data);
    GstElement *pipe=GST_ELEMENT(m_this->m_pipe);

    gst_element_set_state(pipe, GST_STATE_PLAYING);
    g_mutex_unlock(m_this->p_mutex);

    return NULL;
}

gboolean
player_bus_call(GstBus *bus, GstMessage *msg, gpointer data)
{
    AbstractPlayer *m_this=static_cast<AbstractPlayer *>(data);
    gint buffp;
    GstState newstate;
    GstState oldstate;
    GstState pending;
    GError *err=NULL;
    gchar *debug;
    GstElement *pipe=GST_ELEMENT(m_this->m_pipe);
    GstElement *element;
    GstStreamStatusType status;

    switch (GST_MESSAGE_TYPE(msg)) {
    case GST_MESSAGE_EOS:
        qDebug("EOS from %s", GST_MESSAGE_SRC_NAME(msg));
        gst_element_set_state(pipe, GST_STATE_NULL);
        m_this->setEos(true); // Handles playing==false too
        qDebug("EOS Handled");
        break;
    case GST_MESSAGE_ERROR:
        gst_message_parse_error(msg, &err, &debug);
        qDebug("Error: %d %s", err->code, err->message);
        qDebug("Debug info: %s", (debug) ? debug : "none");
        m_this->setError(true, err->code);
        g_free(debug);
        g_error_free(err);
        gst_element_set_state(pipe, GST_STATE_NULL);
        qDebug("ERR_NULLED");
        m_this->setEos(true);
        break;
    case GST_MESSAGE_WARNING:
        gst_message_parse_warning(msg, &err, &debug);
        qDebug("Warning: %d %s", err->code, err->message);
        qDebug("Debug info: %s", (debug) ? debug : "none");
        m_this->setWarning(true, err->code);
        g_free(debug);
        g_error_free(err);
        break;
    case GST_MESSAGE_STATE_CHANGED:
        gst_message_parse_state_changed(msg, &oldstate, &newstate, &pending);

        if (GST_MESSAGE_SRC(msg)==GST_OBJECT(pipe)) {
            m_this->setPlaying(newstate==GST_STATE_PLAYING ? true : false);
            if (m_this->isPlaying()) {
                m_this->setConnecting(false);
            }

            if (newstate==GST_STATE_READY) {
                m_this->setError(false, 0);
                m_this->setWarning(false, 0);
            }
            if (newstate==GST_STATE_READY && oldstate==GST_STATE_PAUSED) {
                m_this->setConnecting(false);
            }
        }

        qDebug("GST: %s state changed (o=%d->n=%d => p=%d)", GST_MESSAGE_SRC_NAME(msg), oldstate, newstate, pending);
        break;
    case GST_MESSAGE_BUFFERING:
        gst_message_parse_buffering(msg, &buffp);
        qDebug("BUFFERING: %d", buffp);
        m_this->setBuffering(buffp);
        break;
    case GST_MESSAGE_STREAM_STATUS:
        gst_message_parse_stream_status(msg, &status, &element);
        qDebug("GST: Status (%d) %s -> %s", status, GST_MESSAGE_SRC_NAME(msg), gst_message_type_get_name(GST_MESSAGE_TYPE(msg)));
        break;
    default:
        qDebug("GST: From %s -> %s", GST_MESSAGE_SRC_NAME(msg), gst_message_type_get_name(GST_MESSAGE_TYPE(msg)));
        break;
    }
    return TRUE;
}

AbstractPlayer::~AbstractPlayer()
{
    g_object_unref(m_pipe);
    session->close();
}

AbstractPlayer::AbstractPlayer(GstElement *src, QObject *parent) :
    QObject(parent)
{
    p_mutex=g_mutex_new();

    m_url="";
    m_eos=true;
    m_playing=false;
    m_connecting=false;
    m_error=false;
    m_warning=false;

    m_pipe=gst_pipeline_new("pipeline");
    g_assert(m_pipe);

    m_queue=gst_element_factory_make("queue2", "queue");
    g_object_set(m_queue, "use-buffering", TRUE, "low-percent", 15, "high-percent", 95, NULL);
    g_assert(m_queue);

    m_decoder=gst_element_factory_make("decodebin2", "decoder");
    g_assert(m_decoder);
    g_signal_connect(m_decoder, "pad-added", G_CALLBACK(player_on_decoder_pad_added_cb), m_queue);
    g_object_set(m_decoder, "use-buffering", TRUE, NULL);

    m_src=src;

    m_sink=gst_element_factory_make("pulsesink", "sink");
    g_assert(m_sink);
    g_object_set(m_sink, "mute", FALSE , NULL);

    m_volume=gst_element_factory_make("volume", "volume");
    g_assert(m_volume);

    m_eq=gst_element_factory_make("equalizer-3bands", "eq");
    g_assert(m_eq);

    m_resample=gst_element_factory_make("audioresample", "resample");
    g_assert(m_resample);
    g_object_set(m_resample, "quality", 10 , NULL);

    gst_bin_add_many(GST_BIN(m_pipe), m_src, m_queue, m_decoder, m_sink, m_resample, m_eq, m_volume, NULL);

    if (has_sometimes_template(m_src))
        g_signal_connect(src , "pad-added", G_CALLBACK(src_on_pad_added_cb), m_decoder);
    else
        g_assert(gst_element_link(m_src, m_decoder));

    /* queue -> eq -> dhmixer -> sink */
    g_assert(gst_element_link(m_queue, m_resample));
    g_assert(gst_element_link(m_resample, m_volume));
    g_assert(gst_element_link(m_volume, m_eq));
    g_assert(gst_element_link(m_eq, m_sink));

    m_bus=gst_pipeline_get_bus(GST_PIPELINE(m_pipe));
    g_assert(m_bus);
    gst_bus_add_watch(m_bus, player_bus_call, this);

    QNetworkConfigurationManager manager;
    QNetworkConfiguration cfg = manager.defaultConfiguration();
    session = new QNetworkSession(cfg);

    // session->open();
}

#define GET_EQ_BAND(band) { double eq; g_object_get(m_eq, band, &eq, NULL); return eq; }
//#define SET_EQ_BAND(_eq, _band) void AbstractPlayer::setEqBand0(double eq) { g_object_set(m_eq, "band0", eq, NULL); emit eqBand0Changed(); }

double AbstractPlayer::getEqBand0() { GET_EQ_BAND("band0"); }
double AbstractPlayer::getEqBand1() { GET_EQ_BAND("band1"); }
double AbstractPlayer::getEqBand2() { GET_EQ_BAND("band2"); }

void AbstractPlayer::setEqBand0(double eq) {
    g_object_set(m_eq, "band0", eq, NULL);
    emit eqBand0Changed();
}

void AbstractPlayer::setEqBand1(double eq) {
    g_object_set(m_eq, "band1", eq, NULL);
    emit eqBand1Changed();
}

void AbstractPlayer::setEqBand2(double eq) {
    g_object_set(m_eq, "band2", eq, NULL);
    emit eqBand2Changed();
}

double AbstractPlayer::getVolume() { double eq; g_object_get(m_volume, "volume", &eq, NULL); return eq; }
void AbstractPlayer::setVolume(double eq) {
    g_object_set(m_volume, "volume", eq, NULL);
    emit changedVolume();
}

int AbstractPlayer::getBufferSize() { int s; g_object_get(m_src, "latency", &s, NULL); return s/1000; }
void AbstractPlayer::setBufferSize(int s) {
    g_object_set(m_src, "latency", s*1000, NULL);
    qDebug("bs: %d", s);
    emit bufferSizeChanged();
}

#if 0
void AbstractPlayer::setSurround(bool d) {
    g_object_set(m_dhmix, "mobile-surround", d ? 1 : 0, NULL);
    emit changedSurround();
}

bool AbstractPlayer::getSurround()
{
    int s;

    g_object_get(m_dhmix, "mobile-surround", &s, NULL);
    qDebug("msr: %d", s);
    return s==0 ? false : true;
}

void AbstractPlayer::setSurroundBrightness(int d) {
    g_object_set(m_dhmix, "brightness", d, NULL);
    emit changedBrightness();
}
int AbstractPlayer::getSurroundBrightness()
{
    int s;

    g_object_get(m_dhmix, "brightness", &s, NULL);
    qDebug("sb: %d", s);
    return s;
}

void AbstractPlayer::setSurroundRoomsize(int d) {
    g_object_set(m_dhmix, "room-size", d, NULL);
    emit changedRoomsize();
}
int AbstractPlayer::getSurroundRoomsize()
{
    int s;

    g_object_get(m_dhmix, "room-size", &s, NULL);
    qDebug("srs: %d", s);
    return s;
}
#endif

const QUrl &AbstractPlayer::url() { return m_url; }

void AbstractPlayer::setUrl(const QUrl &newUrl)
{
    QByteArray tmp;
    const gchar *u;

    if (!newUrl.isValid()) {
        qDebug("Invalid URL");
        m_url.clear();
        emit urlChanged();
        return;
    }

    if (newUrl.isEmpty()) {
        qDebug("Empty URL");
        m_url.clear();
        emit urlChanged();
        return;
    }

    m_url=newUrl;
    tmp=newUrl.toEncoded();
    u=tmp.constData();

    qDebug("setUrl: [%s]", u);
    g_object_set(m_src, "location", u, NULL);
    emit urlChanged();
}

void AbstractPlayer::play()
{
    GstStateChangeReturn r=GST_STATE_CHANGE_SUCCESS;
    GstState state, pending;
    GThread *t;

    qDebug("play()");

    if (g_mutex_trylock(p_mutex)==FALSE)
        return;

    // gst_element_get_state(m_pipe, &state, &pending, 50000);

    t=g_thread_create(pipeline_play, this, FALSE, NULL);
    m_connecting=true;
    emit connectingChanged();

    qDebug("RESULT: %d", r);
}

void AbstractPlayer::stop()
{
    GstStateChangeReturn r;

    qDebug("stop()");
    r=gst_element_set_state(m_pipe, GST_STATE_READY);

    qDebug("RESULT: %d", r);
}

void AbstractPlayer::pause()
{
    GstStateChangeReturn r;

    g_debug("pause()");
    r=gst_element_set_state(m_pipe, GST_STATE_PAUSED);

    qDebug("RESULT: %d", r);
}
