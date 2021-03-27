#include "mediacontroller.h"

MediaController::MediaController():clock(new QTimer()), count(0), isRepeat(false)
{
    player = new QMediaPlayer();
    playlist = new QMediaPlaylist(player);
    songList = new SongList();
    playlist->setPlaybackMode(QMediaPlaylist::Loop);
    songList->loadSongs(playlist);
    player->setPlaylist(playlist);
}

//connect signal and slot, then start controller activity
void MediaController::start()
{
    if (songList->songs().size() > 0){

        QObject::connect(player, SIGNAL(durationChanged(qint64)), this, SLOT(durationChanged(qint64)));
        QObject::connect(player, SIGNAL(mediaStatusChanged(QMediaPlayer::MediaStatus)), this, SLOT(statusChanged(QMediaPlayer::MediaStatus)));
        QObject::connect(playlist, SIGNAL(currentIndexChanged(int)),this, SLOT(onSongChanged(int)));
        QObject::connect(clock, SIGNAL(timeout()), this, SLOT(timerAction()));

//        QObject::connect(this, SIGNAL(playStateChanged(bool)), root, SLOT(onPlayStateChanged(bool)));
//        QObject *slider = root->findChild<QObject*>("rTimeSlider");
//        QObject::connect(this, SIGNAL(progressChanged(double)), slider, SLOT(onProgressChanged(double)));
//        QObject::connect(slider, SIGNAL(seekTo(double)), this, SLOT(seek(double)));
//        QObject::connect(slider, SIGNAL(widthChange()), this, SLOT(calculateProgress()));

        play();
        onSongChanged(0);
        clock->start(1000);
    }
}

//convert time (minisecond) to QString format hh:mm:ss
QString MediaController::calculateTime(int time)
{
    int hour = floor(time/1000/60/60);
    int minu = floor(time/1000/60%60);
    int sec = floor(time/1000%60);
    QString strH = (hour<10?"0":"") + QString::number(hour);
    return (hour<1?"":strH+":") +(minu<10?"0":"") + QString::number(minu) + ":" + (sec<10?"0":"")+ QString::number(sec);
}

//play when not playingstate and vice versa
void MediaController::play()
{
    if (player->state() != QMediaPlayer::State::PlayingState){
        player->play();
    } else {
        player->pause();
    }
    emit playStateChanged(player->state()==QMediaPlayer::State::PlayingState);
}

//set currentindex for playlist
void MediaController::setCurrentIndex(int index)
{
    //check to ensure that not out of bound
    if (index>=0 && index < songList->songs().size())
        playlist->setCurrentIndex(index);
}

//handle next function
void MediaController::next()
{
    //loop to ensure that don't have consecutive songs
    do{
        playlist->next();
    }
    while (playlist->currentIndex()==playlist->nextIndex());

}

//handle previous function
void MediaController::previous()
{
    //loop to ensure that don't have consecutive songs
    do{
    playlist->previous();
    }
    while (playlist->currentIndex()==playlist->previousIndex());
}

//handle suffle function
void MediaController::suffle(bool status)
{
    if (status){
        playlist->setPlaybackMode(QMediaPlaylist::Random);
    } else {
        playlist->setPlaybackMode(QMediaPlaylist::Loop);
    }
}

//handle suffle function by setting isRepeat property and using when the song end
void MediaController::repeat(bool status)
{
    isRepeat = status;
}

//handle all change when the song change
void MediaController::onSongChanged(int position)
{
    //set currentIndex of playList
    QObject *plist = root->findChild<QObject*>("playListID");
    if (plist){
        plist->setProperty("currentIndex", position);
    }
    //set information of MediaInfo
    QString t = QString::fromStdWString(songList->songs().at(position).title);
    QString s = QString::fromStdWString(songList->songs().at(position).singer);
    QString a = songList->songs().at(position).art;
    QObject *info = root->findChild<QObject*>("rMediaInfo");
    if (info){
        info->setProperty("title", t);
        info->setProperty("singer", s);
        info->setProperty("amount", songList->songs().size());
    }
    //set album art property
    QObject *albumArt = root->findChild<QObject*>("rAlbumArt");
    if (albumArt){
        albumArt->setProperty("currentIndex", position-1);
        albumArt->setProperty("currentSong", position);
    }
    //set timePlayed text for time slider
    //have this code will make text change back to zero quickly when change song
    QObject *slider = root->findChild<QObject*>("rTimeSlider");
    if (slider){
        slider->setProperty("timePlayed", "00:00");
    }
    emit songChanged(t, s, a);
}

//action for timer when timer timeout
//check whether count variable may be calculated or not
void MediaController::timerAction()
{
    int dura = player->duration();
    bool isPlaying = player->state() == QMediaPlayer::State::PlayingState;
    if (isPlaying && count <= dura-500){
        count+=1000;
        calculateProgress();
    }
}

//use to calculate and set up timePlayed and progress for slider
void MediaController::calculateProgress()
{
    int dura = player->duration();
    QObject *slider = root->findChild<QObject*>("rTimeSlider");
    if (slider){
        slider->setProperty("timePlayed", calculateTime(count));
    }
    double progress = count/(double)dura>1?1:count/(double)dura;
    emit progressChanged(progress);
}

//handle change and set timeTotal text when duration changed (play other song)
void MediaController::durationChanged(qint64 duration)
{
    QObject *slider = root->findChild<QObject*>("rTimeSlider");
    if (slider){
        slider->setProperty("timeTotal", calculateTime(duration));
    }
}

//seek mediaplayer to time that want, resetup timePlayed when change
void MediaController::seek(double ratio)
{
    count = ratio * player->duration();
    player->setPosition(count);
    QObject *slider = root->findChild<QObject*>("rTimeSlider");
    if (slider){
        slider->setProperty("timePlayed", calculateTime(count));
    }
}

//check status of media when change
//this function include only 2 status for checking repeat song and recount for timer
void MediaController::statusChanged(QMediaPlayer::MediaStatus status)
{
    if (status == QMediaPlayer::MediaStatus::EndOfMedia && isRepeat) {
        playlist->setCurrentIndex(playlist->currentIndex());
    }
    if (status == QMediaPlayer::MediaStatus::EndOfMedia || status == QMediaPlayer::MediaStatus::LoadingMedia){
        emit progressChanged(0);
        count = 0;
    }
}

//setter of root
void MediaController::setRoot(QObject *value)
{
    root = value;
}

//getter of song list
SongList *MediaController::getSongList()
{
    return songList;
}
