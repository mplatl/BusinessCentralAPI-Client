namespace Harmonia.WebRequestTester;

/// <summary>
/// Hilfscodeunit für Nummernkreis und Konfiguration.
/// </summary>
codeunit 71201 "WR Config"
{
    Access = Public;

    var
        LastNo: Integer;

    procedure GetNextNo() Result: Integer
    begin
        LastNo += 1;
        exit(LastNo);
    end;
}
