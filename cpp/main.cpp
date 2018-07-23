#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "datatagcontroller.h"

#include <stdio.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<DataTagController>("Tagging", 1, 0, "DataTagController");

    QQmlApplicationEngine engine;

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
