#ifndef MEDIACONTROLLER_H
#define MEDIACONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QTimer>
#include <cmath>

#include "songlist.h"

class MediaController : public QObject
{
    Q_OBJECT
public:
    MediaController();
    void start();
    QString calculateTime(int time);
    void setRoot(QObject *value);
    SongList* getSongList();
    void updateInfo(int position);
signals:
    void playStateChanged(bool state);
    void shuffleStateChanged(bool state);
    void repeatStateChanged(bool state);
    void progressChanged(double pro);
    void songChanged(QString title, QString singer, QString src);

public slots:
    void play();
    void setCurrentIndex(int index);
    void next();
    void previous();
    void suffle(bool status);
    void repeat(bool status);
    void volumnUp();
    void volumnDown();
    void volumnMute();

    void onSongChanged(int position);
    void timerAction();
    void calculateProgress();
    void durationChanged(qint64 duration);
    void seek(double ratio);
    void statusChanged(QMediaPlayer::MediaStatus status);
    void updateInfo();
private:
    QObject *root;
    SongList *songList;
    QMediaPlayer *player;
    QMediaPlaylist *playlist;
    QTimer *clock;
    int count;
    bool isRepeat;
};

#endif // MEDIACONTROLLER_H
