unit dhtmlx_db;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, dhtmlx_dataprocessor,js, Types,dhtmlx_datastore;

type

  { TDHTMLXDataSource }

  { TDHTMLXDataLink }

  TDHTMLXDataLink = class(TDataLink)
  private
    FDataprocessor: TDHTMLXDataProcessor;
    FDatastore: TDHTMLXDataStore;
    FIdField: string;
    FInCheckForDeletions : Boolean;
    procedure AddRows;
    procedure ResetDataProcessor;
    procedure DataStoreCursorChanged(id : JSValue);
    procedure DataStoreUpdated(id : JSValue;obj : TJSObject;mode : string);
    function DataStoreDeleteItem(id : JSValue) : Boolean;
    function DataProcessorDataUpdated(id : JSValue;state : string;data : TJSObject) : Boolean;
    procedure Delete(id : JSValue);
    procedure CheckforDeletions;
    procedure ClearData;
  protected
    procedure UpdateData; override;
    procedure RecordChanged(Field: TField); override;
    procedure ActiveChanged; override;
    function GetRecordCount: Integer; override;
    procedure DataEvent(Event: TDataEvent; Info: JSValue); override;
  public
    constructor Create;
    property Dataprocessor : TDHTMLXDataProcessor read FDataprocessor;
    property Datastore : TDHTMLXDataStore read FDatastore;
    property IdField : string read FIdField write FIdField;
  end;

implementation

constructor TDHTMLXDataLink.Create;
begin
  inherited Create;
  FInCheckForDeletions := False;
  FDatastore := TDHTMLXDataStore.New('');
  FDatastore.attachEvent('onAfterCursorChange',@DataStoreCursorChanged);
  FDatastore.attachEvent('onStoreUpdated',@DataStoreUpdated);
  FDatastore.attachEvent('onBeforeDelete',@DataStoreDeleteItem);
  FDataprocessor := TDHTMLXDataProcessor.New('');
  FDataprocessor.attachEvent('onBeforeUpdate',@DataProcessorDataUpdated);
  FDataprocessor.enablePartialDataSend(false);
  FDataprocessor.enableDataNames(true);
end;

procedure TDHTMLXDataLink.AddRows;
var
  i, a: Integer;
  aObj: TJSObject;
  aRec: TBookMark;
  aId : JSValue;
begin
  DataSet.DisableControls;
  aRec := DataSet.GetBookmark;
  DataSet.First;
  while not DataSet.EOF do
    begin
      aObj := TJSObject.new;
      for a := 0 to DataSet.FieldCount-1 do
        if DataSet.Fields[a].FieldName=FIdField then
          begin
            aObj.Properties['id'] := DataSet.Fields[a].AsJSValue;
            aId := DataSet.Fields[a].AsJSValue;
          end
        else if ((DataSet.Fields[a] is TDateField)
             or (DataSet.Fields[a] is TDateTimeField)) then
          aObj.Properties[DataSet.Fields[a].FieldName] := DataSet.Fields[a].AsJSValue
        else
          aObj.Properties[DataSet.Fields[a].FieldName] := DataSet.Fields[a].DisplayText;
      try
        if Datastore.item(aId) = null then
          Datastore.add(aObj);
      except
      end;
      DataSet.Next;
    end;
  DataSet.GotoBookmark(aRec);
  DataSet.EnableControls;
end;

procedure TDHTMLXDataLink.ResetDataProcessor;
begin
  FDataprocessor.cleanUpdate;
end;

procedure TDHTMLXDataLink.DataStoreCursorChanged(id: JSValue);
begin
  writeln('DataStoreCursorChange ',id);
  DataSet.Locate(IdField,id,[]);
end;

procedure TDHTMLXDataLink.DataStoreUpdated(id: JSValue; obj: TJSObject;
  mode: string);
begin
  writeln('DatastoreUpdated ',id);
end;

function TDHTMLXDataLink.DataStoreDeleteItem(id: JSValue): Boolean;
begin
  writeln('DataStoreDeleteItem ',id);
  dataSet.DisableControls;
  if (DataSet.State=dsInsert) and (DataSet.FieldByName(IdField).AsJSValue = id) then
    begin
      DataSet.Cancel;
      Result := True;
    end
  else if (DataSet.State=dsEdit) then
    DataSet.Post;
  Result := DataSet.Locate(IdField,id,[]);
  if Result then
    DataSet.Delete
  else writeln('Record to delete not found !',id);
  DataSet.EnableControls;
end;

function TDHTMLXDataLink.DataProcessorDataUpdated(id: JSValue; state: string;
  data: TJSObject): Boolean;
var
  aProps: TStringDynArray;
  i: Integer;
  aField: TField;
  aPropType : string;
begin
  DataSet.DisableControls;
  try
    Result := False;//dont send Data
    if (DataSet.FieldByName(IdField).AsJSValue = null) and (DataSet.State=dsInsert) then
      DataSet.FieldByName(IdField).AsJSValue := id;
    if id <> DataSet.FieldByName(IdField).AsJSValue then
      begin
        if (DataSet.State=dsInsert)
        or (DataSet.State=dsEdit)
        then
          DataSet.Post;
        if not DataSet.Locate(IdField,id,[]) then
          begin
            writeln('Failed to find ROW ! ',id,' ',DataSet.State);
            exit;
          end;
      end;
    if not (DataSet.State in [dsEdit,dsInsert]) then
      DataSet.Edit;
    aProps := TJSObject.getOwnPropertyNames(Data);
    for i := 0 to length(aProps)-1 do
      begin
        aField := DataSet.Fields.FindField(aProps[i]);
        if Assigned(aField) then
          begin
            if (Data.Properties[aProps[i]] <> aField.AsJSValue)
            and (not ((Data.Properties[aProps[i]]='') and (aField.IsNull)))
            then
              begin
                asm
                  aPropType = typeof(data[aProps[i]]);
                end;
                if (aField.FieldDef.DataType = ftString) or (aPropType = 'string') then
                  aField.Text:=string(Data.Properties[aProps[i]]) //call OnSetText
                else
                  aField.AsJSValue := Data.Properties[aProps[i]];
              end;
          end
        else writeln('Field '+aProps[i]+' not found !');
      end;
  finally
    DataSet.EnableControls;
  end;
  Dataprocessor.setUpdated(id);
