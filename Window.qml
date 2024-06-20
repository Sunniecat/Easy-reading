import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Pdf

ApplicationWindow {
    id: appwindow
    width: 1200
    height: 800
    color: "lightgrey"
    title: "Easy reading"
    visible: true
    property string source    //for main.cpp

    menuBar: MenuBar {
        Menu {
                   title: qsTr("文件(&F)")   //可以Alt + F
                   MenuItem { action: actions.open }
                   MenuItem { action: actions.save }
                   MenuItem { action: actions.about }
               }
        Menu {
                   title: qsTr("视图(&V)")   //可以Alt + V
                   MenuItem { action: actions.zoomIn }  //放大(镜头拉近)
                   MenuItem { action: actions.zoomOut }  //缩小（拉远）
                   MenuItem { action: actions.rotateLeft } //向左旋转
                   MenuItem { action: actions.rotateRight } //向右旋转
                   MenuItem { action: actions.zoomFitWidth } //适应宽度缩放
                   MenuItem { action: actions.zoomFitBest }  //最佳缩放
                   MenuItem { action: actions.zoomOriginal } //初始化缩放
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
                //搜索栏
                TextField {
                    id: _searchField
                    placeholderText: "搜索"
                    Layout.minimumWidth: 200
                    Layout.fillWidth: true
                    Layout.bottomMargin: 3
                    onAccepted: {
                        content.drawer.open()
                        content.drawer.drawerTabBar.setCurrentIndex(0)
                    }
                    TapHandler {
                        onTapped: _searchField.clear()
                    }
                }
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

}
