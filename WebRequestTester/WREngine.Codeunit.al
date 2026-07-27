namespace Harmonia.WebRequestTester;

using System.Net.Http;

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
        HttpContent: HttpContent;

    /// <summary>
    /// Führt den übergebenen WebRequest aus und speichert das Ergebnis.
    /// </summary>
    procedure ExecuteRequest(var WRRequest: Record "WR Request")
    var
        BodyBlob: Codeunit "Temp Blob";
        BodyText: Text;
        ResponseBodyBlob: Codeunit "Temp Blob";
        ResponseBodyText: Text;
        WRRequestParam: Record "WR Request Param";
        WRResult: Record "WR Result";
        WRResponseHeader: Record "WR Response Header";
        StartTime: DateTime;
        EndTime: Integer;
        Url: Text;
        i: Integer;
        LineNo: Integer;
        Headers: List of [Text];
        KeyValue: List of [Text];
    begin
        // ── URL mit Query-Parametern aufbauen ──
        Url := WRRequest."Endpoint URL";
        WRRequestParam.SetRange("Request No.", WRRequest."No.");
        WRRequestParam.SetRange("Param Type", WRRequestParam."Param Type"::"Query Parameter");
        WRRequestParam.SetRange(Enabled, true);
        i := 0;
        if WRRequestParam.FindSet() then begin
            if Url.Contains('?') then
                Url := Url + '&'
            else
                Url := Url + '?';
            repeat
                if i > 0 then
                    Url := Url + '&';
                Url := Url + WebUtility.UrlEncode(WRRequestParam.Name) + '=' + WebUtility.UrlEncode(WRRequestParam.Value);
                i := i + 1;
            until WRRequestParam.Next() = 0;
        end;

        // ── HttpRequestMessage vorbereiten ──
        HttpRequestMessage.SetMethod(StringToHttpMethod(WRRequest.Method));
        HttpRequestMessage.SetRequestUri(Url);

        // ── Benutzerdefinierte Header ──
        WRRequestParam.Reset();
        WRRequestParam.SetRange("Request No.", WRRequest."No.");
        WRRequestParam.SetRange("Param Type", WRRequestParam."Param Type"::Header);
        WRRequestParam.SetRange(Enabled, true);
        if WRRequestParam.FindSet() then
            repeat
                HttpRequestMessage.AddHeader(WRRequestParam.Name, WRRequestParam.Value);
            until WRRequestParam.Next() = 0;

        // ── Body setzen (nur bei Methoden, die Body erlauben) ──
        if WRRequest."Body Content".HasValue() then begin
            BodyBlob := WRRequest."Body Content".CreateTempBlob();
            BodyText := BodyBlob.ReadText(TextEncoding.UTF8);

            HttpContent.Init();
            HttpContent.Write(BodyText);

            if WRRequest."Header Content-Type" <> '' then
                HttpContent.SetContentType(WRRequest."Header Content-Type")
            else
                HttpContent.SetContentType('application/json');

            HttpRequestMessage.SetContent(HttpContent);
        end;

        // ── Timeout ──
        HttpClient.SetTimeout(WRRequest."Timeout (ms)");

        // ── Ausführen ──
        StartTime := CurrentDateTime();
        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
        EndTime := CurrentDateTime() - StartTime;
        if EndTime < 0 then
            EndTime := 0;

        // ── Response Body auslesen ──
        if HttpResponseMessage.IsBlockedByEnvironment() then begin
            ResponseBodyText := 'Request blocked by environment. Check that the endpoint is allowed in Admin Center.';
        end else begin
            if HttpResponseMessage.GetContent(HttpContent) then begin
                ResponseBodyText := HttpContent.Read();
            end else
                ResponseBodyText := '';
        end;

        ResponseBodyBlob.FromText(ResponseBodyText, TextEncoding.UTF8);

        // ── Ergebnis speichern ──
        WRResult.SetRange("Request No.", WRRequest."No.");
        WRResult.DeleteAll();

        WRResult.Init();
        WRResult."Request No." := WRRequest."No.";
        WRResult."Response Status" := Format(HttpResponseMessage.GetStatusCode()) + ' ' + HttpResponseMessage.GetReasonPhrase();
        WRResult."Response Time (ms)" := EndTime;
        WRResult."Executed At" := CurrentDateTime();
        WRResult."Executed By" := UserId();
        WRResult."Response Body".SetValue(ResponseBodyBlob);
        WRResult.Insert();

        // ── Status in Request zurückschreiben ──
        WRRequest."Last Response Status" := WRResult."Response Status";
        WRRequest."Last Response Time (ms)" := EndTime;
        WRRequest.Modify();

        // ── Response-Header speichern ──
        WRResponseHeader.SetRange("Request No.", WRRequest."No.");
        WRResponseHeader.DeleteAll();

        LineNo := 0;
        Headers := HttpResponseMessage.GetHeaders();
        if Headers.Count > 0 then begin
            for i := 0 to Headers.Count - 1 do begin
                LineNo := LineNo + 10000;
                KeyValue := Headers.Get(i).Split(':');
                if KeyValue.Count >= 2 then begin
                    WRResponseHeader.Init();
                    WRResponseHeader."Request No." := WRRequest."No.";
                    WRResponseHeader."Line No." := LineNo;
                    WRResponseHeader.Name := KeyValue.Get(0);
                    WRResponseHeader.Value := KeyValue.Get(1);
                    WRResponseHeader.Insert();
                end;
            end;
        end;
    end;

    local procedure StringToHttpMethod(Method: Enum "WR Method"): Text
    begin
        case Method of
            Method::GET: exit('GET');
            Method::POST: exit('POST');
            Method::PUT: exit('PUT');
            Method::PATCH: exit('PATCH');
            Method::DELETE: exit('DELETE');
            Method::HEAD: exit('HEAD');
            Method::OPTIONS: exit('OPTIONS');
        end;
    end;
}
