program SmartSyn;

uses
  Forms,
  SSMainFrm in 'SSMainFrm.pas' {SSMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSSMainForm, SSMainForm);
  Application.Run;
end.
