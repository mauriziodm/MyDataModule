unit DT.MyDatamodule.Wizard;

interface

uses
  Classes, ToolsAPI;

resourcestring
  rsGalleryCategoryName = 'MyDM';  // the visible name of the category/page in the gallery in the File->New->Other form
  rsGalleryCategoryID = 'MyDM.Wizard'; // the unique ID (not visible) of the category/page of the gallery in the File->New->Other form
  rsWizardID = 'MyDM.Wizard.MyDatamodule'; // the unique ID of the wizard into the category/page of the gallery in File->New->Other->iORM
  rsWizardName = 'MyDataModule'; // the visible name of the wizard into the category/page of the gallery in the File->New->Other->iORM
  rsWizardComment = 'Create a new MyDataModule in the project'; // the comment of the wizard into the category/page of the gallery in the File->New->Other->iORM
  rsWizardAuthor = 'Maurizio Del Magno'; // the author of the wizard into the category/page of the gallery in the File->New->Other->iORM
  rsAncestorClassName = 'TMyDataModule'; // the name of the ancestor class

type

  TMyDatamoduleWizard = class(TNotifierObject, IOTAWizard, IOTARepositoryWizard, IOTARepositoryWizard60, IOTARepositoryWizard80, IOTAFormWizard)
  public
    constructor Create;
    // IOTAWizard
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
    // IOTARepositoryWizard
    function GetAuthor: string;
    function GetComment: string;
    function GetPage: string;
    function GetGlyph: Cardinal;
    // IOTARepositoryWizard80
    function GetGalleryCategory: IOTAGalleryCategory;
    function GetPersonality: string;
    function GetDesigner: string;
  end;

implementation

uses
  WinApi.Windows, DT.MyDataModule.Wizard.Creator, System.SysUtils,
  DT.Wizard.Utils;

{ TioViewModelWizard }

constructor TMyDatamoduleWizard.Create;
begin
  inherited Create;
  // Add the wizard gallery category
  TOTAUtils.AddGalleryCategory(rsGalleryCategoryID, rsGalleryCategoryName);
end;

function TMyDatamoduleWizard.GetGalleryCategory: IOTAGalleryCategory;
begin
  // Get the wizard gallery category
  Result := TOTAUtils.GetGalleryCategory(rsGalleryCategoryID);
end;

procedure TMyDatamoduleWizard.Execute;
begin
  // Given the Creator, create a new module of the implied type
  TOTAUtils.CreateWizardModule(TMyDataModulelWizardCreator.Create(rsAncestorClassName));
end;

function TMyDatamoduleWizard.GetAuthor: string;
begin
  Result := rsWizardAuthor;
end;

function TMyDatamoduleWizard.GetComment: string;
begin
  Result := rsWizardComment;
end;

function TMyDatamoduleWizard.GetDesigner: string;
begin
  Result := dAny;
end;

function TMyDatamoduleWizard.GetGlyph: Cardinal;
begin
  Result := 0 // 0 = use standard icon;
end;

function TMyDatamoduleWizard.GetIDString: string;
begin
  Result := rsWizardID;
end;

function TMyDatamoduleWizard.GetName: string;
begin
  Result := rsWizardName;
end;

function TMyDatamoduleWizard.GetPage: string;
begin
  Result := rsGalleryCategoryName;
end;

function TMyDatamoduleWizard.GetPersonality: string;
begin
  Result := sDelphiPersonality;
end;

function TMyDatamoduleWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

end.
