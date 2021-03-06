(*Utilizar a linguagem Delphi (Qualquer vers?o);

Criar uma tela de cadastro de clientes, com os seguintes campos:
Dados do Cadastro:

  Nome
  Identidade
  CPF
  Telefone
  Email
  Endere?o
  Cep
    Logradouro
    Numero
    Complemento
    Bairro
    Cidade
    Estado
    Pais

  Ao informar um Cep o sistema deve realizar a busca dos
  dados relacionados ao mesmo no seguinte endere?o: https://viacep.com.br/;

  A forma de consumo da API do via Cep, dever? ser utilizando JSON;
  Ao termino do cadastro o usu?rio dever? enviar um e-mail contendo as informa??es cadastrais
  e anexar um arquivo no formato XML com o mesmo conte?do;
  Os registros devem ficar salvo em mem?ria, n?o ? necess?rio criar um banco de dados
  ou arquivo para o armazenamento dos dados;
  Disponibilizar o c?digo fonte do projeto no github;


Prazo limite de envio: 14/06/2022

Responder com link do projeto (github) para: gustavo.maia@infosistemas.com.br e luciana.carvalho@infosistemas.com.br
*)
unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  uClassApi,
  XMLIntf,
  XMLDoc,
  StrUtils,
  Vcl.ComCtrls,
  System.UITypes,
  uClassUtils;

