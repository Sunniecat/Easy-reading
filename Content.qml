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
        property alias drawerTabBar: _drawerTabBar
        TabBar{
            id:_drawerTabBar
            transformOrigin: Item.TopRight
            TabButton{
                text:qsTr( "目录" )
            }
            TabButton{
                text: qsTr( "搜索结果" )
            }
        }
        GroupBox {
            anchors.fill: parent
            anchors.topMargin: _drawerTabBar.height

            StackLayout {
                anchors.fill: parent
                currentIndex: _drawerTabBar.currentIndex
                component InfoField: TextInput {
                    width: parent.width
                    selectByMouse: true
                    readOnly: true
                    wrapMode: Text.WordWrap
                }

                //目录的显示
                TreeView {
                    id: _bookDirView
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

        //搜索结果的显示
        ListView {
            id: _searchResultsList
            implicitHeight: parent.height
            model: _pdfMultiView.searchModel
            currentIndex: _pdfMultiView.searchModel.currentResult
            ScrollBar.vertical: ScrollBar { }
            delegate: ItemDelegate {
                id: _searchResultDelegate
                required property int index
                required property int page
                required property string contextBefore
                required property string contextAfter
                width: parent ? parent.width : 0
                RowLayout {
                    anchors.fill: parent
                    spacing: 0
                    Label {
                        text: "Page " + (_searchResultDelegate.page + 1) + ": "
                    }
                    Label {
                        text: _searchResultDelegate.contextBefore
                        elide: Text.ElideLeft
                        horizontalAlignment: Text.AlignRight
                        Layout.fillWidth: true
                        Layout.preferredWidth: parent.width / 2
                    }
                    Label {
                        font.bold: true
                        text: _pdfMultiView.searchString
                        width: implicitWidth
                    }
                    Label {
                        text: _searchResultDelegate.contextAfter
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        Layout.preferredWidth: parent.width / 2
                    }
                }
                highlighted: ListView.isCurrentItem
                onClicked: _pdfMultiView.searchModel.currentResult = _searchResultDelegate.index
         }
        }
       }
      }
     }

// >>>>>>> b6f17b5 (实现更多视图缩放功能以及pdf搜索栏功能的版本提交)
    Dialogs {
        id:_dialogs
        fileOpen.onAccepted: {
            _pdfDoc.source=fileOpen.selectedFile
            console.log(_pdfDoc.source)
        }
    }
}
