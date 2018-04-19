program Clima;

uses
  System.StartUpCopy,
  FMX.Forms,
  apk10 in 'apk10.pas' {Principal};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TPrincipal, Principal);
  Application.Run;
end.
