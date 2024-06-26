import QtQuick
import QtQuick.Controls
import QtQuick.Pdf
import QtQuick.Layouts
import recentfiles
import "controller.js" as Controller
import QtTextToSpeech
import QtMultimedia

ApplicationWindow {
    id: appwindow
    width: 1200
    height: 800
    color: "lightgrey"
    title: "Easy reading"
    visible: true

    menuBar: MenuBar {
        Menu {
            id: fileMenu
            title: qsTr("文件(&F)")   //可以Alt + F
            MenuItem { action: actions.open }
            MenuItem { action: actions.save }

            //recentfiles part
            Menu {
                    id: recentFilesMenu
                    title: qsTr("Recent Files")
                    // enabled: recentFilesInstantiator.count > 0
                    Instantiator {
                        id: recentFilesInstantiator
                        model: recentfiles.recentFiles
                        delegate: MenuItem {
                            text: recentfiles.displayableFilePath(modelData)
                            onTriggered: {
                                Controller.loadFile(modelData)
                                console.log("clicked: ", modelData)
                            }
                        }
                        onObjectAdded: Controller.insertMenuItem(index, object)

                        onObjectRemoved: Controller.removeMenuItem(index, object)

                    }

                    MenuSeparator {}

                    MenuItem {
                        text: qsTr("Clear Recent Files")
                        onTriggered:{
                            console.log("clicked clearRecentFiles")
                            Controller.clearAllRecentfiles()
                        }

                    }
                }
            MenuItem { action: actions.about }
        }
        Menu {
            id: viewMenu
            title: qsTr("视图(&V)")   //可以Alt + V
            MenuItem { action: actions.zoomIn }  //放大(镜头拉近)
            MenuItem { action: actions.zoomOut }  //缩小（拉远）
            MenuItem { action: actions.rotateLeft } //向左旋转
            MenuItem { action: actions.rotateRight } //向右旋转
            MenuItem { action: actions.zoomFitWidth } //适应宽度缩放
            MenuItem { action: actions.zoomFitBest }  //最佳缩放
            MenuItem { action: actions.zoomOriginal } //初始化缩放
            MenuItem { action: actions.playModel }
        }

        Menu {
            title: qsTr("工具(&T)")
            Menu{
                icon.name: "view-readermode-symbolic"
                title: qsTr("有声阅读")
                MenuItem{ action:actions.ttsSetting }
                MenuItem{ action:actions.currentPageTts }
                MenuItem{ action:actions.resume }
                MenuItem{ action:actions.pause }
                MenuItem{ action:actions.stop }
            }
        }
    }

    header: ToolBar {
            RowLayout{
                ToolButton{
                    action: actions.drawerAction
                    ToolTip.visible: enabled && hovered
                    ToolTip.delay: 2000
                    ToolTip.text: "打开边栏"
                }
                ToolButton{ action: actions.zoomIn }
                ToolButton{ action: actions.zoomOut }
                ToolButton{ action: actions.rotateLeft }
                ToolButton{ action: actions.rotateRight }
                ToolButton{ action: actions.addmarks }  //添加书签

                //搜索栏
                TextField {
                    id: _searchField
                    placeholderText: "搜索"
                    Layout.minimumWidth: 200
                    Layout.fillWidth: true
                    Layout.bottomMargin: 3
                    onAccepted: {
                        content.drawer.open()
                        content.drawer.drawerTabBar.setCurrentIndex(1)
                    }
                    TapHandler {
                        onTapped: _searchField.clear()
                    }
        }
             Dialog{
                id: dia
                Rectangle{
                    width: 300
                    height: 300
                    color: "red"
                }

             }
                SpinBox {
                    id: _currentPage
                    from: 1
                    to: content.pdfDoc.pageCount
                    editable: true
                    onValueModified: _pdfMultiView.goToPage(value - 1)
                    Shortcut {
                        sequence: "Ctrl+w"
                        onActivated: _pdfMultiView.goToPage(_currentPage.value - 2)
                    }
                    Shortcut {
                        sequence: "Ctrl+s"
                        onActivated: _pdfMultiView.goToPage(_currentPage.value)
                    }
                }
                ToolButton{action:actions.selectAll}
                ToolButton{action:actions.copy}
         }
    }

    Actions {
        id: actions
        open.onTriggered: {
            content.dialogs.fileOpen.open()
        }
        rotateLeft.onTriggered: {
            _pdfMultiView.pageRotation -= 90

       }
        rotateRight.onTriggered: {
            _pdfMultiView.pageRotation += 90
       }
       addmarks.onTriggered: Controller.addmarks()
    }

    RecenFiles{
        id: recentfiles
        maxCount: 10
    }
    Content{
        id:content
        anchors.fill: parent
    }
    //pdf多页显示类
    PdfMultiPageView{
        id:_pdfMultiView
        document: content.pdfDoc
        anchors.fill:parent
        searchString: _searchField.text

    }

    //临时保存文本类
    TextArea{
        id:_selectedText
        visible: false
        enabled: false
    }

    //文本转语音
    TextToSpeech{
        id:_tts
        volume: content.dialogs.ttsSettingDialog.volumeSlider.value //与slider绑定 下面同理
        pitch: content.dialogs.ttsSettingDialog.pitchSlider.value
        rate: content.dialogs.ttsSettingDialog.rateSlider.value

        onStateChanged: updateStateLabel(state) //状态转换

        function updateStateLabel(state) //状态函数
        {
            switch (state) {
                case TextToSpeech.Ready:
                    _statusLabel.text = qsTr("Ready to read") //判定引擎无误进入就绪态
                    break
                case TextToSpeech.Speaking:
                    _statusLabel.text = qsTr("Speaking")
                    break
                case TextToSpeech.Paused:
                    _statusLabel.text = qsTr("Paused...")
                    break
                case TextToSpeech.Error:
                    _statusLabel.text = qsTr("Error! cannot to read")
                    break
            }
        }

        onSayingWord: (word, id, start, length)=> {

            _selectedText.text=_pdfMultiView.selectedText
            _selectedText.select(start, start + length)
        }

    }

    footer:Label //用于显示当前阅读状态
    {
            id: _statusLabel
            color: "black"
        }

}

