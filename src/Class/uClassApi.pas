unit uClassApi;

interface
uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  JSON,
  REST.Json,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  IdHTTP,
  IdSSLOpenSSL,
  UrlMon;

type
  TApi = class
   strict private
      FIdHttp : TIdHttp;
      FCep : string;
      FLogradouro : string;
      FComplemento : string;
      FBairro : string;
      FLocalidade : string;
      FUf : string;
      function CriarIdHttp: TIdHttp;
      function GetJson (const aCep : string): string;
      procedure CreateJson(const Value : string);
      procedure AddValuesJson(const aJSon : TJSONObject);
    public
      function Cep(const Component : TComponent) : TApi;
      function Logradouro(const Component : TComponent) : TApi;
      function Complemento(const Component : TComponent) : TApi;
      function Bairro(const Component : TComponent) : TApi;
      function Localidade(const Component : TComponent) : TApi;
      function Uf(const Component : TComponent) : TApi;
      function LoadCep(const Value : string) : TApi;

  end;


var
  _Api : TApi;


implementation

function DownLoadInternetFile(Source, Dest: String): Boolean;
begin
  try
    Result := URLDownloadToFile(nil, PChar(Source), PChar(Dest), 0, nil) = 0
  except
    Result := False;
  end;
end;

procedure TApi.AddValuesJson(const aJSon: TJSONObject);
begin
    FCep := aJSon.GetValue<string>('cep');
    FLogradouro := aJSon.GetValue<string>('logradouro');
    FComplemento := aJSon.GetValue<string>('complemento');
    FBairro := aJSon.GetValue<string>('bairro');
    Flocalidade := aJSon.GetValue<string>('localidade');
    FUf := aJSon.GetValue<string>('uf');
end;

function TApi.Bairro(const Component : TComponent) : TApi;
begin
  Result := Self;
  TEdit(Component as TComponent).Text := FBairro;
end;

function TApi.Cep(const Component : TComponent) : TApi;
begin
  Result := Self;
  TEdit(Component as TComponent).Text := FCep;
end;

function TApi.Complemento(const Component : TComponent) : TApi;
begin
  Result := Self;
  TEdit(Component as TComponent).Text := FComplemento;
end;

function TApi.LoadCep(const Value: string): TApi;
begin
  result := Self;
  CreateJson(Value);
end;

procedure TApi.CreateJson(const Value : string);
var
 vJson :TJSONObject;
begin
    vJson := TJSONObject.ParseJSONValue(GetJson(Value)) as TJSONObject;
  try
    AddValuesJson(vJson);
  finally
    vJson.DisposeOf;
  end;
end;

function TApi.CriarIdHttp: TIdHttp;
var
  lIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := TIdHttp.Create;
  try
    lIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Result);
    Result.IOHandler := lIdSSLIOHandlerSocketOpenSSL;
    lIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
    lIdSSLIOHandlerSocketOpenSSL.SSLOptions.SSLVersions :=[sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2,sslvSSLv23,sslvSSLv3];

  except
    Result.Free;
    raise;
  end;
end;

function TApi.GetJson(const aCep : string): string;
var
  lStreamRetorno: TStringStream;
  vCaminhoApi : string;
begin
  result := '';
  FIdHttp := CriarIdHttp;
  lStreamRetorno := TStringStream.Create('', TEncoding.UTF8);
  try
    FIdHttp.Request.BasicAuthentication := true;
    FIdHttp.Request.ContentType := 'application/json';
//    FIdHttp.Request.ContentType :='application/octet-stream';
    FIdHttp.Request.CharSet := 'UTF-8';
    try
      vCaminhoApi := 'https://viacep.com.br/ws/'+aCep+'/json/';
      FIdHttp.Get(vCaminhoApi,lStreamRetorno);
      result := lStreamRetorno.DataString;
    except on e : exception do
      raise Exception.Create('Erro ao consultar '+vCaminhoApi +' '+e.Message);

    end;
  finally
    lStreamRetorno.DisposeOf;
    FIdHttp.DisposeOf;
  end;
end;


function TApi.Localidade(const Component : TComponent) : TApi;
begin
  Result := Self;
  TEdit(Component as TComponent).Text := FLocalidade;
end;

function TApi.Logradouro(const Component : TComponent) : TApi;
begin
  Result := Self;
  TEdit(Component as TComponent).Text := FLogradouro;
end;

function TApi.Uf(const Component : TComponent) : TApi;
begin
  Result := Self;
  TEdit(Component as TComponent).Text := FUf;
end;

initialization
  _Api := TApi.Create;

finalization
  _Api.DisposeOf;

end.
