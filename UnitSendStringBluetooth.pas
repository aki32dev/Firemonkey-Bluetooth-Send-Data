unit UnitSendStringBluetooth;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.ListBox, System.Bluetooth;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    function ManagerConnected:Boolean;
    procedure PairedDevices;
    procedure Button1Click(Sender: TObject);
    function Sendstringdata(dataout:string):string;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FSocket: TBluetoothSocket;
    FBluetoothManager: TBluetoothManager;
    FPairedDevices: TBluetoothDeviceList;
    FAdapter: TBluetoothAdapter;
    LDevice: TBluetoothDevice;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  sGUID = '{00001101-0000-1000-8000-00805F9B34FB}';

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  BluetoothAdapter: TBluetoothAdapter;
begin
  try
    FBluetoothManager := TBluetoothManager.Current;
    BluetoothAdapter := FBluetoothManager.CurrentAdapter;
    FPairedDevices := BluetoothAdapter.PairedDevices;
    LDevice := FPairedDevices[Combobox1.ItemIndex] as TBluetoothDevice;

    if LDevice.IsPaired then
    begin
      FSocket := LDevice.CreateClientSocket(stringtoGUID(sguid), false);
      FSocket.Connect;
      Button1.Text := 'Connected';
    end;
  except
    ShowMessage('Restart your application');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (Edit1.Text <> '') then
  begin
    Sendstringdata(Edit1.Text);
    Edit1.Text := '';
  end
  else
  begin
    showmessage('Type something in Edit1');
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  try
    FBluetoothManager := TBluetoothManager.Current;
    FAdapter := FBluetoothManager.CurrentAdapter;
    if ManagerConnected then
    begin
      PairedDevices;
      Combobox1.ItemIndex := 0;
    end;
  except
    on E : Exception do
    begin
      //ShowMessage('Please turn ON your bluetooth and pair to Charger and Printer');
      FBluetoothManager.EnableBluetooth;
    end;
  end;
end;

function TForm1.ManagerConnected:Boolean;
begin
  if FBluetoothManager.ConnectionState = TBluetoothConnectionState.Connected then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end
end;

procedure TForm1.PairedDevices;
var
  I: Integer;
begin
  Combobox1.Clear;
  if ManagerConnected then
  begin
  FPairedDevices := FBluetoothManager.GetPairedDevices;
  if FPairedDevices.Count > 0 then
    for I:= 0 to FPairedDevices.Count - 1 do
    begin
      Combobox1.Items.Add(FPairedDevices[I].DeviceName);
    end;
  end;
end;

function TForm1.Sendstringdata(dataout:string):string;
var
  DataBytesKirim : TBytes;
begin
  if Assigned(FSocket) then
  Begin
    if FSocket.Connected then
    Begin
      DataBytesKirim := TEncoding.UTF8.GetBytes(dataout);
      FSocket.SendData(DataBytesKirim);
    End;
  end;
end;

end.
