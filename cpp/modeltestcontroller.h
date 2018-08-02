#ifndef MODELTESTCONTROLLER_H
#define MODELTESTCONTROLLER_H

#include <string>
#include <list>
#include <tuple>
#include <vector>

#include <QObject>
#include <QString>
#include <QList>
#include <QVector>
#include <QMap>
#include <QFile>
#include <QLibrary>
#include <QThread>
#include <QDir>
#include <QRegExp>
#include <QVariantList>

//void detectorSetConfigFilesAbsolutePath(std::string path);
typedef void(*detectorSetConfigFilesAbsolutePath)(std::string);

//void detectorLoadData(std::string dataConfig);
typedef void(*detectorLoadData)(std::string);

//void detectorLoadModel(std::string cfgfile, std::string weightfile, void(*progress)(float));
typedef void(*detectorLoadModel)(std::string, std::string, void(*)(float));

//void getDetectorClassNames(std::vector<std::string>& nameList);
typedef void(*getDetectorClassNames)(std::vector<std::string>&);

//void getDetectResult(std::vector<std::tuple<int, float, float, float, float, float>>& result,
//std::string imagePath, float thresh, float hier_thresh);
typedef void(*getDetectResult)(std::vector<std::tuple<int, float, float, float, float, float>>&,
                               std::string, float, float);

class LoadModelProgressPipe : public QObject
{
    Q_OBJECT

public:
    ~LoadModelProgressPipe()
    {
    }

    static LoadModelProgressPipe& globalInstance()
    {
        static LoadModelProgressPipe instance;
        return instance;
    }

    void changeProgressValue(float progressVal)
    {
        emit progressValueChanged(progressVal);
    }

signals:
    void progressValueChanged(float progressVal);

private:
    LoadModelProgressPipe()
    {
    }
};

class LoadModelThread : public QThread
{
    Q_OBJECT

    void run() override;

public:
    LoadModelThread(QObject* parent = 0)
        : QThread(parent), useGpu_(true)
    {
        if(useGpu_)
        {
            #ifdef _WIN32
            QLibrary darknet_gpu("darknet_custom.dll");
            #elif defined __linux__
            QLibrary darknet_gpu("darknet_custom.so");
            #endif
            if(!darknet_gpu.load())
            {
                emit error(darknet_gpu.errorString());
            }

            detector_load_model_ = (detectorLoadModel)darknet_gpu.resolve("detectorLoadModel");
            if(!detector_load_model_)
                emit error("detector_load_model 符号不存在！");
        }
    }

    void setPathes(std::string cfgfile, std::string weightfile);

    static void loadProgress(float progressVal)
    {
        LoadModelProgressPipe::globalInstance().changeProgressValue(progressVal);
    }

signals:
    void error(QString message);
    void loadModelBegin();
    void loadModelEnd();

private:
    bool useGpu_;
    std::string modelConfigFile_;
    std::string weightFile_;
    detectorLoadModel detector_load_model_;
};

class DetectThread : public QThread
{
    Q_OBJECT

    void run() override;

public:
    DetectThread(QObject* parent = 0)
        : QThread(parent), useGpu_(true)
    {
        if(useGpu_)
        {
            #ifdef _WIN32
            QLibrary darknet_gpu("darknet_custom.dll");
            #elif defined __linux__
            QLibrary darknet_gpu("darknet_custom.so");
            #endif
            if(!darknet_gpu.load())
            {
                emit error(darknet_gpu.errorString());
            }

            get_detect_result_ = (getDetectResult)darknet_gpu.resolve("getDetectResult");
            if(!get_detect_result_)
                emit error("getDetectResult 符号不存在！");
        }
    }

    void setImageFolderPath(QString path);

    void setThresh(float thresh, float hier_thresh);

signals:
    void error(QString message);
    void resultReady(QMap<QString, std::vector<std::tuple<int, float, float, float, float, float>>> result);
    void progress(float progressVal);
    void detectBegin();
    void detectEnd();

private:
    bool useGpu_;
    getDetectResult get_detect_result_;
    QString imageFolderPath_;
    float thresh_;
    float hier_thresh_;
};

