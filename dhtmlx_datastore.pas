unit dhtmlx_datastore;

{$mode objfpc}
{$modeswitch externalclass}

interface

uses
  js,web;

type
  TDHTMLXDataStore = class external name 'dhtmlXDataStore' (TJSElement)
    constructor New;varargs;
    function add(aObj : TJSObject) : JSValue;                                   //Adds a new record to the dataset.
    function attachEvent(event : string;aCallback : JSValue) : Integer;         //adds any user-defined handler to available events
    //bind	binds 2 dataStore objects (just for filtration one of datasets. Changes in the master dataStore [creating, updating, deleting] doesn't reflect in the bound dataStore).
    procedure clearAll;	                                                        //Removes all data from the component.
    function dataCount : Integer;	                                        //Returns the total count of items in DataStore. In case of dynamic loading the method returns the expected count of items.
    procedure detachEvent(id : JSValue);	                                //detaches a handler from an event
    //exists	Returns true if an item with the defined ID already exists.
    //filter	Filters DataStore by provided parameters.
    //first	Returns the ID of the first item ( an item with the index == 0 )
    function getCursor : JSValue;	                                        //get position of virtual cursor
    //idByIndex	Returns the ID of an item with the specified index.
    //indexById	Returns the index of an item with the specified ID.
    //item	Returns hash of data related to the specific item.
    //last	Returns the ID of the last item ( an item with the index == dataCount-1).
    //load	loads data to the component via XML or JSON, usually data-values pairs
    //next	Returns the ID of the next item ( an item with the index == current + 1).
    //parse	Parse an object or a string and fill the DataStore by parsed items.
    //previous	Returns the ID of the previous item ( an item with the index == current - 1).
    //remove	Removes item by the ID.
    //saveBatch	Makes simultaneous saving several components (batch saving).
    //serialize	serializes data to a JSON object .
    procedure setCursor(cur : JSValue);	                                        //set virtual cursor
    //sort	Sorts a dataset.
    //sync	binds 2 dataStore objects (changes in the master dataStore [creating, updating, deleting] reflect in the bound dataStore).
    //unbind	unbinds 2 DataStore objects
    //update	updates a specific item
  end;

implementation

end.

