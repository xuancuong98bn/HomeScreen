#ifndef XMLWRITER_H
#define XMLWRITER_H
#include <QtXml>
#include <QFile>
#include "applicationsmodel.h"
#include "widgetsmodel.h"

class XmlWriter
{
public:
    XmlWriter(QString fileName, ApplicationsModel &model);
    XmlWriter(QString fileName, WidgetsModel &model);
private:
    QString convertID(int id);
};
#endif // XMLWRITER_H
