#include "modeltestcontroller.h"

void LoadModelThread::run()
{
    emit loadModelBegin();
    detector_load_model_(modelConfigFile_, weightFile_, loadProgress);
    emit loadModelEnd();
}

void LoadModelThread::setPathes(std::string cfgfile, std::string weightfile)
{
    modelConfigFile_ = cfgfile;
    weightFile_ = weightfile;
}

void DetectThread::run()
{
    QMap<QString, std::vector<std::tuple<int, float, float, float, float, float>>> result;

    QDir dir(imageFolderPath_);
    QStringList nameFilters;
    nameFilters << "*.jpg" << "*.jpeg" << "*.png" << "*.JPG" << "*.JPEG" << "*.PNG";
    QStringList imageFileNames = dir.entryList(nameFilters, QDir::Files|QDir::Readable, QDir::Name);

    emit detectBegin();

    int count = 0;
    for(auto name : imageFileNames)
    {
        count++;

        std::vector<std::tuple<int, float, float, float, float, float>> temp;

        QString path = imageFolderPath_ + "/" + name;

        get_detect_result_(temp, path.toStdString(), thresh_, hier_thresh_);
        result[name] = temp;

        emit progress((float)count / (float)imageFileNames.size());
    }

    emit resultReady(result);
    emit detectEnd();
}

void DetectThread::setImageFolderPath(QString path)
{
    imageFolderPath_ = path;
}

void DetectThread::setThresh(float thresh, float hier_thresh)
{
    thresh_ = thresh;
    hier_thresh_ = hier_thresh;
}

void ModelTestController::setDataConfigFile(QString filePath)
{
    dataConfigFile_ = filePath.toStdString();
}

void ModelTestController::setImageFolderPath(QString folderPath)
{
    imageFolderPath_ = folderPath;
}

void ModelTestController::setModelConfigFile(QString filePath)
{
    modelConfigFile_ = filePath.toStdString();
}

void ModelTestController::setWeightFile(QString filePath)
{
    weightFile_ = filePath.toStdString();
}

void ModelTestController::testImages()
{
    QDir dir(imageFolderPath_);
    QStringList nameFilters;
    nameFilters << "*.jpg" << "*.jpeg" << "*.png" << "*.JPG" << "*.JPEG" << "*.PNG";
    QStringList imageFileNames = dir.entryList(nameFilters, QDir::Files|QDir::Readable, QDir::Name);
}

void ModelTestController::loadDataConfig()
{
    QString absolutePath = QString::fromStdString(dataConfigFile_).remove(QRegExp("data/\\w+.data"));

    detector_set_config_files_absolute_path_(absolutePath.toStdString());

    std::vector<std::string> nameList;

    detector_load_data_(dataConfigFile_);
    get_detector_classnames_(nameList);

    for(auto s : nameList)
    {
        names_.append(QString::fromStdString(s));
        emit nameAdded(QString::fromStdString(s));
    }
}

void ModelTestController::loadModel()
{
    LoadModelThread* loadModelThread = new LoadModelThread(this);
    loadModelThread->setPathes(modelConfigFile_, weightFile_);
    connect(loadModelThread, &LoadModelThread::finished, loadModelThread, &QObject::deleteLater);
    connect(&LoadModelProgressPipe::globalInstance(), &LoadModelProgressPipe::progressValueChanged,
            this, &ModelTestController::changeLoadModelProgressValue);
    connect(loadModelThread, &LoadModelThread::loadModelBegin, this, &ModelTestController::submitLoadModelBegin);
    connect(loadModelThread, &LoadModelThread::loadModelEnd, this, &ModelTestController::submitLoadModelEnd);
    connect(loadModelThread, &LoadModelThread::error, this, &ModelTestController::submitErrorMessage);
    loadModelThread->start();
}

void ModelTestController::detectStart()
{
    DetectThread* detectThread = new DetectThread(this);
    detectThread->setImageFolderPath(imageFolderPath_);
    detectThread->setThresh(thresh_, hier_thresh_);
    connect(detectThread, &DetectThread::finished, detectThread, &QObject::deleteLater);
    connect(detectThread, &DetectThread::resultReady, this, &ModelTestController::dealDetectResult);
    connect(detectThread, &DetectThread::progress, this, &ModelTestController::changeDetectProgressValue);
    connect(detectThread, &DetectThread::detectBegin, this, &ModelTestController::submitDetectBegin);
    connect(detectThread, &DetectThread::detectEnd, this, &ModelTestController::submitDetectEnd);
    detectThread->start();
}

QString ModelTestController::imagePath(int index)
{
    return "file:///" + imageFolderPath_ + "/" + imageFileNames_[index];
}

void ModelTestController::setThresh(float thresh)
{
    thresh_ = thresh;
}

void ModelTestController::setHierThresh(float hier_thresh)
{
    hier_thresh_ = hier_thresh;
}

void ModelTestController::dealDetectResult(QMap<QString, std::vector<std::tuple<int, float, float, float, float, float> > > result)
{
    emit submitResultBegin(result.size());

    auto it = result.constBegin();

    int index = 0;
    for(;it!=result.constEnd();it++)
    {
        QVariantList resultList;
        imageFileNames_.append(it.key());

        for(auto r : it.value())
        {
            resultList.append(std::get<0>(r));
            resultList.append(std::get<1>(r));
            resultList.append(std::get<2>(r));
            resultList.append(std::get<3>(r));
            resultList.append(std::get<4>(r));

            emit detectResultReady(index, resultList);

            resultList.clear();
        }

        index++;
    }

    emit submitResultComplete();
}

