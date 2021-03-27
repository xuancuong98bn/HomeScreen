#ifndef TRANSLATION_H
#define TRANSLATION_H

#include <QObject>
#include <QGuiApplication>
#include <QQuickView>
#include <QTranslator>
#include <QLocale>

enum E_Languages
{
    US = QLocale::UnitedStates,
    VI = QLocale::Vietnamese
};

class Translation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString emptyString READ getEmptyString NOTIFY languageChanged)
public:
    Translation(QGuiApplication *app) {mApp = app;}
    QString getEmptyString(){return "";}

signals:
    void languageChanged();

public slots:
    void updateLanguage(int lang){
        switch (lang) {
            case E_Languages::VI:
            mTranslator.load("Media_VI", ":/translator");
            mApp->installTranslator(&mTranslator);
            //qDebug() << "Vietnam" ;
            break;
        default:
            mApp->removeTranslator(&mTranslator);
            //qDebug() << "US";
            break;
        }
        emit languageChanged();
    }
private:
    QGuiApplication *mApp;
    QTranslator mTranslator;

};

#endif // TRANSLATION_H
