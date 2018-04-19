unit apk10;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSButton, FMX.TMSCustomButton,
  FMX.TMSSpeedButton, FMX.Styles.Objects, FMX.Layouts, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.ListBox, System.Math.Vectors,
  FMX.Controls3D, FMX.Layers3D, FMX.ExtCtrls, LiteCall, LiteConsts, Data.DB,
  System.Generics.Collections, MemDS, DBAccess, LiteAccess, FMX.Menus, FMX.Edit,
  FMX.SearchBox, FMX.Gestures, FMX.Toast, FMX.MultiView, System.Actions,
  FMX.ActnList, FMX.TMSToolBar, FMX.Memo, FMX.WebBrowser, System.Notification,
  System.Sensors, System.Sensors.Components, Web.HTTPApp, FMX.Maps;

type
  TPrincipal = class(TForm)
    Label1: TLabel;
    ImageViewer1: TImageViewer;
    dbcon: TLiteConnection;
    dbquery: TLiteQuery;
    StyleBook1: TStyleBook;
    FMXToast1: TFMXToast;
    exportar: TButton;
    Panel4: TPanel;
    WebDispatcher1: TWebDispatcher;
    NotificationCenter1: TNotificationCenter;
    LocationSensor1: TLocationSensor;
    Label3: TLabel;
    btinfo: TButton;
    Panel1: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    ListBoxProject1: TListBox;
    Bogotá: TListBoxItem;
    Medellín: TListBoxItem;
    Bucaramanga: TListBoxItem;
    Cartagena: TListBoxItem;
    SearchBox1: TSearchBox;
    Label2: TLabel;
    ListBoxProject: TListBox;
    Switch1: TSwitch;
    MapView1: TMapView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ConsultarProyectos;
    procedure btinfoClick(Sender: TObject);

    procedure ListBoxProject1Click(Sender: TObject);
    procedure ImageViewer1Click(Sender: TObject);
    procedure BogotáClick(Sender: TObject);
    procedure exportarClick(Sender: TObject);
    procedure MedellínClick(Sender: TObject);

    procedure BucaramangaClick(Sender: TObject);
    procedure CartagenaClick(Sender: TObject);
    procedure ListBoxProject1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);

    procedure Button1Click(Sender: TObject);
    procedure dbconBeforeConnect(Sender: TObject);
    procedure Switch1Switch(Sender: TObject);

    procedure leer_y_separar(x: string);

  private

  public
    { Public declarations }
    DicId: TDictionary<Integer, Integer>;

  var
    Data: String;
    Lecturas: TArray<String>;
      f: Integer;
  end;

const
  MAX = 100;

type
  vectordata = array [1 .. MAX] of String;

var
  // Principal: TPrincipal;
  Principal: TPrincipal;
  miVector: vectordata;

implementation

{$R *.fmx}

uses FMX.MultiView.Presentations, FMX.DialogService.Async, IdHTTP;

procedure TPrincipal.leer_y_separar(x: string);
var

  mapCenter: TMapCoordinate;
  Notification: TNotification;
begin

  Lecturas := x.Split(['"']);

  Delete(Lecturas[4], 1, 1);
  Delete(Lecturas[4], Lecturas[4].Length, 1);
  // ShowMessage();
  Delete(Lecturas[6], 1, 1);
  Delete(Lecturas[6], Lecturas[6].Length - 1, 1);
  Delete(Lecturas[6], Lecturas[6].Length, 1);
  // ShowMessage();
  Delete(Lecturas[30], 1, 1);
  Delete(Lecturas[30], Lecturas[30].Length, 1);
  Delete(Lecturas[30], Lecturas[30].Length, 1);
  Delete(Lecturas[30], Lecturas[30].Length, 1);
  Delete(Lecturas[30], Lecturas[30].Length, 1);
  f := Round(Lecturas[30].ToDouble()) - 273;
  // Grados:= StrToFloat(Lecturas[30])-273.15;
  ShowMessage('Latitud: ' + Lecturas[6] + ' - Longitud: ' + Lecturas[4] +
    sLineBreak + 'Temperatura: ' + f.ToString { Grados.ToString } + '°C');




  mapCenter := TMapCoordinate.Create(4.61, -74.08);
  MapView1.Location := mapCenter;
  MapView1.Zoom := 10;
  Label3.Text := 'Desconectado a la DB';





end;

procedure TPrincipal.ConsultarProyectos;

var
  i: Integer;
