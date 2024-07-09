import QtQuick
import QtQuick.Dialogs
import QtTextToSpeech
import QtQuick.Controls
import QtQuick.Layouts
import "controller.js" as Controller

Item {
    property alias fileOpen: _fileOpen
    property alias ttsSettingDialog: _ttsSettingDialog
    property alias aAbout: _about

    //Open PDF file window.
    FileDialog{
        id: _fileOpen
        title: "Open a PDF file"
        fileMode: FileDialog.OpenFile
        nameFilters: [ "PDF files (*.pdf)" ]
    }

    //about
    MessageDialog{
        id:_about
        modality: Qt.WindowModal
        buttons:MessageDialog.Ok
        text:"Easy-reading is a PDF free reader"
        informativeText: qsTr("Easy-reading is a free software, and you can download its source code from www.github.com")
        detailedText: "Copyright©2024 EASYREADING (easyreading@163.com)"
    }

    Dialog{
        id:_ttsSettingDialog
        width: 230
        height: 160

        property alias enginesComboBox: _enginesComboBox
        property alias localesComboBox: _localesComboBox
        property alias voicesComboBox: _voicesComboBox
        property alias volumeSlider: _volumeSlider
        property alias pitchSlider: _pitchSlider
        property alias rateSlider: _rateSlider

        GridLayout {
            columns: 2

            Text {
                color: "white"
                text: qsTr("Engine:")
            }
            ComboBox {
                id: _enginesComboBox
                Layout.fillWidth: true
                model: _tts.availableEngines()
                onActivated: {
                    _tts.engine = textAt(currentIndex)
                    Controller.updateLocales() //Real-time update options.
                    Controller.updateVoices()
                }
            }
            Text {
                color: "white"
                text: qsTr("Locale:")
            }
            ComboBox {
                id: _localesComboBox
                Layout.fillWidth: true
                onActivated: {
                    let locales = _tts.availableLocales()
                    _tts.locale = locales[currentIndex]
                    Controller.updateVoices() //Real-time update options.
                }
            }
            Text {
                color: "white"
                text: qsTr("Voice:")
            }
            ComboBox {
                id: _voicesComboBox
                Layout.fillWidth: true
            }
            Text {
                color: "white"
                text: qsTr("Volume:")
            }
            Slider {
                id: _volumeSlider
                from: 0
                to: 1.0
                stepSize: 0.2
                value: 0.8
                Layout.fillWidth: true
            }
            Text {
                color: "white"
                text: qsTr("Pitch:")
            }
            Slider {
                id: _pitchSlider
                from: -1.0
                to: 1.0
                stepSize: 0.5
                value: 0
                Layout.fillWidth: true
            }
            Text {
                color: "white"
                text: qsTr("Rate:")
            }
            Slider {
                id: _rateSlider
                from: -1.0
                to: 1.0
                stepSize: 0.5
                value: 0
                Layout.fillWidth: true
            }
        }
    }
}


