namespace Harmonia.WebRequestTester;

/// <summary>
/// ListPart für die Response-Header eines ausgeführten Requests.
/// </summary>
page 71204 "WR Response Header List"
{
    Caption = 'Response Headers';
    PageType = ListPart;
    SourceTable = "WR Response Header";
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group1)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
