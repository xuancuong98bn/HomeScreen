#ifndef SONGLIST_H
#define SONGLIST_H

#include <QObject>
#include <QVector>
#include <QDir>
#include <QDebug>
#include <QAudio>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QString>
#include <taglib/tag.h>
#include <taglib/fileref.h>

using namespace TagLib;

struct Song{
    wstring title;
    wstring singer;
    QString art;
    QString src;
};

class SongList : public QObject
{
    Q_OBJECT
public:
    explicit SongList(QObject *parent = nullptr);

    QVector<Song> songs() const;
    void loadSongs(QMediaPlaylist *pList);

signals:

public slots:

private:
    QVector<Song> mSongs;
};

#endif // SONGLIST_H
