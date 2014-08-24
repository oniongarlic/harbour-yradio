#ifndef ABSTRACT_PLAYER_H
#define ABSTRACT_PLAYER_H

#include <glib.h>
#include <glib/gthread.h>

#include <QObject>
#include <QUrl>
#include <QThread>
#include <QNetworkConfigurationManager>
#include <QNetworkConfiguration>
#include <QNetworkSession>
#include <gst/gst.h>

class AbstractPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(bool playing READ isPlaying NOTIFY playingChanged)
    Q_PROPERTY(bool eos READ isEos NOTIFY eosChanged)
    Q_PROPERTY(bool connecting READ isConnecting NOTIFY connectingChanged)
    Q_PROPERTY(bool buffering READ isBuffering NOTIFY bufferingChanged)
    Q_PROPERTY(bool error READ isError NOTIFY errorChanged)
    Q_PROPERTY(int ecode READ getErrorCode)
    Q_PROPERTY(bool warning READ isWarning NOTIFY warningChanged)
    Q_PROPERTY(int wcode READ getWarningCode)
    Q_PROPERTY(int bufferpercent READ getBufferPercent NOTIFY bufferpercentChanged)

    Q_PROPERTY(bool connected READ getConnected)

    /* Eq */
    Q_PROPERTY(double eqband0 READ getEqBand0 WRITE setEqBand0 NOTIFY eqBand0Changed)
    Q_PROPERTY(double eqband1 READ getEqBand1 WRITE setEqBand1 NOTIFY eqBand1Changed)
    Q_PROPERTY(double eqband2 READ getEqBand2 WRITE setEqBand2 NOTIFY eqBand2Changed)

    /* Dolby mixer */
#if 0
    Q_PROPERTY(bool surround READ getSurround WRITE setSurround NOTIFY changedSurround)
    Q_PROPERTY(int brightness READ getSurroundBrightness WRITE setSurroundBrightness NOTIFY changedBrightness)
    Q_PROPERTY(int roomsize READ getSurroundRoomsize WRITE setSurroundRoomsize NOTIFY changedRoomsize)
#endif

    /* Volume, 0-1 */
    Q_PROPERTY(double volume READ getVolume WRITE setVolume NOTIFY changedVolume)

    /* Buffer size, in sec */
    Q_PROPERTY(int buffersize READ getBufferSize WRITE setBufferSize NOTIFY bufferSizeChanged)

    friend gpointer pipeline_play(gpointer data);
    friend gboolean player_bus_call(GstBus *bus, GstMessage *msg, gpointer data);

public:
    explicit AbstractPlayer(GstElement *src, QObject *parent = 0);
    ~AbstractPlayer();

    const QUrl &url();
    void setUrl(const QUrl &newUrl);

    bool isPlaying() { return m_playing; }
    bool isEos() { return m_eos; }
    bool isConnecting() { return m_connecting; }

    bool isBuffering() { return m_buffering; }
    int getBufferPercent() { return m_buffer; }

    bool getConnected() { return session->isOpen(); }

    bool isError() { return m_error; }   
    int getErrorCode() { return m_error_code; }

    bool isWarning() { return m_warning; }
    int getWarningCode() { return m_warning_code; }

    double getEqBand0();
    double getEqBand1();
    double getEqBand2();

    void setEqBand0(double eq);
    void setEqBand1(double eq);
    void setEqBand2(double eq);

#if 0
    void setSurround(bool d);
    bool getSurround();

    void setSurroundBrightness(int b);
    int getSurroundBrightness();

    void setSurroundRoomsize(int b);
    int getSurroundRoomsize();
#endif

    void setBufferSize(int s);
    int getBufferSize();

    void setVolume(double b);
    double getVolume();

    Q_INVOKABLE void play();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void pause();

    Q_INVOKABLE void connect() {
        if (!session->isOpen())
            session->open();
    }
    Q_INVOKABLE void disconnect() {
        if (session->isOpen())
            session->close();
    }

signals:
    void urlChanged();
    void playingChanged();
    void eosChanged();
    void connectingChanged();
    void bufferingChanged();
    void errorChanged();
    void warningChanged();
    void bufferpercentChanged();
    void changedSurround();
    void changedBrightness();
    void changedRoomsize();
    void changedVolume();

    void bufferSizeChanged();

    void eqBand0Changed();
    void eqBand1Changed();
    void eqBand2Changed();

public slots:

protected:
    GMutex *p_mutex;
    GstElement *m_pipe;
    GstElement *m_src;
    GstElement *m_queue;
    GstElement *m_decoder;
    GstElement *m_sink;
    GstElement *m_eq;
    GstElement *m_resample;
    GstElement *m_dhmix;
    GstElement *m_volume;
    GstBus *m_bus;

    QUrl m_url;
    QNetworkSession *session;

    bool m_eos;
    bool m_playing;
    bool m_stopped;
    bool m_error;
    int m_error_code;
    bool m_warning;
    int m_warning_code;
    bool m_connecting;
    bool m_buffering;
    int m_buffer;

    void setEos(bool e) {
        m_eos=e;
        emit eosChanged();
        setConnecting(false);
        setPlaying(false);
        setBuffering(0);
    }
    void setPlaying(bool e) {
        m_playing=e;
        emit playingChanged();
        if (e)
            setConnecting(false);
    }
    void setConnecting(bool e) {
        m_connecting=e;
        emit connectingChanged();
    }
    void setError(bool e, int c) {
        m_error_code=c;
        m_error=e;
        emit errorChanged();
    }
    void setWarning(bool e, int c) {
        m_warning_code=c;
        m_warning=e;
        emit warningChanged();
    }
    void setBuffering(int p) {
        m_buffer=p;
        m_buffering=(m_playing==true && p<95) ? true : false;
        emit bufferingChanged();
        emit bufferpercentChanged();
    }
};

#endif // ABSTRACT_PLAYER_H
