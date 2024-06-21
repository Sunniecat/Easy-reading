import QtQuick
import QtQuick.Dialogs

Item {
    property alias fileOpen: _fileOpen
    //打开pdf文件窗口
    FileDialog{
        id: _fileOpen
        title: "Open a PDF file"
        fileMode: FileDialog.OpenFile
        nameFilters: [ "PDF files (*.pdf)" ]
    }
}
