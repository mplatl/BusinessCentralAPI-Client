namespace Harmonia.WebRequestTester;

/// <summary>
/// Speichert die Response-Header eines ausgeführten WebRequests.
/// </summary>
table 71204 "WR Response Header"
{
    Caption = 'Web Request Response Header';
    DataClassification = CustomerContent;
    Permissions = tabledata "WR Response Header" = RIMD;

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
        field(3; Name; Text[200])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(4; Value; Text[500])
        {
            Caption = 'Value';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Request No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
