import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Pdf
import "controller.js" as Controller
import QtTextToSpeech
// import recentfiles
import myModule

Item {
    property alias pdfDoc: _pdfDoc
    property alias dialogs: _dialogs
    property alias drawer: _drawer
    //sidebar
    property alias bookmarksview: _bookmarksview
    property alias bookmarks: _bookmarks
    // property alias marksModel: _marksModel
    signal fullScreen()
    signal window()

    //pdf fileclass
    PdfDocument{
        id:_pdfDoc
        source:"" //文件资源地址
    }

    //sidebar
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
                text:qsTr( "Table of Contents" )
                width: 60
            }
            TabButton{
                text: qsTr( "Search Results" )
                width: 60
            }
            TabButton{
                text:qsTr( "Thumbnail." )
                width: 60
            }
            TabButton{
                text:qsTr( "BookMark" )
                width: 60
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

                //Display of the table of contents.
                TreeView {
                    id: _bookDirView
                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    columnWidthProvider: function() { return width }  //Ensure that the width of the table of contents does not exceed the GroupBox.
                    delegate: TreeViewDelegate {
                        onClicked: _pdfMultiView.goToLocation(page, location, zoom)
                    }
                    model: PdfBookmarkModel{
                        document: pdfDoc
                    }
                    ScrollBar.vertical: ScrollBar{}
                }

        //搜索结果的显示Display the search results
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

        //display thumbails
        GridView{
            id: _thumbNailsView
            implicitWidth: parent.width
            implicitHeight: parent.height
            model: _pdfDoc.pageModel
            cellWidth: width / 2
            cellHeight: cellWidth + 10
            delegate:Item {
                required property int index
                required property string label
                required property size pointSize
                width: _thumbNailsView.cellWidth
                height: _thumbNailsView.cellHeight
                Rectangle{
                    id:_paper
                    width: _image.width
                    height: _image.height
                    x:(parent.width-width)/2
                    y:(parent.height-height-_pageName.height)/2
                    PdfPageImage{
                        id:_image
                        document: _pdfDoc
                        currentFrame: index
                        asynchronous: true// indicates that page rendering is performed asynchronously. This means that the rendering of PDF pages does not block the UI thread, and the user interface remains responsive to user actions during the rendering process.

                        fillMode: Image.PreserveAspectFit//Fill the available space while maintaining its aspect ratio.
                        property bool landscape: pointSize.width > pointSize.height

                        width: landscape ? _thumbNailsView.cellWidth - 6
                                         : height * pointSize.width / pointSize.height
                        height: landscape ? width * pointSize.height / pointSize.width
                                          : _thumbNailsView.cellHeight - 14
                        sourceSize.width: width
                        sourceSize.height: height
                    }
                }
                Text {
                    id: _pageName
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:label
                }
                TapHandler{
                    onTapped: _pdfMultiView.goToPage(index)
                }
            }
         }

     //book marks part
        BookMarks{
            id: _bookmarks
            curFile: pdfDoc.source

        }
        ListView{
            id: _bookmarksview
            height: parent.height
            width: parent.width
            model: bookmarks.marksList
            delegate: MenuItem{
                text: bookmarks.displayMark(modelData)
                onTriggered: {
                    _pdfMultiView.goToPage(modelData - 1)  //The page numbers saved in bookmarks start from 1, whereas the jump here starts from 0.
                }
                TapHandler{
                    acceptedButtons: Qt.RightButton
                    onTapped: {
                        bookmarksview.currentIndex = index
                        marksOption.popup()
                    }
                }
            }

        }//ListView
        Menu{
            id: marksOption  //some function abou marks
            MenuItem{
                id: _removeMark
                text: qsTr("Remove bookmark")
                icon.name: "bookmark-remove"
                onTriggered: {
                    let index = bookmarksview.currentIndex
                    Controller.removeMark(index)
                }
            }
            MenuItem{
                id: _goToMark
                text: qsTr(" go to mark page")
                onTriggered: {
                    var index = bookmarksview.currentIndex
                    var page = bookmarksview.model[index]
                    console.log("gotomark index", page)
                    _pdfMultiView.goToPage(page - 1)
                }
            }
            MenuItem{
                id: _clearMarks
                text: qsTr("clear all mark")
                icon.name: "edit-clear-history"
                onTriggered: Controller.clearAllMarks()
            }
        }

      }//StackLayout
   }//GroupBox
}//Drawer

    Dialogs {
        id:_dialogs
    }

    Component.onCompleted: {
        dialogs.ttsSettingDialog.enginesComboBox.currentIndex = _tts.availableEngines().indexOf(_tts.engine)
        if (_tts.state === TextToSpeech.Ready) {
            Controller.engineReady()
        } else {
            _tts.stateChanged.connect(Controller.engineReady)
        }

        _tts.updateStateLabel(_tts.state)
    }

}


