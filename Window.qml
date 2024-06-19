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
               }

    }
    header: ToolBar {
            RowLayout{
                ToolButton{ action: actions.zoomIn }
                ToolButton{ action: actions.zoomOut}
            }
        }

    Actions {
        id: actions
        open.onTriggered: {
            content.dialogs.fileOpen.open()
        }
    }
    PdfMultiPageView{
        id: pdfview
        anchors.fill: parent
        document: content.pdfdoc
    }
    Content {
        id: content
    }

}
