import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

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
                    dataFolderDialog.visible = true
                }

                onEntered:
                {
                    parent.color = "#EEEEEE"
                }

                onExited:
                {
                    parent.color = "transparent"
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
            anchors.leftMargin: selectPicturesButton.width / 2
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

                selectByMouse: true
            }
        }

        Text
        {
            id: addNamesText

            text: qsTr("添加数据类别名称:")

            anchors.top: selectPicturesTextInputBorder.bottom
            anchors.left: selectPicturesButton.left
            anchors.topMargin: parent.height / 35

            font.family: qsTr("微软雅黑")
            font.pixelSize: parent.width / 25

            color: "#003366"
        }

        Rectangle
        {
            id: deleteNameButton

            height: parent.width / 15
            width: height * 2

            anchors.left: addNamesText.left
            anchors.top: addNamesText.bottom
            anchors.topMargin: addNamesText.height * 0.5

            color: "transparent"
            radius: 5
            border.color: "steelblue"

            Text
            {
                text: qsTr("删 除")
                color: "#003366"
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.width / 4
                anchors.centerIn: parent
            }

            property int prepareToDeleteIndex: -1

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    nameListModel.remove(deleteNameButton.prepareToDeleteIndex)
                    deleteNameButton.prepareToDeleteIndex = -1
                    nameListView.currentIndex = -1
                }

                onEntered:
                {
                    parent.color = "#EEEEEE"
                }

                onExited:
                {
                    parent.color = "transparent"
                }
            }
        }

        Rectangle
        {
            id: addNameButton

            height: parent.width / 15
            width: height * 2

            anchors.left: deleteNameButton.right
            anchors.top: deleteNameButton.top
            anchors.leftMargin: height / 2

            color: "transparent"
            radius: 5
            border.color: "steelblue"

            Text
            {
                text: qsTr("添 加")
                color: "#003366"
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.width / 4
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    var flag = 1
                    for(var i = 0;i<nameListModel.count;i++)
                    {
                        if(addNameTextInput.text === nameListModel.get(i).name)
                            flag = 0
                    }

                    if(addNameTextInput.text === "")
                        flag = 0

                    if(flag)
                        nameListModel.append({"name": addNameTextInput.text})
                }

                onEntered:
                {
                    parent.color = "#EEEEEE"
                }

                onExited:
                {
                    parent.color = "transparent"
                }
            }
        }

        Rectangle
        {
            id: addNameTextInputBorder

            anchors.left: addNameButton.right
            anchors.top: addNameButton.top
            anchors.bottom: addNameButton.bottom
            anchors.right: selectPicturesTextInputBorder.right
            anchors.leftMargin: addNameButton.height / 2

            color: "transparent"
            border.color: "steelblue"
            radius: 5

            TextInput
            {
                id: addNameTextInput
                anchors.fill: parent

                topPadding: parent.height / 10
                leftPadding: topPadding * 2
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height / 2
                color: "steelblue"

                selectByMouse: true
            }
        }

        Rectangle
        {
            id: namesScrollViewBorder
            anchors.left: deleteNameButton.left
            anchors.right: addNameTextInputBorder.right
            anchors.bottom: parent.bottom
            anchors.top: addNameTextInputBorder.bottom
            anchors.topMargin: addNamesText.height
            anchors.bottomMargin: parent.height / 5

            color: "transparent"
            border.color: "steelblue"
            border.width: 1
            radius: 10

            ScrollView
            {
                id: nameListScrollView

                anchors.fill: parent
                anchors.topMargin: parent.height / 20
                anchors.bottomMargin: anchors.topMargin
                anchors.leftMargin: anchors.topMargin
                anchors.rightMargin: anchors.topMargin

                clip: true

                ScrollBar.vertical: ScrollBar
                {
                    id: control
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width / 20

                    contentItem: Rectangle
                    {
                        radius: width / 2
                        color: control.pressed ? "#EEEEEE" : "lightsteelblue"
                    }

                    background: Rectangle
                    {
                        color: "transparent"
                        border.color: "lightsteelblue"
                        radius: width / 2
                    }
                }

                ListView
                {
                    id: nameListView

                    currentIndex: -1

                    model: ListModel
                    {
                        id: nameListModel
                    }

                    delegate: ItemDelegate
                    {
                        id: nameListDelegate
                        text: name

                        onClicked:
                        {
                            //console.log(nameIndex)
                            nameListView.currentIndex = index
                            deleteNameButton.prepareToDeleteIndex = index
                        }

                        contentItem: Text
                        {
                            rightPadding: nameListDelegate.spacing
                            text: nameListDelegate.text
                            font.family: qsTr("微软雅黑")
                            font.pixelSize: namesScrollViewBorder.height / 20
                            color: nameListDelegate.enabled ? (nameListDelegate.down ? "#steelblue" : "#003366") : "#003366"
                            elide: Text.ElideRight
                            visible: nameListDelegate.text
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle
                        {
                            implicitWidth: nameListView.width * 0.9
                            color: nameListDelegate.down ? "#EEEEEE" : "transparent"
                            border.color: nameListView.currentIndex == index ? "#003366" : "transparent"
                            border.width: 2
                        }
                    }
                }
            }
        }

        ProgressBar
        {
            id: uploadProgressBar
            value: 0
            padding: 2

            anchors.left: namesScrollViewBorder.left
            anchors.right: namesScrollViewBorder.right
            anchors.top: namesScrollViewBorder.bottom
            anchors.topMargin: selectPicturesText.height * 0.5

            background: Rectangle
            {
                implicitHeight: selectPicturesText.height * 0.5
                color: "transparent"
                border.color: "steelblue"
                radius: 3
            }

            contentItem: Item
            {
                implicitHeight: selectPicturesText.height * 0.5 - 2

                Rectangle
                {
                    width: uploadProgressBar.visualPosition * parent.width
                    height: parent.height
                    radius: 2
                    color: "lightsteelblue"
                }
            }
        }

        Label
        {
            id: uploadLabel

            anchors.left: uploadProgressBar.left
            anchors.top: uploadProgressBar.bottom
            anchors.right: uploadProgressBar.right

            height: uploadProgressBar.height * 1.2

            text: ""
            font.pixelSize: uploadProgressBar.height
            font.family: qsTr("微软雅黑")

            color: "#003366"
        }

        Rectangle
        {
            id: uploadButton

            height: parent.width / 10
            width: height * 2

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: uploadLabel.bottom
            anchors.topMargin: height / 2

            color: "transparent"
            radius: 5
            border.color: "steelblue"

            Text
            {
                text: qsTr("上传数据")
                color: "#003366"
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.width / 5
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    for(var i = 0;i<nameListModel.count;i++)
                    {
                        dataTagController.addName(nameListModel.get(i).name)
                    }
                }

                onEntered:
                {
                    parent.color = "#EEEEEE"
                }

                onExited:
                {
                    parent.color = "transparent"
                }
            }
        }
    }

    FileDialog
    {
        id: dataFolderDialog
        title: qsTr("选择数据文件夹")
        folder: shortcuts.home
        selectFolder: true
        selectMultiple: false
        visible: false

        onAccepted:
        {
            //console.log("You chose: " + fileDialog.fileUrls)
            visible = false
            selectPicturesTextInputBorder.dataPath = dataFolderDialog.fileUrls[0]
        }

        onRejected:
        {
            visible = false
        }
    }
}
