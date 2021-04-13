#include "xmlwriter.h"
#include <QTextStream>

XmlWriter::XmlWriter(QString fileName, ApplicationsModel &model)
{
    // Load xml file as raw data
    QFile f(PROJECT_PATH + fileName);
    if (!f.open(QIODevice::WriteOnly | QIODevice::Text ))
    {
        // Error while loading file
        return;
    }
    // Set data into the QDomDocument before processing
    QDomDocument m_xmlDoc;

    QDomElement root = m_xmlDoc.createElement("APPLICATIONS");
    m_xmlDoc.appendChild(root);

    for (int i = 0; i < model.rowCount(); i++){
        ApplicationItem app = model.getApplication(i);
        QDomElement tagName = m_xmlDoc.createElement("APP");
        tagName.setAttribute("ID", convertID(i));

        QDomElement tagTitle = m_xmlDoc.createElement("TITLE");
        QDomText txtTitle = m_xmlDoc.createTextNode(app.title());
        tagTitle.appendChild(txtTitle);
        tagName.appendChild(tagTitle);

        QDomElement tagKey = m_xmlDoc.createElement("KEY");
        QDomText txtKey = m_xmlDoc.createTextNode(app.key());
        tagKey.appendChild(txtKey);
        tagName.appendChild(tagKey);

        QDomElement tagURL = m_xmlDoc.createElement("URL");
        QDomText txtURL = m_xmlDoc.createTextNode(app.url());
        tagURL.appendChild(txtURL);
        tagName.appendChild(tagURL);

        QDomElement tagPath = m_xmlDoc.createElement("ICON_PATH");
        QDomText txtPath = m_xmlDoc.createTextNode(app.iconPath());
        tagPath.appendChild(txtPath);
        tagName.appendChild(tagPath);

        root.appendChild(tagName);
    }

    QTextStream stream (&f);
    stream << m_xmlDoc.toString();
    f.close();
}

XmlWriter::XmlWriter(QString fileName, WidgetsModel &model)
{
    // Load xml file as raw data
    QFile f(PROJECT_PATH + fileName);
    if (!f.open(QIODevice::WriteOnly | QIODevice::Text ))
    {
        // Error while loading file
        return;
    }
    // Set data into the QDomDocument before processing
    QDomDocument m_xmlDoc;

    QDomElement root = m_xmlDoc.createElement("WIDGETS");
    m_xmlDoc.appendChild(root);

    for (int i = 0; i < model.rowCount(); i++){
        WidgetItem app = model.getWidget(i);
        QDomElement tagName = m_xmlDoc.createElement("WID");
        tagName.setAttribute("ID", convertID(i));

        QDomElement tagTitle = m_xmlDoc.createElement("TYPE");
        QDomText txtTitle = m_xmlDoc.createTextNode(app.type());
        tagTitle.appendChild(txtTitle);
        tagName.appendChild(tagTitle);

        QDomElement tagURL = m_xmlDoc.createElement("URL");
        QDomText txtURL = m_xmlDoc.createTextNode(app.url());
        tagURL.appendChild(txtURL);
        tagName.appendChild(tagURL);

        root.appendChild(tagName);
    }

    QTextStream stream (&f);
    stream << m_xmlDoc.toString();
    f.close();
}

QString XmlWriter::convertID(int id)
{
    id++;
    if (id < 10) return "00" + QString::number(id);
    if (id < 100) return "0" + QString::number(id);
    return QString::number(id);
}
