import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Pdf

Item {
    property alias pdfDoc: _pdfDoc
    property alias dialogs: _dialogs

    //pdf文件类
    PdfDocument{
        id:_pdfDoc
        source:"" //文件资源地址
    }

    Dialogs{
        id:_dialogs
        fileOpen.onAccepted: {
            _pdfDoc.source=fileOpen.selectedFile
            console.log(_pdfDoc.source)
        }
    }
}
