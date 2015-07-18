#include "downloader.h"
#include <unistd.h>
#include <QDir>

Downloader::Downloader(QObject *parent) : QObject(parent){}

QString Downloader::doDownload(const QString &link, const QString &image, const QString &path){
    m_path = path;
    m_image = image;
    m_stat = "downloading";
    manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply*)));
    manager->get(QNetworkRequest(QUrl(link)));
    return m_stat;
}

void Downloader::replyFinished (QNetworkReply *reply){
    if(reply->error()){
        qDebug() << "ERROR!";
        m_stat = "ERROR!";
        qDebug() << reply->errorString();
    }else{
        qDebug() << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString();

        //QString name = m_image;
        //make the directory here
        QDir dir;
        bool ok = dir.mkpath(m_path);

        if(ok){
            QFile *file = new QFile(m_path + m_image);
            if(file->open(QFile::Append)) {
                file->write(reply->readAll());
                file->flush();
                file->close();
                m_stat = "FINISHED";
            }
            delete file;
        }

    }
    reply->deleteLater();
}

QString Downloader::doStat(){
    return m_stat;
}

QString Downloader::doImg(){
    return m_image;
}

void Downloader::remFolder(const QString &pathtodel){

    QDir dir(pathtodel);
    dir.removeRecursively();
}
