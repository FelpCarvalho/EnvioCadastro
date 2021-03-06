unit uClassUtils;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Zip,
  Winapi.Windows,
  XMLIntf,
  XMLDoc,
  ACBrBase,
  ACBrMail,
  ACBrUtil,
  ACBrUtil.XMLHTML,
  Vcl.Dialogs,
  Vcl.Forms;


type
  TEmail = class
    strict private
      FConfirmationEMail: boolean;
      FNomeEmitente: string;
      FPort: string;
      FSsl: boolean;
      FPassword: string;
      FTls: boolean;
      FHost: string;
      FUserName: string;
      FACBrMail : TACBrMail;
      FEmailDest: string;
      FEmailCc: string;
      FMsg: string;
      FAssunto: string;
      FAnexo: string;
      const CHOST ='mail.teste.com.br';
      const PASS = 'senha';
      const PORTA = 'porta';
      const USER = 'emailusuario';

      function ConfirmationEMail   : boolean;overload;
      function NomeEmitente   : string;overload;
      function EmailDest   : string;overload;
      function EmailCc   : string;overload;
      function Host   : string;overload;
      function Port   : string;overload;
      function UserName   : string;overload;
      function Password   : string;overload;
      function Ssl  :boolean;overload;
      function Tls  : boolean;overload;
      function Msg   : string;overload;
      function Assunto   : string;overload;
      function Anexo   : string;overload;
      procedure ConfiguraEmail;
    public
      function ConfirmationEMail  (const Value : boolean) : TEmail;overload;
      function NomeEmitente  (const Value : string) : TEmail;overload;
      function EmailDest  (const Value : string) : TEmail;overload;
      function EmailCc  (const Value : string) : TEmail;overload;
      function Host  (const Value : string) : TEmail;overload;
      function Port  (const Value : string) : TEmail;overload;
      function UserName  (const Value : string) : TEmail;overload;
      function Password  (const Value : string) : TEmail;overload;
      function Ssl  (const Value : boolean) : TEmail;overload;
      function Tls  (const Value : boolean) : TEmail;overload;
      function Msg  (const Value : string) : TEmail;overload;
      function Assunto  (const Value : string) : TEmail;overload;
      function Anexo  (const Value : string) : TEmail;overload;
      destructor Destroy;override;
      function Send(const NomeEmitente : string; Para : string;
         Assunto : string; msg : string = '') : boolean;overload;
      class function New : TEmail;
      function  LoadPropertys : TEmail;
      function Send : boolean; overload;
      function CompactArq(const Arq : string): TEmail;
      procedure Save;

  end;
  TZip = class
    private
      function ZipaArquivo(const Dir : string) : string;
    public
      function CompactZip(DirArq : string) : string;
      class function New : TZip;
  end;

  TXmlClass = class

    strict private
      FNome : string;
      FIdentidade : string;
      FTelefone : string;
      FEmail : string;
      FCpf : string;
      FCep : string;
      FLogradouro : string;
      FNumero : string;
      FComplemento : string;
      FBairro : string;
      FCidade : string;
      FEstado : string;
      FPais : string;

      function Nome: string;overload;
      function Identidade: string;overload;
      function Telefone: string;overload;
      function Email: string;overload;
      function Cpf: string;overload;
      function Cep: string;overload;
      function Logradouro: string;overload;
      function Numero: string;overload;
      function Complemento: string;overload;
      function Bairro: string;overload;
      function Cidade: string;overload;
      function Estado: string;overload;
      function Pais: string;overload;
    public
      class function New : TXmlClass;
      function Nome(const Value : string) : TXmlClass;overload;
      function Identidade(const Value : string) : TXmlClass;overload;
      function Telefone(const Value : string) : TXmlClass;overload;
      function Email(const Value : string) : TXmlClass;overload;
      function Cpf(const Value : string) : TXmlClass;overload;
      function Cep(const Value : string) : TXmlClass;overload;
      function Logradouro(const Value : string) : TXmlClass;overload;
      function Numero(const Value : string) : TXmlClass;overload;
      function Complemento(const Value : string) : TXmlClass;overload;
      function Bairro(const Value : string) : TXmlClass;overload;
      function Cidade(const Value : string) : TXmlClass;overload;
      function Estado(const Value : string) : TXmlClass;overload;
      function Pais(const Value : string) : TXmlClass;overload;
      function CreateXml : string;
  end;

implementation

{ TEmail }

