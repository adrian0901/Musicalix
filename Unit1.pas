{
Article: Your first MP3 Delphi player

http://delphi.about.com/library/weekly/aa112800a.htm

See how to build a full-blown mp3 player with Delphi
in just a few seconds. Even more: get the ID3 tag
information from a mp3 file and change it!

For the .zip file of this project click here.

}


unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, MPlayer, ComCtrls, ExtCtrls, VrControls, VrWheel,
  VrLcd, VrMatrix, VrHPTimerFunc, VrLevelBar, VrSpectrum, VrNavigator;

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
    procedure btnOpenFolderClick(Sender: TObject);
    procedure mp3ListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ProgresTimerTimer(Sender: TObject);
    procedure VrMediaButton1Click(Sender: TObject);
    procedure VrMediaButton2Click(Sender: TObject);
    procedure VrMediaButton3Click(Sender: TObject);
    procedure Quit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

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
   VrMatrix1.Text:='Wrong or no ID3 tag information';
 end else begin
   if ID3.Genre in [0..MaxID3Genre] then
     VrMatrix1.Text:=ID3.Title + ' by '+ID3.Artist+' from '+ID3.Album+' in year'+ID3.Year+' of '+ID3Genre[ID3.Genre]+' genre'
   else
     VrMatrix1.Text:=ID3.Title + ' by '+ID3.Artist+' from '+ID3.Album+' in year'+ID3.Year+' of unknown genre';
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

 mp3Folder := BrowseDialog('Choose a folder with mp3 files', BIF_RETURNONLYFSDIRS);
 if mp3Folder = '' then Exit;

 VRMatrix2.Text := mp3Folder;

 //fill the list box with mp3 files
 FillMP3FileList(mp3Folder, mp3List.Items);
end;

procedure TForm1.mp3ListClick(Sender: TObject);
 var mp3File:string;
begin
  if mp3List.Items.Count=0 then exit;
  mp3File := Concat(VRMatrix2.Text, mp3List.Items.Strings[mp3List.ItemIndex]);
  if not FileExists(mp3File) then begin
   ShowMessage('MP3 file '+#13#10+ mp3File +#13#10+'does not exist!');
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
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  VRMatrix2.Text := ExtractFilePath(Application.ExeName);
  FillMP3FileList(VRMatrix2.Text, mp3List.Items);
  VRLevelBar1.MaxValue:=0;
end;

procedure TForm1.ProgresTimerTimer(Sender: TObject);
begin
  if VRLevelBar1.MaxValue<>0 then
    if mp3player.Position > 0 then begin
    if VRLevelBar1.Position < VRLevelBar1.MaxValue then begin
    VrSpectrum1.Items[0].Position := Random(101);
    VrSpectrum1.Items[1].Position := Random(101);
    VrSpectrum1.Items[2].Position := Random(101);
    VrSpectrum1.Items[3].Position := Random(101);
    VrSpectrum1.Items[4].Position := Random(101);
    VrSpectrum1.Items[5].Position := Random(101);
    VrSpectrum1.Items[6].Position := Random(101);
    end;
    if VRLevelBar1.Position >= VRLevelBar1.MaxValue then begin
    VrSpectrum1.Items[0].Position := 0;
  VrSpectrum1.Items[1].Position := 0;
  VrSpectrum1.Items[2].Position := 0;
  VrSpectrum1.Items[3].Position := 0;
  VrSpectrum1.Items[4].Position := 0;
  VrSpectrum1.Items[5].Position := 0;
  VrSpectrum1.Items[6].Position := 0;
  end;
    end;
    VRLevelBar1.Position := mp3player.Position;
end;

procedure TForm1.VrMediaButton1Click(Sender: TObject);
begin
  mp3player.Play
end;

procedure TForm1.VrMediaButton2Click(Sender: TObject);
begin
  mp3player.PauseOnly;
  VrSpectrum1.Items[0].Position := 0;
  VrSpectrum1.Items[1].Position := 0;
  VrSpectrum1.Items[2].Position := 0;
  VrSpectrum1.Items[3].Position := 0;
  VrSpectrum1.Items[4].Position := 0;
  VrSpectrum1.Items[5].Position := 0;
  VrSpectrum1.Items[6].Position := 0;
end;

procedure TForm1.VrMediaButton3Click(Sender: TObject);
begin
  mp3player.Stop;
  mp3player.Position := 0;
  VrSpectrum1.Items[0].Position := 0;
  VrSpectrum1.Items[1].Position := 0;
  VrSpectrum1.Items[2].Position := 0;
  VrSpectrum1.Items[3].Position := 0;
  VrSpectrum1.Items[4].Position := 0;
  VrSpectrum1.Items[5].Position := 0;
  VrSpectrum1.Items[6].Position := 0;
end;

procedure TForm1.Quit(Sender: TObject);
begin
  Form1.Close;
end;

end.
