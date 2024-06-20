import QtQuick
import QtQuick.Controls
import QtQuick.Pdf
import QtQuick.Layouts
import "Controller.js" as Controller

ApplicationWindow {
    id:root
    width: 1200
    height: 800
    color: "lightgrey"
    title: "Easy reading"
    visible: true
    property alias view: _view

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


            SpinBox {
                id: currentPageSB
                from: 1
                to: content.pdfDoc.pageCount
                editable: true
                onValueModified: view.goToPage(value - 1)
                Shortcut {
                    sequence: "Ctrl+w"
                    onActivated: view.goToPage(currentPageSB.value - 2)
                }
                Shortcut {
                    sequence: "Ctrl+s"
                    onActivated: view.goToPage(currentPageSB.value)
                }
            }
            ToolButton{action:actions.seleCtall}
            ToolButton{action:actions.ccccc}
        }

    }
    // DropArea {
    //     anchors.fill: parent
    //     keys: ["text/uri-list"]
    //     onEntered: (drag) => {
    //                    drag.accepted = (drag.proposedAction === Qt.MoveAction || drag.proposedAction === Qt.CopyAction) &&
    //                    drag.hasUrls && drag.urls[0].endsWith("pdf")
    //                }
    //     onDropped: (drop) => {
    //                    doc.source = drop.urls[0]
    //                    drop.acceptProposedAction()
    //                }
    // }



    footer: ToolBar{
        RowLayout{
            ToolButton{  action: actions.popup }
        }

    }


    Actions {
        id: actions
        open.onTriggered: content.dialogs.fileOpen.open()
    }

    Content{
        id:content
    }
    PdfMultiPageView {//这个不放window里不显示页面，不理解为什么
        id: _view
        anchors.fill: parent
        document: content.pdfDoc
        // searchString  可以做搜索框
        //onCurrentPageChanged   可以做页面跳转之类的东西
    }
}