function TEmail.Assunto: string;
begin
  Result := FAssunto;
end;

function TEmail.CompactArq(const Arq : string): TEmail;
var
  vZip : TZip;
begin
  result := self;

  vZip := TZip.New;
  try
    self.Anexo(vZip.CompactZip(Arq));
  finally
    vZip.Free
  end;


end;

procedure TEmail.ConfiguraEmail;
begin
  FACBrMail := TACBrMail.Create(nil);
  try

    FACBrMail.IsHTML := false;
    FACBrMail.From := EmailDest;
    FACBrMail.Host := Host; // troque pelo seu servidor smtp
    FACBrMail.Username := UserName;
    FACBrMail.Password := Password;

    FACBrMail.SetSSL := Ssl;
    FACBrMail.SetTLS := Tls;
    FACBrMail.Port := Port; // troque pela porta do seu servidor smtp
    FACBrMail.ReadingConfirmation := ConfirmationEMail;

  finally

  end;
end;

function TEmail.ConfirmationEMail: boolean;
begin
  Result := FConfirmationEMail;
end;

destructor TEmail.Destroy;
begin
  FACBrMail.Free;
  inherited;
end;

function TEmail.LoadPropertys: TEmail;
begin
  result := self;
  try

//    NomeEmitente := NomeEmitente;
//    EmailDest := EmailDest;
//    EmailCc := Cc;
//    Host := vFile.Host;
//    Port := vFile.Port;
//    UserName := vFile.UserName;
//    Password := vFile.Pass;
//    PeriodoCupom := vMesAno;
//
//    Ssl := strtoboolDef(vFile.Ssl,true);
//    Tls := strtoboolDef(vFile.Tls,true);

//    ConfirmationEMail := strtoboolDef(vFile.ReadConfirmation,true);
  finally
  end;



end;

function TEmail.Msg: string;
begin
  Result := FMsg;
end;

class function TEmail.New: TEmail;
begin
  Result := TEmail.Create;

end;


function TEmail.NomeEmitente: string;
begin
  Result := FNomeEmitente;
end;

procedure TEmail.Save;
var
  vMessage : string;
begin

  try
    if vMessage <>'' then
    begin
      vMessage := vMessage +' ERRO ao tentar enviar o xml';
      send('empresa',USER,'Erro Envio de arquivos '+vMessage);
      Showmessage(vMessage);
    end;

  finally

  end;
end;

function TEmail.Send : boolean;
var
  AssuntoMensagem: String;

begin
  result := false;
  // envio da mensagem

  ConfiguraEmail;
  try
    AssuntoMensagem    := Assunto;
    FACBrMail.Clear;
    if EmailCc <>'' then
      FACBrMail.AddCC(EmailCc,'');

    FACBrMail.AddAddress(EmailDest, '');
    FACBrMail.Subject :=AssuntoMensagem;
    FACBrMail.body.Text := msg;
    FACBrMail.AltBody.Text :=(StripHTML(msg));
    FACBrMail.ClearAttachments;
    if Anexo <> '' then
      FACBrMail.AddAttachment(Anexo);


    FACBrMail.Send;
    result := true;
    Save;
  except

  end;
end;

function TEmail.Ssl: boolean;
begin
  Result := FSsl;
end;

function TEmail.Send(const NomeEmitente: string; Para, Assunto, msg: string) : boolean;
var
  AssuntoMensagem: String;
begin
  result := false;
  // envio da mensagem
  ConfiguraEmail;
  try
    AssuntoMensagem    := Assunto;
    FACBrMail.Clear;
    FACBrMail.AddAddress(para,NomeEmitente);
    FACBrMail.Subject :=AssuntoMensagem;
    FACBrMail.body.Text := msg;
    FACBrMail.AltBody.Text :=(StripHTML(msg));

    FACBrMail.Send;
    result := true;
  except

  end;

end;




function TEmail.Anexo(const Value: string) : TEmail;
begin
  Result := Self;
  FAnexo := Value;
end;

function TEmail.Anexo: string;
begin
  Result := FAnexo;
end;

function TEmail.Assunto(const Value: string) : TEmail;
begin
  Result := Self;
  if Value ='' then
    FAssunto := 'Xml'
  else
    FAssunto := Value;
end;

function TEmail.ConfirmationEMail(const Value: boolean) : TEmail;
begin
  FConfirmationEMail := Value;
  Result := self;
end;


function TEmail.EmailCc(const Value: string) : TEMail;
begin
  Result := Self;
  FEmailCc := Value;
