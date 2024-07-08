#include "bookmarks.h"

BookMarks::BookMarks(QObject *parent)
    : QObject{parent}
{}

//setter/getter
QString BookMarks::markPage() const
{
    return m_markPage;
}

void BookMarks::setMarkPage(const QString &newMarkPage)
{
    if (m_markPage == newMarkPage)
        return;
    m_markPage = newMarkPage;
    emit markPageChanged();
}

QStringList BookMarks::marksList()
{
    //get the value of the key(cur_file)
    m_marksList = m_settings.value(m_curFile).toStringList();
    return m_marksList;
}

void BookMarks::setMarksList(const QStringList &newMarksList)
{
    if (m_marksList == newMarksList)
        return;
    m_marksList = newMarksList;
    //update settings（cur_file is the key, and now the m_markslist is value of the key）
    m_settings.setValue(m_curFile, m_marksList);
    emit marksListChanged();
}

QString BookMarks::curFile() const
{
    return m_curFile;
}

void BookMarks::setCurFile(const QString &newCurFile)
{
    if (m_curFile == newCurFile)
        return;
    m_curFile = newCurFile;
    emit curFileChanged();
}

void BookMarks::addMark(const QString &newMark)
{
    m_marksList = marksList(); //get the marks list of cur_file
    m_marksList.removeAll(newMark);
    m_marksList.append(newMark);
    m_settings.setValue(m_curFile, m_marksList); //update settings
    emit marksListChanged();
}

int BookMarks::size() const
{
    return m_marksList.size();
}

void BookMarks::clear()
{
    m_marksList.clear(); //remove all data in marksList
    m_settings.setValue(m_curFile, m_marksList); //update settings
}

void BookMarks::remove(int index)
{
    m_marksList.removeAt(index);
    m_settings.setValue(m_curFile, m_marksList); //update settings
}

QString BookMarks::displayMark(const QString &mark) const
{
    QString str = "#page" + mark + " / " + mark;
    return str;
}
