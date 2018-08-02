#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QMetaType>

#include "datatagcontroller.h"
#include "modeltraincontroller.h"
#include "modeltestcontroller.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qRegisterMetaType<QMap<QString,std::vector<std::tuple<int,float,float,float,float,float>>>>
            ("QMap<QString,std::vector<std::tuple<int,float,float,float,float,float>>>");

    qmlRegisterType<DataTagController>("Tagging", 1, 0, "DataTagController");
    qmlRegisterType<ModelTestController>("Test", 1, 0, "ModelTestController");

    QQmlApplicationEngine engine;

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
