table 70000 "CustVend Staging"
{
    DataClassification = CustomerContent;
    Caption = 'Customer/Vendor Staging';
    fields
    {
        field(1; EntryNo; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; Type; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = New,Error,Processed;
            OptionCaption = 'New,Error,Processed';
        }
        field(7; "Message / Error"; Text[2048])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        EntryNo := GetNextEntryNo();
    end;

    local procedure GetNextEntryNo(): Integer
    var
        CustVendStaging: Record "CustVend Staging";
    begin
        If CustVendStaging.FindLast() then
            exit(CustVendStaging.EntryNo + 1);
        exit(1);
    end;

}