// mp3 player
// I don't even know how to name it
// (C) 2017 Adrian Makes Software

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MPlayer, ComCtrls, ExtCtrls, VrControls, VrWheel,
  VrLcd, VrMatrix, VrHPTimerFunc, VrLevelBar, VrSpectrum, VrNavigator,
  VrSystem, VrDisplay, VrSwitch, VrImageLed, MMSystem, VrLabel, ImgList,
  Menus, inifiles;

const
  MCI_SETAUDIO = $0873;
  MCI_DGV_SETAUDIO_VOLUME = $4002;
  MCI_DGV_SETAUDIO_ITEM = $00800000;
  MCI_DGV_SETAUDIO_VALUE = $01000000;
  MCI_DGV_STATUS_VOLUME = $4019;

type
  MCI_DGV_SETAUDIO_PARMS = record
    dwCallback: DWORD;
    dwItem: DWORD;
    dwValue: DWORD;
    dwOver: DWORD;
    lpstrAlgorithm: PChar;
    lpstrQuality: PChar;
  end;

type
  MCI_STATUS_PARMS = record
    dwCallback: DWORD;
    dwReturn: DWORD;
    dwItem: DWORD;
    dwTrack: DWORD;
  end;
  
type
  TForm1 = class(TForm)
    mp3player: TMediaPlayer;
    mp3List: TListBox;
    ProgresTimer: TTimer;
    VrWheel1: TVrWheel;
    VrMatrix1: TVrMatrix;
    VrMatrix2: TVrMatrix;
    VrSpectrum1: TVrSpectrum;
    VrLevelBar1: TVrLevelBar;
    VrMediaButton1: TVrMediaButton;
    VrMediaButton2: TVrMediaButton;
    VrMediaButton3: TVrMediaButton;
    VrMediaButton4: TVrMediaButton;
    VrMediaButton5: TVrMediaButton;
    VrMediaButton6: TVrMediaButton;
    VrMediaButton7: TVrMediaButton;
    VrMediaButton8: TVrMediaButton;
    VrMediaButton9: TVrMediaButton;
    VrWheel2: TVrWheel;
    VrRunOnce1: TVrRunOnce;
    VrDisplay1: TVrDisplay;
    VrImageLed1: TVrImageLed;
    VrImageLed2: TVrImageLed;
    VrSwitch1: TVrSwitch;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    VrClock1: TVrClock;
    Label4: TLabel;
    ImageList1: TImageList;
    VrTrayIcon1: TVrTrayIcon;
    PopupMenu1: TPopupMenu;
    Play1: TMenuItem;
    Pause1: TMenuItem;
    Stop1: TMenuItem;
    N1: TMenuItem;
    Back1: TMenuItem;
    Step1: TMenuItem;
    N2: TMenuItem;
    Prev1: TMenuItem;
    Next1: TMenuItem;
    N3: TMenuItem;
    Language1: TMenuItem;
    Skin1: TMenuItem;
    N4: TMenuItem;
    Close1: TMenuItem;
    About1: TMenuItem;
    procedure btnOpenFolderClick(Sender: TObject);
    procedure mp3ListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ProgresTimerTimer(Sender: TObject);
    procedure VrMediaButton1Click(Sender: TObject);
    procedure VrMediaButton2Click(Sender: TObject);
    procedure VrMediaButton3Click(Sender: TObject);
    procedure Quit(Sender: TObject);
    procedure VrMediaButton6Click(Sender: TObject);
    procedure VrMediaButton7Click(Sender: TObject);
    procedure ChangeSwitch(Sender: TObject);
    procedure VrMediaButton8Click(Sender: TObject);
    procedure VrMediaButton9Click(Sender: TObject);
    procedure ChangeLanguage(Sender: TObject);
    procedure ChangeSkin(Sender: TObject);
    procedure WriteDefaultSkin(Sender: TObject);
    procedure ShowInfo(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  playing: Integer;
  repeattype: Integer;
  mciopen: Integer;
  paused: Integer;
  last: Integer;
  bytext: string;
  fromtext: string;
  inyeartext: string;
  oftext: string;
  genretext: string;
  choosefoldertext: string;
  playtext: string;
  pausetext: string;
  stoptext: string;
  backtext: string;
  steptext: string;
  languagetext: string;
  skintext: string;
  closetext: string;
  formtext: string;
  prevtext: string;
  nexttext: string;
  offtext: string;
  repsongtext: string;
  replisttext: string;
  shuffletext: string;
  abouttext: string;

type
  TID3Rec = packed record
    Tag     : array[0..2] of Char;
    Title,
    Artist,
    Comment,
    Album   : array[0..29] of Char;
    Year    : array[0..3] of Char;
    Genre   : Byte;
  end;

const
  MaxID3Genre=147;
  ID3Genre: array[0..MaxID3Genre] of string = (
    'Blues', 'Classic Rock', 'Country', 'Dance', 'Disco', 'Funk', 'Grunge',
    'Hip-Hop', 'Jazz', 'Metal', 'New Age', 'Oldies', 'Other', 'Pop', 'R&B',
    'Rap', 'Reggae', 'Rock', 'Techno', 'Industrial', 'Alternative', 'Ska',
    'Death Metal', 'Pranks', 'Soundtrack', 'Euro-Techno', 'Ambient',
    'Trip-Hop', 'Vocal', 'Jazz+Funk', 'Fusion', 'Trance', 'Classical',
    'Instrumental', 'Acid', 'House', 'Game', 'Sound Clip', 'Gospel',
    'Noise', 'AlternRock', 'Bass', 'Soul', 'Punk', 'Space', 'Meditative',
    'Instrumental Pop', 'Instrumental Rock', 'Ethnic', 'Gothic',
    'Darkwave', 'Techno-Industrial', 'Electronic', 'Pop-Folk',
    'Eurodance', 'Dream', 'Southern Rock', 'Comedy', 'Cult', 'Gangsta',
    'Top 40', 'Christian Rap', 'Pop/Funk', 'Jungle', 'Native American',
    'Cabaret', 'New Wave', 'Psychadelic', 'Rave', 'Showtunes', 'Trailer',
    'Lo-Fi', 'Tribal', 'Acid Punk', 'Acid Jazz', 'Polka', 'Retro',
    'Musical', 'Rock & Roll', 'Hard Rock', 'Folk', 'Folk-Rock',
    'National Folk', 'Swing', 'Fast Fusion', 'Bebob', 'Latin', 'Revival',
    'Celtic', 'Bluegrass', 'Avantgarde', 'Gothic Rock', 'Progressive Rock',
    'Psychedelic Rock', 'Symphonic Rock', 'Slow Rock', 'Big Band',
    'Chorus', 'Easy Listening', 'Acoustic', 'Humour', 'Speech', 'Chanson',
    'Opera', 'Chamber Music', 'Sonata', 'Symphony', 'Booty Bass', 'Primus',
    'Porn Groove', 'Satire', 'Slow Jam', 'Club', 'Tango', 'Samba',
    'Folklore', 'Ballad', 'Power Ballad', 'Rhythmic Soul', 'Freestyle',
    'Duet', 'Punk Rock', 'Drum Solo', 'Acapella', 'Euro-House', 'Dance Hall',
    'Goa', 'Drum & Bass', 'Club-House', 'Hardcore', 'Terror', 'Indie',
    'BritPop', 'Negerpunk', 'Polsk Punk', 'Beat', 'Christian Gangsta Rap',
    'Heavy Metal', 'Black Metal', 'Crossover', 'Contemporary Christian',
    'Christian Rock', 'Merengue', 'Salsa', 'Trash Metal', 'Anime', 'Jpop',
    'Synthpop'  {and probably more to come}
  );

implementation

uses ShellAPI, ShlObj;  // needed for the BrowseForFolder function

{$R *.DFM}

procedure FillID3TagInformation(mp3File:string; VRMatrix1:TVRMatrix);
var //fMP3: file of Byte;
    ID3 : TID3Rec;
    fmp3: TFileStream;
begin
  fmp3:=TFileStream.Create(mp3File, fmOpenRead);
  try
    fmp3.position:=fmp3.size-128;
    fmp3.Read(ID3,SizeOf(ID3));
  finally
    fmp3.free;
  end;

 if ID3.Tag <> 'TAG' then begin
   VrMatrix1.Text:=mp3File;
 end else begin
   if ID3.Genre in [0..MaxID3Genre] then
     VrMatrix1.Text:=ID3.Title + bytext +ID3.Artist+fromtext+ID3.Album+inyeartext+ID3.Year+oftext+ID3Genre[ID3.Genre]+genretext
   else
     VrMatrix1.Text:=ID3.Title + bytext +ID3.Artist+fromtext+ID3.Album+inyeartext+ID3.Year+oftext+'unknown'+genretext
 end;
end;


procedure ChangeID3Tag(NewID3: TID3Rec; mp3FileName: string);
var
  fMP3: file of Byte;
  OldID3 : TID3Rec;
begin
  try
    AssignFile(fMP3, mp3FileName);
    Reset(fMP3);
    try
      Seek(fMP3, FileSize(fMP3) - 128);
      BlockRead(fMP3, OldID3, SizeOf(OldID3));
      if OldID3.Tag = 'TAG' then
        { Replace old tag }
        Seek(fMP3, FileSize(fMP3) - 128)
      else
        { Append tag to file because it doesn't exist }
        Seek(fMP3, FileSize(fMP3));
      BlockWrite(fMP3, NewID3, SizeOf(NewID3));
    finally
    end;
  finally
    CloseFile(fMP3);
  end;
end;


procedure FillMP3FileList(Folder: string; sl: TStrings);
var Rec : TSearchRec;
begin
 sl.Clear;
 if SysUtils.FindFirst(Folder + '*.mp3', faAnyFile, Rec) = 0 then
  try
    repeat
      sl.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
 if SysUtils.FindFirst(Folder + '*.wma', faAnyFile, Rec) = 0 then
  try
    repeat
      sl.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
 if SysUtils.FindFirst(Folder + '*.mid', faAnyFile, Rec) = 0 then
  try
    repeat
      sl.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
  if SysUtils.FindFirst(Folder + '*.midi', faAnyFile, Rec) = 0 then
  try
    repeat
      sl.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
  if SysUtils.FindFirst(Folder + '*.rmi', faAnyFile, Rec) = 0 then
  try
    repeat
      sl.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
  if SysUtils.FindFirst(Folder + '*.wav', faAnyFile, Rec) = 0 then
  try
    repeat
      sl.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
  if SysUtils.FindFirst(Folder + '*.kar', faAnyFile, Rec) = 0 then
  try
    repeat
      sl.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
end;

function BrowseDialog(const Title: string; const Flag: integer): string;
var
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
begin
  Result:='';
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  with BrowseInfo do begin
    hwndOwner := Application.Handle;
    pszDisplayName := @DisplayName;
    lpszTitle := PChar(Title);
    ulFlags := Flag;
  end;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result := IncludeTrailingBackslash(TempPath);
    GlobalFreePtr(lpItemID);
  end;
end;


procedure TForm1.btnOpenFolderClick(Sender: TObject);
var mp3Folder : string;
begin

 mp3Folder := BrowseDialog(choosefoldertext, BIF_RETURNONLYFSDIRS);
 if mp3Folder = '' then Exit;

 VRMatrix2.Text := mp3Folder;

 //fill the list box with mp3 files
 FillMP3FileList(mp3Folder, mp3List.Items);
end;

procedure TForm1.mp3ListClick(Sender: TObject);
 var mp3File:string;
begin
  if mp3List.Items.Count=0 then exit;
  if mp3List.ItemIndex <> last then begin;
  mp3File := Concat(VRMatrix2.Text, mp3List.Items.Strings[mp3List.ItemIndex]);
  end;
  if not FileExists(mp3File) then begin
   exit;
  end;

  FillID3TagInformation(mp3File, VRMatrix1);

  VRLevelBar1.MaxValue:=0;

  mp3player.Close;
  mp3player.FileName:=mp3File;
  mp3player.Open;

  VRLevelBar1.MaxValue := mp3player.Length;
  VrSpectrum1.Items[0].Position := 0;
  VrSpectrum1.Items[1].Position := 0;
  VrSpectrum1.Items[2].Position := 0;
  VrSpectrum1.Items[3].Position := 0;
  VrSpectrum1.Items[4].Position := 0;
  VrSpectrum1.Items[5].Position := 0;
  VrSpectrum1.Items[6].Position := 0;
  mciopen := 1;
  last := mp3List.ItemIndex;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  VRMatrix2.Text := ExtractFilePath(Application.ExeName);
  FillMP3FileList(VRMatrix2.Text, mp3List.Items);
  VRLevelBar1.MaxValue:=0;
  paused := 1;
  bytext := ' by ';
  fromtext := ' from ';
  inyeartext := ' in year ';
  oftext := ' of ';
  genretext := ' genre ';
  choosefoldertext := 'Choose a folder with mp3 files';
end;

procedure SetMPVolume(MP: TMediaPlayer; Volume: Integer);
  { Volume: 0 - 1000 }
var
  p: MCI_DGV_SETAUDIO_PARMS;
begin
  { Volume: 0 - 1000 }
  p.dwCallback := 0;
  p.dwItem := MCI_DGV_SETAUDIO_VOLUME;
  p.dwValue := Volume;
  p.dwOver := 0;
  p.lpstrAlgorithm := nil;
  p.lpstrQuality := nil;
  mciSendCommand(MP.DeviceID, MCI_SETAUDIO,
    MCI_DGV_SETAUDIO_VALUE or MCI_DGV_SETAUDIO_ITEM, Cardinal(@p));
end;

procedure TForm1.ProgresTimerTimer(Sender: TObject);
  var
  myDate : TDateTime;
 myHour, myMin, mySec, myMilli : Word;
begin
  myDate := Now;
  DecodeTime(myDate, myHour, myMin, mySec, myMilli);
  VrClock1.Hours := myHour;
  VrClock1.Minutes := myMin;
  SetMPVolume(mp3player, VrWheel2.Position);
  if repeattype = 0 then begin
    VrImageLed1.Active := False;
    VrImageLed2.Active := False;
  end;
  if repeattype = 1 then begin
     VrImageLed1.Active := True;
    VrImageLed2.Active := False;
  end;
  if repeattype = 2 then begin
    VrImageLed1.Active := True;
    VrImageLed2.Active := True;
  end;
  if repeattype = 3 then begin
    VrImageLed1.Active := False;
    VrImageLed2.Active := True;
  end;
  if mciopen = 1 then begin
  if VRLevelBar1.MaxValue<>0 then
    if mp3player.Position > 0 then begin
    if VRLevelBar1.Position < VRLevelBar1.MaxValue then begin
    if paused = 0 then begin
    VrSpectrum1.Items[0].Position := Random(VrWheel2.Position);
    VrSpectrum1.Items[1].Position := Random(VrWheel2.Position);
    VrSpectrum1.Items[2].Position := Random(VrWheel2.Position);
    VrSpectrum1.Items[3].Position := Random(VrWheel2.Position);
    VrSpectrum1.Items[4].Position := Random(VrWheel2.Position);
    VrSpectrum1.Items[5].Position := Random(VrWheel2.Position);
    VrSpectrum1.Items[6].Position := Random(VrWheel2.Position);
    end;
    end;
    if VRLevelBar1.Position >= VRLevelBar1.MaxValue then begin
    VrSpectrum1.Items[0].Position := 0;
  VrSpectrum1.Items[1].Position := 0;
  VrSpectrum1.Items[2].Position := 0;
  VrSpectrum1.Items[3].Position := 0;
  VrSpectrum1.Items[4].Position := 0;
  VrSpectrum1.Items[5].Position := 0;
  VrSpectrum1.Items[6].Position := 0;
      if repeattype = 1 then begin
      mp3player.Position := 0;
      mp3player.Play;
      end;
      if repeattype = 3 then begin
      mp3List.ItemIndex := random(mp3List.Count);
      Form1.mp3ListClick(self);
      mp3Player.Position := 0;
      mp3Player.Play;
      end;
      if (repeattype <> 1) and (repeattype <> 3) then begin
      if mp3List.ItemIndex < mp3List.Count-1 then begin
   mp3List.ItemIndex := mp3List.ItemIndex + 1;
    Form1.mp3ListClick(self);
    mp3Player.Position := 0;
    mp3Player.Play;
    end;
      if repeattype = 2 then begin
      if mp3List.ItemIndex >= mp3List.Count-1 then begin
  mp3List.ItemIndex := 0;
  Form1.mp3ListClick(self);
  mp3Player.Position := 0;
  mp3Player.Play;
  end;
  end;
      end;
  end;
    end;
    VRLevelBar1.Position := mp3player.Position;
  end;
end;

procedure TForm1.VrMediaButton1Click(Sender: TObject);
begin
  if mciopen = 1 then begin
  mp3player.Play;
  paused := 0;
  end
end;

procedure TForm1.VrMediaButton2Click(Sender: TObject);
begin
  if mciopen = 1 then begin
  mp3player.PauseOnly;
  paused := 1;
  VrSpectrum1.Items[0].Position := 0;
  VrSpectrum1.Items[1].Position := 0;
  VrSpectrum1.Items[2].Position := 0;
  VrSpectrum1.Items[3].Position := 0;
  VrSpectrum1.Items[4].Position := 0;
  VrSpectrum1.Items[5].Position := 0;
  VrSpectrum1.Items[6].Position := 0;
  end
end;

procedure TForm1.VrMediaButton3Click(Sender: TObject);
begin
  if mciopen = 1 then begin
  mp3player.Stop;
  mp3player.Position := 0;
  paused := 0;
  VrSpectrum1.Items[0].Position := 0;
  VrSpectrum1.Items[1].Position := 0;
  VrSpectrum1.Items[2].Position := 0;
  VrSpectrum1.Items[3].Position := 0;
  VrSpectrum1.Items[4].Position := 0;
  VrSpectrum1.Items[5].Position := 0;
  VrSpectrum1.Items[6].Position := 0;
  end;
end;

procedure TForm1.Quit(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.VrMediaButton6Click(Sender: TObject);
begin
  if mciopen = 1 then begin
  mp3player.Position := mp3player.Position - Round(mp3player.Length/20);
  if paused = 0 then begin
  mp3player.Play;
  end;
  end;
end;

procedure TForm1.VrMediaButton7Click(Sender: TObject);
begin
  if mciopen = 1 then begin
  mp3player.Position := mp3player.Position + Round(mp3player.Length/20);
  if paused = 0 then begin
  mp3player.Play;
  end;
  end;
end;

procedure TForm1.ChangeSwitch(Sender: TObject);
begin
  if VrSwitch1.Offset = 0 then begin
    repeattype := 0;
  end;
  if VrSwitch1.Offset = 1 then begin
    repeattype := 1;
  end;
  if VrSwitch1.Offset = 2 then begin
    repeattype := 2;
  end;
  if VrSwitch1.Offset = 3 then begin
    repeattype := 3;
  end;
end;

procedure TForm1.VrMediaButton8Click(Sender: TObject);
begin
  if mp3player.Position < 1500 then begin
  if mp3List.ItemIndex > 0 then begin
  mp3List.ItemIndex := mp3List.ItemIndex - 1;
  Form1.mp3ListClick(self);
  mp3Player.Position := 0;
  mp3Player.Play;
  end;
  end;
  if mp3player.Position >= 1500 then begin
  mp3player.Position := 0;
  if paused = 0 then begin
  mp3Player.Play
  end;
  end;
end;

procedure TForm1.VrMediaButton9Click(Sender: TObject);
begin
  if mp3List.ItemIndex < mp3List.Count-1 then begin
  mp3List.ItemIndex := mp3List.ItemIndex + 1;
  Form1.mp3ListClick(self);
  mp3Player.Position := 0;
  mp3Player.Play;
  end;
end;

procedure TForm1.ChangeLanguage(Sender: TObject);
var
  opendialog: topendialog;
  ini: TIniFile;
begin
  // Create the open dialog object - assign to our open dialog variable
  openDialog := TOpenDialog.Create(self);

  // Set up the starting directory to be the current one
  openDialog.InitialDir := GetCurrentDir;

  // Only allow existing files to be selected
  openDialog.Options := [ofFileMustExist];

  // Allow only .ini files to be selected
  openDialog.Filter :=
    'INI|*.ini';

  // Display the open file dialog
  if openDialog.Execute
  then begin
  ini := TIniFile.Create(openDialog.FileName);
  bytext := ini.ReadString('FlavorText', 'By', 'By');
  fromtext := ini.ReadString('FlavorText', 'From', 'From');
  inyeartext := ini.ReadString('FlavorText', 'InYear', 'In year');
  oftext := ini.ReadString('FlavorText', 'Of', 'Of');
  genretext := ini.ReadString('FlavorText', 'Genre', 'Genre');
  choosefoldertext:= ini.ReadString('WindowText', 'ChooseFolder', 'Choose a folder with mp3 files');
  formtext := ini.ReadString('WindowText', 'FormText', 'Musicalix');
  playtext := ini.ReadString('OptionText', 'Play', 'Play');
  pausetext := ini.ReadString('OptionText', 'Pause', 'Pause');
  stoptext := ini.ReadString('OptionText', 'Stop', 'Stop');
  backtext := ini.ReadString('OptionText', 'Back', 'Back');
  steptext := ini.ReadString('OptionText', 'Step', 'Step');
  prevtext := ini.ReadString('OptionText', 'Prev', 'Prev');
  nexttext := ini.ReadString('OptionText', 'Next', 'Next');
  offtext := ini.ReadString('SliderText', 'Off', 'Off');
  languagetext := ini.ReadString('OptionText', 'Language', 'Language...');
  skintext := ini.ReadString('OptionText', 'Skin', 'Skin...');
  closetext := ini.ReadString('OptionText', 'Close', 'Close');
  repsongtext := ini.ReadString('SliderText', 'RepSong', 'Repeat song');
  replisttext := ini.ReadString('SliderText', 'RepList', 'Repeat list');
  shuffletext := ini.ReadString('SliderText', 'Shuffle', 'Shuffle');
  abouttext := ini.ReadString('OptionText', 'About', 'About');
  Form1.Caption := formtext;
  Play1.Caption := playtext;
  Pause1.Caption := pausetext;
  Stop1.Caption := stoptext;
  Back1.Caption := backtext;
  Step1.Caption := steptext;
  Prev1.Caption := prevtext;
  Next1.Caption := nexttext;
  Language1.Caption := languagetext;
  Skin1.Caption := skintext;
  Close1.Caption := closetext;
  Label1.Caption := offtext;
  Label2.Caption := repsongtext;
  Label3.Caption := replisttext;
  Label4.Caption := shuffletext;
  About1.Caption := abouttext;

  end;

  // Free up the dialog
  openDialog.Free;
end;

procedure TForm1.ChangeSkin(Sender: TObject);
var
  opendialog: topendialog;
  ini: TIniFile;
begin
  // Create the open dialog object - assign to our open dialog variable
  openDialog := TOpenDialog.Create(self);

  // Set up the starting directory to be the current one
  openDialog.InitialDir := GetCurrentDir;

  // Only allow existing files to be selected
  //openDialog.Options := [ofFileMustExist];

  // Allow only .ini files to be selected
  openDialog.Filter :=
    'INI|*.ini';

  // Display the open file dialog
  if openDialog.Execute
  then begin
  ini := TIniFile.Create(openDialog.FileName);
  VRMatrix1.Color := ini.ReadInteger('CustomSkin','LCDColor',16711680) ;
  VRMatrix2.Color := ini.ReadInteger('CustomSkin','LCDColor',16711680) ;
  mp3List.Color := ini.ReadInteger('CustomSkin','LCDColor',16711680) ;
  VRDisplay1.Color := ini.ReadInteger('CustomSkin','LCDColor',16711680) ;
  VRImageLed1.Color := ini.ReadInteger('CustomSkin','LCDColor',16711680) ;
  VRImageLed2.Color := ini.ReadInteger('CustomSkin','LCDColor',16711680) ;
  VRClock1.Color := ini.ReadInteger('CustomSkin','LCDColor',16711680) ;
  VRLevelBar1.Color := ini.ReadInteger('CustomSkin','LCDColor',16711680) ;
  VRLevelBar1.Palette1.High := ini.ReadInteger('CustomSkin','Bar1PH',16711680) ;
  VRLevelBar1.Palette1.Low := ini.ReadInteger('CustomSkin','Bar1PL',16711680) ;
  VRLevelBar1.Palette2.High := ini.ReadInteger('CustomSkin','Bar2PH',16711680) ;
  VRLevelBar1.Palette2.Low := ini.ReadInteger('CustomSkin','Bar2PL',16711680) ;
  VRLevelBar1.Palette3.High := ini.ReadInteger('CustomSkin','Bar3PH',16711680) ;
  VRLevelBar1.Palette3.Low := ini.ReadInteger('CustomSkin','Bar3PL',16711680) ;
  VrMatrix1.Palette.High := ini.ReadInteger('CustomSkin','LCDHigh',16711680) ;
  VrMatrix1.Palette.Low := ini.ReadInteger('CustomSkin','LCDLow',16711680) ;
  VrMatrix2.Palette.High := ini.ReadInteger('CustomSkin','LCDHigh',16711680) ;
  VrMatrix2.Palette.Low := ini.ReadInteger('CustomSkin','LCDLow',16711680) ;
  VrImageLed1.Palette.High := ini.ReadInteger('CustomSkin','LCDHigh',16711680) ;
  VrImageLed1.Palette.Low := ini.ReadInteger('CustomSkin','LCDLow',16711680) ;
  VrImageLed2.Palette.High := ini.ReadInteger('CustomSkin','LCDHigh',16711680) ;
  VrImageLed2.Palette.Low := ini.ReadInteger('CustomSkin','LCDLow',16711680) ;
  VrClock1.Palette.High := ini.ReadInteger('CustomSkin','LCDHigh',16711680) ;
  VrClock1.Palette.Low := ini.ReadInteger('CustomSkin','LCDLow',16711680) ;
  VrSpectrum1.MarkerColor := ini.ReadInteger('CustomSkin','SpectrumMarker',16711680) ;
  VrSpectrum1.Color := ini.ReadInteger('CustomSkin','SpectrumColor',16711680) ;
  VRSpectrum1.Palette1.High := ini.ReadInteger('CustomSkin','Spec1PH',16711680) ;
  VRSpectrum1.Palette1.Low := ini.ReadInteger('CustomSkin','Spec1PL',16711680) ;
  VRSpectrum1.Palette2.High := ini.ReadInteger('CustomSkin','Spec2PH',16711680) ;
  VRSpectrum1.Palette2.Low := ini.ReadInteger('CustomSkin','Spec2PL',16711680) ;
  VRSpectrum1.Palette3.High := ini.ReadInteger('CustomSkin','Spec3PH',16711680) ;
  VRSpectrum1.Palette3.Low := ini.ReadInteger('CustomSkin','Spec3PL',16711680) ;

  end;

  // Free up the dialog
  openDialog.Free;
end;

procedure TForm1.WriteDefaultSkin(Sender: TObject);
var
  opendialog: topendialog;
  ini: TIniFile;
begin
  // Create the open dialog object - assign to our open dialog variable
  openDialog := TOpenDialog.Create(self);

  // Set up the starting directory to be the current one
  openDialog.InitialDir := GetCurrentDir;

  // Only allow existing files to be selected
  //openDialog.Options := [ofFileMustExist];

  // Allow only .ini files to be selected
  openDialog.Filter :=
    'INI|*.ini';

  // Display the open file dialog
  if openDialog.Execute
  then begin
  ini := TIniFile.Create(openDialog.FileName);
  ini.WriteInteger('CustomSkin','LCDColor',VRMatrix1.Color) ;
  ini.WriteInteger('CustomSkin','Bar1PH',VRLevelBar1.Palette1.High) ;
  ini.WriteInteger('CustomSkin','Bar1PL',VRLevelBar1.Palette1.Low) ;
  ini.WriteInteger('CustomSkin','Bar2PH',VRLevelBar1.Palette2.High) ;
  ini.WriteInteger('CustomSkin','Bar2PL',VRLevelBar1.Palette2.Low) ;
  ini.WriteInteger('CustomSkin','Bar3PH',VRLevelBar1.Palette3.High) ;
  ini.WriteInteger('CustomSkin','Bar3PL',VRLevelBar1.Palette3.Low) ;
  ini.WriteInteger('CustomSkin','LCDHigh',VrMatrix1.Palette.High) ;
  ini.WriteInteger('CustomSkin','LCDLow',VrMatrix1.Palette.Low) ;
  ini.WriteInteger('CustomSkin','SpectrumMarker',VrSpectrum1.MarkerColor) ;
  ini.WriteInteger('CustomSkin','SpectrumColor',VrSpectrum1.Color) ;
  ini.WriteInteger('CustomSkin','Spec1PH',VRSpectrum1.Palette1.High) ;
  ini.WriteInteger('CustomSkin','Spec1PL',VRSpectrum1.Palette1.Low) ;
  ini.WriteInteger('CustomSkin','Spec2PH',VRSpectrum1.Palette2.High) ;
  ini.WriteInteger('CustomSkin','Spec2PL',VRSpectrum1.Palette2.Low) ;
  ini.WriteInteger('CustomSkin','Spec3PH',VRSpectrum1.Palette3.High) ;
  ini.WriteInteger('CustomSkin','Spec3PL',VRSpectrum1.Palette3.Low) ;

  end;

  // Free up the dialog
  openDialog.Free;
end;

procedure TForm1.ShowInfo(Sender: TObject);
begin
  ShowMessage('(C) 2017 Musicalix Community. Fork me on https://github.com/adrian0901/Musicalix');
  ShowMessage('Russian translation by infraGem');
end;

end.
