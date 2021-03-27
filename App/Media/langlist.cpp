#include "langlist.h"

LangList::LangList(QObject *parent) : QObject(parent)
{
    loadLangs();
}

QVector<Language> LangList::langs() const
{
    return mLangs;
}

//load all data's language to list
void LangList::loadLangs()
{
    Language lus;
    lus.code = E_Languages::US;lus.name = "United State";lus.src = "qrc:/App/Media/Image/us.png";
    mLangs.append(lus);
    Language lvi;
    lvi.code = E_Languages::VI;lvi.name = "Viet Nam";lvi.src = "qrc:/App/Media/Image/vn.png";
    mLangs.append(lvi);
}
