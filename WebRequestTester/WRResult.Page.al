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
                    ToolTip = 'HTTP status code e.g. 200 OK, 404 Not Found.';
                }
                field("Response Time (ms)"; Rec."Response Time (ms)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Response time in milliseconds.';
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
            group(ResponseHeaders)
            {
                Caption = 'Response Headers';
                part(ResponseHeadersPart; "WR Response Header List")
                {
                    ApplicationArea = All;
                    SubPageLink = "Request No." = field("Request No.");
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
        BodyBlob: Codeunit "Temp Blob";
    begin
        if Rec."Response Body".HasValue() then begin
            BodyBlob := Rec."Response Body".CreateTempBlob();
            ResponseBodyText := BodyBlob.ReadText(TextEncoding.UTF8);
        end else
            ResponseBodyText := '(No response body)';
    end;
}
