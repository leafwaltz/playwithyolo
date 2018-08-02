import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import Test 1.0

Rectangle
{
    id: page

    ModelTestController
    {
        id: modelTestController

        function getColor()
        {
            var colorValue = "0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f"
            var colorArray = colorValue.split(",")
            var color = "#"
            for(var i = 0;i < 6;i++)
            {
                color += colorArray[Math.floor(Math.random()*16)];
            }
            return color;
        }

        onNameAdded:
        {
            nameListModel.append({"name": name, "classColor": getColor()})
        }

        onLoadModelProgressValueChanged:
        {
            loadModelProgressBar.value = progressVal
        }

        onLoadModelBegin:
        {
            loadModelProgressBarBorder.visible = true
            uploadButton.enabled = false
        }

        onLoadModelEnd:
        {
            loadModelProgressBarBorder.visible = false
            uploadButton.enabled = true
            threshTextInputBorder.enabled = true
            hierThreshTextInputBorder.enabled = true
            startDetectButton.enabled = true
        }

        onSubmitResultBegin:
        {
            for(var i=0;i<imageCount;i++)
            {
                image.detectResultList.push([])
            }
            nextImageButton.imageCount = imageCount
        }

        onDetectResultReady:
        {
            var temp = new Array()
            temp.push(result[0])
            temp.push(result[1])
            temp.push(result[2])
            temp.push(result[3])
            temp.push(result[4])
            image.detectResultList[imageIndex].push(temp)
        }

        onSubmitResultComplete:
        {
            image.source = imagePath(0)
            image.imageIndex = 0
            canvas.requestPaint()
        }

        onDetectProgressValueChanged:
        {
            detectProgressBar.value = progressVal
        }

        onDetectBegin:
        {
            detectProgressBarBorder.visible = true
            detectText.text = "detecting ..."
            startDetectButton.enabled = false
            threshTextInputBorder.enabled = false
            hierThreshTextInputBorder.enabled = false
        }

        onDetectEnd:
        {
            detectProgressBarBorder.visible = false
            startDetectButton.enabled = true
            threshTextInputBorder.enabled = true
            hierThreshTextInputBorder.enabled = true
        }
    }

    /*Rectangle
    {
        id: testButton

        color: "red"

        width: 100
        height: 100

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                modelTestController.detectStart()
            }
        }
    }*/

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
            id: selectDataConfigFileText

            text: qsTr("选择类别名称配置文件:")

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
            id: selectDataConfigFileButton

            width: parent.width / 15
            height: width

            anchors.left: selectDataConfigFileText.left
            anchors.top: selectDataConfigFileText.bottom
            anchors.topMargin: selectDataConfigFileText.height * 0.5

            color: "transparent"
            radius: 5
            border.color: enabled ? "steelblue" : "lightsteelblue"

            Text
            {
                text: qsTr("···")
                color: enabled ? "steelblue" : "lightsteelblue"
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    dataFolderDialog.invokeID = 0
                    dataFolderDialog.title = qsTr("选择类别配置文件")
                    dataFolderDialog.selectFolder = false
                    dataFolderDialog.nameFilters = ["Data Config Files (*.data)"]
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
            id: selectDataConfigFileTextInputBorder

            property string dataPath: ""

            anchors.left: selectDataConfigFileButton.right
            anchors.top: selectDataConfigFileButton.top
            anchors.bottom: selectDataConfigFileButton.bottom
            anchors.right: parent.right
            anchors.leftMargin: selectDataConfigFileButton.width / 2
            anchors.rightMargin: selectDataConfigFileButton.width

            color: "transparent"
            border.color: enabled ? "steelblue" : "lightsteelblue"
            radius: 5

            onDataPathChanged:
            {
                var path = dataPath.substring(8)
                selectDataConfigFileTextInput.text = path
            }

            TextInput
            {
                id: selectDataConfigFileTextInput
                anchors.fill: parent

                topPadding: parent.height / 10
                leftPadding: topPadding * 2
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height / 2
                color: enabled ? "steelblue" : "lightsteelblue"

                selectByMouse: true
            }
        }

        Text
        {
            id: selectConfigFileText

            text: qsTr("选择模型配置文件:")

            anchors.top: selectDataConfigFileTextInputBorder.bottom
            anchors.left: parent.left
            anchors.topMargin: parent.height / 35
            anchors.leftMargin: parent.width / 20

            font.family: qsTr("微软雅黑")
            font.pixelSize: parent.width / 25

            color: "#003366"
        }

        Rectangle
        {
            id: selectConfigFileButton

            width: parent.width / 15
            height: width

            anchors.left: selectConfigFileText.left
            anchors.top: selectConfigFileText.bottom
            anchors.topMargin: selectConfigFileText.height * 0.5

            color: "transparent"
            radius: 5
            border.color: enabled ? "steelblue" : "lightsteelblue"

            Text
            {
                text: qsTr("···")
                color: enabled ? "steelblue" : "lightsteelblue"
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    dataFolderDialog.invokeID = 1
                    dataFolderDialog.title = qsTr("选择模型配置文件")
                    dataFolderDialog.selectFolder = false
                    dataFolderDialog.nameFilters = ["Config Files (*.cfg)"]
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
            id: selectConfigFileTextInputBorder

            property string dataPath: ""

            anchors.left: selectConfigFileButton.right
            anchors.top: selectConfigFileButton.top
            anchors.bottom: selectConfigFileButton.bottom
            anchors.right: parent.right
            anchors.leftMargin: selectConfigFileButton.width / 2
            anchors.rightMargin: selectConfigFileButton.width

            color: "transparent"
            border.color: enabled ? "steelblue" : "lightsteelblue"
            radius: 5

            onDataPathChanged:
            {
                var path = dataPath.substring(8)
                selectConfigFileTextInput.text = path
            }

            TextInput
            {
                id: selectConfigFileTextInput
                anchors.fill: parent

                topPadding: parent.height / 10
                leftPadding: topPadding * 2
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height / 2
                color: enabled ? "steelblue" : "lightsteelblue"

                selectByMouse: true
            }
        }

        Text
        {
            id: selectWeightsFileText

            text: qsTr("选择模型文件:")

            anchors.top: selectConfigFileTextInputBorder.bottom
            anchors.left: parent.left
            anchors.topMargin: parent.height / 35
            anchors.leftMargin: parent.width / 20

            font.family: qsTr("微软雅黑")
            font.pixelSize: parent.width / 25

            color: "#003366"
        }

        Rectangle
        {
            id: selectWeightsFileButton

            width: parent.width / 15
            height: width

            anchors.left: selectWeightsFileText.left
            anchors.top: selectWeightsFileText.bottom
            anchors.topMargin: selectWeightsFileText.height * 0.5

            color: "transparent"
            radius: 5
            border.color: enabled ? "steelblue" : "lightsteelblue"

            Text
            {
                text: qsTr("···")
                color: enabled ? "steelblue" : "lightsteelblue"
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    dataFolderDialog.invokeID = 2
                    dataFolderDialog.title = qsTr("选择模型文件")
                    dataFolderDialog.selectFolder = false
                    dataFolderDialog.nameFilters = ["Model Files (*.weights)"]
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
            id: selectWeightsFileTextInputBorder

            property string dataPath: ""

            anchors.left: selectWeightsFileButton.right
            anchors.top: selectWeightsFileButton.top
            anchors.bottom: selectWeightsFileButton.bottom
            anchors.right: parent.right
            anchors.leftMargin: selectWeightsFileButton.width / 2
            anchors.rightMargin: selectWeightsFileButton.width

            color: "transparent"
            border.color: enabled ? "steelblue" : "lightsteelblue"
            radius: 5

            onDataPathChanged:
            {
                var path = dataPath.substring(8)
                selectWeightsFileTextInput.text = path
            }

            TextInput
            {
                id: selectWeightsFileTextInput
                anchors.fill: parent

                topPadding: parent.height / 10
                leftPadding: topPadding * 2
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height / 2
                color: enabled ? "steelblue" : "lightsteelblue"

                selectByMouse: true
            }
        }

        Text
        {
            id: selectPicturesText

            text: qsTr("选择图像存储文件夹:")

            anchors.top: selectWeightsFileTextInputBorder.bottom
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
            border.color: enabled ? "steelblue" : "lightsteelblue"

            Text
            {
                text: qsTr("···")
                color: enabled ? "steelblue" : "lightsteelblue"
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    dataFolderDialog.invokeID = 3
                    dataFolderDialog.title = qsTr("选择图像存储文件夹")
                    dataFolderDialog.selectFolder = true
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
            border.color: enabled ? "steelblue" : "lightsteelblue"
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
                color: enabled ? "steelblue" : "lightsteelblue"

                selectByMouse: true
            }
        }

        Text
        {
            id: addNamesText

            text: qsTr("数据类别名称:")

            anchors.top: selectPicturesTextInputBorder.bottom
            anchors.left: selectPicturesButton.left
            anchors.topMargin: parent.height / 35

            font.family: qsTr("微软雅黑")
            font.pixelSize: parent.width / 25

            color: "#003366"
        }

        Rectangle
        {
            id: namesScrollViewBorder
            anchors.left: addNamesText.left
            anchors.right: selectPicturesTextInputBorder.right
            anchors.bottom: parent.bottom
            anchors.top: addNamesText.bottom
            anchors.topMargin: addNamesText.height / 2
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

                        contentItem: Text
                        {
                            rightPadding: nameListDelegate.spacing
                            text: nameListDelegate.text
                            font.family: qsTr("微软雅黑")
                            font.pixelSize: namesScrollViewBorder.height / 8
                            color: classColor
                            elide: Text.ElideRight
                            visible: nameListDelegate.text
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle
                        {
                            color: "transparent"
                        }
                    }
                }
            }
        }

        Rectangle
        {
            id: loadModelProgressBarBorder

            anchors.top: namesScrollViewBorder.bottom
            anchors.bottom: uploadButton.top
            anchors.left: namesScrollViewBorder.left
            anchors.right: namesScrollViewBorder.right
            anchors.topMargin: uploadButton.height / 5
            anchors.bottomMargin: anchors.topMargin

            color: "transparent"

            visible: false

            ProgressBar
            {
                id: loadModelProgressBar
                value: 0
                padding: 4
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: parent.width / 2

                background: Rectangle
                {
                    color: "transparent"
                    border.color: "steelblue"
                    radius: 3
                }

                contentItem: Item
                {
                    Rectangle
                    {
                        width: loadModelProgressBar.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: "lightsteelblue"
                    }
                }
            }

            Text
            {
                id: loadModelText

                anchors.left: loadModelProgressBar.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: parent.width / 25

                color: "#003366"

                text: "Loading Model..."

                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height * 0.6
            }
        }

        Rectangle
        {
            id: uploadButton

            height: parent.height / 15
            width: height * 2

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height

            color: "transparent"
            radius: 5
            border.color: enabled ? "steelblue" : "lightsteelblue"

            Text
            {
                text: uploadButton.reuploadFlag ? qsTr("重新选择") : qsTr("上传数据")
                color: enabled ? "#003366" : "lightsteelblue"
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.width / 5
                anchors.centerIn: parent
            }

            property bool reuploadFlag: false

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    if(selectDataConfigFileTextInput.text === ""
                            || selectConfigFileTextInput.text === ""
                            || selectWeightsFileTextInput.text === ""
                            || selectPicturesTextInput.text === "")
                    {

                    }
                    else
                    {
                        if(uploadButton.reuploadFlag)
                        {
                            selectDataConfigFileButton.enabled = true
                            selectDataConfigFileTextInputBorder.enabled = true
                            selectConfigFileButton.enabled = true
                            selectConfigFileTextInputBorder.enabled = true
                            selectPicturesButton.enabled = true
                            selectPicturesTextInputBorder.enabled = true
                            selectWeightsFileButton.enabled = true
                            selectWeightsFileTextInputBorder.enabled = true

                            uploadButton.reuploadFlag = false

                            image.source = ""
                            image.detectResultList = []
                            image.imageIndex = 0
                            for(var i=0;i<nextImageButton.imageCount;i++)
                            {
                                image.detectResultList.push([])
                            }

                            nextImageButton.imageCount = 0

                            startDetectButton.restartFlag = false

                            canvas.requestClear = true
                            canvas.requestPaint()

                            detectProgressBar.value = 0.0

                            startDetectButton.enabled = false
                            threshTextInputBorder.enabled = false
                            hierThreshTextInputBorder.enabled = false

                            nameListModel.clear()
                        }
                        else
                        {
                            modelTestController.setDataConfigFile(selectDataConfigFileTextInput.text)
                            modelTestController.loadDataConfig()

                            modelTestController.setModelConfigFile(selectConfigFileTextInput.text)
                            modelTestController.setWeightFile(selectWeightsFileTextInput.text)
                            modelTestController.loadModel()

                            modelTestController.setImageFolderPath(selectPicturesTextInput.text)


                            selectDataConfigFileButton.enabled = false
                            selectDataConfigFileTextInputBorder.enabled = false
                            selectConfigFileButton.enabled = false
                            selectConfigFileTextInputBorder.enabled = false
                            selectPicturesButton.enabled = false
                            selectPicturesTextInputBorder.enabled = false
                            selectWeightsFileButton.enabled = false
                            selectWeightsFileTextInputBorder.enabled = false

                            uploadButton.reuploadFlag = true
                        }
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

    Rectangle
    {
        id: testWindow

        anchors.left: baseInfomation.right
        anchors.top: baseInfomation.top
        anchors.bottom: baseInfomation.bottom
        anchors.right: parent.right
        anchors.leftMargin: parent.width / 40
        anchors.rightMargin: anchors.leftMargin

        border.color: "lightsteelblue"
        border.width: 1
        color: "transparent"
        radius: 10

        Rectangle
        {
            id: imageWindow

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: parent.height / 20
            anchors.leftMargin: parent.width / 10
            anchors.rightMargin: anchors.leftMargin
            anchors.bottomMargin: parent.height / 5

            border.color: "steelblue"
            border.width: 1
            color: "transparent"
            radius: 10

            Image
            {
                id: image

                anchors.fill: parent
                anchors.margins: parent.width / 30

                asynchronous: true

                property int imageIndex: 0

                property var detectResultList: new Array()

                onProgressChanged:
                {
                    if(progress == 1.0)
                    {
                        canvas.requestPaint()
                    }
                }

                Canvas
                {
                    id: canvas
                    anchors.fill: parent

                    property bool requestClear: false

                    onPaint:
                    {
                        var ctx = getContext('2d')

                        if(image.detectResultList.length > 0&&!canvas.requestClear)
                        {
                            var currentImage = image.detectResultList[image.imageIndex]

                            ctx.clearRect(0, 0, canvas.width, canvas.height)

                            for(var i=0;i<currentImage.length;i++)
                            {
                                var rectWidth = currentImage[i][3] * canvas.width
                                var rectHeight = currentImage[i][4] * canvas.height
                                var rectX = currentImage[i][1] * canvas.width - rectWidth / 2
                                var rectY = currentImage[i][2] * canvas.height - rectHeight / 2
                                ctx.strokeStyle = nameListModel.get(currentImage[i][0]).classColor
                                ctx.fillStyle = nameListModel.get(currentImage[i][0]).classColor
                                ctx.lineWidth = 5.0
                                ctx.strokeRect(rectX, rectY, rectWidth, rectHeight)
                                ctx.lineWidth = 1.0
                                ctx.font = "24px sans-serif"
                                ctx.fillText(currentImage[i][0] + " - " + nameListModel.get(currentImage[i][0]).name, rectX , rectY - 20)
                            }
                        }

                        if(canvas.requestClear)
                        {
                            canvas.requestClear = false
                            ctx.clearRect(0, 0, canvas.width, canvas.height)
                        }
                    }
                }
            }

            ArrowButton
            {
                id: prevImageButton

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: -width / 2

                width: parent.width / 20
                height: parent.height / 4

                visible: image.imageIndex > 0

                direction: "left"
                borderColor: "steelblue"
                interColor: "lightsteelblue"

                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        image.imageIndex--
                        image.source = modelTestController.imagePath(image.imageIndex)
                        canvas.requestClear = true
                        canvas.requestPaint()
                    }
                }
            }

            ArrowButton
            {
                id: nextImageButton

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: -width / 2

                width: parent.width / 20
                height: parent.height / 4

                property int imageCount: 0

                visible: image.imageIndex != nextImageButton.imageCount - 1 && nextImageButton.imageCount > 0

                direction: "right"
                borderColor: "steelblue"
                interColor: "lightsteelblue"

                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        image.imageIndex++
                        image.source = modelTestController.imagePath(image.imageIndex)
                        canvas.requestClear = true
                        canvas.requestPaint()
                    }
                }
            }
        }

        Rectangle
        {
            id: detectProgressBarBorder

            anchors.top: imageWindow.bottom
            anchors.bottom: startDetectButton.top
            anchors.left: imageWindow.left
            anchors.right: imageWindow.right
            anchors.topMargin: startDetectButton.height / 5
            anchors.bottomMargin: anchors.topMargin

            color: "transparent"

            visible: false

            ProgressBar
            {
                id: detectProgressBar
                value: 0
                padding: 4
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: parent.width / 2

                background: Rectangle
                {
                    color: "transparent"
                    border.color: "steelblue"
                    radius: 3
                }

                contentItem: Item
                {
                    Rectangle
                    {
                        width: detectProgressBar.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: "lightsteelblue"
                    }
                }
            }

            Text
            {
                id: detectText

                anchors.left: detectProgressBar.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: parent.width / 25

                color: "#003366"

                text: ""

                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height * 0.6
            }
        }

        Text
        {
            id: threshText

            text: qsTr("阈值(thresh):")

            height: parent.height / 15

            anchors.left: imageWindow.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height * 0.8

            font.family: qsTr("微软雅黑")
            font.pixelSize: height * 0.4

            color: "#003366"
        }

        Rectangle
        {
            id: threshTextInputBorder

            height: parent.height / 20
            width: height * 2

            enabled: false

            anchors.left: threshText.right
            anchors.leftMargin: parent.width / 45
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height * 1.5

            color: "transparent"
            border.color: enabled ? "steelblue" : "lightsteelblue"
            radius: 5

            TextInput
            {
                id: threshTextInput
                anchors.fill: parent

                text: qsTr("0.3")
                validator: DoubleValidator {bottom: 0.0; top: 1.0}

                topPadding: parent.height / 10
                leftPadding: topPadding * 2
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height / 2
                color: enabled ? "steelblue" : "lightsteelblue"

                selectByMouse: true
            }
        }

        Text
        {
            id: hierThreshText

            text: qsTr("分层阈值(hier_thresh):")

            height: parent.height / 15

            anchors.left: threshTextInputBorder.right
            anchors.leftMargin: parent.width / 45
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height * 0.8

            font.family: qsTr("微软雅黑")
            font.pixelSize: height * 0.4

            color: "#003366"
        }

        Rectangle
        {
            id: hierThreshTextInputBorder

            height: parent.height / 20
            width: height * 2

            enabled: false

            anchors.left: hierThreshText.right
            anchors.leftMargin: parent.width / 45
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height * 1.5

            color: "transparent"
            border.color: enabled ? "steelblue" : "lightsteelblue"
            radius: 5

            TextInput
            {
                id: hierThreshTextInput
                anchors.fill: parent

                text: qsTr("0.5")
                validator: DoubleValidator {bottom: 0.0; top: 1.0}

                topPadding: parent.height / 10
                leftPadding: topPadding * 2
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.height / 2
                color: enabled ? "steelblue" : "lightsteelblue"

                selectByMouse: true
            }
        }

        Rectangle
        {
            id: startDetectButton

            height: parent.height / 15
            width: height * 2

            anchors.right: imageWindow.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height

            color: "transparent"
            radius: 5
            border.color: enabled ? "steelblue" : "lightsteelblue"

            property bool restartFlag: false

            enabled: false

            Text
            {
                text: startDetectButton.restartFlag ? qsTr("重新检测") : qsTr("开始检测")
                color: enabled ? "#003366" : "lightsteelblue"
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.width / 5
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    modelTestController.setThresh(parseFloat(threshTextInput.text).toFixed(2))
                    modelTestController.setHierThresh(parseFloat(hierThreshTextInput.text).toFixed(2))

                    if(!startDetectButton.restartFlag)
                    {
                        modelTestController.detectStart()
                        startDetectButton.restartFlag = true
                    }
                    else
                    {
                        image.source = ""
                        image.detectResultList = []
                        image.imageIndex = 0
                        for(var i=0;i<nextImageButton.imageCount;i++)
                        {
                            image.detectResultList.push([])
                        }

                        startDetectButton.restartFlag = false

                        nextImageButton.imageCount = 0

                        canvas.requestClear = true
                        canvas.requestPaint()

                        detectProgressBar.value = 0.0
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
        title: ""
        folder: shortcuts.home
        selectFolder: true
        selectMultiple: false
        visible: false

        property int invokeID: -1

        onAccepted:
        {
            visible = false
            switch(invokeID)
            {
            case 0:
                selectDataConfigFileTextInputBorder.dataPath = dataFolderDialog.fileUrls[0]
                break
            case 1:
                selectConfigFileTextInputBorder.dataPath = dataFolderDialog.fileUrls[0]
                break
            case 2:
                selectWeightsFileTextInputBorder.dataPath = dataFolderDialog.fileUrls[0]
                break
            case 3:
                selectPicturesTextInputBorder.dataPath = dataFolderDialog.fileUrls[0]
                break
            default:
                break
            }
            invokeID = -1
        }

        onRejected:
        {
            visible = false
        }
    }

}
