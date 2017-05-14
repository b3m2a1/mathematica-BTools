(* ::Package:: *)


(* ::Notebook::RGBColor[.7,.7,1]:: *)
(*Test*)


FEMenus::usage="Gets menus by names";


FEMenuFind::usage="Finds a menu in a menu structure";
FEMenuChildren::usage="Finds a menu's children in a menu structure";
FEMenuParent::usage="Finds a menu's parent in a menu structure";
FEMenuDrop::usage="Drops a menu from a menu structure";
FEMenuTake::usage="Takes a menus from a menu structure";
FEMenuReplace::usage="Replaces a menu in a menu structure";
FEMenuInsert::usage="Inserts a menu at a position";


FEMenuAdd::usage="Adds a set of options chunk to the front end menus";
FEMenuRemove::usage="Removes entries from menus";


FEMenuGraph::usage="Creates a graph of the menu structure";


$FrontEndMenu::usage="The displayed front end menu";


$FEMenuRoot::usage="The root menu";
FEMenuReset::usage="Resets the menus";
FEMenuSet::usage="Sets a menu";


FEMenuGet::usage="Uses the menu list get function. Might work on a standard menu.";


Begin["`Private`"];


$MenuSetupTR=
	FileNameJoin@{
		$InstallationDirectory,
		"SystemFiles","FrontEnd","TextResources",
		"Macintosh","MenuSetup.tr"};
$MenuStringsTR=
	FileNameJoin@{$InstallationDirectory,
		"SystemFiles","FrontEnd","TextResources",
		"MenuStrings.tr"};


$FEMenuRoot=
	Block[{$Context="System`",$ContextPath=Append[$ContextPath,"FrontEnd`"]},
		Quiet[Import@$MenuSetupTR,General::shdw]
		];
$menuStrings=
	Block[{$Context="System`",$ContextPath=Append[$ContextPath,"FrontEnd`"]},
		Quiet[Import@$MenuStringsTR,General::shdw]
		];


$menuNames=
	Cases[$FEMenuRoot,
		(MenuItem[__,name_String?(StringContainsQ["Dialog"])]|Menu[name_,___]):>name,\[Infinity]];


$FEMenus=
	{
		"Open",
		"BackgroundDialog"
		};
$FEMenuLists=
{
		"MenuListBoxFormFormatTypes",
		"MenuListCellEvaluators",
		"MenuListCellTags",
		"MenuListCommonDefaultFormatTypesInput",
		"MenuListCommonDefaultFormatTypesInputInline",
		"MenuListCommonDefaultFormatTypesOutput",
		"MenuListCommonDefaultFormatTypesOutputInline",
		"MenuListCommonDefaultFormatTypesText",
		"MenuListCommonDefaultFormatTypesTextInline",
		"MenuListConvertFormatTypes","MenuListDisplayAsFormatTypes",
		"MenuListExportClipboardSpecial",
		"MenuListFonts",
		"MenuListFontSubstitutions",
		"MenuListGlobalEvaluators",
		"MenuListHelpWindows",
		"MenuListNotebookEvaluators",
		"MenuListNotebooksMenu",
		"MenuListPackageWindows",
		"MenuListPalettesMenu",
		"MenuListPaletteWindows",
		"MenuListPlayerWindows",
		"MenuListPlugInCommands",
		"MenuListPrintingStyleEnvironments",
		"MenuListQuitEvaluators",
		"MenuListRelatedFilesMenu",
		"MenuListSaveClipboardSpecial",
		"MenuListScreenStyleEnvironments",
		"MenuListStartEvaluators",
		"MenuListStyleDefinitions",
		"MenuListStyles",
		"MenuListStylesheetWindows",
		"MenuListTextWindows",
		"MenuListWindows"};


FEMenus[pat_:""]:=
	Join[
		Sort@
			Select[
				Select[Join[$FEMenus,$menuNames],StringContainsQ[pat]],
				StringContainsQ[#,WordCharacter]&&!StringContainsQ[#,WhitespaceCharacter]&
				],
		Select[$FEMenuLists,StringContainsQ[pat]]
		];


$feStoredMenu=Automatic;
$FrontEndMenu:=Replace[$feStoredMenu,Automatic->$FEMenuRoot];
$FrontEndMenu/:HoldPattern[Set[$FrontEndMenu,m:_Menu|_List|None]]:=
	With[{r=FEMenuSet[m]},
		If[MatchQ[r,_Menu],$feStoredMenu=r]
		] ;
$FrontEndMenu/:HoldPattern[Set[$FrontEndMenu,Automatic]]:=
	($feStoredMenu=Automatic;FEMenuReset[]);
$FrontEndMenu/:HoldPattern[Unset[$FrontEndMenu]]:=
	($FrontEndMenu=Automatic;);
$FrontEndMenu/:HoldPattern[$FrontEndMenu[key_]]:=FEMenuTake[$FrontEndMenu,key];


menuRules[Menu[name_,e_]]:=Menu[name]->menuRules@e;
menuRules[ignore:(_String|_MenuItem|Delimiter|_AlternateItems)]:=ignore;
SetAttributes[menuRules,Listable];


menuPart[menu_,name_]:=
FirstCase[menu,Menu[name,_],None,\[Infinity]];
menuPart[menu_,name1_,names__]:=
Fold[menuPart,menu,{name1,names}];
menuEdges[menu_]:=
ReplaceAll[
Cases[
DeleteCases[menuRules@menu,
Except[_Menu|_MenuItem|Rule[_Menu,_]|_List|_String|_AlternateItems],
\[Infinity]]//.{
Rule[m_,expr:Except[_Rule]]:>Thread[m->expr],
Rule[m_Menu,Rule[subm_Menu,e_]]:>{m->subm,subm->e}
},
_Rule,
\[Infinity]]//Flatten,
Rule->DirectedEdge];


