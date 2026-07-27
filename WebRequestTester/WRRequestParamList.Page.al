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
                ShowCaption = true;
                field("Param Type"; Rec."Param Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select Header or Query Parameter.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the parameter name.';
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the parameter value.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable or disable this parameter.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Optional description.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(NewParam)
            {
                ApplicationArea = All;
                Caption = 'New';
                Image = New;

                trigger OnAction()
                var
                    WRRequestParam: Record "WR Request Param";
                    NextLine: Integer;
                begin
                    WRRequestParam.SetRange("Request No.", Rec."Request No.");
                    WRRequestParam.CalcSums("Line No.");
                    NextLine := WRRequestParam."Line No." + 10000;

                    Rec.Init();
                    Rec."Request No." := Rec."Request No.";
                    Rec."Line No." := NextLine;
                    Rec."Param Type" := Rec."Param Type"::Header;
                    Rec.Enabled := true;
                    Rec.Insert(true);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