end;

function TEmail.EmailCc: string;
begin
  Result := FEmailCc;
end;

function TEmail.EmailDest: string;
begin
  Result := FEmailDest;
end;

function TEmail.EmailDest(const Value: string) : TEmail;
begin
  Result := Self;
  FEmailDest := Value;
end;


function TEmail.Host: string;
begin
  Result := FHost;
end;

function TEmail.Host(const Value: string) : TEmail;
begin
  Result := Self;
  if Value='' then
    FHost := CHOST
  else FHost := Value;
end;

function TEmail.Msg(const Value: string) : TEmail;
var
    CorpoMensagem: TStringList;
begin
  Result := Self;
  if Value ='' then
  begin
    CorpoMensagem := TStringList.Create;
    try
      CorpoMensagem.Clear;
      CorpoMensagem.Add('Prezado,');
      CorpoMensagem.Add('');
      CorpoMensagem.Add('Voc? est? recebendo o xml de '+NomeEmitente);
      CorpoMensagem.Add('Qualquer d?vida estou a disposi??o');
      CorpoMensagem.Add('');
      CorpoMensagem.Add('Atenciosamente,');
      CorpoMensagem.Add('');
      CorpoMensagem.Add('Enviado automaticamente por:'+UserName);
      CorpoMensagem.Add('');
      FMsg := CorpoMensagem.Text;
    finally
      CorpoMensagem.Free;
    end;

  end else  FMsg := Value;
end;

function TEmail.NomeEmitente(const Value: string) : TEmail;
begin
  Result := Self;
  FNomeEmitente := Value;
end;

function TEmail.Password(const Value: string) : TEmail;
begin
  Result := Self;
  if Value ='' then
    FPassword :=PASS
  else FPassword := Value;
end;

function TEmail.Password: string;
begin
  Result := FPassword;
end;

function TEmail.Port: string;
begin
  Result := FPort;
end;

function TEmail.Port(const Value: string) : TEmail;
begin
  Result := Self;
  if Value ='' then
    FPort := PORTA
  else FPort := Value;
end;

function TEmail.Ssl(const Value: boolean) : TEmail;
begin
  Result := Self;
  FSsl := Value;
end;


function TEmail.Tls: boolean;
begin
  Result := FTls;
end;

function TEmail.Tls(const Value: boolean) : TEMail;
begin
  Result := Self;
  FTls := Value;
end;

function TEmail.UserName: string;
begin
  Result := FUserName;
end;

function TEmail.UserName(const Value: string) : TEmail;
begin
  Result := Self;
  if Value ='' then
    FUserName := USER
  else FUserName := Value;
end;



{ TZip }

function TZip.CompactZip(DirArq : string) : string;
begin

    Result := ZipaArquivo(DirArq);
//    ExtractFileDir(Application.ExeName) + '\temp.xml'
end;


class function TZip.New : TZip;
begin
  result := TZip.Create;
end;


function TZip.ZipaArquivo(const Dir : string) : string;
var
  vDir : string;
  zip: TZipFile;
  vArquivos : TStringList;
  SR: TSearchRec;
  vFileName : string;

