import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

ApplicationWindow
{
    id: window
    visible: true
    width: 1280
    height: 720
    title: qsTr("Play With Yolo")

    background: Rectangle
    {
       gradient: Gradient
       {
           GradientStop { position: 0; color: "white" }
           GradientStop { position: 0.5; color: "lightsteelblue" }
           GradientStop { position: 1; color: "white" }
       }
    }

    TabView
    {
        id: functionSelector
        anchors.fill: parent
        anchors.margins: window.width / 80

        Tab
        {
            title: qsTr("数据标注")

            DataTagPage
            {
                id: dataTagPage
                color: "transparent"
                anchors.fill: parent
            }
        }

        Tab
        {
            title: qsTr("模型训练")
        }

        Tab
        {
            title: qsTr("模型测试")
        }

        style: TabViewStyle
        {
            frameOverlap: window.height / 30

            tab: Rectangle
            {
                color: styleData.selected ? "steelblue" : "lightsteelblue"
                border.color: "steelblue"
                implicitWidth: window.width / 10
                implicitHeight: window.height / 20
                radius: 10

                Text
                {
                    id: text
                    font.family: qsTr("微软雅黑")
                    font.pixelSize: parent.height / 2
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? "white" : "#003366"
                }
            }

            frame: Rectangle
            {
                color: "#EEEEEE"
                radius: 10
                opacity: 0.3
                border.color: "steelblue"
                border.width: 2
            }
        }
    }
}
