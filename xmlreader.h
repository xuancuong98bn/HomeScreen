#ifndef XMLREADER_H
#define XMLREADER_H
#include <QtXml>
#include <QFile>
#include "applicationsmodel.h"
#include "widgetsmodel.h"

class XmlReader
{
public:
    XmlReader(QString fileName, ApplicationsModel &model);
    XmlReader(QString fileName, WidgetsModel &model);
private:
    QDomDocument m_xmlDoc; //The QDomDocument class represents an XML document.
    bool ReadXmlFile(QString fileName);
    void PaserXmlToApp(ApplicationsModel &model);
    void PaserXmlToWidget(WidgetsModel &model);
};

#endif // XMLREADER_H
