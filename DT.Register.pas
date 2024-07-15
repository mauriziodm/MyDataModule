unit DT.Register;

interface

procedure Register;

implementation

uses
  ToolsAPI,
  DesignIntf,
  DesignEditors,
  System.Classes,
  DT.MyDataModule.Wizard,
  U.MyDataModule;

procedure Register;
begin
  // IDE Wizards
  RegisterPackageWizard(TMyDatamoduleWizard.Create);
  RegisterCustomModule(TMyDataModule, TCustomModule);
end;

end.
