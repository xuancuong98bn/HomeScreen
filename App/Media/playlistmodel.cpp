#include "playlistmodel.h"
#include "songlist.h"

PlayListModel::PlayListModel(QObject *parent)
    : QAbstractListModel(parent), mSongs(nullptr)
{
}

int PlayListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !mSongs)
        return 0;

    // FIXME: Implement me!
    return mSongs->songs().size();
}

//implement to get data when qml involke with roleNames are defined below
QVariant PlayListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || !mSongs)
        return QVariant();

    // FIXME: Implement me!
    const Song song = mSongs->songs().at(index.row());
    switch (role) {
    case kTitle:
        return QVariant(QString::fromStdWString(song.title));
    case kSinger:
        return QVariant(QString::fromStdWString(song.singer));
    case kArt:
        return QVariant(song.art);
    case kSrc:
        return QVariant(song.src);
    }
    return QVariant();
}

//define property will be call in qml list view
QHash<int, QByteArray> PlayListModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[kTitle] = "title";
    names[kSinger] = "singer";
    names[kArt] = "art";
    names[kSrc] = "src";
    return names;
}

SongList *PlayListModel::songs() const
{
    return mSongs;
}

void PlayListModel::setSongs(SongList *songs)
{
    beginResetModel();
    if (mSongs) mSongs->disconnect(this);
    mSongs = songs;
}
