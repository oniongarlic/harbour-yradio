#ifndef RTSPPLAYER_H
#define RTSPPLAYER_H

#include <glib.h>
#include <glib/gthread.h>

#include <QObject>
#include <QUrl>
#include <QThread>
#include <QNetworkConfigurationManager>
#include <QNetworkConfiguration>
#include <QNetworkSession>
#include <gst/gst.h>

#include "abstractplayer.h"

class RTSPPlayer : public AbstractPlayer
{
    Q_OBJECT

    friend gboolean rtsp_bus_call(GstBus *bus, GstMessage *msg, gpointer data);

public:
    explicit RTSPPlayer(QObject *parent = 0);    

public slots:

protected:    

private:

};

#endif // RTSPPLAYER_H
