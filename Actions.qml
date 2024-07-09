import QtQuick
import QtQuick.Controls
import QtTextToSpeech


Item {
    //File
    property  alias open: _open
    property alias about: _about
    property alias closefile: _closefile

    //View
    property alias zoomIn: _zoomIn
    property alias zoomOut: _zoomOut
    property alias rotateLeft: _rotateLeft
    property alias rotateRight: _rotateRight
    property alias zoomFitWidth: _zoomFitWidth
    property alias zoomFitBest: _zoomFitBest
    property alias zoomOriginal: _zoomOriginal
    property alias playModel: _playModel

    //Tool
    property alias drawerAction: _drawerAction //sidebar
    property alias selectAll: _selectAll
    property alias copy: _copy
    property alias addmarks: _addmarks
    property alias currentPageTts: _currentPageTts
    property alias ttsSetting: _ttsSetting
    property alias resume: _resume
    property alias stop: _stop
    property alias pause: _pause

    //file
    Action {
        id: _open
        text: "Open(O)"
        icon.name: "document-open"
        shortcut: "Ctrl+O"
    }

    Action {
        id: _about
        text: "About"  //Some introduction about this reader, etc.
        icon.name: "help-about"
        // onTriggered:
    }
    Action {
        id: _closefile
        text: "Close File"
        icon.name: "document-close"
    }

    //View
    Action {
        id: _zoomIn
        text: "Zoom-in"
        icon.name: "zoom-in"
        shortcut: StandardKey.ZoomIn  //The usual shortcut is Ctrl + “+” // After testing, it’s not this combination, but Ctrl + Shift + “+”.
        enabled: _pdfMultiView.renderScale < 10   //This action is only available when the conditions are met (it actually sets the upper limit of zoom, which is the maximum).
        onTriggered: _pdfMultiView.renderScale *= 1.1  //Each time, zoom in by a factor of 1.1 times the original ratio.
    }
    Action {
        id: _zoomOut   //usual Ctrl + ”-“
        text: "Zoom-out"
        icon.name: "zoom-out"
        shortcut: StandardKey.ZoomOut
        enabled: _pdfMultiView.renderScale > 0.1   //This action is only available when the conditions are met (it actually sets the upper limit of zoom, which is the minmum).
        onTriggered: _pdfMultiView.renderScale /= 1.1
    }
    Action {
        id:_rotateLeft
        text: "rotate left"
        icon.name: "object-rotate-left-symbolic"
        shortcut: "Ctrl+L"
    }
    Action {
        id:_rotateRight
        text: "rotate right"
        icon.name: "object-rotate-right-symbolic"
        shortcut: "Ctrl+R"
    }
    Action {
        id:_zoomFitWidth
        text: "fit width"
        icon.name: "zoom-fit-width"
        onTriggered: _pdfMultiView.scaleToWidth(appwindow.contentItem.width, appwindow.contentItem.height)
    }
    Action{
        id:_zoomFitBest
        text: "fit best"
        icon.name: "zoom-fit-best"
        onTriggered: _pdfMultiView.scaleToPage(appwindow.contentItem.width, appwindow.contentItem.height)
    }
    Action{
        id:_zoomOriginal
        text: "fit original"
        icon.name: "zoom-fit-original"
        onTriggered: _pdfMultiView.resetScale()
    }
    Action{
        id:_playModel
        text: "play Model"
        onTriggered: fullScreen()
    }
    Action{
        id:_fullScreen
        text: "Full Screen"
    }

    //Tool
    Action {
        id: _drawerAction

        icon.name: "sidebar-expand-left"
        onTriggered: content.drawer.open()
    }
    Action{
        id:_selectAll
        text:"select all"
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
        text: qsTr("add bookmark")
        icon.name: "bookmark-new"
    }
    Action{
        id:_ttsSetting
        icon.name: "settings-configure-symbolic"
        text: "Reading settings."
        onTriggered: content.dialogs.ttsSettingDialog.open()
    }
    Action{
        id:_currentPageTts
        text: "read current page"
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
        text:"continue"
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
