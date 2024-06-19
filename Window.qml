import QtQuick
import QtQuick.Controls
import QtQuick.Pdf
import QtQuick.Layouts
import "Controller.js" as Controller

ApplicationWindow {
    width: 1200
    height: 800
    color: "lightgrey"
    title: "Easy reading"
    visible: true

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
        }

    }
    header: ToolBar {
        RowLayout{
            ToolButton{ action: actions.zoomIn }
            ToolButton{ action: actions.zoomOut}
        }
    }

    PdfMultiPageView {
        id: view
        anchors.fill: parent
        document: content.pdfDoc
        // searchString  可以做搜索框
        //onCurrentPageChanged   可以做页面跳转之类的东西
    }
    Actions {
        id: actions
        open.onTriggered: content.dialogs.fileOpen.open()
    }

    Content{
        id:content
    }
}
