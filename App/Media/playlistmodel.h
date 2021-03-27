#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>

class SongList;

class PlayListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(SongList *songs READ songs WRITE setSongs)

public:
    explicit PlayListModel(QObject *parent = nullptr);
    ~PlayListModel(){};
    enum {
        kTitle = Qt::UserRole,
        kSinger, kArt, kSrc
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    SongList *songs() const;
    void setSongs(SongList *songs);

private:
    SongList *mSongs;
};

#endif // PLAYLISTMODEL_H
