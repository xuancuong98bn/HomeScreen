#include "applicationsmodel.h"
#include "xmlreader.h"
#include "xmlwriter.h"
#include <QKeySequence>

ApplicationItem::ApplicationItem(QString title, QString key, QString url, QString iconPath)
{
    m_key = key;
    m_title = title;
    m_url = url;
    m_iconPath = iconPath;
}

QString ApplicationItem::title() const
{
    return m_title;
}

QString ApplicationItem::key() const
{
    return m_key;
}


QString ApplicationItem::url() const
{
    return m_url;
}

QString ApplicationItem::iconPath() const
{
    return m_iconPath;
}

QString ApplicationsModel::getUrlByKey(Qt::Key keyEvent)
{
    for(ApplicationItem app : m_data){
        qDebug() << QKeySequence(keyEvent).toString() << "and" << app.key();
        if (QKeySequence(keyEvent).toString().compare(app.key()) == 0){
            return app.url();
        }
    }
    return "NONE";
}

void ApplicationsModel::move(int from, int to)
{
    if (copy_data.size() > from && copy_data.size() > to){
        copy_data.move(from, to);
    }
}

void ApplicationsModel::saveApps()
{
    XmlWriter xmlWriter("applications.xml", *this);
}

ApplicationsModel::ApplicationsModel(QObject *parent)
{
    Q_UNUSED(parent)
}

int ApplicationsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

QVariant ApplicationsModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    const ApplicationItem &item = m_data[index.row()];
    if (role == TitleRole)
        return item.title();
    else if (role == UrlRole)
        return item.url();
    else if (role == IconPathRole)
        return item.iconPath();
    return QVariant();
}

void ApplicationsModel::addApplication(ApplicationItem &item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data << item;
    copy_data << item;
    endInsertRows();
}

ApplicationItem ApplicationsModel::getApplication(int position)
{
    return copy_data.at(position);
}

void ApplicationsModel::loadApps()
{
    XmlReader xmlReader("applications.xml", *this);
}

QHash<int, QByteArray> ApplicationsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[UrlRole] = "url";
    roles[IconPathRole] = "iconPath";
    return roles;
}

