#include "appconfig.h"

AppConfig::AppConfig(QSize device, QObject *parent) : QObject(parent)
{
    screen_size.default_size = QSize(1920, 1200);
    screen_size.device_size = device;
}

qreal AppConfig::getWRatio()
{
    return (qreal)screen_size.device_size.width()/screen_size.default_size.width();
}

qreal AppConfig::getHRatio()
{
    return (qreal)screen_size.device_size.height()/screen_size.default_size.height();
}

