#ifndef LANGLIST_H
#define LANGLIST_H

#include <QObject>
#include <QVector>
#include "translation.h"

struct Language{
    E_Languages code;
    QString name;
    QString src;
};

class LangList : public QObject
{
    Q_OBJECT
public:
    explicit LangList(QObject *parent = nullptr);

    QVector<Language> langs() const;
    void loadLangs();

signals:

public slots:

private:
    QVector<Language> mLangs;
};

#endif // LANGLIST_H
