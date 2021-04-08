#ifndef APPLICATIONSMODEL_H
#define APPLICATIONSMODEL_H
#include <QAbstractListModel>

class ApplicationItem {
public:
    ApplicationItem(QString id, QString title, QString key, QString url, QString iconPath);
    QString id() const;
    QString title() const;
    QString key () const;
    QString url() const;
    QString iconPath() const;

private:    
    QString m_id;
    QString m_title;
    QString m_key;
    QString m_url;
    QString m_iconPath;
};

class ApplicationsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        KeyRole,
        UrlRole,
        IconPathRole
    };
    explicit ApplicationsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void addApplication(ApplicationItem &item);
    ApplicationItem getApplication(int position);
    void loadApps();
public slots:
    QString getIdByKey(Qt::Key keyEvent);
    QString getIdByIndex(int index);
    void move(int from, int to);
    void saveApps();
protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<ApplicationItem> m_data;
    QList<ApplicationItem> copy_data;
};

#endif // APPLICATIONSMODEL_H
