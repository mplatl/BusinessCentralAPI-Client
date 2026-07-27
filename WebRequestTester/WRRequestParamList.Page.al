namespace Harmonia.WebRequestTester;

/// <summary>
/// ListPart für die Parameter (Header und Query-Parameter) eines WebRequests.
/// </summary>
page 71202 "WR Request Param List"
{
    Caption = 'Parameters';
    PageType = ListPart;
    SourceTable = "WR Request Param";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group1)
            {
                field("Param Type"; Rec."Param Type")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
