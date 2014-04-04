#include "FileDownloader.h"

#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QDir>
#include <QFile>
#include <QStandardPaths>

QNetworkDiskCache * FileDownloader::m_networkDiskCache = new QNetworkDiskCache();

FileDownloader::FileDownloader(QObject* parent)
    : QObject(parent),
    m_networkAccessManager(new QNetworkAccessManager(this)),
    m_httpcode(0),
    m_progress(0.0),
    m_loading(false),
    m_usecache(true)
{
    m_networkDiskCache->setCacheDirectory(QStandardPaths::writableLocation(QStandardPaths::CacheLocation));
    m_networkAccessManager->setCache(m_networkDiskCache);
}

void FileDownloader::download(const QUrl url, const QString destination)
{
    QNetworkRequest request(url);

    qDebug() << "URL: " << url;
    qDebug() << "Destination: " << destination;

    // xxx maybe more options ? export all control attributes?
    if (m_usecache) {
        qDebug() << "Using cache";
        request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    } else {
        request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::AlwaysNetwork);
    }
    request.setRawHeader("User-Agent", QString("Y-Radio (Sailfish OS)").toUtf8());

    if (!destination.isEmpty()) {
        if (destination.startsWith("/")) {
            m_dest_file = destination;
        } else {
            QString dataFolder = QDir::homePath();
            m_dest_file = dataFolder + "/" + destination;
        }
        QString tmp = m_dest_file+".tmp";
        m_dest.setFileName(m_dest_file);
        m_temp.setFileName(tmp);

        if (!m_temp.open(QIODevice::WriteOnly)) {
            emit complete(false);
            return;
        }
    } else {        
        m_dest_file.clear();
    }

    m_data.clear();

    m_progress=0.0;
    emit progressChanged();

    m_loading=true;
    emit loadingChanged();

    QNetworkReply* reply = m_networkAccessManager->get(request);
    connect(reply, SIGNAL(finished()), this, SLOT(onGetReply()));
    connect(reply, SIGNAL(downloadProgress(qint64, qint64)), this, SLOT(dowloadProgressed(qint64, qint64)));
}

void FileDownloader::setUseCache(bool cache) {
    if (m_usecache==cache)
        return;
    m_usecache=cache;
    emit useCacheChanged();
}

void FileDownloader::setData(QByteArray data) {
    m_data=data;
    emit dataChanged();
}

void FileDownloader::onGetReply()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    bool r=true;
    qint64 w=0;

    // Is this even needed?
    if (!reply)
        return;

    m_httpcode=reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QVariant rUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute);
    emit httpCodeChanged();

    QVariant contentMimeType = reply->header(QNetworkRequest::ContentTypeHeader);
    qDebug() << "MIME: " << contentMimeType;

    // XXX: Handle redirection if we get that
    if (rUrl.isValid()) {
        QUrl currentUrl = reply->request().url();
        QUrl newUrl = rUrl.toUrl();

        if (currentUrl==newUrl) {
            qDebug() << "Loop detected";
            emit complete(false);
        } else {

        }

        qDebug() << "Redirection not handled: " << rUrl;
        reply->deleteLater();
        return;
    }

    switch (reply->error()) {
    case QNetworkReply::NoError: {
        const qint64 available = reply->bytesAvailable();
        const QByteArray buffer(reply->readAll());
        setData(buffer);
        if (!m_dest_file.isEmpty()) {
            qDebug() << "Writing to temp file: " << m_temp.fileName();
            w=m_temp.write(buffer);
            m_temp.close();
            if (w==available) {
                qDebug() << "Moving temporary file in place: " << m_dest.fileName();
                m_dest.remove();
                r=m_temp.rename(m_dest.fileName());
            } else {
                qDebug() << "Write failed";
                m_temp.remove();
            }
        }
    }
    break;
    default: {
        QString e;
        e = tr("Error: %1 status: %2").arg(reply->errorString(), reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString());
        qDebug() << e;
        r=false;
    }
    }

    switch (m_httpcode) {
    case 200:
        break;
    case 301:
    case 302:
        qDebug() << "Redirect";
        break;
    case 404:
        r=false;
        break;
    default:
        break;
    }

    reply->deleteLater();

    emit complete(r);

    m_loading=false;
    emit loadingChanged();
}

void FileDownloader::dowloadProgressed(qint64 bytes, qint64 total)
{
    qDebug() << "Loading: " << bytes << " / " << total;

    if (total==0 || total<0) {
        m_progress = 0.0;
    } else {
        m_progress =  double(bytes)/double(total);
        qDebug() << "Progress: " << m_progress;
    }
    emit progressChanged();
}
