unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,

  System.IOUtils
  {$IFDEF ANDROID}
  ,Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
  Androidapi.JNI.Webkit,
  Androidapi.JNIBridge,
  DW.Androidapi.JNI.FileProvider
  {$ENDIF}


  ;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    {$IFDEF Android}
      function findMimeType (file_extension : string) : JString;
    {$ENDIF}
  public
    { Public declarations }
    procedure ShareFile(FileName: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
    file_name : string;
    a_file : TextFile;
begin

   file_name := System.IOUtils.TPath.GetTempPath +
        System.IOUtils.TPath.DirectorySeparatorChar + 'text_file.txt';

    // open a file for writing
    AssignFile (a_file, file_name);
    ReWrite (a_file);

    // write to a file
    WriteLn (a_file, 'share a text file on a mobile device');

    // close the file
    CloseFile (a_file);

    ShareFile (file_name);
end;
function TForm1.findMimeType(file_extension: string): JString;
begin
    file_extension := StringReplace (file_extension, '.', '', []);
    result := TJMimeTypeMap.JavaClass.getSingleton.getMimeTypeFromExtension
        (StringToJString (file_extension));
end;

procedure TForm1.ShareFile(FileName: string);
var
  {$IFDEF ANDROID}
   an_intent: JIntent;
   FileUri: Jnet_Uri;
   lFile: JFile;
  {$ENDIF}
begin
   {$IFDEF Android}
    an_intent := TJIntent.Create;
    //an_intent.setAction (TJIntent.JavaClass.ACTION_VIEW);
    an_intent.setAction (TJIntent.JavaClass.ACTION_SEND);
    an_intent.setFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
    //an_intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString('Mensagem compartilhada para postar no Whatsapp'));
    //an_intent.setPackage(StringToJString('com.whatsapp'));
    lFile := TJFile.JavaClass.init(StringToJString(FileName));
    FileUri := TJFileProvider.JavaClass.getUriForFile(TAndroidHelper.Context,
      StringToJString(JStringToString(TAndroidHelper.Context.getApplicationContext.getPackageName) + '.fileprovider'), lFile);
    an_intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, TJParcelable.Wrap((FileUri as ILocalObject).GetObjectID));
    an_intent.setDataAndType (FileUri,findMimeType (TPath.GetExtension (FileName)));
    TAndroidHelper.Activity.startActivity(an_intent);
  {$ENDIF}
end;

end.
