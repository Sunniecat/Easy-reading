import QtQuick
import QtQuick.Controls
import QtQuick.Pdf
import QtQuick.Layouts
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

    menuBar: MenuBar {
        Menu {
            id: fileMenu
            title: qsTr("File(&F)")   //Alt + F
            MenuItem { action: actions.open }
            MenuItem { action: actions.save }

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
            MenuItem { action: actions.zoomIn }
            MenuItem { action: actions.zoomOut }
            MenuItem { action: actions.rotateLeft }
            MenuItem { action: actions.rotateRight }
            MenuItem { action: actions.zoomFitWidth }
            MenuItem { action: actions.zoomFitBest }
            MenuItem { action: actions.zoomOriginal }
            MenuItem { action: actions.playModel }
        }

        Menu {
            title: qsTr("Tools(&T)")
            Menu{
                icon.name: "view-readermode-symbolic"
                title: qsTr("Audio reading")
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
                    ToolTip.text: "openSidebar"
                }
                ToolButton{ action: actions.zoomIn }
                ToolButton{ action: actions.zoomOut }
                ToolButton{ action: actions.rotateLeft }
                ToolButton{ action: actions.rotateRight }
                ToolButton{ action: actions.addmarks }

                //Search bar
                TextField {
                    id: _searchField
                    placeholderText: "search"
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

    footer:Label //Used to display the current reading status
    {
            id: _statusLabel
            color: "black"
        }

}

