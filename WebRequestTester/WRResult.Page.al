namespace Harmonia.WebRequestTester;

/// <summary>
/// Zeigt das Ergebnis eines ausgeführten WebRequests.
/// </summary>
page 71203 "WR Result"
{
    Caption = 'Web Request Result';
    PageType = Card;
    SourceTable = "WR Result";
    UsageCategory = Tasks;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                }
                field("Response Status"; Rec."Response Status")
                {
                    ApplicationArea = All;
                }
                field("Response Time (ms)"; Rec."Response Time (ms)")
                {
                    ApplicationArea = All;
                }
                field("Executed At"; Rec."Executed At")
                {
                    ApplicationArea = All;
                }
                field("Executed By"; Rec."Executed By")
                {
                    ApplicationArea = All;
                }
            }
            group(ResponseBody)
            {
                Caption = 'Response Body';
                field(ResponseBodyText; ResponseBodyText)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadResponse();
    end;

    var
        ResponseBodyText: Text;

    local procedure LoadResponse()
    var
        InStr: InStream;
        ReadText: Text;
    begin
        if Rec."Response Body".HasValue() then begin
            Rec."Response Body".CreateInStream(InStr, TextEncoding::UTF8);
            InStr.ReadText(ResponseBodyText);
        end else
            ResponseBodyText := '(No response body)';
    end;
}
