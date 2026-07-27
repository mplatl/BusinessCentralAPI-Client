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
                    ToolTip = 'Specifies the number of the web request.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter a description for this request.';
                }
                field("Endpoint URL"; Rec."Endpoint URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the full endpoint URL (e.g. https://api.example.com/endpoint).';
                }
                field(Method; Rec.Method)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the HTTP method.';
                }
                field("Header Content-Type"; Rec."Header Content-Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Content-Type header value, e.g. application/json.';
                }
                field("Timeout (ms)"; Rec."Timeout (ms)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Timeout in milliseconds. Default 30000.';
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
                    ToolTip = 'Block this request from being executed.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Body)
            {
                Caption = 'Body';
                Visible = IsBodyVisible();

                field("Body Type"; Rec."Body Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the body content type.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Body Content"; Rec."Body Content")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Enter the request body content.';
                }
            }
            group("Parameters")
            {
                Caption = 'Parameters';
                part("WR Request Params"; "WR Request Param List")
                {
                    ApplicationArea = All;
                    Page = "WR Request Param List";
                    SubPageLink = "Request No." = field("No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Actions)
            {
                Caption = 'Actions';
                action(SendRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Send Request';
                    Image = Play;
                    Promoted = true;
                    PromotedCategory = CategoryProcess;
                    PromotedIsBig = true;
                    ToolTip = 'Execute the web request and show the result.';

                    trigger OnAction()
                    var
                        WREngine: Codeunit "WR Engine";
                        WRResult: Record "WR Result";
                    begin
                        if Rec.Blocked then
                            Error('This request is blocked and cannot be executed.');

                        CurrPage.SaveRecord();
                        WREngine.ExecuteRequest(Rec);

                        // Ergebnis öffnen
                        WRResult.SetRange("Request No.", Rec."No.");
                        if WRResult.FindFirst() then
                            PAGE.RunModal(PAGE::"WR Result", WRResult);
                    end;
                }
                action(ViewResult)
                {
                    ApplicationArea = All;
                    Caption = 'View Last Result';
                    Image = View;
                    ToolTip = 'View the last result of this request.';

                    trigger OnAction()
                    var
                        WRResult: Record "WR Result";
                    begin
                        if Rec."Last Response Status" = '' then
                            Error('No result available. Execute the request first.');
                        WRResult.SetRange("Request No.", Rec."No.");
                        if WRResult.FindFirst() then
                            PAGE.RunModal(PAGE::"WR Result", WRResult);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Update(false);
    end;

    local procedure IsBodyVisible(): Boolean
    begin
        case Rec.Method of
            Rec.Method::GET,
            Rec.Method::HEAD,
            Rec.Method::OPTIONS:
                exit(false);
        end;
        exit(true);
    end;
}
