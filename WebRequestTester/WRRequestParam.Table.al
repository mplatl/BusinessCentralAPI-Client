namespace Harmonia.WebRequestTester;

/// <summary>
/// Parameter (Name-Value-Pairs) für einen WebRequest.
/// Dient als Header, Query-Parameter oder Form-Feld.
/// </summary>
table 71201 "WR Request Param"
{
    Caption = 'Web Request Parameter';
    DataClassification = CustomerContent;
    Permissions = tabledata "WR Request Param" = RIMD;

    fields
    {
        field(1; "Request No."; Integer)
        {
            Caption = 'Request No.';
            DataClassification = SystemMetadata;
            TableRelation = "WR Request";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Param Type"; Enum "WR Param Type")
        {
            Caption = 'Param Type';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(4; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(5; Value; Text[500])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(7; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = SystemMetadata;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Request No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, Value)
        {
        }
    }
}
