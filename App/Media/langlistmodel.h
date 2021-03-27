#ifndef LANGLISTMODEL_H
#define LANGLISTMODEL_H

#include <QAbstractListModel>

class LangList;

class LangListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(LangList *langs READ langs WRITE setLangs)

public:
    explicit LangListModel(QObject *parent = nullptr);

    enum {
        kCode = Qt::UserRole,
        kName, kSrc
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    LangList *langs() const;
    void setLangs(LangList *langs);

private:
    LangList *mLangs;
};

#endif // LANGLISTMODEL_H
