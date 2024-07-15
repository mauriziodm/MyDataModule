unit DT.Wizard.Utils;

interface

uses
  ToolsAPI;

type

  TOTAUtils = class
  public
    class function GetModuleServices(const ACheckIfThereIsAcActiveProject: Boolean): IOTAModuleServices;
    class procedure CreateWizardModule(const ACreator: IOTACreator);
    class procedure GetNewUnitAndClassName(AUnitNamePrefixOrEmpty, AClassNamePrefixOrEmpty: String; var AUnitName, AClassName, AFileName: string);
    class procedure AddGalleryCategory(const AGalleryCategoryID, AGalleryCategoryName: String);
    class function GetGalleryCategory(const AGalleryCategoryID: String): IOTAGalleryCategory;
  end;

implementation

uses
  System.SysUtils;

{ TioOTAUtils }

class procedure TOTAUtils.AddGalleryCategory(const AGalleryCategoryID, AGalleryCategoryName: String);
var
  LGalleryCategoryManager: IOTAGalleryCategoryManager;
  LGalleryCategoryRoot: IOTAGalleryCategory;
  LGalleryCategory: IOTAGalleryCategory;
begin
  // Extract the gallery category manager
  LGalleryCategoryManager := (BorlandIDEServices as IOTAGalleryCategoryManager);
  if not Assigned(LGalleryCategoryManager) then
    raise Exception.Create('TioOTAUtils.AddGalleryCategory: LGalleryCategoryManager not assigned.');
  // Get the root gallery category
  LGalleryCategoryRoot := LGalleryCategoryManager.FindCategory(sCategoryDelphiNew);
  if not Assigned(LGalleryCategoryRoot) then
    raise Exception.Create('TioOTAUtils.AddGalleryCategory: LGalleryCategoryRoot not assigned.');
  // Add a new gallery category for the wizard
  LGalleryCategory := LGalleryCategoryManager.AddCategory(LGalleryCategoryRoot, AGalleryCategoryID, AGalleryCategoryName);
  if not Assigned(LGalleryCategory) then
    raise Exception.Create('TioOTAUtils.AddGalleryCategory: LGalleryCategory not assigned.');
end;

class procedure TOTAUtils.CreateWizardModule(const ACreator: IOTACreator);
var
  LModuleServices: IOTAModuleServices;
begin
  // Extract the IOTAModuleService interface
  LModuleServices := Self.GetModuleServices(True);
  // Given the Creator, create a new module of the implied type
  LModuleServices.CreateModule(ACreator);
end;

class function TOTAUtils.GetGalleryCategory(const AGalleryCategoryID: String): IOTAGalleryCategory;
var
  LGalleryCategoryManager: IOTAGalleryCategoryManager;
  LGalleryCategory: IOTAGalleryCategory;
begin
  // Extract the gallery category manager
  LGalleryCategoryManager := (BorlandIDEServices as IOTAGalleryCategoryManager);
  if not Assigned(LGalleryCategoryManager) then
    raise Exception.Create('TioOTAUtils.AddGalleryCategory: LGalleryCategoryManager not assigned.');
  // Get the gallery category for the wizard and return it
  LGalleryCategory := LGalleryCategoryManager.FindCategory(AGalleryCategoryID);
  if not Assigned(LGalleryCategory) then
    raise Exception.Create('TioOTAUtils.AddGalleryCategory: LGalleryCategory not assigned.');
  // Return the galery category
  Result := LGalleryCategory;
end;

class function TOTAUtils.GetModuleServices(const ACheckIfThereIsAcActiveProject: Boolean): IOTAModuleServices;
var
  LModuleServices: IOTAModuleServices;
begin
  // Extract the IOTAModuleService interface
  if not Assigned(BorlandIDEServices) then
    raise Exception.Create('TioOTAUtils.GetIOTAModuleServices: BorlandIDEServices not assigned.');
  if not Supports(BorlandIDEServices, IOTAModuleServices, LModuleServices) then
    raise Exception.Create('TioOTAUtils.GetIOTAModuleServices: IOTAModuleServices interfaces not implemented by BorlandIDEServices.');
  // Check if there is an active project
  if ACheckIfThereIsAcActiveProject and not Assigned(LModuleServices.GetActiveProject) then
    raise Exception.Create('TioOTAUtils.GetIOTAModuleServices: There is no active project.');
  // Return the ModuleService
  Result := LModuleServices;
end;

class procedure TOTAUtils.GetNewUnitAndClassName(AUnitNamePrefixOrEmpty, AClassNamePrefixOrEmpty: String; var AUnitName, AClassName, AFileName: string);
var
  LModuleServices: IOTAModuleServices;
begin
  // Get module services
  LModuleServices := Self.GetModuleServices(True);
  // Get AUnitNname and AFileName (AClassName is always empty I don't know why)
  LModuleServices.GetNewModuleAndClassName(AUnitNamePrefixOrEmpty, AUnitName, AClassName, AFileName);
  // Set the class name (get the progressive number from AUnitName)
  if AClassNamePrefixOrEmpty.IsEmpty and not AUnitNamePrefixOrEmpty.IsEmpty then
    AClassNamePrefixOrEmpty := 'T' + AUnitNamePrefixOrEmpty;
  if AUnitNamePrefixOrEmpty.IsEmpty then
    AUnitNamePrefixOrEmpty := 'Unit';
  AClassName := AClassNamePrefixOrEmpty + Copy(AUnitName, Length(AUnitNamePrefixOrEmpty)+1, Length(AUnitName));
end;

end.
