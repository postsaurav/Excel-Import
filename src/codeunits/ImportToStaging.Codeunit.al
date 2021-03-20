codeunit 70000 "Import To Staging"
{
    trigger OnRun()
    begin
        ReadExcelFile();
        //SetLastRowandColumn();
        //ImportToStaging();
    end;

    local procedure ReadExcelFile()
    var
        FileManagement: Codeunit "File Management";
        SelectDialougLbl: Label 'Import Excel File';
        ExcelFileExtensionTok: Label 'Excel Files (*.xlsx;*.xls)|*.xlsx;*.xls', Locked = true;
        SheetName: Text;
    begin
        If not UploadIntoStream(SelectDialougLbl, '', ExcelFileExtensionTok, ServerFileName, ExcelInstream) then
            exit;

        if ServerFileName <> '' then begin
            ServerFileName := FileManagement.GetFileName(ServerFileName);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInstream);
        end;
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ServerFileName: Text;
        ExcelInstream: InStream;
}