class ModelTestController : public QObject
{
    Q_OBJECT

public:
    ModelTestController(QObject* parent=0)
        : QObject(parent), useGpu_(true),
          thresh_(0.3), hier_thresh_(0.5)
    {
        if(useGpu_)
        {
            #ifdef _WIN32
            QLibrary darknet_gpu("darknet_custom.dll");
            #elif defined __linux__
            QLibrary darknet_gpu("darknet_custom.so");
            #endif
            if(!darknet_gpu.load())
            {
                emit error(darknet_gpu.errorString());
            }

            detector_set_config_files_absolute_path_ = (detectorSetConfigFilesAbsolutePath)
                    darknet_gpu.resolve("detectorSetConfigFilesAbsolutePath");
            if(!detector_set_config_files_absolute_path_)
                emit error("detectorSetConfigFilesAbsolutePath 符号不存在！");
            detector_load_data_ = (detectorLoadData)darknet_gpu.resolve("detectorLoadData");
            if(!detector_load_data_)
                emit error("detectorLoadData 符号不存在!");
            detector_load_model_ = (detectorLoadModel)darknet_gpu.resolve("detectorLoadModel");
            if(!detector_load_model_)
                emit error("detectorLoadModel 符号不存在！");
            get_detector_classnames_ = (getDetectorClassNames)darknet_gpu.resolve("getDetectorClassNames");
            if(!get_detector_classnames_)
                emit error("getDetectorClassNames 符号不存在！");

            detector_set_config_files_absolute_path_("");
        }
    }

    ~ModelTestController()
    {
    }

    Q_INVOKABLE void setDataConfigFile(QString filePath);

    Q_INVOKABLE void setImageFolderPath(QString folderPath);

    Q_INVOKABLE void setModelConfigFile(QString filePath);

    Q_INVOKABLE void setWeightFile(QString filePath);

    Q_INVOKABLE void testImages();

    Q_INVOKABLE void loadDataConfig();

    Q_INVOKABLE void loadModel();

    Q_INVOKABLE void detectStart();

    Q_INVOKABLE QString imagePath(int index);

    Q_INVOKABLE void setThresh(float thresh);

    Q_INVOKABLE void setHierThresh(float hier_thresh);

public slots:
    void changeLoadModelProgressValue(float progressVal)
    {
        emit loadModelProgressValueChanged(progressVal);
    }

    void changeDetectProgressValue(float progressVal)
    {
        emit detectProgressValueChanged(progressVal);
    }

    void submitLoadModelBegin()
    {
        emit loadModelBegin();
    }

    void submitLoadModelEnd()
    {
        emit loadModelEnd();
    }

    void submitErrorMessage(const QString& message)
    {
        emit error(message);
    }

    void dealDetectResult(QMap<QString, std::vector<std::tuple<int, float, float, float, float, float>>> result);

    void submitDetectBegin()
    {
        emit detectBegin();
    }

    void submitDetectEnd()
    {
        emit detectEnd();
    }

signals:
    void error(QString message);
    void nameAdded(QString name);
    void loadModelProgressValueChanged(float progressVal);
    void detectProgressValueChanged(float progressVal);
    void loadModelBegin();
    void loadModelEnd();
    void submitResultBegin(int imageCount);
    void detectResultReady(int imageIndex, QVariantList result);
    void submitResultComplete();
    void detectBegin();
    void detectEnd();

private:
    QString imageFolderPath_;
    QStringList imageFileNames_;
    std::string dataConfigFile_;
    std::string modelConfigFile_;
    std::string weightFile_;

    QVector<QString> names_;

    bool useGpu_;

    float thresh_;
    float hier_thresh_;

    detectorSetConfigFilesAbsolutePath detector_set_config_files_absolute_path_;
    detectorLoadData detector_load_data_;
    detectorLoadModel detector_load_model_;
    getDetectorClassNames get_detector_classnames_;
};


#endif // MODELTESTCONTROLLER_H
