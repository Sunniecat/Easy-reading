
function addmarks() {
    content.marksModel.append({name: "page", value: _pdfMultiView.currentPage})
    console.log(_pdfMultiView.currentPage)
}

//recentfiles part
function loadFile(filepath)
{
    content.pdfDoc.source = filepath
    console.log("filepath", filepath)
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
function removetMenuItem(index, object)
{
    recentFilesMenu.removeItem(object)
    console.log("remove index: ", index)
    // console.log("object: ", object.text)
}

function clearAllRecentfiles()
{
    var i = recentFilesInstantiator.count
    var object
    for(i; i >= 0; i--)
    {
        object = recentFilesInstantiator.objectAt(i)
        removetMenuItem(i, object)
    }
    console.log()
    recentfiles.clear("recentFilesInstantiator.count:",recentFilesInstantiator.count)
    console.log("recentFiles.size:",recentfiles.size())
}
