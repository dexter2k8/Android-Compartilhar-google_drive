- O arquivo DW.Androidapi.JNI.Provider.pas da biblioteca KastriFree deve ser atualizado para funcionar nas versões atuais do Android.
  A linha 28 que contém:
  [JavaSignature('android/support/v4/content/FileProvider')]
  Deve ser substituída por:
  [JavaSignature('androidx/core/content/FileProvider')]

- Em Project > Options > Application > Entitlement List
  Deve ser marcada como "true" a opção "Secure File Sharing"
  Isso incluirá automaticamente no AndroidManifest.xml a informação abaixo:

  <provider
  android:name="android.support.v4.content.FileProvider"
  android:authorities="com.embarcadero.myappname.fileprovider"
  android:exported="false"
  android:grantUriPermissions="true">
  <meta-data
    android:name="android.support.FILE_PROVIDER_PATHS"
    android:resource="@xml/provider_paths" />
  </provider>

  Este provedor é necessário para que as versões mais recentes do Android acessem o arquivo enviado.
  O provider-paths.xml também é criado e adicionado automaticamente ao Projects > Deployment.

  Esta aplicação possui a função "findMimeType" que identifica 
  automaticamente o tipo de arquivo aceito pela diretiva JIntent (exemplo abaixo).
  intent.setDataAndType(URI, StringToJString('FileType'));

  Para conhecimento, apenas os tipos de arquivo ('FileType') listados abaixo são aceitos:
  image/jpeg
  audio/mpeg4-generic
  text/html
  audio/mpeg
  audio/aac
  audio/wav
  audio/ogg
  audio/midi
  audio/x-ms-wma
  video/mp4
  video/x-msvideo
  video/x-ms-wmv
  image/png
  image/jpeg
  image/gif
  .xml ->text/xml
  .txt -> text/plain
  .cfg -> text/plain
  .csv -> text/plain
  .conf -> text/plain
  .rc -> text/plain
  .htm -> text/html
  .html -> text/html
  .pdf -> application/pdf
  .apk -> application/vnd.android.package-archive
