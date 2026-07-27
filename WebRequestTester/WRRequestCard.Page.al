namespace Harmonia.WebRequestTester;

/// <summary>
/// Karte zum Bearbeiten und Ausführen eines WebRequests.
/// </summary>
page 71201 "WR Request Card"
{
    Caption = 'Web Request Card';
    PageType = Card;
    SourceTable = "WR Request";
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Endpoint URL"; Rec."Endpoint URL")
                {
                    ApplicationArea = All;
                }
                field(Method; Rec.Method)
                {
                    ApplicationArea = All;
                }
                field("Header Content-Type"; Rec."Header Content-Type")
                {
                    ApplicationArea = All;
                }
                field("Timeout (ms)"; Rec."Timeout (ms)")
                {
                    ApplicationArea = All;
                }
                field("Last Response Status"; Rec."Last Response Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Last Response Time (ms)"; Rec."Last Response Time (ms)")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group("Body")
            {
                Caption = 'Body';
                field("Body Type"; Rec."Body Type")
                {
                    ApplicationArea = All;
                }
                field("Body Content"; Rec."Body Content")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
            group("Parameters")
            {
                Caption = 'Parameters';
                part("WRParamList"; "WR Request Param List")
                {
                    ApplicationArea = All;
                    SubPageLink = "Request No." = field("No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                action(SendRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Send Request';
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        WREngine: Codeunit "WR Engine";
                        WRResult: Record "WR Result";
                    begin
                        CurrPage.SaveRecord();
                        Commit();
                        WREngine.ExecuteRequest(Rec);
                        Commit();
                        WRResult.SetRange("Request No.", Rec."No.");
                        if WRResult.FindFirst() then
                            PAGE.RunModal(71203, WRResult);
                    end;
                }
                action(ViewResult)
                {
                    ApplicationArea = All;
                    Caption = 'View Last Result';
                    Image = View;

                    trigger OnAction()
                    var
                        WRResult: Record "WR Result";
                    begin
                        if Rec."Last Response Status" = '' then
                            Error('No result available. Execute the request first.');
                        WRResult.SetRange("Request No.", Rec."No.");
                        if WRResult.FindFirst() then
                            PAGE.RunModal(71203, WRResult);
                    end;
                }
            }
        }
    }

    var
        IsBodyVisible: Boolean;
}
