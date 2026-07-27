namespace Harmonia.WebRequestTester;

permissionset 71210 "WR Tester - User"
{
    Assignable = true;
    Caption = 'Web Request Tester - User';

    Permissions =
                  tabledata "WR Request" = RIMD,
                  tabledata "WR Request Param" = RIMD,
                  tabledata "WR Result" = RIMD,
                  tabledata "WR Response Header" = RIMD,
                  page "WR Request List" = X,
                  page "WR Request Card" = X,
                  page "WR Request Param List" = X,
                  page "WR Result" = X,
                  page "WR Response Header List" = X,
                  codeunit "WR Engine" = X,
                  codeunit "WR Config" = X;
}
