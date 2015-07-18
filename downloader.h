#ifndef DOWNLOADER_H
#define DOWNLOADER_H
#include <QtQuick/QQuickItem>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QFile>
#include <QDebug>
using namespace std;

class Downloader : public QObject
{
    Q_OBJECT
public:
    explicit Downloader(QObject *parent = 0);

    Q_INVOKABLE QString doDownload(const QString &link, const QString &image, const QString &path);
    Q_INVOKABLE QString doStat();
    Q_INVOKABLE QString doImg();
    Q_INVOKABLE void remFolder(const QString &pathtodel);
    QString m_path;
    QString m_image;
    Q_INVOKABLE QString m_stat = "NOT YET!";

signals:

public slots:
    void replyFinished(QNetworkReply *reply);

private:
   QNetworkAccessManager *manager;

};

#endif // DOWNLOADER_H