end;

procedure TDHTMLXDataLink.Delete(id: JSValue);
begin
  if Id = Undefined then exit;
  writeln('deleting ',Id);
  Dataprocessor.setUpdated(id);
  Datastore.remove(id);
end;

procedure TDHTMLXDataLink.CheckforDeletions;
var
  aId: JSValue;
  aRec: TBookMark;
begin
  if FInCheckForDeletions then exit;
  FInCheckForDeletions:=True;
  DataSet.DisableControls;
  aRec := DataSet.GetBookmark;
  aId := Datastore.first;
  repeat
    begin
      try
        if (aId<>Undefined) and (not DataSet.Locate(IdField,aId,[])) then
          begin
            aId := Datastore.next(aId);
            Delete(aId);
          end
        else
          aId := Datastore.next(aId);
      except
        aId := Datastore.next(aId);
      end;
    end;
  until aId = Datastore.last;
  DataSet.GotoBookmark(aRec);
  DataSet.EnableControls;
  FInCheckForDeletions:=False;
end;

procedure TDHTMLXDataLink.ClearData;
var
  aId: JSValue;
  tmp: String;
begin
  aId := Datastore.first;
  while aId <> Datastore.last do
    begin
      try
        Dataprocessor.setUpdated(aId);
      except
      end;
      aId := Datastore.next(aId);
    end;
  Datastore.clearAll;
end;

procedure TDHTMLXDataLink.UpdateData;
begin
  writeln('UpdateData');
end;

procedure TDHTMLXDataLink.RecordChanged(Field: TField);
begin
  writeln('RecordChanged',Field);
  inherited RecordChanged(Field);
end;

procedure TDHTMLXDataLink.ActiveChanged;
var
  aId: JSValue;
begin
  inherited ActiveChanged;
  writeln('ActiveChanged');
  ClearData;
  if Active then
    Dataprocessor.ignore(@AddRows)
end;

function TDHTMLXDataLink.GetRecordCount: Integer;
begin
  Result:=DataSet.RecordCount;
end;

procedure TDHTMLXDataLink.DataEvent(Event: TDataEvent; Info: JSValue);
var
  tmp: JSValue;
  procedure SetId;
  begin
    DataSet.FieldByName(IdField).AsJSValue := tmp;
  end;

begin
  case Event of
  deFieldChange://A field value changed.
    writeln('DataEvent ','deFieldChange');
  deRecordChange://The contents of the current record changed.
    writeln('DataEvent ','deRecordChange');//
  deDataSetChange://A change occurred that affects the entire dataset (such as the insertion or deletion of records, changes to the key, or edits).
    begin
      writeln('DataEvent ','deDataSetChange');
      if DataSet.State=dsBrowse then
        Dataprocessor.ignore(@CheckforDeletions);
    end;
  deDataSetScroll://The set of displayed records was scrolled.
    begin
      writeln('DataEvent ','deDataSetScroll');
      Datastore.setCursor(DataSet.FieldByName(IdField).AsJSValue);
    end;
  deLayoutChange://The layout of data in a data-aware control changed.
    writeln('DataEvent ','deLayoutChange');
  deUpdateRecord://Edits to the current record were posted.
    writeln('DataEvent ','deUpdateRecord');
  deUpdateState://The state of the dataset changed.
    begin
      writeln('DataEvent ','deUpdateState');
      if DataSet.State=dsInsert then
        begin
          tmp := Datastore.add(TJSObject.new);
          writeln('Row ',tmp,' inserted ',DataSet.RecordCount);
          Dataprocessor.ignore(@SetId);
          Datastore.setCursor(tmp);
        end;
    end;
  deCheckBrowseMode://The state of the dataset is about to change.
    begin
      writeln('DataEvent ','deCheckBrowseMode');
      //Post before change the Row like DBGrid does
      DataSet.DisableControls;
      if (DataSet.State=dsInsert)
      or (DataSet.State=dsEdit) then
        begin
          writeln('Posting Dataset before Row Change ',DataSet.FieldByName(IdField).AsJSValue,' ',DataSet.State);
          DataSet.Post;
        end;
      DataSet.EnableControls;
    end;
  dePropertyChange://A property of the dataset or one of its fields changed.
    writeln('DataEvent ','dePropertyChange');
  deFieldListChange://The list of fields in the dataset changed.
    writeln('DataEvent ','deFieldListChange');
  deFocusControl://Focus needs to shift to the representation of a specified field.
    writeln('DataEvent ','deFocusControl');
  deParentScroll://The parent for which the dataset is a nested detail scrolled.
    writeln('DataEvent ','deParentScroll');
  deConnectChange://The connection to a remote dataset changed.
    writeln('DataEvent ','deConnectChange');
  deReconcileError://The dataset encountered reconcile errors when applying updates.
    writeln('DataEvent ','deReconcileError');
  deDisabledStateChange://not avalible in current Emba impl ??!
    writeln('DataEvent ','deDisabledStateChange');
  end;
  inherited;
end;

end.

