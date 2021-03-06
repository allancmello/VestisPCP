{**********************************************************************************}
{ VESTIS PCP  - SISTEMA PARA INDUSTRIAS DE CONFEC��ES.                             } 
{                                                                                  } 
{ Este arquivo � parte do codigo-fonte do sistema VESTIS PCP, � um software livre; }
{ voc� pode redistribu�-lo e/ou modific�-lo dentro dos termos da GNU LGPL vers�o 3 }
{ como publicada pela Funda��o do Software Livre (FSF).                            }
{                                                                                  }
{ Este programa � distribu�do na esperan�a que possa ser �til, mas SEM NENHUMA     }
{ GARANTIA; sem uma garantia impl�cita de ADEQUA��O a qualquer MERCADO ou          }
{ APLICA��O EM PARTICULAR. Veja a Licen�a P�blica Geral GNU/LGPL em portugu�s      }
{ para maiores detalhes.                                                           }
{                                                                                  }
{ Voc� deve ter recebido uma c�pia da GNU LGPL vers�o 3, sob o t�tulo              }
{ "LICENCA.txt", junto com esse programa.                                          }
{ Se n�o, acesse <http://www.gnu.org/licenses/>                                    }
{ ou escreva para a Funda��o do Software Livre (FSF) Inc.,                         }
{ 51 Franklin St, Fifth Floor, Boston, MA 02111-1301, USA.                         }
{                                                                                  }
{                                                                                  }
{ Autor: Adriano Zanini -  vestispcp.indpcp@gmail.com                              }
{                                                                                  }
{**********************************************************************************}


{***********************************************************************************
**  SISTEMA...............: VESTIS PCP                                            **
**  DESCRI��O.............: SISTEMA ERP PARA INDUSTRIAS DE CONFEC��ES             **
**  LINGUAGEM/DB..........: DELPHI XE7  /  SQL SERVER 2014                        ** 
**  ANO...................: 2010 - 2018                                           ** 
**                                                                                **
** ------------------------------------------------------------------------------ **
**                                                                                **
**  AUTOR/DESENVOLVEDOR...: ADRIANO ZANINI                                        **
**  MINHAS AUTORIAS.......:  Vestis PCP e IndPCP                                  **
**  - VESTISPCP (� gratuito, disponivel no GitHub). N�o dou Suporte T�cnico.      **
**  - INDPCP (� pago). Dou Suporte T�cnico.                                       **
**                                                                                **
** -----------------------------------------------------------------------------  **
**                                                                                **
** - VESTISPCP � C�DIGO-FONTE LIVRE. O CODIGO-FONTE N�O PODE SER COMERCIALIZADO.  **
**                                                                                **
** - INDPCP � RESTRITO. SOMENTE EU, O AUTOR, POSSO COMERCIALIZAR O CODIGO-FONTE.  **
**                                                                                **
***********************************************************************************}

unit FCotacaoMoeda;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, Buttons, ExtCtrls, DB, SqlExpr,
   FMTBcd, Grids, DBGrids, Provider, DBClient, Mask, DBCtrls, FFrameBotoes,
   SimpleDS,        FFrameBarra, ShellApi, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
   TFrmCotacaoMoeda = class(TForm)
      Panel1: TPanel;
      Label1: TLabel;
      EditCodigo: TDBEdit;
      Labelsimbolo: TLabel;
      EditSimbolo: TDBEdit;
      Label4: TLabel;
      DBEdit4: TDBEdit;
      Label5: TLabel;
      DBEdit5: TDBEdit;
      Panel4: TPanel;
      BtnSair: TBitBtn;
      BtnCancelar: TBitBtn;
      BtnSalvar: TBitBtn;
      DS_CotacaoMoeda: TDataSource;
      db_CotacaoMoeda:  TFDQuery;
    db_CotacaoMoedaCODIGO: TIntegerField;
    db_CotacaoMoedaATUALIZACAO: TSQLTimeStampField;
    db_CotacaoMoedaFONTE: TStringField;
    db_CotacaoMoedaDOLAR: TBCDField;
    db_CotacaoMoedaEURO: TBCDField;
    FrmFrameBarra1: TFrmFrameBarra;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
      procedure db_CotacaoMoedaBeforeDelete(DataSet: TDataSet);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure FormCreate(Sender: TObject);
      procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure BtnSalvarClick(Sender: TObject);
      procedure BtnCancelarClick(Sender: TObject);
      procedure BtnSairClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure db_CotacaoMoedaBeforePost(DataSet: TDataSet);
   private
      { Private declarations }
      xHTTP : String;
    procedure AcessarSiteBancoCentral;
   public
      { Public declarations }
   end;

var
   FrmCotacaoMoeda: TFrmCotacaoMoeda;

implementation

uses FPrincipal, Biblioteca, SQLServer;

{$R *.dfm}

procedure TFrmCotacaoMoeda.FormCreate(Sender: TObject);
begin
   xHTTP :='';
   FrmPrincipal.MnuArquivo_Cotacao.Enabled := False;
   db_CotacaoMoeda.open;

end;

procedure TFrmCotacaoMoeda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   FrmPrincipal.MnuArquivo_Cotacao.Enabled := True;
   db_CotacaoMoeda.close;
   Action := Cafree;
end;

procedure TFrmCotacaoMoeda.BtnCancelarClick(Sender: TObject);
begin
   db_CotacaoMoeda.Cancel;
end;

procedure TFrmCotacaoMoeda.BtnSairClick(Sender: TObject);
begin
   close;
end;

procedure TFrmCotacaoMoeda.BtnSalvarClick(Sender: TObject);
begin

   if (db_CotacaoMoeda.State in [dsInsert, dsEdit]) then
   begin
      db_CotacaoMoeda.Post;
   End;


end;

procedure TFrmCotacaoMoeda.db_CotacaoMoedaBeforeDelete(DataSet: TDataSet);
begin
   Informar('Aten��o:  ' + #13 + #10 +
     'A exclus�o de qualquer um dos registros poder� ocasionar falhas ' +
     'ao gerar futuras Tabelas de Pre�os');

end;

procedure TFrmCotacaoMoeda.db_CotacaoMoedaBeforePost(DataSet: TDataSet);
begin
   db_CotacaoMoeda.FieldByName('ATUALIZACAO').AsDateTime :=Now;
end;

procedure TFrmCotacaoMoeda.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin


   If Key = vk_escape then
      close;

end;

procedure TFrmCotacaoMoeda.SpeedButton1Click(Sender: TObject);
begin
   AcessarSiteBancoCentral;
end;


procedure TFrmCotacaoMoeda.AcessarSiteBancoCentral;
begin
     If pergunta('[Taxas de c�mbio] Acessar site do Banco Central?')=false Then
        exit;

     xHTTP := 'http://www.bcb.gov.br';
     ShellExecute(0, nil, pchar(xHTTP), nil, nil, SW_SHOW);
end;

end.
