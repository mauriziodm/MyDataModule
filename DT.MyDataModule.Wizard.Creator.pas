unit DT.MyDataModule.Wizard.Creator;

interface

uses
  ToolsAPI;

resourcestring
  SImplFileName = 'S4YViewModel1';

type

  TMyDataModulelWizardCreator = class(TNotifierObject, IOTACreator, IOTAModuleCreator)
  private
    FAncestorName: String;
    FUnitName: String;
    FClassName: String;
    FFileName: String;
  public
    constructor Create(AAncestorName: String);
    // IOTACreator
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
    // IOTAModuleCreator
    function GetAncestorName: string;
    function GetImplFileName: string;
    function GetIntfFileName: string;
    function GetFormName: string;
    function GetMainForm: Boolean;
    function GetShowForm: Boolean;
    function GetShowSource: Boolean;
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    procedure FormCreated(const FormEditor: IOTAFormEditor);
  end;

  TMayDataModulelPasFileCreator = class(TInterfacedObject, IOTAFile)
  private
    FAncestorName: String;
    FUnitName: String;
    FClassName: String;
  public
    constructor Create(const AUnitName, AAncestorName, AClassName: String);
    function GetAge: TDateTime;
    function GetSource: string;
  end;

implementation

uses
  System.SysUtils, System.IOUtils, DT.Wizard.Utils, VCL.Dialogs;

{ TioViewModelWizardCreator }

constructor TMyDataModulelWizardCreator.Create(AAncestorName: String);
begin
  FAncestorName := AAncestorName;
  TOTAUtils.GetNewUnitAndClassName('', AAncestorName, FUnitName, FClassName, FFileName);
end;

procedure TMyDataModulelWizardCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
end;

function TMyDataModulelWizardCreator.GetAncestorName: string;
begin
  // If the name starts with "T" character (class) then skip the first char
  if FAncestorName.StartsWith('T') then
    Result := Copy(FAncestorName, 2, Length(FAncestorName))
  else
    Result := FAncestorName;
end;

function TMyDataModulelWizardCreator.GetCreatorType: string;
begin
  Result := sForm;
end;

function TMyDataModulelWizardCreator.GetExisting: Boolean;
begin
  Result := False;
end;

function TMyDataModulelWizardCreator.GetFileSystem: string;
begin
  Result := '';
end;

function TMyDataModulelWizardCreator.GetFormName: string;
begin
  // If the name starts with "T" character (class) then skip the first char
  if FClassName.StartsWith('T') then
    Result := Copy(FClassName, 2, Length(FClassName))
  else
    Result := FClassName;
end;

function TMyDataModulelWizardCreator.GetImplFileName: string;
begin
  // Should return the name of the implementation file (*.pas).
  // This must be fully qualified (ex: "drive:\path\filename.pas").
  // You can leave this blank to have the IDE create a new unique one for you.
  Result := FFileName;
end;

function TMyDataModulelWizardCreator.GetIntfFileName: string;
begin
  Result := '';
end;

function TMyDataModulelWizardCreator.GetMainForm: Boolean;
begin
  Result := False;
end;

function TMyDataModulelWizardCreator.GetOwner: IOTAModule;
begin
  Result := GetActiveProject;
end;

function TMyDataModulelWizardCreator.GetShowForm: Boolean;
begin
  Result := True;
end;

function TMyDataModulelWizardCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

function TMyDataModulelWizardCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

function TMyDataModulelWizardCreator.NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

function TMyDataModulelWizardCreator.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := TMayDataModulelPasFileCreator.Create(FUnitName, FAncestorName, FClassName);
end;

function TMyDataModulelWizardCreator.NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

{ TioViewModelPasFile }

constructor TMayDataModulelPasFileCreator.Create(const AUnitName, AAncestorName, AClassName: String);
begin
  inherited Create;
  FUnitName := AUnitName;
  FClassName := AClassName;
  FAncestorName := AAncestorName;
end;

function TMayDataModulelPasFileCreator.GetAge: TDateTime;
begin
  Result := -1;
end;

function TMayDataModulelPasFileCreator.GetSource: string;
begin
  // Template
  Result :=
    'unit $UNITNAME$;' + sLineBreak +
    sLineBreak +
    'interface' + sLineBreak +
    sLineBreak +
    'uses' + sLineBreak +
    '  System.SysUtils,' + sLineBreak +
    '  System.Classes,' + sLineBreak +
    '  U.MyDatamodule;' + sLineBreak +
    sLineBreak +
    'type' + sLineBreak +
    sLineBreak +
    '  $CLASSNAME$ = class($ANCESTORNAME$)' + sLineBreak +
    '  private' + sLineBreak +
    '    { Private declarations }' + sLineBreak +
    '  public' + sLineBreak +
    '    { Public declarations }' + sLineBreak +
    '  end;' + sLineBreak +
    sLineBreak +
    'implementation' + sLineBreak +
    sLineBreak +
    '{%CLASSGROUP ''System.Classes.TPersistent''}' + sLineBreak +
    sLineBreak +
    '{$R *.dfm}' + sLineBreak +
    sLineBreak +
    'end.';
  // Replace tags with real data
  Result := StringReplace(Result, '$UNITNAME$', FUnitName, [rfIgnoreCase, rfReplaceAll]);
  Result := StringReplace(Result, '$CLASSNAME$', FClassName, [rfIgnoreCase, rfReplaceAll]);
  Result := StringReplace(Result, '$ANCESTORNAME$', FAncestorName, [rfIgnoreCase, rfReplaceAll]);
end;

end.
