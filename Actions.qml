import QtQuick
import QtQuick.Controls
import QtTextToSpeech


Item {
    //文件
    property  alias open: _open
    property alias save: _save
    property alias about: _about
    property alias closefile: _closefile

    //视图
    property alias zoomIn: _zoomIn
    property alias zoomOut: _zoomOut
    property alias rotateLeft: _rotateLeft
    property alias rotateRight: _rotateRight
    property alias zoomFitWidth: _zoomFitWidth
    property alias zoomFitBest: _zoomFitBest
    property alias zoomOriginal: _zoomOriginal
    property alias playModel: _playModel

    //工具
    property alias drawerAction: _drawerAction //Sidebar
    property alias selectAll: _selectAll
    property alias copy: _copy
    property alias addmarks: _addmarks
    property alias currentPageTts: _currentPageTts
    property alias ttsSetting: _ttsSetting
    property alias resume: _resume
    property alias stop: _stop
    property alias pause: _pause

    //文件
    Action {
        id: _open
        text: "Open(O)"  //use to open a file
        icon.name: "document-open"
        shortcut: "Ctrl+O"
    }
    Action {
        id: _save
        text: "Save(S)"   //用于做了修改后（比如做了批注等）保存
        icon.name: "document-save"
        shortcut: StandardKey.Save   // Ctrl + S
        // onTriggered:
    }
    Action {
        id: _about
        text: "about"  //some introduction about the app
        icon.name: "help-about"
        // onTriggered:
    }
    Action {
        id: _closefile
        text: "closeFile"
        icon.name: "document-close"
    }

    //view part
    Action {
        id: _zoomIn
        text: "zoomIn"
        icon.name: "zoom-in"
        shortcut: StandardKey.ZoomIn  //Normally, it is Ctrl + "+", but after testingg, found that it is Ctrl + shift + "+"
        enabled: _pdfMultiView.renderScale < 10   //When the condition is met, this action is available (basically setting the upper limit of scaling, that is, the maximum).
        onTriggered: _pdfMultiView.renderScale *= 1.1
    }
    Action {
        id: _zoomOut   //Ctrl + ”-“
        text: "zoomOut"
        icon.name: "zoom-out"
        shortcut: StandardKey.ZoomOut
        enabled: _pdfMultiView.renderScale > 0.1   //the minimum
        onTriggered: _pdfMultiView.renderScale /= 1.1
    }
    Action {
        id:_rotateLeft
        text: "rotateLeft"
        icon.name: "object-rotate-left-symbolic"
        shortcut: "Ctrl+L"
    }
    Action {
        id:_rotateRight
        text: "rotateRight"
        icon.name: "object-rotate-right-symbolic"
        shortcut: "Ctrl+R"
    }
    Action {
        id:_zoomFitWidth
        text: "FitWidth"
        icon.name: "zoom-fit-width"
        onTriggered: _pdfMultiView.scaleToWidth(appwindow.contentItem.width, appwindow.contentItem.height)
    }
    Action{
        id:_zoomFitBest
        text: "FitBest"
        icon.name: "zoom-fit-best"
        onTriggered: _pdfMultiView.scaleToPage(appwindow.contentItem.width, appwindow.contentItem.height)
    }
    Action{
        id:_zoomOriginal
        text: "zoomOriginal"
        icon.name: "zoom-fit-original"
        onTriggered: _pdfMultiView.resetScale()
    }
    Action{
        id:_playModel
        text: "playModel"
        onTriggered: fullScreen()
    }
    Action{
        id:_fullScreen
        text: "fullScreen"
    }

    //tools part
    Action {
        id: _drawerAction
        icon.name: "sidebar-expand-left"
        onTriggered: content.drawer.open()
    }
    Action{
        id:_selectAll
        text:"selectAll"
        icon.name: "edit-select-all-symbolic"
        onTriggered: _pdfMultiView.selectAll()
    }
    Action{
        id:_copy
        text: "copy"
        icon.name: "edit-copy-symbolic"
        enabled: _pdfMultiView.selectedText !== ""
        onTriggered: _pdfMultiView.copySelectionToClipboard()
    }
    Action {
        id: _addmarks
        text: qsTr("addmarks")
        icon.name: "bookmark-new"
    }
    Action{
        id:_ttsSetting
        icon.name: "settings-configure-symbolic"
        text: "audioReadingSetting"
        onTriggered: content.dialogs.ttsSettingDialog.open()
    }
    Action{
        id:_currentPageTts
        text: "readCurrentPage"
        icon.name: "media-playback-start-symbolic"
        enabled: [TextToSpeech.Paused, TextToSpeech.Ready].includes(_tts.state)
        onTriggered: {
            _pdfMultiView.selectAll()
            if (_pdfMultiView.selectedText !== "")
            {
                let voices = _tts.availableVoices()
                _tts.voice = voices[content.dialogs.ttsSettingDialog.voicesComboBox.currentIndex]
                _tts.say(_pdfMultiView.selectedText)
            }
        }
    }
    Action{
        id:_resume
        text:"resume"
        icon.name: "media-playback-playing-symbolic"
        enabled: _tts.state == TextToSpeech.Paused
        onTriggered: _tts.resume()
    }
    Action{
        id:_stop
        text:"stop"
        icon.name: "media-playback-stop-symbolic"
        enabled: [TextToSpeech.Speaking, TextToSpeech.Paused].includes(_tts.state)
        onTriggered: _tts.stop()
    }
    Action{
        id:_pause
        text:"pause"
        icon.name: "media-playback-paused-symbolic"
        enabled: _tts.state == TextToSpeech.Speaking
        onTriggered: _tts.pause()
    }
}
