
function addmarks() {
    content.marksModel.append({name: "page", value: _pdfMultiView.currentPage})
    console.log(_pdfMultiView.currentPage)
}
//open file part
function openfile()
{
    content.dialogs.fileOpen.rejected.
    connect(()=>{return})//rejected, then do nothing
    content.dialogs.fileOpen.accepted.
    connect(()=>{
                content.pdfDoc.source = content.dialogs.fileOpen.selectedFile
                console.log("open file:", content.pdfDoc.source)
                //every time we open a new file, we should add it to recentfiles
                recentfiles.curFile = content.pdfDoc.source
                recentfiles.addRecentFile(recentfiles.curFile)
                beginview.recentfileslist.model = recentfiles.recentFiles  //update the recentfileslist after open a new file
                _pdfMultiView.visible = true
                beginview.visible = false
                console.log("clear  list, count: ", beginview.recentfileslist.count)
            })
    content.dialogs.fileOpen.open()
}

//recentfiles part
function loadFile(filepath)
{
    content.pdfDoc.source = filepath
    recentfiles.curFile = content.pdfDoc.source
    recentfiles.addRecentFile(recentfiles.curFile)
    console.log("filepath", filepath)
    _pdfMultiView.visible = true
    beginview.visible = false
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
    beginview.recentfileslist.model = recentfiles.recentFiles //update the recentfileslist after clear all recentfiles
    console.log("recentFiles.size:",recentfiles.size())
}

function removeRecentfile(index)   //remove a recent file
{
    recentfiles.remove(index)
    //update the recentFilesMenu
    var object = recentFilesInstantiator.objectAt(index)
    recentFilesInstantiator.objectRemoved(index, object)
    //update recentfileslist model
    beginview.recentfileslist.model = recentfiles.recentFiles

}

//close file
function closefile()
{
    _pdfMultiView.visible = false
    beginview.visible = true
    console.log("closefile",_pdfMultiView.document.source)
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
