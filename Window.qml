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
                to: doc.pageCount
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
        }

    }

    Drawer{
        id:silderbar
        edge: Qt.LeftEdge
        modal: false
        width: 300
        y: root.header.height+30
        height: view.height
        dim: false
        clip: true

        TabBar {
            id: sidebarTabs
            x: -width
            rotation: -90
            transformOrigin: Item.TopRight
            currentIndex: 2 // bookmarks by default
            TabButton {
                text: qsTr("Bookmarks")
            }
            TabButton {
                text: qsTr("Pages")
            }
        }
        GroupBox{
            anchors.fill: parent
            anchors.leftMargin: sidebarTabs.height
            StackLayout{
                anchors.fill: parent
                currentIndex: sidebarTabs.currentIndex
                component InfoField:TextInput{
                    width: parent
                    selectByMouse: true
                    readOnly: true
                    wrapMode: Text.WordWrap
                }
                Column{
                    spacing: 6
                    width: parent.width - 6
                    Label { font.bold: true; text: qsTr("Title") }
                    InfoField { text:Content.pdfDoc.title }
                }
                TreeView {
                    id: bookmarksTree
                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    columnWidthProvider: function() { return width }
                    delegate: TreeViewDelegate {
                        required property int page
                        required property point location
                        required property real zoom
                        onClicked: view.goToLocation(page, location, zoom)
                    }
                    model: PdfBookmarkModel {
                        document: content.pdfDoc
                    }
                    ScrollBar.vertical: ScrollBar { }
                }
            }
        }


    }

    footer: ToolBar{
        RowLayout{
            ToolButton{  action: actions.popup }
            ToolButton{ action:actions.popdown}

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
