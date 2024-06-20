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
        source: ""
    }


    //侧边栏
    Drawer {
        id: _drawer
        width: 300
        height: view.height
        y: root.header.height+root.menuBar.height

        TabBar {
            id: sidebarTabs
            x: -width
            rotation: -90
            transformOrigin: Item.TopRight
            currentIndex: 2 // bookmarks by default
            TabButton {
                text: qsTr("pages")
            }
        }
        GroupBox{
            anchors.fill: parent
            anchors.leftMargin: sidebarTabs.height

            StackLayout{
                anchors.fill: parent
                currentIndex: sidebarTabs.currentIndex
                component InfoField: TextInput {
                    width: parent.width
                    selectByMouse: true
                    readOnly: true
                    wrapMode: Text.WordWrap
                }


                GridView{
                    id: thumbnailsView
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    model: pdfDoc.pageModel
                    cellWidth: width / 2
                    cellHeight: cellWidth + 10
                    delegate:Item {
                        required property int index
                        required property string label
                        required property size pointSize
                        width:thumbnailsView.cellWidth
                        height: thumbnailsView.cellHeight
                        Rectangle{
                            id:paper
                            width: _image.width
                            height: _image.height
                            x:(parent.width-width)/2
                            y:(parent.height-height-pagename.height)/2
                            PdfPageImage{
                                id:_image
                                document: pdfDoc
                                currentFrame: index
                                asynchronous: true//表示页面渲染是异步进行的。这意味着PDF页面的渲染不会阻塞UI线程，用户界面在渲染过程中仍然可以响应用户操作。

                                fillMode: Image.PreserveAspectFit//保持其宽高比的方式填充可用空间
                                property bool landscape: pointSize.width > pointSize.height

                                width: landscape ? thumbnailsView.cellWidth - 6
                                                 : height * pointSize.width / pointSize.height
                                height: landscape ? width * pointSize.height / pointSize.width
                                                  : thumbnailsView.cellHeight - 14
                                sourceSize.width: width
                                sourceSize.height: height
                            }
                        }
                        Text {
                            id: pagename
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            text:label
                        }
                        TapHandler{
                            onTapped: view.goToLocation(index)
                        }

                    }
                }
            }
        }
    }


    Dialogs{
        id:_dialogs
        fileOpen.onAccepted: {
            _pdfDoc.source=fileOpen.selectedFile
        }
    }



}


