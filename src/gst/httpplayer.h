#ifndef HTTPPLAYER_H
#define HTTPPLAYER_H

#include "abstractplayer.h"

class HTTPPlayer : public AbstractPlayer
{
    Q_OBJECT

public:
    explicit HTTPPlayer(QObject *parent = 0);

public slots:

protected:

private:

};

#endif // HTTPPLAYER_H
