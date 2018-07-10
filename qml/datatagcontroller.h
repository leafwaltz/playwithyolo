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
#include <QVariantList>
#include <QThread>
#include <QMap>
#include <QPair>
#include <QDebug>

class ImageFilesSaver : public QObject
{
    Q_OBJECT

public slots:
    void saveImageFiles(QStringList imageFiles)
    {
    }

signals:
    void resultReady(const QString &result);
};

class ImageFilesSaveController :  public QObject
{
    Q_OBJECT

public:
private:
    QThread saveThread;
};

class DataTagController : public QObject
{
    Q_OBJECT

    struct Tags
    {
        int classIndex;
        float x;
        float y;
        float height;
        float width;

        Tags()
            : classIndex(-1), x(0.), y(0.), height(0.), width(0.) {}

        Tags(int classIndex, float x, float y, float height, float width)
            : classIndex(classIndex), x(x), y(y), height(height), width(width) {}
    };

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

    void makeDataFolder()
    {
        QDir dir;

        if(!dir.exists(savePath_ + "/data"))
        {
            dir.mkdir(savePath_ + "/data");
        }

        if(!dir.exists(savePath_ + "/data/img"))
        {
            dir.mkdir(savePath_ + "/data/img");
        }
    }

    void saveNames()
    {
        QFile file(savePath_ + "/data/obj.names");
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
            qDebug() << "fuck";

        QTextStream out(&file);
        for(auto name : nameList_)
        {
            out << name << "\n";
        }
    }

    void saveTrainFile()
    {
        QFile file(savePath_ + "/data/train.txt");
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
            qDebug() << "fuck";

        QTextStream out(&file);
        for(auto imageFile : imageFiles_)
        {
            out << "data/img/" + imageFile << "\n";
        }
    }

    Q_INVOKABLE void saveImageTags(QString fileName, int classIndex, float x, float y, float width, float height)
    {
        imageTags_[fileName].push_back(Tags(classIndex, x, y, width, height));
    }

    Q_INVOKABLE void save()
    {
        makeDataFolder();
        saveNames();
        saveTrainFile();
    }

    Q_INVOKABLE void getImagePathes(QString folderPath)
    {
        imageFolderPath_ = folderPath;

        QDir dir(folderPath);
        QStringList nameFilters;
        nameFilters << "*.jpg" << "*.jpeg" << "*.png" << "*.JPG" << "*.JPEG" << "*.PNG";
        imageFiles_ = dir.entryList(nameFilters, QDir::Files|QDir::Readable, QDir::Name);
    }

    Q_INVOKABLE void setSavePath(QString folderPath)
    {
        savePath_ = folderPath;
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
    QString savePath_;
    QStringList imageFiles_;
    QMap<QString, QVector<Tags>> imageTags_;
};

#endif // DATATAGCONTROLLER_H
