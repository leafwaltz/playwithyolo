#ifndef DATATAGCONTROLLER_H
#define DATATAGCONTROLLER_H

#include <QObject>
#include <QList>
#include <QString>
#include <QStringList>
#include <QDir>
#include <QQuickPaintedItem>
#include <QVector>
#include <QImage>
#include <QDebug>

#include <string>

#include <opencv2/opencv.hpp>

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

    Q_INVOKABLE void getImagePathes(QString folderPath)
    {
        imageFolderPath_ = folderPath;

        QDir dir(folderPath);
        QStringList nameFilters;
        nameFilters << "*.jpg" << "*.jpeg" << "*.png" << "*.JPG" << "*.JPEG" << "*.PNG";
        imageFiles_ = dir.entryList(nameFilters, QDir::Files|QDir::Readable, QDir::Name);
    }

    Q_INVOKABLE QString imagePath(int index) const
    {
        return imageFiles_[index];
    }

    Q_INVOKABLE QString imageFolderPath() const
    {
        return imageFolderPath_;
    }

    Q_INVOKABLE int imagesCount() const
    {
        return imageFiles_.size();
    }

private:
    QList<QString> nameList_;
    QString imageFolderPath_;
    QStringList imageFiles_;
};

#endif // DATATAGCONTROLLER_H
