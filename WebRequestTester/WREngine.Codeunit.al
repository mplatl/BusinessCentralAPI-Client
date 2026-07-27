namespace Harmonia.WebRequestTester;

/// <summary>
/// Führt WebRequests aus und speichert das Ergebnis (Response Body + Header).
/// </summary>
codeunit 71200 "WR Engine"
{
    Access = Public;

    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;

    /// <summary>
    /// Führt den übergebenen WebRequest aus und speichert das Ergebnis.
    /// </summary>
    procedure ExecuteRequest(var WRRequest: Record "WR Request")
    var
        BodyText: Text;
        ResponseBodyText: Text;
        WRRequestParam: Record "WR Request Param";
        WRResult: Record "WR Result";
        WRResponseHeader: Record "WR Response Header";
        StartTime: DateTime;
        EndTime: Integer;
        Url: Text;
        BodyInStream: InStream;
        ResponseOutStream: OutStream;
        StatusCodeInteger: Integer;
    begin
        // ── URL zusammenbauen ──
        Url := WRRequest."Endpoint URL";

        // ── HttpRequestMessage vorbereiten ──
        HttpRequestMessage.SetRequestUri(Url);

        case WRRequest.Method of
            WRRequest.Method::GET: HttpRequestMessage.Method('GET');
            WRRequest.Method::POST: HttpRequestMessage.Method('POST');
            WRRequest.Method::PUT: HttpRequestMessage.Method('PUT');
            WRRequest.Method::PATCH: HttpRequestMessage.Method('PATCH');
            WRRequest.Method::DELETE: HttpRequestMessage.Method('DELETE');
            WRRequest.Method::HEAD: HttpRequestMessage.Method('HEAD');
            WRRequest.Method::OPTIONS: HttpRequestMessage.Method('OPTIONS');
        end;

        // ── Body setzen ──
        if WRRequest."Body Content".HasValue() then begin
            WRRequest."Body Content".CreateInStream(BodyInStream, TextEncoding::UTF8);
            BodyInStream.ReadText(BodyText);

            HttpRequestMessage.Content().Clear();
            RequestContent.WriteFrom(BodyText);
            HttpRequestMessage.Content := RequestContent;
        end;

        // ── Timeout setzen und senden ──
        HttpClient.Clear();
        HttpClient.Timeout(WRRequest."Timeout (ms)");

        StartTime := CurrentDateTime();
        if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then begin
            if HttpResponseMessage.IsBlockedByEnvironment() then
                ResponseBodyText := 'Blocked by environment. Check Admin Center.'
            else
                ResponseBodyText := 'Connection failed: ' + HttpRequestMessage.GetRequestUri();
            EndTime := CurrentDateTime() - StartTime;
            if EndTime < 0 then EndTime := 0;
            SaveResult(WRRequest, WRResult, ResponseBodyText, 0, EndTime);
            exit;
        end;

        EndTime := CurrentDateTime() - StartTime;
        if EndTime < 0 then EndTime := 0;

        // ── Status-Code und Body ──
        StatusCodeInteger := HttpResponseMessage.HttpStatusCode();
        ResponseBodyText := ReadResponseBody();

        // ── Ergebnis speichern ──
        SaveResult(WRRequest, WRResult, ResponseBodyText, StatusCodeInteger, EndTime);
    end;

    local procedure ReadResponseBody(): Text
    var
        ResponseText: Text;
    begin
        HttpResponseMessage.Content().ReadAs(ResponseText);
        exit(ResponseText);
    end;

    local procedure SaveResult(var WRRequest: Record "WR Request"; var WRResult: Record "WR Result"; ResponseBody: Text; StatusCode: Integer; ResponseTime: Integer)
    var
        ResponseOutStream: OutStream;
    begin
        WRResult.SetRange("Request No.", WRRequest."No.");
        WRResult.DeleteAll();

        WRResult.Init();
        WRResult."Request No." := WRRequest."No.";
        WRResult."Response Status" := Format(StatusCode);
        WRResult."Response Time (ms)" := ResponseTime;
        WRResult."Executed At" := CurrentDateTime();
        WRResult."Executed By" := UserId();

        WRResult."Response Body".CreateOutStream(ResponseOutStream, TextEncoding::UTF8);
        ResponseOutStream.WriteText(ResponseBody);
        WRResult.Insert();

        WRRequest."Last Response Status" := WRResult."Response Status";
        WRRequest."Last Response Time (ms)" := ResponseTime;
        WRRequest.Modify();
    end;
}
