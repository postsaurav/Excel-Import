codeunit 70001 "Process Staging"
{
    trigger OnRun()
    begin

    end;

    procedure ProcessStagingRecords()
    begin
        ProcessCustomerRecords();
        ProcessVendorRecords();
        UpdateStagingStatus();
    end;

    local procedure ProcessCustomerRecords()
    var
        CustVendStaging: Record "CustVend Staging";
        Customer: Record Customer;
    begin
        CustVendStaging.Reset();
        CustVendStaging.SetRange(Type, 1);
        CustVendStaging.SetFilter(Status, '%1|%2', CustVendStaging.Status::Error, CustVendStaging.Status::New);
        If not CustVendStaging.FindSet() then
            exit;

        repeat
            If TryCreateCustomer(CustVendStaging, Customer) then begin
                Customer.Insert(true);
                UpdateStatus(CustVendStaging, '', Customer."No.");
            end else
                UpdateStatus(CustVendStaging, GetLastErrorText(), '');
        until (CustVendStaging.Next() = 0);
    end;

    [TryFunction]
    local procedure TryCreateCustomer(CustVendStaging: Record "CustVend Staging"; Var Customer: Record Customer)
    begin
        Clear(Customer);
        Customer.Init();
        Customer.Validate(Name, CustVendStaging.Name);
        Customer.Validate("Phone No.", CustVendStaging."Phone No.");
        Customer.Validate("Customer Posting Group", CustVendStaging."Posting Group");
    end;

    local procedure ProcessVendorRecords()
    var
        CustVendStaging: Record "CustVend Staging";
        Vendor: Record Vendor;
    begin
        CustVendStaging.Reset();
        CustVendStaging.SetFilter(Status, '%1|%2', CustVendStaging.Status::Error, CustVendStaging.Status::New);
        CustVendStaging.SetRange(Type, 2);
        If Not CustVendStaging.FindSet() then
            exit;
        repeat
            If TryCreatingVendor(CustVendStaging, Vendor) then begin
                Vendor.Insert(True);
                UpdateStatus(CustVendStaging, '', Vendor."No.");
            end else
                UpdateStatus(CustVendStaging, GetLastErrorText(), '');
        until (CustVendStaging.Next() = 0);
    end;

    [TryFunction]
    local procedure TryCreatingVendor(CustVendStaging: Record "CustVend Staging"; Var Vendor: Record Vendor)
    begin
        Clear(Vendor);
        Vendor.Init();
        Vendor.Validate(Name, CustVendStaging.Name);
        Vendor.Validate("Phone No.", CustVendStaging."Phone No.");
        Vendor.Validate("Vendor Posting Group", CustVendStaging."Posting Group");
    end;

    local procedure UpdateStatus(CustVendStaging: Record "CustVend Staging"; LastError: Text; MasterNo: Code[20])
    begin
        TempCustVendStaging.Init();
        TempCustVendStaging.TransferFields(CustVendStaging);
        If LastError <> '' then begin
            TempCustVendStaging.Status := TempCustVendStaging.Status::Error;
            TempCustVendStaging."Message / Error" := CopyStr(LastError, 1, MaxStrLen(TempCustVendStaging."Message / Error"));
        end else begin
            TempCustVendStaging.Status := TempCustVendStaging.Status::Processed;
            TempCustVendStaging."Message / Error" := MasterNo;
        end;
        TempCustVendStaging.Insert();
    end;

    local procedure UpdateStagingStatus()
    var
        CustVendStaging: Record "CustVend Staging";
    begin
        If not TempCustVendStaging.FindSet() then
            exit;
        repeat
            CustVendStaging.Get(TempCustVendStaging.EntryNo);
            CustVendStaging.Status := TempCustVendStaging.Status;
            CustVendStaging."Message / Error" := TempCustVendStaging."Message / Error";
            CustVendStaging.Modify(true);
        until (TempCustVendStaging.Next() = 0);
    end;

    var
        TempCustVendStaging: Record "CustVend Staging" temporary;
}