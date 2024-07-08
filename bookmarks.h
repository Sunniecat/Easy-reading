#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QSettings>
#include <QStringList>

class BookMarks : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString markPage READ markPage WRITE setMarkPage NOTIFY markPageChanged FINAL)
    Q_PROPERTY(QStringList marksList READ marksList WRITE setMarksList NOTIFY marksListChanged FINAL)
    Q_PROPERTY(QString curFile READ curFile WRITE setCurFile NOTIFY curFileChanged FINAL)
    QML_ELEMENT
public:
    explicit BookMarks(QObject *parent = nullptr);

    Q_INVOKABLE void addMark(const QString &newMark);
    Q_INVOKABLE int size() const;
    Q_INVOKABLE void clear();           //remove all marks
    Q_INVOKABLE void remove(int index); //remove a mark
    Q_INVOKABLE QString displayMark(const QString &mark) const;

    QString markPage() const;
    void setMarkPage(const QString &newMarkPage);
    QStringList marksList();
    void setMarksList(const QStringList &newMarksList);
    QString curFile() const;
    void setCurFile(const QString &newCurFile);

signals:

    void markPageChanged();
    void marksListChanged();
    void curFileChanged();

private:
    QSettings m_settings;
    QString m_curFile;
    QString m_markPage;      //the page of the new mark
    QStringList m_marksList; //all book marks
};