FEMenuGraph[menu_:Automatic]:=
With[{edges=menuEdges@Replace[menu,Automatic->$FrontEndMenu]},
Graph[
edges,
VertexShape->{
Menu[n_]:>Graphics[Tooltip[{Hue[.1,.8,1],Disk[]},n]],
m_MenuItem:>Graphics[Tooltip[{Hue[.6,.8,1],Disk[]},m]],
e_AlternateItems:>Graphics[Tooltip[{Hue[.4,.8,1],Disk[]},e]]
}
]
];


FEMenuFind[structure_Menu,menu_:_String|_Alternatives|_PatternTest]:=
	FEMenuFind[menu,structure];
FEMenuFind[menu:_String|_Alternatives|_PatternTest,structure_:Automatic]:=
	FirstCase[Replace[structure,Automatic:>$FrontEndMenu],
		(Menu|MenuItem)[menu,___]|MenuItem[__,menu],
		None,\[Infinity]];
FEMenuFind[m:(_Menu|_MenuItem),structure_:Automatic]:=
	FirstCase[Replace[structure,Automatic:>$FrontEndMenu],m,None,\[Infinity]];


FEMenuParent[menu:_String|_Alternatives|_PatternTest,structure_:Automatic]:=
	FirstCase[Replace[structure,Automatic:>$FrontEndMenu],
		Menu[___,(Menu|MenuItem)[menu,___]|MenuItem[__,menu],___]|
		Menu[___,{___,(Menu|MenuItem)[menu,___]|MenuItem[__,menu],___},___],
		None,\[Infinity]];
FEMenuParent[m:(_Menu|_MenuItem),structure_:$FrontEndMenu]:=
	FirstCase[Replace[structure,Automatic:>$FrontEndMenu],
		Menu[___,m,___]|Menu[___,{___,m,___},___],
		None,\[Infinity]];


FEMenuChildren[menu:_String|_Alternatives|_PatternTest,structure_:Automatic]:=
	FirstCase[Replace[structure,Automatic:>$FrontEndMenu],
		Menu[menu,c_,___]:>c,
		None,\[Infinity]];
FEMenuChildren[m_Menu,structure_:Automatic]:=
	If[Length@m>1,m[[2]],FEMenuChildren[First@m,structure]];


FEMenuDrop[m_List,structure_]:=
	DeleteCases[
		Replace[structure,Automatic->$FrontEndMenu],
		Alternatives@@FEMenuFind/@m,\[Infinity]];
FEMenuDrop[m_,structure_:Automatic]:=
	FEMenuDrop[{m},structure];


FEMenuTake[m_List,structure_:Automatic]:=
	FEMenuFind[#,structure]&/@m;
FEMenuTake[m_,structure_:Automatic]:=
	First@FEMenuTake[{m},structure];


FEMenuReplace[
	replacements:(
		Rule[_Menu|_MenuItem|_String,_Menu|_MenuItem]|
		{Rule[_Menu|_MenuItem|_String,_Menu|_MenuItem]..}),
	structure_:Automatic]:=
	With[{struct=Replace[structure,Automatic->$FrontEndMenu]},
		With[{reps=
			Replace[{replacements},
				(s_String->m_):>
					Replace[FEMenuFind[struct,s],{
						None->Nothing,
						e_:>(e->m)
						}],
					1]},
			ReplaceAll[struct,reps]
			]
		];


FEMenuInsert[
	menu_,key_,
	structure_:Automatic]:=
	With[{m=Replace[structure,Automatic->$FrontEndMenu]},
		With[{k=
			Replace[key,{
				i_Integer:>{2,i},
				{i__}:>{2,i},
				_:>Prepend[First@Position[m,FEMenuFind[m,key]],1]
				}]},
			Insert[m,menu,k]
			]
		];


FEMenuAdd[menu:_String|_Menu|_MenuItem,options_List]:=
FrontEndExecute[
FrontEnd`AddMenuCommands[menu,
options
]
];
FEMenuAdd[menu_,option:_MenuItem|_Menu]:=FEMenuAdd[menu,{option}];
FEMenuAdd[menu_,options:(_MenuItem|_Menu..)]:=FEMenuAdd[menu,{options}];


FEMenuRemove[menu_,key_]:=
	FrontEndExecute@
		FrontEnd`RemoveMenuCommands[ToString@menu,key]


FEMenuGet[menu_]:=
	FE`Evaluate[FEPrivate`GetPopupList[menu]];


FEMenuReset[]:=
	FrontEndExecute@ResetMenusPacket[{Automatic}];
FEMenuSet[menu:Menu["Mathematica",_List,___]]:=
	(FrontEndExecute@ResetMenusPacket[{menu}];menu)
FEMenuSet[menu:Menu[Except@"Mathematica",_List,___]]:=
	FEMenuSet[Menu["Mathematica",{menu}]];
FEMenuSet[menus:{___Menu}]:=
		FEMenuSet[Menu["Mathematica",menus]];
FEMenuSet[None]:=
	FEMenuSet[{}];


End[];



