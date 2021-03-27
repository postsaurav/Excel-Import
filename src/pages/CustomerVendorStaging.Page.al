page 70000 "Customer Vendor Staging"
{

    ApplicationArea = All;
    Caption = 'Customer Vendor Staging';
    PageType = List;
    SourceTable = "CustVend Staging";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Entry No.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Status';
                }
                field("Message / Error"; Rec."Message / Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Message / Error';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer / Vendor';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer / Vendor Name';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Phone No.';
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer / Vendor Posting Group';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportExcel)
            {
                ApplicationArea = All;
                ToolTip = 'Import an Excel File.';
                Caption = 'Excel Import';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ImportExcel;
                RunObject = codeunit "Import To Staging";
            }

            action(ProcessStaging)
            {
                ApplicationArea = All;
                ToolTip = 'Create Customer / Vendor Records.';
                Caption = 'Process Records';
                Image = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ProcessRecords: Codeunit "Process Staging";
                begin
                    ProcessRecords.ProcessStagingRecords();
                    Message('Records Processed.');
                end;
            }
            action(OpenRecord)
            {
                ApplicationArea = All;
                ToolTip = 'Open Customer / Vendor Record.';
                Image = Open;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    Customer: Record Customer;
                    Vendor: Record Vendor;
                    CustomerCard: Page "Customer Card";
                    VendorCard: Page "Vendor Card";
                begin
                    If rec.Status = Rec.Status::Error then
                        Exit;

                    If Rec.Type = 1 then begin
                        Customer.SetRange("No.", Rec."Message / Error");
                        IF Customer.FindFirst() then begin
                            CustomerCard.SetTableView(Customer);
                            CustomerCard.RunModal();
                        end;
                    end;
                    If Rec.Type = 2 then begin
                        Vendor.SetRange("No.", Rec."Message / Error");
                        IF Vendor.FindFirst() then begin
                            VendorCard.SetTableView(Vendor);
                            VendorCard.RunModal();
                        end;
                    end;
                end;
            }

        }
    }
}
