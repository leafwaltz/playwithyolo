#ifndef DATATAGCONTROLLER_H
#define DATATAGCONTROLLER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QTextStream>
#include <QMap>
#include <QVector>
#include <QDir>
#include <QThread>

struct TagRect
{
    int     classIndex;
    QString className;
    float   x;
    float   y;
    float   width;
    float   height;

    TagRect()
    {
    }

    TagRect(int classIndex, QString className, float x, float y, float width, float height)
        : classIndex(classIndex), className(className), x(x), y(y), width(width), height(height)
    {
    }
};

class SaveDataFilesThread : public QThread
{
    Q_OBJECT

    void run() override;

public:
    SaveDataFilesThread(QObject* parent = 0)
        : QThread(parent)
    {
    }

    void setPathAndData(const QString& imageFolderPath, const QString& savePath, const QMap<QString, QVector<TagRect>>& data);

signals:
    void saveStart();
    void done();
    void saving(QString fileName);
    void savingProgress(float process);
    void error(QString message);

private:
    QString savePath_;
    QString imageFolderPath_;
    QMap<QString, QVector<TagRect>> data_;
};

class DataTagController : public QObject
{
    Q_OBJECT

public:
    DataTagController(QObject* parent = 0)
        : QObject(parent)
    {
    }

    ~DataTagController() {}

    Q_INVOKABLE void addName(QString name);

    Q_INVOKABLE void makeDataFolder();

    Q_INVOKABLE void saveNames();

    Q_INVOKABLE void saveTrainFile();

    Q_INVOKABLE void saveTagRect(QString imageFileName, int classIndex, QString className, float x, float y, float width, float height);

    Q_INVOKABLE void saveDataFiles();

    Q_INVOKABLE void getImagePathes(QString folderPath);

    Q_INVOKABLE void setSavePath(QString folderPath);

    Q_INVOKABLE QString imageFileName(int index) const;

    Q_INVOKABLE QString imagePath(int index) const;

    Q_INVOKABLE QString imageFolderPath() const;

    Q_INVOKABLE int taggingImageCount() const;

    Q_INVOKABLE void clearTaggingImages();

public slots:
    void submitProgress(float progressVal)
    {
        emit progress(progressVal);
    }

    void submitSavingFile(const QString& fileName)
    {
        emit savingFile(fileName);
    }

    void submitSaveFileBegin()
    {
        emit saveImageFilesBegin();
    }

    void submitSaveFileEnd()
    {
        emit saveImageFilesEnd();
    }

    void submitErrorMessage(const QString& message)
    {
        emit error(message);
    }

signals:
    void progress(float progressVal);
    void savingFile(QString fileName);
    void saveImageFilesBegin();
    void saveImageFilesEnd();
    void error(QString message);

private:
    /**
     * @brief hold class names, for the file "obj.names"
     */
    QList<QString> nameList_;

    QString imageFolderPath_;
    QString savePath_;

    QStringList imageFileNames_;

    QMap<QString, QVector<TagRect>> tagRects_;
};

#endif // DATATAGCONTROLLER_H
