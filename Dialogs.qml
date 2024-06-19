import QtQuick
import QtQuick.Dialogs

Item {
    property alias fileOpen: _fileOpen

    FileDialog {
        id: _fileOpen
        title: "Open a book file"
        nameFilters: ["select a book file (*.pdf)"]
        onAccepted: {

            content.pdfdoc.source = selectedFile
            console.log(content.pdfdoc.source)
        }

    }


}
