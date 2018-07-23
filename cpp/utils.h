#ifndef UTILS_H
#define UTILS_H

#include <ctime>
#include <list>
#include <QList>
#include <QThread>

#include <QDebug>

class CreateRandomSequenceThread : public QThread
{
    Q_OBJECT

    void run() override
    {
        std::srand((unsigned)time(NULL));
        std::list<int> l;

        if ((end_<0)||(begin_<0)||(begin_>end_)||((int)size_>end_))
        {
            emit resultReady(QList<int>());
        }
        else
        {
            while (l.size() < size_)
            {
                l.push_back(rand() % (end_ - begin_ + 1) + begin_);
                l.sort();
                l.unique();
            }
        }

        emit resultReady(QList<int>::fromStdList(l));
    }

public:
    CreateRandomSequenceThread(QObject* parent = 0)
        : QThread(parent)
    {
    }

    void setRangeAndSize(int begin, int end, size_t sequenceSize)
    {
        begin_ = begin;
        end_ = end;
        size_ = sequenceSize;
    }

signals:
    void resultReady(QList<int> seq);

private:
    int begin_;
    int end_;
    size_t size_;
};

#endif // UTILS_H
