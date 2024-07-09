import QtQuick
import QtQuick.Controls
import QtQuick.Pdf
import QtQuick.Layouts
import Qt.labs.settings
// import recentfiles
import myModule
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
    Component.onDestruction: {
        _setting.previouspage=_pdfMultiView.currentPage
        console.log("page=",_setting.previouspage)
    }
    Settings{
        id:_setting
        property int previouspage: _pdfMultiView.currentPage
    }
    menuBar: MenuBar {
        Menu {
            id: fileMenu
            title: qsTr("File(&F)")   //Alt + F
            MenuItem { action: actions.open }

            //recentfiles part
            Menu {
                id: recentFilesMenu
                title: qsTr("Recent Files")
                icon.name: "document-open-recent"
                Instantiator {
                    id: recentFilesInstantiator
                    model: recentfiles.recentFiles
                    delegate: MenuItem {
                        text: recentfiles.displayableFilePath(modelData)
                        onTriggered: {
                            let filepath = modelData
                            Controller.loadFile(filepath)
                            console.log("clicked: ", filepath)
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
            MenuItem { action: actions.closefile }
        }
        Menu {
            id: viewMenu
            title: qsTr("View(&V)")   //Alt + V
            MenuItem { action: actions.zoomIn }  //Zoom in (or bring the camera lens closer)
            MenuItem { action: actions.zoomOut }  //Zoom out (or pull the camera back).
            MenuItem { action: actions.rotateLeft } //Rotate to the left.
            MenuItem { action: actions.rotateRight } //Rotate to the right
            MenuItem { action: actions.zoomFitWidth } //Scale to fit width.
            MenuItem { action: actions.zoomFitBest }  //Optimal zoom.
            MenuItem { action: actions.zoomOriginal } //Initialize zoom.
            MenuItem { action: actions.playModel }
        }

        Menu {
            title: qsTr("Tool(&T)")
            Menu{
                icon.name: "view-readermode-symbolic"
                title: qsTr("Audio reading.")
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
                ToolTip.text: "Open the sidebar."
            }
            ToolButton{ action: actions.zoomIn }
            ToolButton{ action: actions.zoomOut }
            ToolButton{ action: actions.rotateLeft }
            ToolButton{ action: actions.rotateRight }
            ToolButton{ action: actions.addmarks }  //add BookMarks

            //search bar
            TextField {
                id: _searchField
                placeholderText: "Search"
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
            SpinBox {
                id: _currentPage
                from: 1
                to: content.pdfDoc.pageCount
                editable: true
                wheelEnabled: true
                value:_pdfMultiView.currentPage
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
        //file part
        open.onTriggered: Controller.openfile()

        closefile.onTriggered: Controller.closefile()
        //view part
        rotateLeft.onTriggered: {
            _pdfMultiView.pageRotation -= 90

        }
        rotateRight.onTriggered: {
            _pdfMultiView.pageRotation += 90
        }
        addmarks.onTriggered: Controller.addmarks()
        about.onTriggered: Controller.about()
    }

    RecenFiles{
        id: recentfiles
        maxCount: 10
    }
    Content{
        id:content
        anchors.fill: parent
    }
    Rectangle{
        id: twoview
        anchors.fill: parent
        color: "lightgrey"
        Begining{
            id: beginview
            visible: true
        }
        PdfMultiPageView{
            id:_pdfMultiView
            document: content.pdfDoc
            anchors.fill:twoview
            searchString: _searchField.text
            visible: false
            Component.onCompleted: {
                _pdfMultiView.goToPage(_setting.previouspage)
            }
        }
    }

    //Temporarily save text”
    TextArea{
        id:_selectedText
        visible: false
        enabled: false
    }
    //Text-to-speech
    TextToSpeech{
        id:_tts
        volume: content.dialogs.ttsSettingDialog.volumeSlider.value //Bound to the slider, the same applies below
        pitch: content.dialogs.ttsSettingDialog.pitchSlider.value
        rate: content.dialogs.ttsSettingDialog.rateSlider.value

        onStateChanged: updateStateLabel(state) //State transition

        function updateStateLabel(state) //state function
        {
            switch (state) {
            case TextToSpeech.Ready:
                _statusLabel.text = qsTr("Ready to read") //Judge engine enters ready state without error.
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
    DropArea {
        anchors.fill: parent
        keys: ["text/uri-list"]
        onEntered: (drag) => {
                       drag.accepted = (drag.proposedAction === Qt.MoveAction || drag.proposedAction === Qt.CopyAction) &&
                       drag.hasUrls && drag.urls[0].endsWith("pdf")
                   }
        onDropped: (drop) => {
                       content.pdfDoc.source=drop.urls[0]
                       drop.acceptProposedAction()
                   }
    }



    footer:Label //Used to display the current reading status.
    {
        id: _statusLabel
        color: "black"
    }

}

