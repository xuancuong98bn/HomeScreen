#include "widgetsmodel.h"
#include "xmlreader.h"
#include "xmlwriter.h"

WidgetsModel::WidgetsModel(QObject *parent)
{
    Q_UNUSED(parent)
}

int WidgetsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

QVariant WidgetsModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    const WidgetItem &item = m_data[index.row()];
    if (role == TypeRole)
        return item.type();
    else if (role == UrlRole)
        return item.url();
    return QVariant();
}

//add a WidgetItem to m_data and copy_data list
void WidgetsModel::addWidget(WidgetItem &item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data << item;
    copy_data << item;
    endInsertRows();
}

//get a WidgetItem in copy_data list at position (real position)
WidgetItem WidgetsModel::getWidget(int position)
{
    return copy_data.at(position);
}

void WidgetsModel::loadWidgets()
{
    XmlReader xmlReader("widgets.xml", *this);
}

QString WidgetsModel::getUrlByType(QString type)
{
    //loop all member of m_data to get url of member if member type equal type param
    for(WidgetItem item : m_data){
        if (item.type().compare(type) == 0) return item.url();
    }
    return "NONE";
}

void WidgetsModel::move(int from, int to)
{
    if (from >= 0 && to >= 0 && copy_data.size() > from && copy_data.size() > to){
        copy_data.move(from, to);
    }
}

void WidgetsModel::saveWidgets()
{
    XmlWriter xmlWriter("widgets.xml", *this);
}

QHash<int, QByteArray> WidgetsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TypeRole] = "type";
    roles[UrlRole] = "url";
    return roles;
}

WidgetItem::WidgetItem(QString type, QString url)
{
    m_type = type;
    m_url = url;
}

QString WidgetItem::type() const
{
    return m_type;
}

QString WidgetItem::url() const
{
    return m_url;
}
