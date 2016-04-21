{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     中国人自己的开放源码第三方开发包                         }
{                   (C)Copyright 2001-2008 CnPack 开发组                       }
{                   ------------------------------------                       }
{                                                                              }
{            本开发包是开源的自由软件，您可以遵照 CnPack 的发布协议来修        }
{        改和重新发布这一程序。                                                }
{                                                                              }
{            发布这一开发包的目的是希望它有用，但没有任何担保。甚至没有        }
{        适合特定目的而隐含的担保。更详细的情况请参阅 CnPack 发布协议。        }
{                                                                              }
{            您应该已经和开发包一起收到一份 CnPack 发布协议的副本。如果        }
{        还没有，可访问我们的网站：                                            }
{                                                                              }
{            网站地址：http://www.cnpack.org                                   }
{            电子邮件：master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit SSMainFrm;
{ |<PRE>
================================================================================
* 软件名称：文件夹智能同步工具
* 单元名称：主窗体单元
* 单元作者：周劲羽 (zjy@cnpack.org)
* 备    注：
* 开发平台：PWinXP SP3 + Delphi 7.1
* 兼容测试：
* 本 地 化：该单元中的字符串暂不符合本地化处理方式
* 单元标识：$Id: $
* 修改记录：2008.10.24 V1.0
*               创建单元
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
    ErrorDlg('源文件夹不存在！')
  else if not DirectoryExists(edtDst.Text) then
    ErrorDlg('目标文件夹不存在！')
  else if SameText(Trim(edtSrc.Text), Trim(edtDst.Text)) then
    ErrorDlg('源文件夹与目标文件夹不能相同！')
  else if AnsiPos(UpperCase(Trim(edtSrc.Text)), UpperCase(Trim(edtDst.Text))) = 1 then
    ErrorDlg('目标文件夹不能是源文件夹的子目录！')
  else if AnsiPos(UpperCase(Trim(edtDst.Text)), UpperCase(Trim(edtSrc.Text))) = 1 then
    ErrorDlg('源文件夹不能是目标文件夹的子目录！')
  else
  begin
    with ListView.Items.Add do
    begin
      Caption := IntToStr(Index + 1);
      SubItems.Add(edtSrc.Text);
      SubItems.Add(edtDst.Text);
      if chkIncSub.Checked then
        SubItems.Add('包含')
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
  if QueryDlg('确认要清空吗？') then
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
    FAbort := QueryDlg('是否中断处理？');
  end
  else
  begin
    ControlSetEnabled(False);
    FExecuting := True;
    FAbort := False;
    pb1.Position := 0;
    btnExecute.Caption := '中断(&I)';
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
        FCurrMsg := '正在统计: ' + FSrcDir;
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
        // 先删除目标目录中的旧文件
        FCurrMsg := '正在处理: ' + FSrcDir;
        FindFile(FDstDir, '*.*', FileDelProc, DirDelProc,
          ListView.Items[i].SubItems[2] <> '', True);
        // 再复制源目录中的新文件
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
      btnExecute.Caption := '同步(&I)';
      if not FAbort then
        InfoDlg(Format('文件夹同步完成，共更新文件 %d 个，删除旧文件(夹) %d 个！',
          [FCopyCnt, FDelCnt]));
    end;
  end;
end;

procedure TSSMainForm.btnAboutClick(Sender: TObject);
begin
  InfoDlg(Caption + #13#10#13#10 +
    '该软件用于同步多个目录中的文件。同步后的目标文件夹'#13#10 +
    '将与源文件夹内容完全一致。同步更新时自动复制源文件'#13#10 +
    '夹中大小或日期变更过的文件，并删除目标文件夹中不存'#13#10 +
    '在于源文件夹的文件和目录。'#13#10#13#10 +
    '软件作者 周劲羽 (zjy@cnpack.org)'#13#10 +
    '版权所有 (C)2001-2008 CnPack 开发组');
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
  lbl4.Caption := Format('已用 %s 剩余 %s', [TimeToStr(t1), TimeToStr(t2)]);
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
    FCurrMsg := '正在复制: ' + FileName;
    SetFileAttributes(PChar(DstName), FILE_ATTRIBUTE_NORMAL);  // 去掉只读属性
    DeleteFile(DstName); // 先删除文件再复制以避免属性和日期不同
    CopyFile(PChar(FileName), PChar(DstName), False);
    Inc(FCopyCnt);
  end;

  Inc(FProcCnt);
end;

procedure TSSMainForm.DirDelProc(const SubDir: string);
begin
  if not DirectoryExists(FSrcDir + SubDir) then
  begin
    FCurrMsg := '正在删除: ' + FDstDir + SubDir;
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
    FCurrMsg := '正在删除: ' + FileName;
    SetFileAttributes(PChar(FileName), FILE_ATTRIBUTE_NORMAL);
    DeleteFile(FileName);
    Inc(FDelCnt);
  end;
end;

end.
