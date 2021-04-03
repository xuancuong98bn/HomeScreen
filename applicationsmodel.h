#ifndef APPLICATIONSMODEL_H
#define APPLICATIONSMODEL_H
#include <QAbstractListModel>

class ApplicationItem {
public:
    ApplicationItem(QString title, QString key, QString url, QString iconPath);
    QString title() const;
    QString key () const;
    QString url() const;
    QString iconPath() const;

private:    
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
        TitleRole = Qt::UserRole + 1,
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
    QString getUrlByKey(Qt::Key keyEvent);
    void move(int from, int to);
    void saveApps();
protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<ApplicationItem> m_data;
};

#endif // APPLICATIONSMODEL_H
