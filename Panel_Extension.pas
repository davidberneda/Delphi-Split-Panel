{ @davidberneda 2026 }
unit Panel_Extension;

{
  https://github.com/davidberneda/Delphi-Split-Panel
}

interface

{
  Design-time Delphi package.

  Extends the TPanel control at design-time, adding to new local menus:

   Split Horizontally
   Split Vertically

   These create two sub-panel children controls and a splitter.

   You can keep splitting the children recursively.
}


uses
  SysUtils, Classes, DesignIntf, DesignMenus, DesignEditors;

type
  TPanelCustomMenuEditor = class(TComponentEditor)
  public
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

procedure Register;

implementation

uses
  ExtCtrls, Controls, Graphics;

{ TPanelCustomMenuEditor }

function TPanelCustomMenuEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

function TPanelCustomMenuEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Split Horizontally';
    1: Result := 'Split Vertically';
  else
    Result := '';
  end;
end;

Function GetUniqueName(const AComponent:TComponent):TComponentName;
var tmp : Integer;
    Start : String;
begin
  Start:=Copy(AComponent.ClassName,2,1000);

  if Assigned(AComponent.Owner) then
  begin
    tmp:=1;

    while Assigned(AComponent.Owner.FindComponent(Start+IntToStr(tmp))) do
         Inc(tmp);

    result:=Start+IntToStr(tmp);
  end
  else
    result:=Start+'1';
end;

procedure TPanelCustomMenuEditor.ExecuteVerb(Index: Integer);
var
  CurrentPanel: TPanel;

  function CreatePanel:TPanel;
  begin
    result:=TPanel.Create(CurrentPanel.Owner);
    result.Name:=GetUniqueName(result);

    result.Caption:='';
    result.BevelInner:=bvNone;
    result.BevelOuter:=bvNone;
  end;

var
  A,B : TPanel;
  S : TSplitter;
begin
  if Component is TPanel then
  begin
    CurrentPanel := TPanel(Component);

    if (Index=0) or (Index=1) then
    begin
      A:=CreatePanel;
      B:=CreatePanel;

      A.Parent:=CurrentPanel;
      B.Parent:=CurrentPanel;

      S:=TSplitter.Create(CurrentPanel.Owner);
      S.Name:=GetUniqueName(S);

      S.Parent:=CurrentPanel;
      S.Color:=clGray;

      if Index=0 then
      begin
        A.Align:=alLeft;
        B.Align:=alClient;

        A.Width:=CurrentPanel.Width div 2;

        S.Align:=alLeft;
      end
      else
      begin
        A.Align:=alTop;
        B.Align:=alClient;

        A.Height:=CurrentPanel.Height div 2;

        S.Align:=alTop;
      end;

      Designer.Modified;
    end;
  end;
end;

procedure Register;
begin
  RegisterComponentEditor(TPanel, TPanelCustomMenuEditor);
end;

end.

