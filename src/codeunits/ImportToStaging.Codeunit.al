codeunit 70000 "Import To Staging"
{
    trigger OnRun()
    begin
        ReadExcelFile();
        SetLastRowandColumn();
        ImportToStaging();
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

        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(ExcelInstream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure SetLastRowandColumn()
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.SetRange("Row No.", 1);
        IF TempExcelBuffer.FindLast() then
            MaxColumnNo := TempExcelBuffer."Column No.";

        TempExcelBuffer.Reset();
        IF TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";
    end;

    local procedure ImportToStaging()
    var
        CustVendStaging: Record "CustVend Staging";
        Rowno: Integer;
    begin
        for Rowno := 2 to MaxRowNo do begin
            CustVendStaging.Init();
            Evaluate(CustVendStaging.Type, GetCellValue(Rowno, 1));
            Evaluate(CustVendStaging.Name, GetCellValue(Rowno, 2));
            Evaluate(CustVendStaging."Phone No.", GetCellValue(Rowno, 3));
            Evaluate(CustVendStaging."Posting Group", GetCellValue(Rowno, 4));
            CustVendStaging.Insert(true);
        end;
    end;

    local procedure GetCellValue(Rowno: Integer; Colno: Integer): Text
    begin
        TempExcelBuffer.Reset();
        IF TempExcelBuffer.GET(Rowno, Colno) then
            Exit(TempExcelBuffer."Cell Value as Text");
        Exit('');
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        MaxRowNo, MaxColumnNo : Integer;
        ServerFileName: Text;
        ExcelInstream: InStream;
}