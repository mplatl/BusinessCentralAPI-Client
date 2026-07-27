namespace Harmonia.WebRequestTester;

/// <summary>
/// HTTP-Methoden für WebRequests.
/// </summary>
enum 71200 "WR Method"
{
    Extensible = false;

    value(0; GET) { Caption = 'GET'; }
    value(1; POST) { Caption = 'POST'; }
    value(2; PUT) { Caption = 'PUT'; }
    value(3; PATCH) { Caption = 'PATCH'; }
    value(4; DELETE) { Caption = 'DELETE'; }
    value(5; HEAD) { Caption = 'HEAD'; }
    value(6; OPTIONS) { Caption = 'OPTIONS'; }
}
