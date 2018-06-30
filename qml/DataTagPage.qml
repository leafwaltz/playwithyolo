import QtQuick 2.7
import QtQuick.Dialogs 1.2

Rectangle
{
    Rectangle
    {
        id: baseInfomation

        width: parent.width / 3

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.topMargin: parent.height / 20
        anchors.leftMargin: parent.width / 40
        anchors.bottomMargin: parent.height / 20

        border.color: "lightsteelblue"
        border.width: 1
        color: "transparent"
        radius: 10

        Text
        {
            id: selectPicturesText

            text: qsTr("选择数据文件夹:")

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: parent.height / 35
            anchors.leftMargin: parent.width / 20

            font.family: qsTr("微软雅黑")
            font.pixelSize: parent.width / 25

            color: "#003366"
        }

        Rectangle
        {
            id: selectPicturesButton

            width: parent.width / 15
            height: width

            anchors.left: selectPicturesText.left
            anchors.top: selectPicturesText.bottom
            anchors.topMargin: selectPicturesText.height * 0.5

            color: "transparent"
            radius: 5
            border.color: "steelblue"

            Text
            {
                text: qsTr("···")
                color: "steelblue"
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    fileDialog.visible = true
                }
            }
        }

        Rectangle
        {
            id: selectPicturesTextInputBorder

            property string dataPath: ""

            anchors.left: selectPicturesButton.right
            anchors.top: selectPicturesButton.top
            anchors.bottom: selectPicturesButton.bottom
            anchors.right: parent.right
            anchors.leftMargin: selectPicturesButton.width
            anchors.rightMargin: selectPicturesButton.width

            color: "transparent"
            border.color: "steelblue"
            radius: 5

            onDataPathChanged:
            {
                var path = dataPath.substring(8)
                selectPicturesTextInput.text = path
            }

            TextInput
            {
                id: selectPicturesTextInput
                anchors.fill: parent

                topPadding: parent.height / 10
                leftPadding: topPadding * 2
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height / 2
                color: "steelblue"
            }
        }
    }

    FileDialog
    {
        id: fileDialog
        title: qsTr("选择数据文件夹")
        folder: shortcuts.home
        selectFolder: true
        selectMultiple: false
        visible: false

        onAccepted:
        {
            //console.log("You chose: " + fileDialog.fileUrls)
            visible = false
            selectPicturesTextInputBorder.dataPath = fileDialog.fileUrls[0]
        }

        onRejected:
        {
            //console.log("Canceled")
            visible = false
        }
    }
}
