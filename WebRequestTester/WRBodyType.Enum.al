namespace Harmonia.WebRequestTester;

enum 71201 "WR Body Type"
{
    Extensible = false;

    value(0; None) { Caption = 'None'; }
    value(1; JSON) { Caption = 'JSON'; }
    value(2; XML) { Caption = 'XML'; }
    value(3; "Form-Urlencoded") { Caption = 'Form-Urlencoded'; }
    value(4; "Text/Plain") { Caption = 'Text/Plain'; }
    value(5; "Binary/File") { Caption = 'Binary/File'; }
}