begin
  result := '';
  vDir := Dir +'\';


  vDir := StringReplace(vDir,'\\','\',[rfReplaceAll]);

  if not(LocaleDirectoryExists(vDir)) then
    exit;


  vFileName := vDir+'.zip';

  if FileExists(vFileName)  then
  begin
    result :=vFileName;
    exit;
  end;


  vArquivos := TStringList.Create;
  zip := TZipFile.Create;

  try

    try
      zip.Open(vFileName, zmWrite);
      if FindFirst(vDir+'*.*', faAnyFile, SR) = 0 then// encontra todos os arquivos dentro do diretorio informado
      begin
        repeat
          if (SR.Attr <> faDirectory) then
            zip.Add(vDir + SR.Name);
        until FindNext(SR) <> 0;
        FindClose(SR.FindHandle);
      end;

//      for I := 0 to pred(vArquivos.Count) do
//        zip.Add(vArquivos.Strings[I]);


      if fileExists(vFileName) then
        zip.Close;

    except
      vFileName :='';
    end;

  finally
    result := vFileName;
    vArquivos.Free;
    zip.Free;
  end;
end;

{ TXml }

function TXmlClass.Bairro: string;
begin
  Result := FBairro;
end;

function TXmlClass.Bairro(const Value: string): TXmlClass;
begin
  Result := Self;
  FBairro := Value;
end;

function TXmlClass.Cep: string;
begin
  Result := FBairro;

end;

function TXmlClass.Cep(const Value: string): TXmlClass;
begin
  Result := Self;
  FCep := Value;
end;

function TXmlClass.Cidade: string;
begin
  Result := FCidade;
end;

function TXmlClass.Cidade(const Value: string): TXmlClass;
begin
  Result := Self;
  FCidade := Value;
end;

function TXmlClass.Complemento: string;
begin
  Result := FComplemento;
end;

function TXmlClass.Complemento(const Value: string): TXmlClass;
begin
  Result := Self;
  FComplemento := Value;
end;

function TXmlClass.Cpf(const Value: string): TXmlClass;
begin
  Result := Self;
  FCpf := Value;
end;

function TXmlClass.Cpf: string;
begin
  Result := FCpf;
end;

function TXmlClass.CreateXml: string;
var
  XMLEnvio: TXMLDocument;
  vReturn : string;
begin
  XMLEnvio := TXMLDocument.Create(nil);
  try
    XMLEnvio.Active := True;
    XMLEnvio.AddChild('Cliente');
      XMLEnvio.DocumentElement.AddChild('Nome').NodeValue := Nome;
      XMLEnvio.DocumentElement.AddChild('Identidade').NodeValue := Identidade;
      XMLEnvio.DocumentElement.AddChild('Cpf').NodeValue := Cpf;
      XMLEnvio.DocumentElement.AddChild('Telefone').NodeValue := Telefone;
      XMLEnvio.DocumentElement.AddChild('Email').NodeValue := Email;

    XMLEnvio.DocumentElement.ChildNodes['Nome'];
        XMLEnvio.DocumentElement.AddChild('Cep').NodeValue := Cep;
        XMLEnvio.DocumentElement.AddChild('Logradouro').NodeValue := Logradouro;
        XMLEnvio.DocumentElement.AddChild('Numero').NodeValue := Numero;
        XMLEnvio.DocumentElement.AddChild('Complemento').NodeValue := Complemento;

        XMLEnvio.DocumentElement.AddChild('Bairro').NodeValue := Bairro;
        XMLEnvio.DocumentElement.AddChild('Cidade').NodeValue := Cidade;
        XMLEnvio.DocumentElement.AddChild('Estado').NodeValue := Estado;
        XMLEnvio.DocumentElement.AddChild('Pais').NodeValue := Pais;

   vReturn := (ExtractFileDir(Application.ExeName) + '\temp.xml');
   XMLEnvio.SaveToFile(vReturn);
   Result := vReturn;
  finally
//    XMLEnvio.Free;
  end;
end;

function TXmlClass.Email(const Value: string): TXmlClass;
begin
  Result := Self;
  FEmail := Value;
end;

function TXmlClass.Email: string;
begin
  Result := FEmail;
end;

function TXmlClass.Estado: string;
begin
  Result := FEstado;
end;

function TXmlClass.Estado(const Value: string): TXmlClass;
begin
  Result := Self;
  FEstado := Value;
end;

function TXmlClass.Identidade(const Value: string): TXmlClass;
begin
  Result := Self;
  FIdentidade := Value;
end;

function TXmlClass.Identidade: string;
begin
  Result := FIdentidade;
end;

function TXmlClass.Logradouro(const Value: string): TXmlClass;
begin
  Result := Self;
  FLogradouro := Value;
end;

function TXmlClass.Logradouro: string;
begin
  Result := FLogradouro;
end;

class function TXmlClass.New: TXmlClass;
begin
  Result := Self.Create;
end;

function TXmlClass.Nome: string;
begin
  Result := FNome;
end;

function TXmlClass.Nome(const Value: string): TXmlClass;
begin
  Result := Self;
  FNome := Value;
end;

function TXmlClass.Numero: string;
begin
  Result := FNumero;
end;

function TXmlClass.Numero(const Value: string): TXmlClass;
begin
  Result := Self;
  FNumero := Value;
end;

function TXmlClass.Pais(const Value: string): TXmlClass;
begin
  Result := Self;
  FPais := Value;
end;

function TXmlClass.Pais: string;
begin
  Result := FPais;
end;

function TXmlClass.Telefone: string;
begin
  FIdentidade := FTelefone;
end;

function TXmlClass.Telefone(const Value: string): TXmlClass;
begin
  Result := Self;
  FTelefone := Value;
end;

end.
