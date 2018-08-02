#include "datatagcontroller.h"

void SaveDataFilesThread::run()
{
    emit saveStart();

    QMap<QString, QVector<TagRect>>::const_iterator it = data_.constBegin();
    int count = 0;

    while(it!=data_.constEnd())
    {
        count++;

        QFile tagFile(savePath_ + it.key().split(".")[0] + ".txt");
        if (!tagFile.open(QIODevice::WriteOnly | QIODevice::Text))
            emit error(QString::fromLocal8Bit("写入标注文件") + it.key().split(".")[0] + QString::fromLocal8Bit(".txt") + QString::fromLocal8Bit("失败!"));

        emit saving("Saving...   " + it.key().split(".")[0] + ".txt");

        QTextStream tagOut(&tagFile);

        for(TagRect rect : it.value())
        {
            tagOut << rect.classIndex << " " << rect.x << " " << rect.y << " " << rect.width << " " << rect.height << "\n";
        }

        QFile imageFile(imageFolderPath_ + it.key());
        if (!imageFile.open(QIODevice::ReadOnly))
            emit error(QString::fromLocal8Bit("拷贝图像文件") + it.key() + QString::fromLocal8Bit("失败!"));

        imageFile.copy(savePath_ + it.key());

        emit saving("Saving...   " + it.key());

        emit savingProgress((float)count / (float)data_.size());

        it++;
    }

    emit done();
}

void SaveDataFilesThread::setPathAndData(const QString &imageFolderPath, const QString &savePath, const QMap<QString, QVector<TagRect> > &data)
{
    savePath_ = savePath + "/data/img/";
    imageFolderPath_ = imageFolderPath + "/";
    data_ = data;
}

void DataTagController::addName(QString name)
{
    nameList_.append(name);
}

void DataTagController::clearNameList()
{
    nameList_.clear();
}

void DataTagController::makeDataFolder()
{
    QDir dir;

    if(!dir.exists(savePath_ + "/data"))
    {
        dir.mkdir(savePath_ + "/data");
    }

    if(!dir.exists(savePath_ + "/backup"))
    {
        dir.mkdir(savePath_ + "/backup");
    }

    if(!dir.exists(savePath_ + "/data/img"))
    {
        dir.mkdir(savePath_ + "/data/img");
    }
}

void DataTagController::saveNames()
{
    QFile file(savePath_ + "/data/obj.names");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        emit error(QString::fromLocal8Bit("写入分类配置文件 obj.names 失败!"));

    QTextStream out(&file);
    for(auto name : nameList_)
    {
        out << name << "\n";
    }
}

void DataTagController::saveTrainAndValidFile()
{
    QFile trainFile(savePath_ + "/data/train.txt");
    if (!trainFile.open(QIODevice::WriteOnly | QIODevice::Text))
        emit error(QString::fromLocal8Bit("写入训练配置文件 train.txt 失败!"));

    QFile validFile(savePath_ + "/data/valid.txt");
    if (!validFile.open(QIODevice::WriteOnly | QIODevice::Text))
        emit error(QString::fromLocal8Bit("写入训练配置文件 valid.txt 失败!"));

    QTextStream trainOut(&trainFile);
    QTextStream validOut(&validFile);

    if(validateFileIndices_.isEmpty())
        emit error(QString::fromLocal8Bit("生成验证集失败!检查是否设置了验证集比例,或者等待一段时间再试。"));

    for(int i = 0;i<imageFileNames_.size();i++)
    {
        if(validateFileIndices_.contains(i))
            validOut << "data/img/" + imageFileNames_[i] << "\n";
        else
            trainOut << "data/img/" + imageFileNames_[i] << "\n";
    }
}

void DataTagController::savePathesConfig()
{
    QFile file(savePath_ + "/data/obj.data");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        emit error(QString::fromLocal8Bit("写入路径配置文件 obj.data 失败!"));

    QTextStream out(&file);
    out << "classes=" << nameList_.size() << "\n";
    out << "train=data/train.txt" << "\n";
    out << "valid=data/valid.txt" << "\n";
    out << "names=data/obj.names" << "\n";
    out << "backup=backup/" << "\n";
}

void DataTagController::saveTagRect(QString imageFileName, int classIndex, QString className, float x, float y, float width, float height)
{
    tagRects_[imageFileName].append(TagRect(classIndex, className, x, y, width, height));
}

void DataTagController::saveDataFiles()
{
    SaveDataFilesThread* saveThread = new SaveDataFilesThread(this);
    saveThread->setPathAndData(imageFolderPath_, savePath_, tagRects_);
    connect(saveThread, &SaveDataFilesThread::finished, saveThread, &QObject::deleteLater);
    connect(saveThread, &SaveDataFilesThread::saveStart, this, &DataTagController::submitSaveFileBegin);
    connect(saveThread, &SaveDataFilesThread::done, this, &DataTagController::submitSaveFileEnd);
    connect(saveThread, &SaveDataFilesThread::savingProgress, this, &DataTagController::submitProgress);
    connect(saveThread, &SaveDataFilesThread::saving, this, &DataTagController::submitSavingFile);
    connect(saveThread, &SaveDataFilesThread::error, this, &DataTagController::submitErrorMessage);
    saveThread->start();
}

void DataTagController::getImagePathes(QString folderPath)
{
    imageFolderPath_ = folderPath;

    QDir dir(folderPath);
    QStringList nameFilters;
    nameFilters << "*.jpg" << "*.jpeg" << "*.png" << "*.JPG" << "*.JPEG" << "*.PNG";
    imageFileNames_ = dir.entryList(nameFilters, QDir::Files|QDir::Readable, QDir::Name);

    for(auto name : imageFileNames_)
    {
        tagRects_[name] = QVector<TagRect>();
    }

    CreateRandomSequenceThread* createRandomSequenceThread = new CreateRandomSequenceThread(this);
    createRandomSequenceThread->setRangeAndSize(0, imageFileNames_.size(), imageFileNames_.size()*validatePercent_);
    connect(createRandomSequenceThread, &CreateRandomSequenceThread::finished, createRandomSequenceThread, &QObject::deleteLater);
    connect(createRandomSequenceThread, &CreateRandomSequenceThread::resultReady, this, &DataTagController::setValidateFileIndices);
    createRandomSequenceThread->start();
}

void DataTagController::setSavePath(QString folderPath)
{
    savePath_ = folderPath;
}

QString DataTagController::imageFileName(int index) const
{
    return imageFileNames_[index];
}

QString DataTagController::imagePath(int index) const
{
    return "file:///" + imageFolderPath_ + "/" + imageFileNames_[index];
}

QString DataTagController::imageFolderPath() const
{
    return imageFolderPath_;
}

int DataTagController::taggingImageCount() const
{
    return imageFileNames_.count();
}

void DataTagController::clearTaggingImages()
{
    imageFileNames_.clear();
}

void DataTagController::setValidatePercent(float validatePercent)
{
    validatePercent_ = validatePercent;
}

void DataTagController::clearTagRects()
{
    tagRects_.clear();
}

void DataTagController::clearValidateFileIndices()
{
    validateFileIndices_.clear();
}
