#ifndef WIDGETSMODEL_H
#define WIDGETSMODEL_H

#include <QAbstractListModel>

class WidgetItem {
public:
    WidgetItem(QString type, QString url);
    QString type() const;
    QString url() const;

private:
    QString m_type;
    QString m_url;
};

class WidgetsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit WidgetsModel(QObject *parent = nullptr);
    enum Roles {
        TypeRole = Qt::UserRole + 1,
        UrlRole,
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void addWidget(WidgetItem &item);
    WidgetItem getWidget(int position);
    void loadWidgets();
public slots:
    QString getUrlByType(QString type);
    void move(int from, int to);
    void saveWidgets();
protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<WidgetItem> m_data;
    QList<WidgetItem> copy_data;
};

#endif // WIDGETSMODEL_H
