{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2008 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit SSMainFrm;
{ |<PRE>
================================================================================
* ������ƣ��ļ�������ͬ������
* ��Ԫ���ƣ������嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP3 + Delphi 7.1
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ����ݲ����ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: $
* �޸ļ�¼��2008.10.24 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellCtrls, ExtCtrls, IniFiles, Buttons, XPMan,
  CnCommon;

type
  TSSMainForm = class(TForm)
    StatusBar: TStatusBar;
    pnl1: TPanel;
    lbl3: TLabel;
    ListView: TListView;
    btnAdd: TButton;
    btnDel: TButton;
    btnClear: TButton;
    btnUp: TButton;
    btnDown: TButton;
    btnImport: TButton;
    btnExport: TButton;
    btnExecute: TButton;
    pb1: TProgressBar;
    lbl4: TLabel;
    pnl2: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    chkIncSub: TCheckBox;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    tmr1: TTimer;
    btnAbout: TButton;
    btnExit: TButton;
    edtSrc: TEdit;
    edtDst: TEdit;
    btnSrcDir: TSpeedButton;
    btnDstDir: TSpeedButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnSrcDirClick(Sender: TObject);
    procedure btnDstDirClick(Sender: TObject);
  private
    { Private declarations }
    FFileCnt: Integer;
    FExecuting: Boolean;
    FAbort: Boolean;
    FCurrMsg: string;
    FStartTick: Cardinal;
    FProcTick: Cardinal;
    FProcCnt: Integer;
    FCopyCnt: Integer;
    FDelCnt: Integer;
    FSrcDir, FDstDir: string;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    procedure UpdateIndex;
    procedure FileCntProc(const FileName: string; const Info: TSearchRec;
      var Abort: Boolean);
    procedure FileSyncProc(const FileName: string; const Info: TSearchRec;
      var Abort: Boolean);
    procedure FileDelProc(const FileName: string; const Info: TSearchRec;
      var Abort: Boolean);
    procedure DirDelProc(const SubDir: string);
  public
    { Public declarations }
  end;

var
  SSMainForm: TSSMainForm;

implementation

{$R *.dfm}

{ TSSMainForm }

procedure TSSMainForm.FormCreate(Sender: TObject);
begin
  Application.Title := Caption;
  LoadFromFile(ChangeFileExt(Application.ExeName, '.ssb'));
end;

procedure TSSMainForm.FormDestroy(Sender: TObject);
begin
  SaveToFile(ChangeFileExt(Application.ExeName, '.ssb'));
end;

procedure TSSMainForm.btnAddClick(Sender: TObject);
begin
  if not DirectoryExists(edtSrc.Text) then
    ErrorDlg('Դ�ļ��в����ڣ�')
  else if not DirectoryExists(edtDst.Text) then
    ErrorDlg('Ŀ���ļ��в����ڣ�')
  else if SameText(Trim(edtSrc.Text), Trim(edtDst.Text)) then
    ErrorDlg('Դ�ļ�����Ŀ���ļ��в�����ͬ��')
  else if AnsiPos(UpperCase(Trim(edtSrc.Text)), UpperCase(Trim(edtDst.Text))) = 1 then
    ErrorDlg('Ŀ���ļ��в�����Դ�ļ��е���Ŀ¼��')
  else if AnsiPos(UpperCase(Trim(edtDst.Text)), UpperCase(Trim(edtSrc.Text))) = 1 then
    ErrorDlg('Դ�ļ��в�����Ŀ���ļ��е���Ŀ¼��')
  else
  begin
    with ListView.Items.Add do
    begin
      Caption := IntToStr(Index + 1);
      SubItems.Add(edtSrc.Text);
      SubItems.Add(edtDst.Text);
      if chkIncSub.Checked then
        SubItems.Add('����')
      else
        SubItems.Add('');
    end;  
  end;
end;

procedure TSSMainForm.btnDelClick(Sender: TObject);
begin
  ListViewDeleteSelected(ListView);
  UpdateIndex;
end;

procedure TSSMainForm.btnClearClick(Sender: TObject);
begin
  if QueryDlg('ȷ��Ҫ�����') then
    ListView.Clear;
end;

procedure TSSMainForm.btnUpClick(Sender: TObject);
begin
  ListViewMoveUpSelected(ListView);
  UpdateIndex;
end;

procedure TSSMainForm.btnDownClick(Sender: TObject);
begin
  ListViewMoveDownSelected(ListView);
  UpdateIndex;
end;

procedure TSSMainForm.UpdateIndex;
var
  i: Integer;
begin
  for i := 0 to ListView.Items.Count - 1 do
    ListView.Items[i].Caption := IntToStr(i + 1);
end;

procedure TSSMainForm.LoadFromFile(const FileName: string);
var
  i: Integer;
begin
  ListView.Clear;
  with TMemIniFile.Create(FileName) do
  try
    i := 1;
    while SectionExists(IntToStr(i)) do
    begin
      with ListView.Items.Add do
      begin
        Caption := IntToStr(i);
        SubItems.Add(ReadString(IntToStr(i), 'SrcDir', ''));
        SubItems.Add(ReadString(IntToStr(i), 'DstDir', ''));
        SubItems.Add(ReadString(IntToStr(i), 'IncSub', ''));
      end;
      Inc(i);
    end;
  finally
    Free;
  end;
end;

procedure TSSMainForm.SaveToFile(const FileName: string);
var
  i: Integer;
begin
  DeleteFile(FileName);
  with TMemIniFile.Create(FileName) do
  try
    for i := 0 to ListView.Items.Count - 1 do
    begin
      WriteString(ListView.Items[i].Caption, 'SrcDir', ListView.Items[i].SubItems[0]);
      WriteString(ListView.Items[i].Caption, 'DstDir', ListView.Items[i].SubItems[1]);
      WriteString(ListView.Items[i].Caption, 'IncSub', ListView.Items[i].SubItems[2]);
    end;
  finally
    UpdateFile;
    Free;
  end;
end;

procedure TSSMainForm.btnImportClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    LoadFromFile(dlgOpen.FileName);
  end;
end;

procedure TSSMainForm.btnExportClick(Sender: TObject);
begin
  if (ListView.Items.Count > 0) and dlgSave.Execute then
  begin
    SaveToFile(dlgSave.FileName);
  end;
end;

procedure TSSMainForm.btnExecuteClick(Sender: TObject);
var
  i: Integer;
  
  procedure ControlSetEnabled(AEnabled: Boolean);
  var
    i: Integer;
  begin
    for i := 0 to ComponentCount - 1 do
      if (Components[i] is TControl) and (Components[i].Tag = 1) then
        TControl(Components[i]).Enabled := AEnabled;
  end;
begin
  if FExecuting then
  begin
    FAbort := QueryDlg('�Ƿ��жϴ���');
  end
  else
  begin
    ControlSetEnabled(False);
    FExecuting := True;
    FAbort := False;
    pb1.Position := 0;
    btnExecute.Caption := '�ж�(&I)';
    try
      pb1.Position := 0;
      FFileCnt := 0;
      FCopyCnt := 0;
      FDelCnt := 0;
      FProcCnt := 0;
      FStartTick := GetTickCount;
      FProcTick := 0;
      tmr1.Enabled := True;
      for i := 0 to ListView.Items.Count - 1 do
      begin
        FSrcDir := MakePath(ListView.Items[i].SubItems[0]);
        FCurrMsg := '����ͳ��: ' + FSrcDir;
        FindFile(FSrcDir, '*.*', FileCntProc, nil,
          ListView.Items[i].SubItems[2] <> '', True);
        if FAbort then
          Exit;
      end;
      pb1.Max := FFileCnt;

      FProcTick := GetTickCount;
      for i := 0 to ListView.Items.Count - 1 do
      begin
        FSrcDir := MakePath(ListView.Items[i].SubItems[0]);
        FDstDir := MakePath(ListView.Items[i].SubItems[1]);
        // ��ɾ��Ŀ��Ŀ¼�еľ��ļ�
        FCurrMsg := '���ڴ���: ' + FSrcDir;
        FindFile(FDstDir, '*.*', FileDelProc, DirDelProc,
          ListView.Items[i].SubItems[2] <> '', True);
        // �ٸ���ԴĿ¼�е����ļ�
        FindFile(FSrcDir, '*.*', FileSyncProc, nil,
          ListView.Items[i].SubItems[2] <> '', True);
        if FAbort then
          Exit;
      end;
      tmr1Timer(nil);
    finally
      tmr1.Enabled := False;
      ControlSetEnabled(True);
      FExecuting := False;
      btnExecute.Caption := 'ͬ��(&I)';
      if not FAbort then
        InfoDlg(Format('�ļ���ͬ����ɣ��������ļ� %d ����ɾ�����ļ�(��) %d ����',
          [FCopyCnt, FDelCnt]));
    end;
  end;
end;

procedure TSSMainForm.btnAboutClick(Sender: TObject);
begin
  InfoDlg(Caption + #13#10#13#10 +
    '���������ͬ�����Ŀ¼�е��ļ���ͬ�����Ŀ���ļ���'#13#10 +
    '����Դ�ļ���������ȫһ�¡�ͬ������ʱ�Զ�����Դ�ļ�'#13#10 +
    '���д�С�����ڱ�������ļ�����ɾ��Ŀ���ļ����в���'#13#10 +
    '����Դ�ļ��е��ļ���Ŀ¼��'#13#10#13#10 +
    '������� �ܾ��� (zjy@cnpack.org)'#13#10 +
    '��Ȩ���� (C)2001-2008 CnPack ������');
end;

procedure TSSMainForm.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TSSMainForm.tmr1Timer(Sender: TObject);
var
  t1, t2: TDateTime;
begin
  pb1.Position := FProcCnt;
  StatusBar.SimpleText := FCurrMsg;
  t1 := (GetTickCount - FStartTick) / 1000 / 3600 / 24;
  if (FProcTick <> 0) and (FProcCnt > 0) then
    t2 := ((GetTickCount - FProcTick) / 1000 / 3600 / 24) * (1 - FFileCnt / FProcCnt)
  else
    t2 := 0;
  lbl4.Caption := Format('���� %s ʣ�� %s', [TimeToStr(t1), TimeToStr(t2)]);
end;

procedure TSSMainForm.btnSrcDirClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := edtSrc.Text;
  if GetDirectory('', Dir, True) then
    edtSrc.Text := Dir;
end;

procedure TSSMainForm.btnDstDirClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := edtDst.Text;
  if GetDirectory('', Dir, True) then
    edtDst.Text := Dir;
end;

procedure TSSMainForm.FileCntProc(const FileName: string;
  const Info: TSearchRec; var Abort: Boolean);
begin
  Inc(FFileCnt);
  Abort := FAbort;
end;

procedure TSSMainForm.FileSyncProc(const FileName: string;
  const Info: TSearchRec; var Abort: Boolean);
var
  DstName: string;
begin
  if FAbort then
  begin
    Abort := True;
    Exit;
  end;

  DstName := FDstDir + Copy(FileName, Length(FSrcDir) + 1, MaxInt);
  if not FileExists(DstName) or (GetFileSize(FileName) <> GetFileSize(DstName))
    or (GetFileDateTime(FileName) <> GetFileDateTime(DstName)) then
  begin
    ForceDirectories(ExtractFileDir(DstName));
    FCurrMsg := '���ڸ���: ' + FileName;
    SetFileAttributes(PChar(DstName), FILE_ATTRIBUTE_NORMAL);  // ȥ��ֻ������
    DeleteFile(DstName); // ��ɾ���ļ��ٸ����Ա������Ժ����ڲ�ͬ
    CopyFile(PChar(FileName), PChar(DstName), False);
    Inc(FCopyCnt);
  end;

  Inc(FProcCnt);
end;

procedure TSSMainForm.DirDelProc(const SubDir: string);
begin
  if not DirectoryExists(FSrcDir + SubDir) then
  begin
    FCurrMsg := '����ɾ��: ' + FDstDir + SubDir;
    Deltree(FDstDir + SubDir);
    Inc(FDelCnt);
  end;
end;

procedure TSSMainForm.FileDelProc(const FileName: string;
  const Info: TSearchRec; var Abort: Boolean);
var
  SrcName: string;
begin
  if FAbort then
  begin
    Abort := True;
    Exit;
  end;

  SrcName := FSrcDir + Copy(FileName, Length(FDstDir) + 1, MaxInt);
  if not FileExists(SrcName) then
  begin
    FCurrMsg := '����ɾ��: ' + FileName;
    SetFileAttributes(PChar(FileName), FILE_ATTRIBUTE_NORMAL);
    DeleteFile(FileName);
    Inc(FDelCnt);
  end;
end;

end.