begin
  dbquery.Close;
  dbquery.SQL.Text := 'select id,ciudad,dttm from project';
  dbquery.Open;
  ListBoxProject.Clear; // Limpiar el ListBox
  DicId.Clear;

  for i := 0 to dbquery.RecordCount - 1 do
  begin
    ListBoxProject.Items.Add(dbquery.FieldByName('ciudad').AsString);
    // ListBoxProject.Items.Add(dbquery.FieldByName('dttm').AsString);
    DicId.Add(i, dbquery.FieldByName('id').AsInteger);

    dbquery.Next;
  end;

  if ListBoxProject.Items.Count > 0 then

end;

procedure TPrincipal.exportarClick(Sender: TObject);
begin
  Principal.Close;
end;

procedure TPrincipal.dbconBeforeConnect(Sender: TObject);
begin
  // Para correr en Android

  dbcon.Database :=
  {$IF Defined(ANDROID)}GetHomePath + PathDelim{$IFNDEF ANDROID} +
    'Documents'{$ENDIF} + PathDelim + {$ENDIF}'dbandroid.db';
end;

{ procedure TPrincipal.dbconBeforeConnect(Sender: TObject);
  begin
  Para correr en Android

  dbcon.Database :={$IF Defined(ANDROID) }{ GetHomePath + PathDelim{$IFNDEF ANDROID } { + {'Documents'{$ENDIF }{ + PathDelim + {$ENDIF }{ 'dbandroid.db';
  end;

  { procedure TPrincipal.EliminarProyectos;
  var
  j: Integer;

  begin
  j := DicId.Items[(ListBoxProject.Selected.Index)];
  // dbquery.Close;
  // ShowMessage('select,' + DicId.Items[(ListBoxProject.Selected.Index)-2].ToString +',tittle from project');
  // delete from project where id=1;
  // j := ListBoxProject.Selected.Index - 2;
  // ShowMessage( j.ToString );
  // cte := DicId.Items[j];
  // ShowMessage(cte.ToString);

  // ShowMessage('select,' + j.ToString +',tittle from project');

  MessageDlg('Desea eliminar el proyecto, y todos los datos',
  System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes,
  System.UITypes.TMsgDlgBtn.mbNo], 0,
  procedure(const AResult: TModalResult)
  begin
  case AResult of
  { Detect which button was pushed and show a different message }
{ mrYes:
  begin
  // pressed yes

  dbquery.Close;
  dbquery.SQL.Text := 'delete from project where id=' + j.ToString;
  dbquery.Execute;
  FMXToast1.ToastMessage := 'Proyecto Eliminado';
  FMXToast1.Show(ListBoxProject);
  ConsultarProyectos;
  end;
  mrNo:
  begin
  // pressed no
  end;
  end;
  end);




  // ConsultarProyectos;

  end;
  procedure TPrincipal.exportarClick(Sender: TObject);
  begin
  Principal.Close;
  end; }

procedure TPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dbcon.Close
end;

const
  HTTP_RESPONSE_OK = 200;

function GetPage(aURL: string): string;
var
  Response: TStringStream;
  HTTP: TIdHTTP;
begin
  Result := '';
  Response := TStringStream.Create('');
  try
    HTTP := TIdHTTP.Create(nil);
    try
      HTTP.Get(aURL, Response);
      if HTTP.ResponseCode = HTTP_RESPONSE_OK then
      begin
        Result := Response.DataString;
      end
      else
      begin
        // TODO -cLogging: add some logging
      end;
    finally
      HTTP.Free;
    end;
  finally
    Response.Free;
  end;
end;

procedure TPrincipal.Button1Click(Sender: TObject);
var
  Text: String;
begin

end;

procedure TPrincipal.FormCreate(Sender: TObject);

var
  i: Integer;
  Notification: TNotification;
  mapCenter: TMapCoordinate;

begin

  mapCenter := TMapCoordinate.Create(4.61, -74.08);
  MapView1.Location := mapCenter;
  MapView1.Zoom := 10;
  Label3.Text := 'Desconectado a la DB';

  DicId := TDictionary<Integer, Integer>.Create;

  Notification := NotificationCenter1.CreateNotification;
  try
    Notification.Name := 'MyNotification';
    Notification.AlertBody := 'Bienvenido a Su Clima a Un Clic!';
    Notification.FireDate := Now;

    { Send notification in Notification Center }
    NotificationCenter1.PresentNotification(Notification);
    { also this method is equivalent if platform supports scheduling }
    // NotificationC.ScheduleNotification(Notification);
  finally
    Notification.DisposeOf;
  end;

  try
    dbcon.Connect;
    ConsultarProyectos;
    Label3.Text := 'Conectado a la DB';
  except
    ShowMessage('Error, Intente Nuevamente');
  end;

end;

procedure TPrincipal.ImageViewer1Click(Sender: TObject);
begin
  ShowMessage('APK Desarrollada Por Juan Guarnizo');
end;

procedure TPrincipal.ListBoxProject1Click(Sender: TObject);
begin
  // btcont.Visible := False;
  // btdel.Visible := False;
  // btedt.Visible := False;
  //
  // ListBoxProject.ItemIndex := -1;
  // ListBoxProject.ClearSelection;

end;

procedure TPrincipal.ListBoxProject1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);

begin
  // data:= WebBrowser1;
  // ShowMessage(Data);
end;


procedure TPrincipal.MedellínClick(Sender: TObject);
var
  mapCenter: TMapCoordinate;
   Notification: TNotification;
begin
  // ShowMessage('Medellín');
  // WebBrowser1.Navigate
  // ('http://api.openweathermap.org/data/2.5/weather?id=3674962&appid=37ff707ccf9ece0e458d58dcd56fefef');

  Data := GetPage
    ('http://api.openweathermap.org/data/2.5/weather?id=3674962&appid=37ff707ccf9ece0e458d58dcd56fefef');

  // ShowMessage('antes');
  leer_y_separar(Data);
  // ShowMessage('desp');
  // ShowMessage(data);
  //-75.56,"lat":6.25
   mapCenter := TMapCoordinate.Create(6.25, -75.56);
  MapView1.Location := mapCenter;
  MapView1.Zoom := 10;

   Principal.dbquery.Close;
   Principal.dbquery.SQL.Clear;

//NSERT INTO project (tittle,dttm,clienpro,nmvia,codvia,trunseg,geom) values(''PJ3'',CURRENT_TIMESTAMP,''Juan'',''Via Vieja'',''0003'',''Segmento 2'',''30'');');

      apk10.Principal.dbquery.SQL.Add
     // ('INSERT INTO project (tittle,dttm,clienpro,nmvia,codvia,trunseg,geom) values(''PJ3'',CURRENT_TIMESTAMP,''Juan'',''Via Vieja'',''0003'',''Segmento 2'',''30'');');
       ('INSERT INTO project (dttm,ciudad,temper) values(CURRENT_TIMESTAMP,:ciudad,:temper);');



     // ShowMessage(DateToStr(date));
     // ShowMessage(DateToStr(Time));
//
      Principal.dbquery.ParamByName('ciudad').AsString := 'Medellin';
      //apk10.Principal.dbquery.ParamByName('dttm').AsString := 'CURRENT_TIMESTAMP';
      Principal.dbquery.ParamByName('temper').AsString := f.ToString;

      Principal.dbquery.Execute;

       Principal.FMXToast1.ToastMessage := 'Temperatura Registrada';
      Principal.FMXToast1.Show(apk10.Principal.ListBoxProject);
      Principal.ConsultarProyectos;

            Notification := NotificationCenter1.CreateNotification;
  try
    Notification.Name := 'MyNotification';
    Notification.AlertBody := 'Medellin '+'Temperatura: ' + f.ToString +'°C'+' Latitud: ' + Lecturas[6] + ' - Longitud: ' + Lecturas[4] ;
    Notification.FireDate := Now;

    { Send notification in Notification Center }
    NotificationCenter1.PresentNotification(Notification);
    { also this method is equivalent if platform supports scheduling }
    // NotificationC.ScheduleNotification(Notification);
  finally
    Notification.DisposeOf;
  end;

end;

procedure TPrincipal.Switch1Switch(Sender: TObject);
begin
  LocationSensor1.Active := Switch1.IsChecked;
end;

procedure TPrincipal.CartagenaClick(Sender: TObject);
var
  mapCenter: TMapCoordinate;
   Notification: TNotification;
begin
  // 3687238
  // WebBrowser1.Navigate
  // ('http://api.openweathermap.org/data/2.5/weather?id=3687238&appid=37ff707ccf9ece0e458d58dcd56fefef');

  Data := GetPage
    ('http://api.openweathermap.org/data/2.5/weather?id=3687238&appid=37ff707ccf9ece0e458d58dcd56fefef');
  // ShowMessage(data);
  leer_y_separar(Data);

  mapCenter := TMapCoordinate.Create(10.4, -75.51);
  MapView1.Location := mapCenter;
  MapView1.Zoom := 10;

   Principal.dbquery.Close;
   Principal.dbquery.SQL.Clear;

//NSERT INTO project (tittle,dttm,clienpro,nmvia,codvia,trunseg,geom) values(''PJ3'',CURRENT_TIMESTAMP,''Juan'',''Via Vieja'',''0003'',''Segmento 2'',''30'');');

      apk10.Principal.dbquery.SQL.Add
     // ('INSERT INTO project (tittle,dttm,clienpro,nmvia,codvia,trunseg,geom) values(''PJ3'',CURRENT_TIMESTAMP,''Juan'',''Via Vieja'',''0003'',''Segmento 2'',''30'');');
       ('INSERT INTO project (dttm,ciudad,temper) values(CURRENT_TIMESTAMP,:ciudad,:temper);');



     // ShowMessage(DateToStr(date));
     // ShowMessage(DateToStr(Time));
//
      Principal.dbquery.ParamByName('ciudad').AsString := 'Cartagena';
      //apk10.Principal.dbquery.ParamByName('dttm').AsString := 'CURRENT_TIMESTAMP';
      Principal.dbquery.ParamByName('temper').AsString := f.ToString;

      Principal.dbquery.Execute;

       Principal.FMXToast1.ToastMessage := 'Temperatura Registrada';
      Principal.FMXToast1.Show(apk10.Principal.ListBoxProject);
      Principal.ConsultarProyectos;

            Notification := NotificationCenter1.CreateNotification;
  try
    Notification.Name := 'MyNotification';
    Notification.AlertBody := 'Cartagena '+'Temperatura: ' + f.ToString +'°C'+' Latitud: ' + Lecturas[6] + ' - Longitud: ' + Lecturas[4];
    Notification.FireDate := Now;

    { Send notification in Notification Center }
    NotificationCenter1.PresentNotification(Notification);
    { also this method is equivalent if platform supports scheduling }
    // NotificationC.ScheduleNotification(Notification);
  finally
    Notification.DisposeOf;
  end;

  // ,"lat":10.4

end;

procedure TPrincipal.BogotáClick(Sender: TObject);
var
  URLString: String;
  mapCenter: TMapCoordinate;
  Notification: TNotification;
begin
  // ShowMessage('Bogotá');

  // URLString :=
  // 'http://api.openweathermap.org/data/2.5/weather?id=3688689&appid=37ff707ccf9ece0e458d58dcd56fefef';
  // WebBrowser1.Navigate(URLString);

  Data := GetPage
    ('http://api.openweathermap.org/data/2.5/weather?id=3688689&appid=37ff707ccf9ece0e458d58dcd56fefef');
  // ShowMessage(data);
  leer_y_separar(Data);
  mapCenter := TMapCoordinate.Create(4.61, -74.08);
  MapView1.Location := mapCenter;
  MapView1.Zoom := 10;


   Principal.dbquery.Close;
   Principal.dbquery.SQL.Clear;

//NSERT INTO project (tittle,dttm,clienpro,nmvia,codvia,trunseg,geom) values(''PJ3'',CURRENT_TIMESTAMP,''Juan'',''Via Vieja'',''0003'',''Segmento 2'',''30'');');

      apk10.Principal.dbquery.SQL.Add
     // ('INSERT INTO project (tittle,dttm,clienpro,nmvia,codvia,trunseg,geom) values(''PJ3'',CURRENT_TIMESTAMP,''Juan'',''Via Vieja'',''0003'',''Segmento 2'',''30'');');
       ('INSERT INTO project (dttm,ciudad,temper) values(CURRENT_TIMESTAMP,:ciudad,:temper);');



     // ShowMessage(DateToStr(date));
     // ShowMessage(DateToStr(Time));
//
      Principal.dbquery.ParamByName('ciudad').AsString := 'Bogota';
      //apk10.Principal.dbquery.ParamByName('dttm').AsString := 'CURRENT_TIMESTAMP';
      Principal.dbquery.ParamByName('temper').AsString := f.ToString;

      Principal.dbquery.Execute;

       Principal.FMXToast1.ToastMessage := 'Temperatura Registrada';
      Principal.FMXToast1.Show(apk10.Principal.ListBoxProject);
      Principal.ConsultarProyectos;

            Notification := NotificationCenter1.CreateNotification;
  try
    Notification.Name := 'MyNotification';
    Notification.AlertBody := 'Bogota '+'Temperatura: ' + f.ToString +'°C'+' Latitud: ' + Lecturas[6] + ' - Longitud: ' + Lecturas[4];
    Notification.FireDate := Now;

    { Send notification in Notification Center }
    NotificationCenter1.PresentNotification(Notification);
    { also this method is equivalent if platform supports scheduling }
    // NotificationC.ScheduleNotification(Notification);
  finally
    Notification.DisposeOf;
  end;



end;

procedure TPrincipal.btinfoClick(Sender: TObject);

begin

  try
    dbquery.Close;
    // select dttm from project where id=2;

    dbquery.SQL.Text :=
      'select dttm,ciudad,temper from project where id=' +
      DicId.Items[(ListBoxProject.Selected.Index)].ToString;
    dbquery.Open;

    // ShowMessage(dbquery.FieldByName('dttm').AsString);
    // MessageDlg('¿Salir sin guardar?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

    ShowMessage('ID: ' + DicId.Items[(ListBoxProject.Selected.Index)].ToString +
      sLineBreak + 'FECHA: ' + dbquery.FieldByName('dttm').AsString + sLineBreak
      + 'Ciudad ' + dbquery.FieldByName('ciudad').AsString +
      sLineBreak + 'Temperatura: ' + dbquery.FieldByName('temper').AsString);
  except
    ShowMessage('Error, Seleccione un proyecto');
  end;

  // delete from project where id=1;
  // j := ListBoxProject.Selected.Index - 2;
  // ShowMessage(j.ToString);
  // cte := DicId.Items[j];
  // ShowMessage(cte.ToString);
end;

procedure TPrincipal.BucaramangaClick(Sender: TObject);
var
  mapCenter: TMapCoordinate;
   Notification: TNotification;
begin
  //
  // WebBrowser1.Navigate
  // ('http://api.openweathermap.org/data/2.5/weather?id=3688465&appid=37ff707ccf9ece0e458d58dcd56fefef');

  Data := GetPage
    ('http://api.openweathermap.org/data/2.5/weather?id=3688465&appid=37ff707ccf9ece0e458d58dcd56fefef');
  // ShowMessage(data);
  leer_y_separar(Data);
  // ,"lat":
  mapCenter := TMapCoordinate.Create(7.13, -73.12);
  MapView1.Location := mapCenter;
  MapView1.Zoom := 10;

   Principal.dbquery.Close;
   Principal.dbquery.SQL.Clear;

//NSERT INTO project (tittle,dttm,clienpro,nmvia,codvia,trunseg,geom) values(''PJ3'',CURRENT_TIMESTAMP,''Juan'',''Via Vieja'',''0003'',''Segmento 2'',''30'');');

      apk10.Principal.dbquery.SQL.Add
     // ('INSERT INTO project (tittle,dttm,clienpro,nmvia,codvia,trunseg,geom) values(''PJ3'',CURRENT_TIMESTAMP,''Juan'',''Via Vieja'',''0003'',''Segmento 2'',''30'');');
       ('INSERT INTO project (dttm,ciudad,temper) values(CURRENT_TIMESTAMP,:ciudad,:temper);');



     // ShowMessage(DateToStr(date));
     // ShowMessage(DateToStr(Time));
//
      Principal.dbquery.ParamByName('ciudad').AsString := 'Bucaramanga';
      //apk10.Principal.dbquery.ParamByName('dttm').AsString := 'CURRENT_TIMESTAMP';
      Principal.dbquery.ParamByName('temper').AsString := f.ToString;

      Principal.dbquery.Execute;

       Principal.FMXToast1.ToastMessage := 'Temperatura Registrada';
      Principal.FMXToast1.Show(apk10.Principal.ListBoxProject);
      Principal.ConsultarProyectos;

            Notification := NotificationCenter1.CreateNotification;
  try
    Notification.Name := 'MyNotification';
    Notification.AlertBody := 'Bucaramanga '+'Temperatura: ' + f.ToString +'°C'+' Latitud: ' + Lecturas[6] + ' - Longitud: ' + Lecturas[4];
    Notification.FireDate := Now;

    { Send notification in Notification Center }
    NotificationCenter1.PresentNotification(Notification);
    { also this method is equivalent if platform supports scheduling }
    // NotificationC.ScheduleNotification(Notification);
  finally
    Notification.DisposeOf;
  end;

end;

end.
