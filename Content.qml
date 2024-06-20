import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Pdf

Item {
    property alias pdfDoc: _pdfDoc
    property alias dialogs: _dialogs
    property alias drawer: _drawer

    //pdf文件类
    PdfDocument{
        id:_pdfDoc
        source:"" //文件资源地址
    }


    //侧边栏
    Drawer {
        id: _drawer
        width: 300
        height: _pdfMultiView.height
        y: appwindow.header.height+appwindow.menuBar.height

        //侧边栏里的工具栏
        TabBar {
            id: drawerToolBar
            // currentIndex: 1
            // RowLayout {
                TabButton { action: actions.bookdir }
                TabButton { action: actions.bookmarks }
            // }

        }
        GroupBox {
            // title: qsTr("目录")
            anchors.fill: parent
            anchors.topMargin: drawerToolBar.height
            // title: qsTr("Synchronize")
            StackLayout {  //用于目录、缩略图、搜索结果等不同部分的显示
                anchors.fill: parent
                currentIndex: drawerToolBar.currentIndex
            }
            //目录的显示
            TreeView {
                id: bookdirview
                implicitHeight: parent.height
                implicitWidth: parent.width
                columnWidthProvider: function() { return width }  //保证了目录宽度不会超过GroupBox
                delegate: TreeViewDelegate {
                    onClicked: _pdfMultiView.goToLocation(page, location, zoom)
                }
                model: PdfBookmarkModel{
                    document: pdfDoc
                }
                ScrollBar.vertical: ScrollBar{}
            }
            //书签   开发中...
            TreeView {
                id: bookmarksview
                implicitHeight: parent.height
                implicitWidth: parent.width
                delegate: TreeViewDelegate{

                }
                model: PdfLinkModel{

                }
// PdfLinkDelegate
            }

        }
    }
    Dialogs {
        id:_dialogs
        fileOpen.onAccepted: {
            _pdfDoc.source=fileOpen.selectedFile
            console.log(_pdfDoc.source)
        }
    }
}