type
  TfrmMain = class(TForm)
    pnlMain: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edtNome: TEdit;
    edtIdentidade: TEdit;
    edtTelefone: TEdit;
    edtEmail: TEdit;
    edtCpf: TEdit;
    edtCep: TEdit;
    edtLogradouro: TEdit;
    edtNumero: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    edtPais: TEdit;
    PageControl1: TPageControl;
    TabCliente: TTabSheet;
    tabConfiguraEmail: TTabSheet;
    Panel1: TPanel;
    Label6: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    SpeedButton2: TSpeedButton;
    Label20: TLabel;
    Label21: TLabel;
    edtCopia: TEdit;
    edtPara: TEdit;
    edtAssunto: TEdit;
    memoBody: TMemo;
    edtEmitente: TEdit;
    edtPort: TEdit;
    edtHost: TEdit;
    edtPass: TEdit;
    edtUser: TEdit;
    chkSsl: TCheckBox;
    chkTls: TCheckBox;
    chkReadConfirmation: TCheckBox;
    btoEnviar: TSpeedButton;
    btnBuscarCep: TSpeedButton;
    procedure btoEnviarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure edtCepExit(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure btnBuscarCepClick(Sender: TObject);
    procedure edtCpfExit(Sender: TObject);
    procedure edtNomeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    FEmail : TEmail;
    function CreateXml : string;
    procedure LoadValuesEmail;
    procedure BuscaCep;
  public
    { Public declarations }
  end;


var
  frmMain: TfrmMain;

implementation

procedure ValidaCPF(pNumero: string);
var
  lCPF: string;
  lI: Integer;
  lTotal: Integer;
  lDg1: Integer;
  lDg2: Integer;
  lRet: Boolean;
begin
  lRet := True;
  for lI := 1 to Length(pNumero) do
    if not(CharInSet(pNumero[lI], ['0' .. '9', '-', '.', ' '])) then
      lRet := False;
  if lRet then
  begin
    lRet := True;
    lCPF := '';
    for lI := 1 to Length(pNumero) do
      if CharInSet(pNumero[lI], ['0' .. '9']) then
        lCPF := lCPF + pNumero[lI];
    if Length(lCPF) <> 11 then
      lRet := False;
    if lRet then
    begin
      // 1? d?gito
      lTotal := 0;
      for lI := 1 to 9 do
        lTotal := lTotal + (StrToInt(lCPF[lI]) * lI);
      lDg1 := lTotal mod 11;
      if lDg1 = 10 then
        lDg1 := 0;
      // 2? d?gito
      lTotal := 0;
      for lI := 1 to 8 do
        lTotal := lTotal + (StrToInt(lCPF[lI + 1]) * (lI));
      lTotal := lTotal + (lDg1 * 9);
      lDg2 := lTotal mod 11;
      if lDg2 = 10 then
        lDg2 := 0;
      // Valida??o final
      if lDg1 = StrToInt(lCPF[10]) then
        if lDg2 = StrToInt(lCPF[11]) then
          lRet := True;
      // Inv?lidos
      case AnsiIndexStr(lCPF, ['00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666',
        '77777777777', '88888888888', '99999999999']) of
        0 .. 9:
          lRet := False;
      end;
    end
    else
    begin
      // Se n?o informado deixa passar
      if lCPF = '' then
        lRet := True;
    end;
  end;
  if lRet then
    messageDlg('Cpf inv?lido!',mtWarning,[mbOk],0);
end;

function FormataCPF(pNumero: string): string;
var
  lAux: string;
  lResultado: string;
  lI: Integer;
begin
  if Length(pNumero) < 10 then
  begin
    Result := '';
    Exit;
  end;
  for lI := 1 to Length(pNumero) do
  begin
    if CharInSet(pNumero[lI], ['0' .. '9']) then
      lResultado := lResultado + pNumero[lI];
  end;
  if Length(lResultado) < 11 then
    lResultado := StringOfChar('0', 11 - Length(lResultado)) + lResultado;
  lAux := copy(lResultado, 1, 3) + '.';
  lAux := lAux + copy(lResultado, 4, 3) + '.';
  lAux := lAux + copy(lResultado, 7, 3) + '-';
  lAux := lAux + copy(lResultado, 10, 2);
  Result := lAux;
end;
{$R *.dfm}

procedure TfrmMain.btnBuscarCepClick(Sender: TObject);
begin
  BuscaCep;
end;

procedure TfrmMain.btoEnviarClick(Sender: TObject);
var
  vMsg : string;
begin
  if edtPara.Text='' then
    exit;
    LoadValuesEmail;
  try
    if FEmail.LoadPropertys.CompactArq(CreateXml).Send then
    begin
      vMsg := 'Email enviado para '+edtPara.Text;
      if edtCopia.Text <>'' then
        vMsg := vMsg +', com c?pia para'+edtCopia.Text;
     MessageDlg(vMsg,mtConfirmation, [mbOk],0);
    end;
  finally
  end;


end;

procedure TfrmMain.BuscaCep;
begin
   if edtCep.Text ='' then
    exit;

  _Api.LoadCep(edtCep.Text).
    Cep(edtCep)
    .Logradouro(edtLogradouro)
    .Complemento(edtComplemento)
    .Bairro(edtBairro)
    .Localidade(edtCidade)
    .Uf(edtEstado);
end;

function TfrmMain.CreateXml : string;
var
  vXml: TXmlClass;
begin
  Result :='';
  vXml:= TXmlClass.New;
  try
    vXml.Nome(edtNome.Text)
    .Identidade(edtIdentidade.Text)
    .Telefone(edtTelefone.Text)
    .Email(edtEmail.Text)
    .Cpf(edtCpf.Text)
    .Cep(edtCep.Text)
    .Logradouro(edtLogradouro.Text)
    .Numero(edtNumero.Text)
    .Complemento(edtComplemento.Text)
    .Bairro(edtBairro.Text)
    .Cidade(edtCidade.Text)
    .Estado(edtEstado.Text)
    .Pais(edtPais.Text);
     Result := vXml.CreateXml;

  finally
    vXml.DisposeOf;
  end;

end;

procedure TfrmMain.edtCepExit(Sender: TObject);
begin
  BuscaCep;
end;

procedure TfrmMain.edtCpfExit(Sender: TObject);
begin
  ValidaCPF(TEdit(sender).Text);
  TEdit(sender).Text := FormataCPF(TEdit(sender).Text);
end;

procedure TfrmMain.edtEmailExit(Sender: TObject);
begin
  edtUser.Text := edtEmail.Text;
end;

procedure TfrmMain.edtNomeKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key =#13)then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FEmail := TEmail.New;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FEmail.DisposeOf;
end;

procedure TfrmMain.LoadValuesEmail;
begin
    FEmail.NomeEmitente(edtEmitente.Text)
    .EmailDest(edtPara.Text)
    .EmailCc(edtCopia.Text)
    .Host(edtHost.Text)
    .Port(edtPort.Text)
    .UserName(edtUser.Text)
    .Password(edtPass.Text)
    .Ssl(chkSsl.Checked)
    .Tls(chkTls.Checked)
    .ConfirmationEMail(chkReadConfirmation.Checked)
    .Msg(memoBody.Text)
    .Assunto(edtAssunto.Text);
end;

procedure TfrmMain.SpeedButton2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 edtPass.PasswordChar:= #0;
end;

procedure TfrmMain.SpeedButton2MouseLeave(Sender: TObject);
begin
  edtPass.PasswordChar := '*';
end;

end.
