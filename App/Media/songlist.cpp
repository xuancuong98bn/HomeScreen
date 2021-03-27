#include "songlist.h"

SongList::SongList(QObject *parent) : QObject(parent)
{
}

QVector<Song> SongList::songs() const
{
    return mSongs;
}

//load all data's song to list and add src to playlist
//using TagLib lib
void SongList::loadSongs(QMediaPlaylist *pList)
{
    QDir dir = QDir::currentPath();
    dir.cd(PROJECT_PATH"/App/Music");//default folder that not inside project
    QStringList files = dir.entryList(QStringList() << "*.mp3",QDir::Files);
    QList<QMediaContent> content;
    for(QString& f:files)
    {
        FileRef a((dir.path()+"/" + f).toLocal8Bit().data());
        Tag *tag = a.tag();
        Song s;
        s.title = tag->title().toWString();
        s.singer = tag->artist().toWString();
        if (tag->album() == String::null) s.art = "Image/album_art.png";
        else s.art = ("Image/" + tag->album()).toCString(true);
        s.src = dir.path()+"/" + f;
        mSongs.append(s);
        content.push_back(QUrl::fromLocalFile(dir.path()+"/" + f));
    }
    pList->addMedia(content);
}
