#ifndef DATEUTILS_H
#define DATEUTILS_H

#include <QObject>
#include <QDateTime>

class DateUtils : public QObject
{
    Q_OBJECT
public:
    explicit DateUtils(QObject *parent = 0);
    Q_INVOKABLE QDate getDate(const QString rawDateString);
    Q_INVOKABLE QDateTime getDateTime(const QString rawDateString);

signals:

public slots:

private:

};

#endif
