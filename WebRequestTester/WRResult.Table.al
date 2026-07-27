namespace Harmonia.WebRequestTester;

/// <summary>
/// Speichert das Ergebnis eines ausgeführten WebRequests (Body, Status, Time).
/// Es kann genau ein Ergebnis pro Request geben (wird überschrieben bei erneuter Ausführung).
/// </summary>
table 71203 "WR Result"
{
    Caption = 'Web Request Result';
    DataClassification = CustomerContent;
    Permissions = tabledata "WR Result" = RIMD;

    fields
    {
        field(1; "Request No."; Integer)
        {
            Caption = 'Request No.';
            DataClassification = SystemMetadata;
            TableRelation = "WR Request";
        }
        field(2; "Response Status"; Text[100])
        {
            Caption = 'Response Status';
            DataClassification = CustomerContent;
        }
        field(3; "Response Time (ms)"; Integer)
        {
            Caption = 'Response Time (ms)';
            DataClassification = SystemMetadata;
        }
        field(4; "Response Body"; Blob)
        {
            Caption = 'Response Body';
            DataClassification = CustomerContent;
        }
        field(5; "Executed At"; DateTime)
        {
            Caption = 'Executed At';
            DataClassification = SystemMetadata;
        }
        field(6; "Executed By"; Code[50])
        {
            Caption = 'Executed By';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Request No.")
        {
            Clustered = true;
        }
    }
}
