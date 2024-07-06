
function addmarks() {
    content.marksModel.append({name: "page", value: _pdfMultiView.currentPage})
    console.log(_pdfMultiView.currentPage)
}

//recentfiles part
function loadFile(filepath)
{
    content.pdfDoc.source = filepath
    console.log("filepath", filepath)
    _pdfMultiView.visible = true
    beginview.visible = false
}
function addrecentfiles()
{
    if(!content.pdfDoc.source)   //source is not null
    {
        recentfiles.addRecentFile(content.pdfDoc.source)
        console.log("add rencentfiles:", content.pdfDoc.source)
    }
}

function insertMenuItem(index, object)
{
    recentFilesMenu.insertItem(index, object)
    console.log("insert index: ", index)
    console.log("object: ", object.text)
}
function removeMenuItem(index, object)
{
    recentFilesMenu.removeItem(object)
    console.log("remove index: ", index)
}

function clearAllRecentfiles()
{
    var i = recentFilesInstantiator.count
    var object
    for(i; i >= 0; i--)
    {
        object = recentFilesInstantiator.objectAt(i)
        removeMenuItem(i, object)
    }
    console.log()
    recentfiles.clear()
    console.log("recentFiles.size:",recentfiles.size())
}

//close file
function closefile()
{
    _pdfMultiView.visible = false
    beginview.visible = true
    console.log("closefile",_pdfMultiView.document)
}

//text to speech
function updateLocales() {
    let allLocales = _tts.availableLocales().map((locale) => locale.nativeLanguageName)
    let currentLocaleIndex = allLocales.indexOf(_tts.locale.nativeLanguageName)
    _dialogs.ttsSettingDialog.localesComboBox.model = allLocales
    _dialogs.ttsSettingDialog.localesComboBox.currentIndex = currentLocaleIndex
}

function updateVoices() {
    _dialogs.ttsSettingDialog.voicesComboBox.model = _tts.availableVoices().map((voice) => voice.name)
    let indexOfVoice = _tts.availableVoices().indexOf(_tts.voice)
    _dialogs.ttsSettingDialog.voicesComboBox.currentIndex = indexOfVoice
}

function engineReady() {
    _tts.stateChanged.disconnect(engineReady)
    if (_tts.state !== TextToSpeech.Ready) {
        _tts.updateStateLabel(_tts.state)
        return;
    }
    updateLocales()
    updateVoices()
}
