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
    Q_PROPERTY (bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY (double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY (bool cache READ useCache WRITE setUseCache NOTIFY useCacheChanged)
    Q_PROPERTY (int httpCode READ httpCode NOTIFY httpCodeChanged)
    // Q_PROPERTY(QString userAgent READ userAgent NOTIFY userAgentChanged)
    // Q_PROPERTY(QString destination READ destination WRITE setDestination NOTIFY destinationChanged)
    Q_PROPERTY(QString data READ data NOTIFY dataChanged)    

public:
    FileDownloader(QObject* parent = 0);
    virtual ~FileDownloader();

public Q_SLOTS:
    void download(const QUrl url, const QString destination);
    QString data() const { return m_data; }

Q_SIGNALS:
    void complete(bool success);
    void loadingChanged();
    void progressChanged();
    void dataChanged();
    void useCacheChanged();
    void httpCodeChanged();

private Q_SLOTS:
    void onGetReply();    
    void dowloadProgressed(qint64, qint64);
    double progress() const { return m_progress; }
    bool loading() const { return m_loading; }
    bool useCache() { return m_usecache; }
    int httpCode() { return m_httpcode; }
    void setUseCache(bool cache);

private:
    static QNetworkDiskCache * m_networkDiskCache;
    QNetworkAccessManager* m_networkAccessManager;

    void setData(QByteArray data);

    int m_httpcode;
    double m_progress;
    bool m_loading;    
    bool m_usecache;    

    QFile m_dest;
    QFile m_temp;
    QString m_dest_file;
    QString m_data;
};

#endif
