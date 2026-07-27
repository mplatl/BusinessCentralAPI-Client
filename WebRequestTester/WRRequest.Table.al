namespace Harmonia.WebRequestTester;

/// <summary>
/// Speichert eine einzelne WebRequest-Konfiguration (Url, Methode, Body).
/// Zu jeder Request können beliebig viele Parameter (Header/Query) angelegt werden.
/// </summary>
table 71200 "WR Request"
{
    Caption = 'Web Request';
    DataClassification = CustomerContent;
    Permissions = tabledata "WR Request" = RIMD;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Endpoint URL"; Text[500])
        {
            Caption = 'Endpoint URL';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(4; "Method"; Enum "WR Method")
        {
            Caption = 'Method';
            DataClassification = SystemMetadata;
            NotBlank = true;
        }
        field(5; "Body Type"; Enum "WR Body Type")
        {
            Caption = 'Body Type';
            DataClassification = SystemMetadata;
        }
        field(6; "Body Content"; Blob)
        {
            Caption = 'Body Content';
            DataClassification = CustomerContent;
        }
        field(7; "Header Content-Type"; Text[100])
        {
            Caption = 'Content-Type';
            DataClassification = CustomerContent;
        }
        field(8; "Timeout (ms)"; Integer)
        {
            Caption = 'Timeout (ms)';
            DataClassification = SystemMetadata;
            InitValue = 30000;
            MinValue = 1000;
            MaxValue = 120000;
        }
        field(9; "Last Response Status"; Text[50])
        {
            Caption = 'Last Response Status';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(10; "Last Response Time (ms)"; Integer)
        {
            Caption = 'Last Response (ms)';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(11; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(12; "User"; Code[50])
        {
            Caption = 'User';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Description", "Endpoint URL")
        {
        }
    }
}
