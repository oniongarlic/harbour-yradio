#include "DateUtils.h"

QString DateUtils::formatTime(const QString rawDateString)
{
	// Parse a datetime string looking like 2013-01-09T12:05:00
	QDateTime tmp=QDateTime::fromString(rawDateString, "yyyy-MM-dd'T'hh:mm:ss");
	if (!tmp.isValid())
		qDebug("Failed to parse rawDateString");
	return tmp.toString("hh:mm");
}

QDate DateUtils::getDate(const QString rawDateString)
{
	// Parse a datetime string looking like 2013-01-09T12:05:00
	QDateTime tmp=QDateTime::fromString(rawDateString, "yyyy-MM-dd'T'hh:mm:ss");
	if (!tmp.isValid())
		qDebug("Failed to parse rawDateString");
	return tmp.date();
}

QDateTime DateUtils::getDateTime(const QString rawDateString)
{
	// Parse a datetime string looking like 2013-01-09T12:05:00
	return QDateTime::fromString(rawDateString, "yyyy-MM-dd'T'hh:mm:ss");
}

