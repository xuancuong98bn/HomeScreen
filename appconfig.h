#ifndef APPCONFIG_H
#define APPCONFIG_H

#include <QObject>
#include <QSize>

struct ScreenSize
{
    QSize default_size;
    QSize device_size;
};

class AppConfig : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal w_ratio READ getWRatio NOTIFY sizeChanged)
    Q_PROPERTY(qreal h_ratio READ getHRatio NOTIFY sizeChanged)
public:
    explicit AppConfig(QSize device, QObject *parent = nullptr);
    qreal getWRatio();
    qreal getHRatio();
public slots:

signals:
    void sizeChanged();
public:
    ScreenSize screen_size;
};

#endif // APPCONFIG_H
