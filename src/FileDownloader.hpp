#ifndef FILEDOWNLOADER_HPP
#define FILEDOWNLOADER_HPP

#include <QtCore/QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QNetworkDiskCache>
#include <QUrl>
#include <QFile>
#include <QDebug>

class QNetworkAccessManager;

class FileDownloader : public QObject
{
    Q_OBJECT
    Q_PROPERTY (double loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY (bool cache READ useCache WRITE setUseCache NOTIFY useCacheChanged)
    Q_PROPERTY (int httpCode READ httpCode NOTIFY httpCodeChanged)
    // Q_PROPERTY(QString userAgent READ userAgent NOTIFY userAgentChanged)
    // Q_PROPERTY(QString destination READ destination WRITE setDestination NOTIFY destinationChanged)
    Q_PROPERTY(QString data READ data NOTIFY dataChanged)    

public:
    FileDownloader(QObject* parent = 0);

public Q_SLOTS:
    void download(const QUrl url, const QString destination);
    QString data() const { return m_data; }

Q_SIGNALS:
    void complete(bool success);
    void loadingChanged();
    void dataChanged();
    void useCacheChanged();
    void httpCodeChanged();

private Q_SLOTS:
    void onGetReply();    
    void dowloadProgressed(qint64, qint64);
    double loading() const;
    bool useCache() { return m_usecache; }
    int httpCode() { return m_httpcode; }
    void setUseCache(bool cache);

private:
    void setData(QByteArray data);
    QNetworkAccessManager* m_networkAccessManager;
    static QNetworkDiskCache * m_networkDiskCache;
    double m_loading;
    bool m_usecache;
    int m_httpcode;
    QFile m_dest;
    QFile m_temp;
    QString m_dest_file;
    QString m_data;
};

#endif
