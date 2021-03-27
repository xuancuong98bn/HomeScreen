#include "langlistmodel.h"
#include "langlist.h"

LangListModel::LangListModel(QObject *parent)
    : QAbstractListModel(parent), mLangs(nullptr)
{
}

int LangListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !mLangs)
        return 0;

    // FIXME: Implement me!
    return mLangs->langs().size();
}

//implement to get data when qml involke with roleNames are defined below
QVariant LangListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || !mLangs)
        return QVariant();

    const Language lang = mLangs->langs().at(index.row());
    switch (role) {
    case kCode:
        return QVariant(lang.code);
    case kName:
        return QVariant(lang.name);
    case kSrc:
        return QVariant(lang.src);
    }
    return QVariant();
}

//define property will be call in qml list view
QHash<int, QByteArray> LangListModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[kCode] = "code";
    names[kName] = "name";
    names[kSrc] = "src";
    return names;
}

LangList *LangListModel::langs() const
{
    return mLangs;
}

void LangListModel::setLangs(LangList *langs)
{
    beginResetModel();
    if (mLangs) mLangs->disconnect(this);
    mLangs = langs;
}
