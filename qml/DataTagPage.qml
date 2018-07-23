import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import Tagging 1.0

Rectangle
{
    id: page

    DataTagController
    {
        id: dataTagController

        property var taggingImageList: new Array()

        onError:
        {
            messageDialog.text = qsTr(message)
            messageDialog.visible = true
        }

        onProgress:
        {
            saveProgressBar.value = progressVal
        }

        onSaveImageFilesBegin:
        {
            saveProgressBarBorder.visible = true
        }

        onSaveImageFilesEnd:
        {
            saveProgressBarBorder.visible = false
        }

        onSavingFile:
        {
            saveText.text = qsTr(fileName)
        }

        function save()
        {
            makeDataFolder()
            saveNames()
            saveTrainAndValidFile()
            savePathesConfig()

            if(taggingImageList.length != 0)
            {
                for(var i = 0;i<taggingImageList.length;i++)
                {
                    var imageName = imageFileName(i)

                    for(var j = 0;j<taggingImageList[i].length;j++)
                    {
                        var rect = taggingImageList[i][j]
                        saveTagRect(imageName, rect.classIndex, rect.className, rect.x, rect.y, rect.width, rect.height)
                    }
                }
            }

            saveDataFiles()
        }
    }

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
                    dataFolderDialog.visible = true
                    dataFolderDialog.invokeID = 0
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
            id: selectSavePathText

            text: qsTr("选择保存路径:")

            anchors.top: selectPicturesTextInputBorder.bottom
            anchors.left: parent.left
            anchors.topMargin: parent.height / 35
            anchors.leftMargin: parent.width / 20

            font.family: qsTr("微软雅黑")
            font.pixelSize: parent.width / 25

            color: "#003366"
        }

        Rectangle
        {
            id: selectSavePathButton

            width: parent.width / 15
            height: width

            anchors.left: selectSavePathText.left
            anchors.top: selectSavePathText.bottom
            anchors.topMargin: selectSavePathText.height * 0.5

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
                    dataFolderDialog.visible = true
                    dataFolderDialog.invokeID = 1
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
            id: selectSavePathTextInputBorder

            property string dataPath: ""

            anchors.left: selectSavePathButton.right
            anchors.top: selectSavePathButton.top
            anchors.bottom: selectSavePathButton.bottom
            anchors.right: parent.right
            anchors.leftMargin: selectSavePathButton.width / 2
            anchors.rightMargin: selectSavePathButton.width

            color: "transparent"
            border.color: enabled ? "steelblue" : "lightsteelblue"
            radius: 5

            onDataPathChanged:
            {
                var path = dataPath.substring(8)
                selectSavePathTextInput.text = path
            }

            TextInput
            {
                id: selectSavePathTextInput
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
            id: validatePercentText

            text: qsTr("选择生成训练集比例:")

            anchors.top: selectSavePathTextInputBorder.bottom
            anchors.left: selectSavePathButton.left
            anchors.topMargin: parent.height / 35

            font.family: qsTr("微软雅黑")
            font.pixelSize: parent.width / 25

            color: "#003366"
        }

        Rectangle
        {
            id: validatePercentBorder

            height: width / 15

            anchors.left: validatePercentText.left
            anchors.right: selectSavePathTextInputBorder.right
            anchors.top: validatePercentText.bottom
            anchors.topMargin: validatePercentText.height * 0.5

            color: "transparent"

            Rectangle
            {
                id: validatePercentTextInputBorder

                property string validatePercent: ""

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                width: height * 1.8

                color: "transparent"
                border.color: enabled ? "steelblue" : "lightsteelblue"
                radius: 5

                TextInput
                {
                    id: validatePercentTextInput
                    anchors.fill: parent

                    text: "0.0"

                    topPadding: parent.height / 10
                    leftPadding: topPadding * 2.5
                    font.family: qsTr("微软雅黑")
                    font.pixelSize: parent.height * 0.6
                    color: enabled ? "steelblue" : "lightsteelblue"

                    readOnly: true
                }
            }

            Slider
            {
                id: validatePercentSlider

                anchors.left: validatePercentTextInputBorder.right
                anchors.leftMargin: validatePercentTextInputBorder.width * 0.5
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                from: 0.0
                value: 0.0
                to: 1.0

                onMoved:
                {
                    validatePercentTextInput.text = value.toFixed(2).toString()
                    dataTagController.setValidatePercent(value)
                }

                background: Rectangle
                {
                    x: validatePercentSlider.leftPadding
                    y: validatePercentSlider.topPadding + validatePercentSlider.availableHeight / 2 - height / 2
                    implicitWidth: validatePercentBorder.width * 0.8
                    implicitHeight: 4
                    width: validatePercentSlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: enabled ? "lightsteelblue" : "lightgray"

                    Rectangle
                    {
                        width: validatePercentSlider.visualPosition * parent.width
                        height: parent.height
                        color: enabled ? "steelblue" : "lightsteelblue"
                        radius: 2
                    }
                }

                handle: Rectangle
                {
                    x: validatePercentSlider.leftPadding + validatePercentSlider.visualPosition * (validatePercentSlider.availableWidth - width)
                    y: validatePercentSlider.topPadding + validatePercentSlider.availableHeight / 2 - height / 2
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 13
                    color: validatePercentSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                }
            }
        }

        Text
        {
            id: addNamesText

            text: qsTr("添加数据类别名称:")

            anchors.top: validatePercentBorder.bottom
            anchors.left: validatePercentBorder.left
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
            border.color: enabled ? "steelblue" : "lightsteelblue"

            Text
            {
                text: qsTr("删 除")
                color: enabled ? "#003366" : "lightsteelblue"
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
            border.color: enabled ? "steelblue" : "lightsteelblue"

            Text
            {
                text: qsTr("添 加")
                color: enabled ? "#003366" : "lightsteelblue"
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.width / 4
                anchors.centerIn: parent
            }

            MouseArea
            {
                anchors.fill: parent

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
                    {
                        nameListModel.append({"name": addNameTextInput.text, "classColor": getColor()})
                        addNameTextInput.text = ""
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

        Rectangle
        {
            id: addNameTextInputBorder

            anchors.left: addNameButton.right
            anchors.top: addNameButton.top
            anchors.bottom: addNameButton.bottom
            anchors.right: selectPicturesTextInputBorder.right
            anchors.leftMargin: addNameButton.height / 2

            color: "transparent"
            border.color: enabled ? "steelblue" : "lightsteelblue"
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

                    onCurrentIndexChanged:
                    {
                        if(currentIndex!=-1)
                            canvas.color = nameListModel.get(currentIndex).classColor
                    }

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
                            font.pixelSize: namesScrollViewBorder.height / 10
                            color: nameListDelegate.enabled ? (nameListDelegate.down ? "#steelblue" : classColor) : classColor
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
            border.color: "steelblue"

            Text
            {
                text: uploadButton.reuploadFlag ? qsTr("重新选择") : qsTr("上传数据")
                color: "#003366"
                font.family: qsTr("微软雅黑")
                font.pixelSize: parent.width / 5
                anchors.centerIn: parent
            }

            property bool reuploadFlag: false
            property bool uploaded: false

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    if(selectPicturesTextInput.text === "" || selectSavePathTextInput.text === "")
                    {

                    }
                    else
                    {
                        if(uploadButton.reuploadFlag)
                        {
                            uploadButton.reuploadFlag = false

                            selectPicturesTextInputBorder.enabled = true
                            selectPicturesButton.enabled = true

                            selectSavePathTextInputBorder.enabled = true
                            selectSavePathButton.enabled = true

                            deleteNameButton.enabled = true
                            addNameButton.enabled = true
                            addNameTextInputBorder.enabled = true

                            validatePercentTextInputBorder.enabled = true
                            validatePercentSlider.enabled = true

                            dataTagController.taggingImageList = []
                            canvas.requestClear = true
                            canvas.requestPaint()
                            image.source = ""
                            image.imageIndex = 0
                            uploadButton.uploaded = false
                            nameListView.currentIndex = -1
                        }
                        else
                        {
                            for(var i = 0;i<nameListModel.count;i++)
                            {
                                dataTagController.addName(nameListModel.get(i).name)
                            }

                            dataTagController.getImagePathes(selectPicturesTextInput.text)
                            dataTagController.setSavePath(selectSavePathTextInput.text)
                            dataTagController.taggingImageList = []

                            for(var j = 0;j<dataTagController.taggingImageCount();j++)
                            {
                                dataTagController.taggingImageList.push([])
                            }

                            if(dataTagController.taggingImageCount() !== 0)
                            {
                                image.source = dataTagController.imagePath(0)
                                image.imageIndex = 0

                                uploadButton.uploaded = true
                                uploadButton.reuploadFlag = true

                                selectPicturesTextInputBorder.enabled = false
                                selectPicturesButton.enabled = false

                                selectSavePathTextInputBorder.enabled = false
                                selectSavePathButton.enabled = false

                                deleteNameButton.enabled = false
                                addNameButton.enabled = false
                                addNameTextInputBorder.enabled = false

                                validatePercentTextInputBorder.enabled = false
                                validatePercentSlider.enabled = false

                                canvas.requestClear = true
                                canvas.requestPaint()

                                nextImageButton.imagesCount = dataTagController.taggingImageCount()
                            }
                            else
                            {

                            }
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
        id: tagWindow

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

                onProgressChanged:
                {
                    if(progress==1.0)
                    {
                        canvas.requestPaint()
                    }
                }

                Canvas
                {
                    id: canvas
                    anchors.fill: parent

                    property real startX
                    property real startY
                    property string color
                    property bool requestClear: false
                    property bool isTagging: false

                    onPaint:
                    {
                        var ctx = getContext('2d')

                        if(nameListView.currentIndex != -1 && uploadButton.uploaded && !canvas.requestClear)
                        {
                            ctx.clearRect(0, 0, canvas.width, canvas.height)

                            var taggingRectList = dataTagController.taggingImageList[image.imageIndex]

                            for(var i = 0;i < taggingRectList.length;i++)
                            {
                                var rect = taggingRectList[i]

                                if(rect !== null)
                                {
                                    var rectWidth = rect.width * canvas.width
                                    var rectHeight = rect.height * canvas.height
                                    var rectX = rect.x * canvas.width - rectWidth / 2
                                    var rectY = rect.y * canvas.height - rectHeight / 2
                                    ctx.strokeStyle = rect.color
                                    ctx.fillStyle = rect.color
                                    ctx.lineWidth = 5.0
                                    ctx.strokeRect(rectX, rectY, rectWidth, rectHeight)
                                    ctx.lineWidth = 1.0
                                    ctx.font = "24px sans-serif"
                                    ctx.fillText(rect.classIndex + " - " + rect.className, rectX , rectY - 20)
                                }
                            }


                            if(canvas.isTagging && area.mouseX - startX != 0 && area.mouseY - startY != 0)
                            {
                                ctx.strokeStyle = canvas.color
                                ctx.fillStyle = canvas.color
                                var rect_ = Qt.rect(startX, startY, area.mouseX - startX, area.mouseY - startY)
                                ctx.lineWidth = 5.0
                                ctx.strokeRect(rect_.x, rect_.y, rect_.width, rect_.height)
                                ctx.lineWidth = 1.0
                                ctx.font = "24px sans-serif"
                                ctx.fillText(nameListView.currentIndex + " - " + nameListModel.get(nameListView.currentIndex).name, rect_.x , rect_.y - 20)
                            }
                        }

                        if(canvas.requestClear)
                        {
                            canvas.requestClear = false
                            ctx.clearRect(0, 0, canvas.width, canvas.height)
                        }
                    }

                    MouseArea
                    {
                        id: area
                        anchors.fill: parent
                        cursorShape: !uploadButton.uploaded ? Qt.ArrowCursor : Qt.CrossCursor

                        onPressed:
                        {
                            canvas.startX = mouseX
                            canvas.startY = mouseY
                            canvas.isTagging = true
                        }

                        onReleased:
                        {
                            if(nameListView.currentIndex != -1)
                            {
                                var taggingImage = dataTagController.taggingImageList[image.imageIndex]

                                taggingImage.push({classIndex: nameListView.currentIndex,
                                                   className: nameListModel.get(nameListView.currentIndex).name,
                                                   color: canvas.color,
                                                   x: (canvas.startX+(mouseX-canvas.startX)/2)/canvas.width,
                                                   y: (canvas.startY+(mouseY-canvas.startY)/2)/canvas.height,
                                                   width: (mouseX-canvas.startX)/canvas.width,
                                                   height: (mouseY-canvas.startY)/canvas.height})
                            }

                            canvas.isTagging = false
                        }

                        onPositionChanged:
                        {
                            canvas.requestPaint()
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

                visible: image.imageIndex > 0 && uploadButton.uploaded

                direction: "left"
                borderColor: "steelblue"
                interColor: "lightsteelblue"

                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        image.imageIndex--
                        image.source = dataTagController.imagePath(image.imageIndex)
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

                property int imagesCount: 0

                visible: image.imageIndex != imagesCount - 1 && uploadButton.uploaded

                direction: "right"
                borderColor: "steelblue"
                interColor: "lightsteelblue"

                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        image.imageIndex++
                        image.source = dataTagController.imagePath(image.imageIndex)
                        canvas.requestClear = true
                        canvas.requestPaint()
                    }
                }
            }
        }

        Rectangle
        {
            id: saveProgressBarBorder

            anchors.top: imageWindow.bottom
            anchors.bottom: buttons.top
            anchors.left: imageWindow.left
            anchors.right: imageWindow.right
            anchors.topMargin: buttons.height / 5
            anchors.bottomMargin: anchors.topMargin

            color: "transparent"

            visible: false

            ProgressBar
            {
                id: saveProgressBar
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
                        width: saveProgressBar.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: "lightsteelblue"
                    }
                }
            }

            Text
            {
                id: saveText

                anchors.left: saveProgressBar.right
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

        Row
        {
            id: buttons
            spacing: parent.width / 10
            leftPadding: spacing * 1.2
            height: parent.height / 15
            anchors.left: imageWindow.left
            anchors.right: imageWindow.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: height

            Rectangle
            {
                id: revokeButton

                height: parent.height
                width: height * 2

                color: "transparent"
                radius: 5
                border.color: "steelblue"

                Text
                {
                    text: qsTr("撤 销")
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
                        if(dataTagController.taggingImageList[image.imageIndex].length>0)
                            dataTagController.taggingImageList[image.imageIndex].pop()
                        canvas.requestPaint()
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
                id: clearButton

                height: parent.height
                width: height * 2

                color: "transparent"
                radius: 5
                border.color: "steelblue"

                Text
                {
                    text: qsTr("清 空")
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
                        dataTagController.taggingImageList[image.imageIndex] = []
                        canvas.requestPaint()
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
                id: saveButton

                height: parent.height
                width: height * 2

                color: "transparent"
                radius: 5
                border.color: "steelblue"

                Text
                {
                    text: qsTr("保 存")
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
                        dataTagController.save()
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
    }

    FileDialog
    {
        id: dataFolderDialog
        title: qsTr("选择数据文件夹")
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
                selectPicturesTextInputBorder.dataPath = dataFolderDialog.fileUrls[0]
                break
            case 1:
                selectSavePathTextInputBorder.dataPath = dataFolderDialog.fileUrls[0]
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

    MessageDialog
    {
         id: messageDialog

         title: "Error!"
         icon: StandardIcon.Warning
         text: ""
         visible: false

         onAccepted:
         {
             messageDialog.visible = false
         }
    }
}
