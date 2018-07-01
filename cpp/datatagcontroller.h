#ifndef DATATAGCONTROLLER_H
#define DATATAGCONTROLLER_H

#include <QObject>
#include <QList>
#include <QString>
#include <QDebug>

class DataTagController : public QObject
{
    Q_OBJECT

public:
    ~DataTagController() {}

    static DataTagController& globalInstance()
    {
        static DataTagController instance;
        return instance;
    }

    Q_INVOKABLE void addName(QString name)
    {
        nameList_.append(name);
    }

private:
    QList<QString> nameList_;
};

#endif // DATATAGCONTROLLER_H
