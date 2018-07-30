unit dhtmlx_tabbar;

{$mode objfpc}
{$modeswitch externalclass}

interface

uses
  js,web;

type
  TDHTMLXTabbarCell = class external name 'dhtmlXTabBarCell' (TJSElement)
    procedure appendObject(aObj : JSValue);	                                //attaches an object to a cell without clearing cell content
    function attachAccordion(conf : TJSObject): JSValue;	                //attaches dhtmlxAccordion to a cell
    function attachCarousel(conf : TJSObject): JSValue;	                        //attaches a carousel object to a cell
    function attachChart(conf : TJSObject): JSValue;	                        //attaches dhtmlxChart to a cell
    function attachDataView(conf : TJSObject): JSValue;	                        //attaches dhtmlxDataView to a cell
    function attachEditor(conf : TJSObject): JSValue;	                        //attaches dhtmlxEditor to a cell
    function attachForm(opt : TJSObject) : JSValue;	                        //attaches dhtmlxForm to a cell
    function attachGrid(opt : TJSObject) : JSValue;	                        //attaches dhtmlxGrid to a cell
    //attachHTMLString	attaches HTML content to a cell
    function attachLayout(opt : TJSObject) : JSValue;	                        //attaches dhtmlxLayout to a cell
    function attachList(opt : TJSObject) : JSValue;	                        //attaches dhtmlxList to a cell
    //attachMap	attaches Google Maps to a cell
    //attachMenu	attaches dhtmlxMenu to a cell
    procedure attachObject(aObj : JSValue);	                                //attaches an HTML object to a cell
    function attachRibbon(conf : TJSObject): JSValue;	                        //attaches dhtmlxRibbon to a cell
    function attachScheduler(conf : TJSObject): JSValue;	                //attaches dhtmlxScheduler to a cell
    function attachSidebar(conf : TJSObject): JSValue;	                        //attaches dhtmlxSidebar to a cell
    function attachStatusBar(conf : TJSObject): JSValue;	                //attaches a status bar to a cell
    function attachTabbar(conf : TJSObject): JSValue;	                        //attaches dhtmlxTabbar to a cell
    function attachToolbar(conf : TJSObject): JSValue;	                        //attaches dhtmlxToolbar to a cell
    function attachTree(conf : TJSObject): JSValue;	                        //attaches dhtmlxTree to a cell
    function attachTreeView(conf : TJSObject): JSValue;	                        //attaches dhtmlxTreeView to a cell
    procedure attachURL(url : string {[boolean ajax,boolean|object postData]});varargs;	//attaches the specified URL to a cell
    //attachVault	attaches dhtmlxVault to a cell
    procedure close;	                                                        //closes (unloads) the specified tab from the tabbar
    //detachMenu	detaches dhtmlxMenu from a cell
    procedure detachObject(obj : JSValue);	                                //detaches any attached content from a cell
    //detachRibbon	detaches dhtmlxRibbon from a cell
    //detachStatusBar	detaches status bar from a cell
    //detachToolbaTDHTMLXTabbarCellr	detaches dhtmlxToolbar from a cell
    procedure disable;	                                                        //disables the specified tab in the tabbar
    procedure enable;	                                                        //enables the specified tab in the tabbar
    //getAttachedMenu	returns dhtmlxMenu instance attached to a cell
    //getAttachedObject	returns the object attached to a cell
    //getAttachedRibbon	returns dhtmlxRibbon instance attached to a cell
    //getAttachedStatusBar	returns status bar object attached to a cell
    //getAttachedToolbar	returns dhtmlxToolbar instance attached to a cell
    function getFrame : TJSWindow;	                                        //returns an iframe object when an URL is attached to a cell
    //getId	returns the id of a cell
    //getIndex	returns the tab's index
    function getText : string;	                                                //returns the tab's text
    //getViewName	returns the name of the current view
    procedure hide;	                                                        //hides the specified tab
    //hideMenu	hides dhtmlxMenu attached to a cell
    //hideRibbon	hides dhtmlxRibbon attached to a cell
    //hideStatusBar	hides status bar object attached to a cell
    //hideToolbar	hides dhtmlxToolbar attached to a cell
    function isActive : boolean;	                                        //returns the tab's active/inactive state
    function isEnabled : Boolean;	                                        //returns the tab's enabled/disabled state
    function isVisible : Boolean;	                                        //returns the tab's visible/hidden state
    procedure progressOff;	                                                //hides the progress indicator in a cell
    procedure progressOn;	                                                //shows the progress indicator in a cell
    //reloadURL	reloads the attached URL in a cell
    procedure setActive;	                                                //selects the specified tab
    procedure setText(text : string);	                                        //sets the text of a tab
    procedure show;	                                                        //shows the specified tab
    //showInnerScroll	shows inner cell scrolls
    //showMenu	shows dhtmlxMenu attached to a cell
    //showRibbon	shows dhtmlxRibbon attached to a cell
    //showStatusBar	shows status bar object attached to a cell
    //showToolbar	shows dhtmlxToolbar attached to a cell
    //showView	shows the specified view, creates a new one if it doesn't exist
    procedure unloadView;	                                                //unloads the specified view
  end;

  TDHTMLXTabbar = class external name 'dhtmlXTabBar' (TJSElement)
    constructor New(parent : JSValue);varargs;
    procedure addTab(id : JSValue;text : string;width : JSValue;position : Integer;
                     active,close : Boolean);	                                //adds a new tab to Tabbar
    //adjustOuterSize	adjusts the tabbar's size when the parent's size was changed
    function attachEvent(event : string;aCallback : JSValue) : Integer;         //adds any user-defined handler to available events
    //attachFooter	attaches footer to component's bottom
    //attachHeader	attaches header to component's top
    //attachMenu	attaches dhtmlxMenu to component's top
    //attachRibbon	attaches dhtmlxRibbon to component's top
    //attachStatusBar	attaches a status bar object to component's bottom
    //attachToolbar	attaches dhtmlxToolbar to component's top
    function cells(id : JSValue) : TDHTMLXTabbarCell;	                        //returns dhtmlXTabBarCell instance (tabbar's tab)
    //clearAll	removes all tabs
    //destructor	unloads the tabbar
    procedure detachEvent(id : JSValue);	                                //detaches a handler from an event
    //detachFooter	detaches footer from component's bottom
    //detachHeader	detaches header from component's top
    //detachMenu	detaches dhtmlxMenu from component's top
    //detachRibbon	detaches dhtmlxRibbon from component's top
    //detachStatusBar	detaches status bar object from component's bottom
    //detachToolbar	detaches dhtmlxToolbar from component's top
    //disableTab	disables the specified tab in the tabbar
    //enableAutoReSize	enables/disables automatic adjusting of height and width to the outer container
    //enableAutoSize	enables/disables auto adjusting of height and width to the inner content
    //enableContentZone	enables/disables the content zone
    //enableForceHiding	enables/disables the force hiding mode
    //enableScroll	enables/disables scrolls (enabled by default)
    //enableTab	enables the specified tab in the tabbar
    //enableTabCloseButton	enables/disables a "close" button for tabs
    //forEachCell	an iterator, calls a user-defined handler for each tab
    //forEachTab	an iterator, calls a user-defined handler for each tab
    //forceLoad	reloads the URL attached to a cell
    //getActiveTab	returns id of the active tab
    //getAllTabs	returns an array of the tabbar tabs' ids
    //getAttachedMenu	returns dhtmlxMenu instance attached to component's top
    //getAttachedRibbon	returns dhtmlxRibbon instance attached to component's top
    //getAttachedStatusBar	returns status bar object attached to component's bottom
    //getAttachedToolbar	returns dhtmlxToolbar instance attached to component's top
    //getIndex	returns the tab's index
    //getLabel	returns the tab's text
    //getNumberOfTabs	returns the number of tabs
    //goToNextTab	selects the tab next to the active one
    //goToPrevTab	selects the tab prev to the active one
    //hideMenu	hides dhtmlxMenu attached to component's top
    //hideRibbon	hides dhtmlxRibbon attached to component's top
    //hideStatusBar	hides status bar object attached to component's bottom
    //procedure hideTab(id : JSValue);	                                        //hides the specified tab
    //hideToolbar	hides dhtmlxToolbar attached to component's top
    //loadStruct	loads data to the component via XML or JSON, usually component config
    //loadXML	loads tabs config via xml
    //loadXMLString	loads tabs config via xml string
    //moveTab	moves the specified tab to the specified position
    //normalize	reformats the tabbar to remove the tab's scrolls
    //progressOff	hides progress indicator for full component
    //progressOn	shows progress indicator for full component
    //removeTab	removes the specified tab from the tabbar
    //setAlign	aligns tabs within the tabbar
    //setArrowsMode	sets the mode for auto show/hide left-right tabs arrows
    //setContent	sets the content of a tab
    //setContentHTML	sets the content of a tab as an HTML string
    //setContentHref	sets the content as the href to an external file
    //setCustomStyle	sets some specific colors for the specific tab
    //setHrefMode	sets the mode that allows loading of external content
    //setImagePath	sets the path to the image's folder
    //setLabel	sets the text of a tab
    //setMargin	sets the distance between tabs
    //setOffset	sets an offset before the first tab in the tabbar
    //setOffsets	sets offsets for parent container from each side
    //setSize	sets control size
    procedure setSizes;	                                                        //adjusts the size of the tabbar when the parent's size is changed
    //setSkin	changes the tabbar's skin
    //setSkinColors	allows setting skin to the specific color
    //setStyle	sets tab style
    //setTabActive	selects the specified tab
    //setTabInActive	unselects any selected tab
    //setTabsMode	sets tabs' mode (top or bottom)
    //showInnerScroll	shows inner cell scrolls
    //showMenu	shows dhtmlxMenu attached to component's top
    //showRibbon	shows dhtmlxRibbon attached to component's top
    //showStatusBar	shows status bar object attached to component's bottom
    //showTab	shows the specified tab
    //showToolbar	shows dhtmlxToolbar attached to component's bottom
    //tabWindow	returns iframe when an URL is attached to a cell
    //tabs	returns dhtmlXTabBarCell instance (tabbar's tab)
    procedure unload;                                       	                //unloads tabbar (destructor)
  end;

implementation

end.

