namespace Harmonia.WebRequestTester;

/// <summary>
/// Liste aller gespeicherten WebRequests.
/// </summary>
page 71200 "WR Request List"
{
    Caption = 'Web Requests';
    PageType = List;
    SourceTable = "WR Request";
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the web request.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the web request.';
                }
                field(Method; Rec.Method)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HTTP method.';
                }
                field("Endpoint URL"; Rec."Endpoint URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the endpoint URL.';
                }
                field("Last Response Status"; Rec."Last Response Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the last response status.';
                }
                field("Last Response Time (ms)"; Rec."Last Response Time (ms)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the last response time in milliseconds.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(NewAction)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Init();
                    Rec."No." := GetNextNo();
                    Rec.Method := Rec.Method::GET;
                    Rec.Insert(true);
                    PAGE.RunModal(71201, Rec);
                end;
            }
        }
    }

    var
        WRConfig: Codeunit "WR Config";

    local procedure GetNextNo() Result: Integer
    begin
        Result := WRConfig.GetNextNo();
    end;
}
