#pragma once
#include <QObject>
#include <QSettings>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class RecenFiles : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList recentFiles READ recentFiles WRITE setRecentFiles NOTIFY
                   recentFilesChanged FINAL)
    Q_PROPERTY(int maxCount READ maxCount WRITE setMaxCount NOTIFY maxCountChanged FINAL)
    Q_PROPERTY(QString curFile READ curFile WRITE setCurFile NOTIFY curFileChanged FINAL)
    QML_ELEMENT
public:
    explicit RecenFiles(QObject *parent = nullptr);
    explicit RecenFiles(int maxcount);
    RecenFiles(QStringList recenfs, int maxcount);
    Q_INVOKABLE void addRecentFile(const QString &filpath);
    Q_INVOKABLE int size() const;
    Q_INVOKABLE void clear();
    Q_INVOKABLE QString displayableFilePath(const QString &filePath) const;
    QStringList recentFiles();
    void setRecentFiles(const QStringList &newRecentFiles);
    int maxCount() const;
    void setMaxCount(int newMaxCount);

    QString curFile() const;
    void setCurFile(const QString &newCurFile);

signals:
    void recentFilesChanged();
    void maxCountChanged();

    void curFileChanged();

private:
    QString m_curFile;
    QStringList m_recentFiles;
    int m_maxCount;
};
