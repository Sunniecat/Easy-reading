#include "recenfiles.h"

#include <QFileInfo>

RecenFiles::RecenFiles(QObject *parent) {}

RecenFiles::RecenFiles(int maxcount)
    : m_maxCount(maxcount)
{}

RecenFiles::RecenFiles(QStringList recenfs, int maxcount)
    : m_recentFiles(recenfs)
    , m_maxCount(maxcount)
{
}

//setter/getter
QStringList RecenFiles::recentFiles()
{
    QSettings settings;
    m_recentFiles = settings.value("recentFiles").toStringList();
    return m_recentFiles;
}

void RecenFiles::setRecentFiles(const QStringList &newRecentFiles)
{
    if (m_recentFiles == newRecentFiles)
        return;
    QSettings settings;
    m_recentFiles = newRecentFiles;
    settings.setValue("recentFiles",
                      m_recentFiles); //if recentfiles changed, then settings should changed too
    emit recentFilesChanged();
}

int RecenFiles::maxCount() const
{
    return m_maxCount;
}

void RecenFiles::setMaxCount(int newMaxCount)
{
    if (m_maxCount == newMaxCount)
        return;
    m_maxCount = newMaxCount;
    emit maxCountChanged();
}

QString RecenFiles::curFile() const
{
    return m_curFile;
}

void RecenFiles::setCurFile(const QString &newCurFile)
{
    if (m_curFile == newCurFile)
        return;
    m_curFile = newCurFile;
    emit curFileChanged();
}

void RecenFiles::addRecentFile(const QString &filepath)
{
    QSettings settings; //-->settings是全局单例对象
    //先获取setting中原本就有的recentfiles list
    m_recentFiles = recentFiles();
    //Removes all elements that compare equal to t from the list. Returns the number of elements removed, if any.
    m_recentFiles.removeAll(filepath);
    m_recentFiles.prepend(filepath); //Inserts value at the beginning of the list.
    while (m_recentFiles.size() > m_maxCount)
        m_recentFiles.removeLast(); //Removes the last item in the list.
    //Sets the value of setting key to value. If the key already exists, the previous value is overwritten.
    settings.setValue("recentFiles", m_recentFiles);
    emit recentFilesChanged();
}

int RecenFiles::size() const
{
    return m_recentFiles.size();
}

void RecenFiles::clear()
{
    QSettings settings;
    settings.clear();
    m_recentFiles.clear();
}

QString RecenFiles::displayableFilePath(const QString &filePath) const
{
    // use QFileInfo to get the information of the file
    QFileInfo fileInfo(filePath);
    //return the name of the file( it doesn't include the path)
    return fileInfo.fileName();
}
