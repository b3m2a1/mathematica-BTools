(* ::Package:: *)



(* ::Subsubsection::Closed:: *)
(*NinePatchCreate*)



NinePatchCreate::usage=
	"Creates a NinePatch image for use in Appearance";


(* ::Subsubsection::Closed:: *)
(*Appearance Images*)



AppearanceReadyImage::usage=
	"Converts an image into a background appearance for (say) a button";
GradientAppearance::usage=
	"Converts a gradient type appearance";
FrameMasked::usage=
	"Creates a mask with Framed for images";


(* ::Subsubsection::Closed:: *)
(*Framed Appearances*)



FramedButton::usage=
	"Formats a button in a frame";
FramedPopupMenu::usage=
	"A popup menu that is also framed";
FramedActionMenu::usage=
	"A popup menu that is also framed";


(* ::Subsubsection::Closed:: *)
(*Colorized Appearances*)



ColorizedAppearances::usage=
	"Colorizes appearance images";
ColorizationAdjust::usage=
	"Adjusts the colorization so mouseover differences are more notable";
ColoredButton::usage=
	"Formats a rounded button from a set of predefined choices";
ColoredButtonAppearances::usage=
	"Gets the appearance used by ColoredButton";
ColoredPanel::usage=
	"Panel equivalent of ColoredButton";
ColoredPanelAppearances::usage=
	"Gets the appearance used by ColoredPanel";
ColoredPopupMenu::usage=
	"Formats a rounded popup menu using ColoredButton";
ColoredActionMenu::usage=
	"Formats a rounded popup menu using ColoredButton";
PopupDropDown::usage=
	"A label-less popup using the standard down-arrow appearance";
ActionDropDown::usage=
	"A label-less actionmenu using the standard down-arrow appearance";
ButtonPopupMenu::usage=
	"A combination button/popup menu";
ButtonActionMenu::usage=
	"A combination button/action menu";
ButtonActionPopup::usage=
	"A combination button/action menu/popup menu";


(* ::Subsubsection::Closed:: *)
(*Gradient Buttons and Panels*)



GradientPanelAppearance::usage=
	"Turns a color into panel appearances";
GradientButtonAppearance::usage=
	"Turns a color into button appearances";
GradientDropDownAppearance::usage=
	"Turns two colors into an arrow dropdown";


Begin["`Private`"];


(* ::Subsection:: *)
(*Appearances*)



(* ::Subsubsection::Closed:: *)
(*NinePatchCreate*)



ninePatchMarkerPatternSingle=
	_Integer|Scaled[i_?NumericQ]|
	Offset[
		Scaled[i_?NumericQ]|_Integer,
		Scaled[i_?NumericQ]|_Integer
		];
ninePatchMarkerPattern=
	ninePatchMarkerPatternSingle|{ninePatchMarkerPatternSingle..};
ninePatchParamClean[p_,ind_,dim_,doNeg_:True]:=
	ReplaceRepeated[p,
		{
			Scaled[i_]:>
			i*dim[[Mod[ind,2,1]]],
			i_Integer?(Negative[#]&&doNeg&):>
			i+dim[[Mod[ind,2,1]]],
			i:Except[_Integer,_?NumericQ]:>
			Floor[i]
			}
		];
ninePatchStretchZones[stretch_,contents_,dim_]:=
	Module[
		{
			stretchesX,stretchesY,
			contentsX,contentsY,
			stretchOffsetsX,stretchOffsetsY,
			contentOffsetsX,contentOffsetsY
			},
		{stretchesX,stretchesY}=
		Flatten@*List/@
		Replace[stretch,Automatic->{1,1}];
		{contentsX,contentsY}=
		Flatten@*List/@
		Replace[contents,
			Automatic->{stretchesX,stretchesY}
			];
		stretchOffsetsX=
		ConstantArray[0,Length@stretchesX];
		stretchOffsetsY=
		ConstantArray[0,Length@stretchesY];
		contentOffsetsX=
		ConstantArray[0,Length@contentsX];
		contentOffsetsY=
		ConstantArray[0,Length@contentsY];
		{stretchesX,stretchesY,contentsX,contentsY}=
		MapIndexed[
			With[{ind=#2[[1]]},
				MapIndexed[
					Replace[
						#,
						{
							Offset[w_,s_]:>
							With[{
									v=
									ninePatchParamClean[s,ind,dim,False]
									},
								Switch[ind,
									1,stretchOffsetsX[[#2[[1]]]]=v,
									2,stretchOffsetsY[[#2[[1]]]]=v,
									3,contentOffsetsX[[#2[[1]]]]=v,
									4,contentOffsetsY[[#2[[1]]]]=v
									];
								ninePatchParamClean[w,ind,dim]
								],
							e_:>
							ninePatchParamClean[e,ind,dim]
							}
						]&,
					#
					]
				]&,
			{stretchesX,stretchesY,contentsX,contentsY}
			];
		If[AnyTrue[Flatten@{
				stretchesX,stretchesY,
				contentsX,contentsY,
				stretchOffsetsX,stretchOffsetsY,
				contentOffsetsX,contentOffsetsY
				},Not@*IntegerQ],
		Throw[$Failed],
		{
			stretchesX,stretchesY,
			contentsX,contentsY,
			stretchOffsetsX,stretchOffsetsY,
			contentOffsetsX,contentOffsetsY
			}
		]
	];
ninePatchImagePad[img_,
	{
		stretchesX_,stretchesY_,
		contentsX_,contentsY_,
		stretchOffsetsX_,stretchOffsetsY_,
		contentOffsetsX_,contentOffsetsY_
		}]:=
	With[{dim=ImageDimensions[img]+2},
		ReplacePixelValue[
			ImagePad[img, 1, White],
			Flatten[
				Map[
					With[{vals=#[[1]],offsets=#[[2]],f=#[[3]]},
						MapThread[
							With[{v=#,o=#2},
								Array[f[#,v,o]&,v]
								]&,
							{vals,offsets}
							]
						]&,
					{
						{
							stretchesY,stretchOffsetsY,
							{1,Floor[(dim[[2]]-#2)/2]+#+#3}&
							},
						{
							stretchesX,stretchOffsetsX,
							{Floor[(dim[[1]]-#2)/2]+#+#3,dim[[2]]}&
							},
						{
							contentsY,contentOffsetsY,
							{dim[[1]],Floor[(dim[[2]]-#2)/2]+#+#3}&
							},
						{
							contentsX,contentOffsetsX,
							{Floor[(dim[[1]]-#2)/2]+#+#3,1}&
							}
						}
					],
				2
				]->Black
			]
		];


NinePatchCreate[
	img_?ImageQ,
	stretch:{ninePatchMarkerPattern, ninePatchMarkerPattern}|Automatic:Automatic,
	content:{ninePatchMarkerPattern, ninePatchMarkerPattern}|Automatic:Automatic
	]:=
	Catch@
		Image[
			ColorConvert[
				ninePatchImagePad[img,
					ninePatchStretchZones[stretch,content,ImageDimensions[img]]
					],
				RGBColor
				],
			"Byte",
			Interleaving->True
			];
NinePatchCreate[e_,
	stretch:{ninePatchMarkerPattern, ninePatchMarkerPattern}|Automatic:Automatic,
	content:{ninePatchMarkerPattern, ninePatchMarkerPattern}|Automatic:Automatic
	]:=
	NinePatchCreate[Rasterize[e],stretch,content]


(* ::Subsubsection::Closed:: *)
(*AppearanceReadyImage*)



Options[AppearanceReadyImage]=
	Join[
		{
			BorderDimensions->Automatic,
			Prolog->Identity,
			ImagePadding->None
			},
		Options@Rasterize
		];
AppearanceReadyImage[i_?(ImageQ),ops:OptionsPattern[]]:=
	With[{img=
		ColorConvert[
			ImagePad[
				Replace[OptionValue[ImagePadding],{
					Except[_Integer|{{_Integer,_Integer},{_Integer,_Integer}}]:>
						Replace[OptionValue@Prolog,None->Identity]@i,
					int_:>
						ImagePad[
							Replace[OptionValue@Prolog,None->Identity]@i,
							int,
							GrayLevel[0,0]]
					}],
				1,
				GrayLevel[0,0]],
			"RGB"
			]},
		With[{dims=ImageDimensions@img},
			With[{
				mx=Floor@First@dims/2,my=Floor@Last@dims/2,
				x=First@dims,y=Last@dims
				},
				With[{
					rleft=
						Replace[
							Replace[OptionValue@BorderDimensions,{
								Automatic->Scaled[.5],
								{{x_,_},_}|{x:Except[_List],_}:>
									Replace[x,Automatic->Scaled[.5]]
								}],{
							Except[_Scaled|_?NumericQ]->None,
							w_?NumericQ:>
								Range[Ceiling@-w/2,Floor@w/2],
							Scaled[w_]:>
								Range[Ceiling@-(y*w/2),Floor@(y*w/2)]
							}],
					rright=
						Replace[
							Replace[OptionValue@BorderDimensions,{
								Automatic->Scaled[.5],
								{{_,r_},_}|{r:Except[_List],_}:>
									Replace[r,Automatic->Scaled[.5]]
								}],{
							Except[_Scaled|_?NumericQ]->None,
							w_?NumericQ:>
								Range[Ceiling@-w/2,Floor@w/2],
							Scaled[w_]:>
								Range[Ceiling@-(y*w/2),Floor@(y*w/2)]
							}],
					rbottom=
						Replace[
							Replace[OptionValue@BorderDimensions,{
								Automatic->Scaled[.8],
								{_,{x_,_}}|{_,x_}:>
									Replace[x,Automatic->Scaled[.8]]
								}],{
							e:Except[_Scaled|_?NumericQ]:>(Print[e];None),
							w_?NumericQ:>
								Range[Ceiling@-w/2,Floor@w/2],
							Scaled[w_]:>
								Range[Ceiling@-(x*w/2),Floor@(x*w/2)]
							}],
					rtop=
						Replace[
							Replace[OptionValue@BorderDimensions,{
								Automatic->Scaled[.5],
								{_,{_,t_}}|{_,t_}:>
									Replace[t,Automatic->Scaled[.5]]
								}],{
							Except[_Scaled|_?NumericQ]->None,
							w_?NumericQ:>
								Range[Ceiling@-w/2,Floor@w/2],
							Scaled[w_]:>
								Range[Ceiling@-(x*w/2),Floor@(x*w/2)]
							}]
					},
					Image[
						ReplacePixelValue[
							img,
							Join[
								If[rleft===None,
									{},
									Thread[{1,rleft+my}]
									],
								If[rright===None,
									{},
									Thread[{x,rright+my}]
									],
								If[rbottom===None,
									{},
									Thread[{rbottom+mx,1}]
									],
								If[rtop===None,
									{},
									Thread[{rtop+mx,y}]
									]
								]->Black
							],
							"Byte",
							Interleaving->True
						]
					]
				]
			]
		];
AppearanceReadyImage[
	e:Except[_Mouseover|_List|_Rule]?(Not@*ImageQ),
	ops:OptionsPattern[]]:=
	AppearanceReadyImage[
		Rasterize[e,"Image",FilterRules[{ops},Options@Rasterize]],
		ops];
AppearanceReadyImage[k_->img_,ops:OptionsPattern[]]:=
	k->AppearanceReadyImage[img,ops];
AppearanceReadyImage[l_List,ops:OptionsPattern[]]:=
	AppearanceReadyImage[#,ops]&/@l;
AppearanceReadyImage[Mouseover[e1_,e2_],ops:OptionsPattern[]]:=
	{
		"Default"->AppearanceReadyImage[e1,ops],
		"Hover"->AppearanceReadyImage[e2,ops]
		};


(* ::Subsubsection::Closed:: *)
(*GradientImagePaddingFormat*)



GradientImagePaddingFormat[where_:None,pad_]:=
	Switch[where,
		Automatic,
			Replace[
				pad,{
				Automatic->1,
				Center->{{1,1},{1,1}},
				{Center,i_}:>
					{{1,1},{i,i}},
				{Center,_,{b_,t_}}:>
					{{1,1},{b,t}},
				{Center,_,b_}:>
					{{1,1},{b,b}},
				i:_Integer|Automatic:>({{i,1},{i,i}}/.Automatic->1),
				{i:_Integer|Automatic,j_}:>
					({{i,1},{j,j}}/.Automatic->1),
				{{r_,l_},{b_,t_}}:>
					({{r,l},{b,t}}/.Automatic->1)
				}],
		First,
			Replace[
				pad,{
				Automatic->{{1,0},{1,1}},
				Center->{{0,0},{1,1}},
				{Center,i_}:>
					{{0,0},{i,i}},
				{Center,_,{b_,t_}}:>
					{{0,0},{b,t}},
				{Center,_,b_}:>
					{{0,0},{b,b}},
				i:_Integer|Automatic:>({{i,0},{i,i}}/.Automatic->1),
				{i:_Integer|Automatic,j_}:>
					({{i,0},{j,j}}/.Automatic->1),
				{{r_,l_},{b_,t_}}:>
					({{r,l/.Automatic->0},{b,t}}/.Automatic->1)
				}],
		Last,
			Replace[
				pad,{
				Automatic->{{1,1},{1,1}},
				Center->{{1,0},{1,1}},
				{Center,i_}:>
					{{i,0},{i,i}},
				{Center,i_,{b_,t_}}:>
					{{i,0},{b,t}},
				{Center,i_,b_}:>
					{{i,0},{b,b}},
				i:_Integer|Automatic:>({{i,i},{i,i}}/.Automatic->1),
				{i:_Integer|Automatic,j_}:>
					({{i,i},{j,j}}/.Automatic->1),
				{{r_,l_},{b_,t_}}:>
					({{r,l},{b,t}}/.Automatic->1)
				}],
		_,
			Replace[
				pad,{
				Automatic->{{1,0},{1,1}},
				Center->{{1,0},{1,1}},
				{Center,i_}:>
					{{i,0},{i,i}},
				{Center,i_,{b_,t_}}:>
					{{i,0},{b,t}},
				{Center,i_,b_}:>
					{{i,0},{b,b}},
				i:_Integer|Automatic:>({{i,0},{i,i}}/.Automatic->1),
				{i:_Integer|Automatic,j_}:>
					({{i,0},{j,j}}/.Automatic->1),
				{{r_,l_},{b_,t_}}:>
					({{r,l/.Automatic->0},{b,t}}/.Automatic->1)
				}]
	];


(* ::Subsubsection::Closed:: *)
(*GradientAppearance*)



Options[GradientAppearance]={
	ImageSize->{9,24},
	ImagePadding->1,
	FrameStyle->Automatic,
	ImageAdjust->Automatic,
	ImageCompose->None
	};
GradientAppearance[
	color:_?ColorQ|{__?ColorQ},
	center:
		_?NumericQ|_Scaled|
			{_?NumericQ|_Scaled,_?NumericQ|_Scaled}:
		Scaled[0],
	ops:OptionsPattern[]]:=
	With[{
		adj=
			Take[
				Flatten@
					ConstantArray[
						Replace[OptionValue@ImageAdjust,
							Automatic:>
								If[ColorQ@color,
									{0,.025,-.05},
									0
									]
							],
						3],
				3],
		imageSize=
			Replace[
				OptionValue[ImageSize],
				n_?NumericQ:>
					{n,20}
				],
		frameColor=
			Replace[OptionValue[FrameStyle],{
				c:_?ColorQ|{_,_}:>
					c,
				e_:>
					If[e===Automatic,Darker,e]@First@Flatten@{color}
				}],
		pad=
			If[OptionValue@FrameStyle===None,
				None,
				GradientImagePaddingFormat[Automatic,OptionValue[ImagePadding]]
				]
		},
		With[{cents=
			Replace[
				Replace[center,{
					n_?NumericQ:>
						{Scaled[1],n},
					s_Scaled:>
						{Scaled[1],s}
					}],{
				Scaled[s_]:>
					s*Last@imageSize,
				Except[_?NumericQ]:>
					0
				},
			1]},
			If[OptionValue@ImageCompose=!=None,
				Fold[ImageCompose[#,Sequence@@#2]&,
					#,
					Replace[
						Flatten[{OptionValue@ImageCompose},1],{
						i_?ImageQ:>
							{i},
						g_Graphics:>
							List@If[MatchQ[ImageSize/.Options[g,ImageSize],Automatic],
								Rasterize[g,"Image",
									RasterSize->First@imageSize,
									Background->None],
								Rasterize[g,"Image",
									Background->None]
								],
						e:Except[_List]:>
							{e},
						l_List:>
							Replace[l,{
								i_?ImageQ:>
									{i},
								g_Graphics:>
									If[MatchQ[ImageSize/.Options[g,ImageSize],Automatic],
										Rasterize[g,"Image",
											RasterSize->First@imageSize,
											Background->None],
										Rasterize[g,"Image",
											Background->None]
										]
								},
								1
								]
						},
						1]
					]&,
				Identity
				]@
			If[pad=!=None,
				Replace[frameColor,{
					_?ColorQ:>
						ImagePad[#,
							pad,
							frameColor],
					{c1:_?ColorQ|Automatic,c2:_?ColorQ|Automatic}:>
						Replace[pad,{
							n_?NumericQ:>
								Function[If[ColorQ@c2,ImagePad[#,{{0,0},{n,n}},c2],#]]@
									If[ColorQ@c1,
										ImagePad[#,{{n,n},{0,0}},c1],
										#
										],
							{h_?NumericQ,v_?NumericQ}:>
								Function[If[ColorQ@c2,ImagePad[#,{{0,0},{v,v}},c2],#]]@
									If[ColorQ@c1,
										ImagePad[#,{{h,h},{0,0}},c1],
										#
										],
							{{l_,r_},{b_,t_}}:>
								Function[If[ColorQ@c2,ImagePad[#,{{0,0},{b,t}},c2],#]]@
									If[ColorQ@c1,
										ImagePad[#,{{l,r},{0,0}},c1],
										#
										]
							}],
					{{cl_,cr_},{cb_,ct_}}:>
						Replace[pad,{
							n_?NumericQ:>
								Function[If[ColorQ@ct,ImagePad[#,{{0,0},{0,n}},ct],#]]@
								Function[If[ColorQ@cb,ImagePad[#,{{0,0},{n,0}},cb],#]]@
								Function[If[ColorQ@cr,ImagePad[#,{{0,n},{0,0}},cr],#]]@
									If[ColorQ@cl,
										ImagePad[#,{{n,0},{0,0}},cl],
										#
										],
							{h_?NumericQ,v_?NumericQ}:>
								Function[If[ColorQ@ct,ImagePad[#,{{0,0},{0,v}},ct],#]]@
								Function[If[ColorQ@cb,ImagePad[#,{{0,0},{v,0}},cb],#]]@
								Function[If[ColorQ@cr,ImagePad[#,{{0,h},{0,0}},cr],#]]@
									If[ColorQ@cl,
										ImagePad[#,{{h,0},{0,0}},cl],
										#
										],
							{{l_,r_},{b_,t_}}:>
								Function[If[ColorQ@ct,ImagePad[#,{{0,0},{0,t}},ct],#]]@
								Function[If[ColorQ@cb,ImagePad[#,{{0,0},{b,0}},cb],#]]@
								Function[If[ColorQ@cr,ImagePad[#,{{0,r},{0,0}},cr],#]]@
									If[ColorQ@cl,
										ImagePad[#,{{l,0},{0,0}},cl],
										#
										]
							}]
					}]&,
				Identity]@
				LinearGradientImage[
					Thread@{Center,cents}->
						MapThread[
							With[{c=#,a=#2},
								Hue[#[[1]],#[[2]],#[[3]]+a]&@
									ColorConvert[c,Hue]
								]&,{
								Take[Flatten@ConstantArray[color,3],3],
								adj
							}],
					imageSize
					]
			]
	];


(* ::Subsubsection::Closed:: *)
(*FrameMasked*)



Options[FrameMasked]=
	Join[
		Options@Framed,
		Options@Rasterize,{
		Epilog->Identity
		}];
FrameMasked[img_?ImageQ,ops:OptionsPattern[]]:=
	With[{
		id=ImageDimensions@img,
		keyColor=
			Replace[OptionValue@FrameStyle,{
				_?(ColorQ@#&&ColorDistance[Black,#]<.01&)->
					Purple,
				_?(ColorQ@#&&ColorDistance[White,#]<.01&)->
					Green,
				c_?ColorQ:>
					ColorNegate[c],
				Directive[___,c_?ColorQ,___]:>
					ColorNegate[c],
				_->Black
				}]},
		With[{
			template=
				Rasterize[
					Framed["",
						Background->keyColor,
						ImageSize->id,
						FrameStyle->
							Replace[OptionValue[FrameStyle],
								Except[_?ColorQ|_Directive|Thick|Thin|None]:>
									None
								],
						FilterRules[{ops},
							Options@Framed]
						],
					"Image",
					RasterSize->id,
					FilterRules[{ops},Options@Rasterize]
					]
				},
			OptionValue[Epilog]@
					ReplacePixelValue[template,
						Join[
							Thread[
								With[{ppos=
									PixelValuePositions[template,
										keyColor,
										.5
										]},
									ppos->PixelValue[img,ppos]
									]
								],
							With[{ppos=PixelValuePositions[template,White]},
								Map[#->{1.,1.,1.,0.}&,ppos]
								]
							]
						]
			]
		];
FrameMasked[k_->i_?ImageQ,ops:OptionsPattern[]]:=
	k->FrameMasked[i,ops];
FrameMasked[r:{__Rule},ops:OptionsPattern[]]:=
	FrameMasked[#,ops]&/@r;


(* ::Subsubsection::Closed:: *)
(*ColorizedAppearances*)



(*gradientPreservingColoration[image_?ImageQ,colorValue_?ColorQ]:=
	With[{
			img=ColorConvert[image,Hue],
			color=ColorConvert[colorValue,Hue]
			},
		With[{brightnessDistance=
				color[[3]]-
					Median[Flatten[ImageData@ColorConvert[img,Hue],1]][[3]]
				},
			Image[
				ImageAdjust[
					ImageMultiply[Lighter[img,brightnessDistance],color],
					{0.5,-.1}],
				Interleaving\[Rule]True
				]
			]
		];*)


(*$colorizerDefaultColors=
	Hue@@@
		Join[
			Tuples[{Range[0,1,.1],{1},Range[.5,1,.25]}],
			Tuples[{{0},{0},Range[0,1,.1]}]
			];
ColorizedAppearances[
	im_?ImageQ,
	pixelValues:{__?ColorQ}:
		$colorizerDefaultColors
	]:=
	Map[gradientPreservingColoration[im,#]&,pixelValues];
ColorizedAppearances[
	im_?ImageQ,
	c_?ColorQ]:=
	gradientPreservingColoration[im,c];
ColorizedAppearances[
	assoc_Association?(MatchQ[Normal@#,{(_\[Rule]_?ImageQ)..}]&),
	pixelValues:_?ColorQ|{__?ColorQ}:
		$colorizerDefaultColors
	]:=
	Normal@Map[ColorizedAppearances[#,pixelValues]&,assoc];
ColorizedAppearances[ims:{(_\[Rule]_?ImageQ)..},
	pixelValues:_?ColorQ|{__?ColorQ}:
		$colorizerDefaultColors]:=
With[{assoc=Association@ims},
ColorizedAppearances[assoc,pixelValues]
];
ColorizedAppearances[ims:{(_\[Rule]_FrontEnd`FileName)..},
	pixelValues:_?ColorQ|{__?ColorQ}:
		$colorizerDefaultColors]:=
	ColorizedAppearances[
		Map[First@#\[Rule]FEImport[Last@#]&,ims],
		pixelValues
		];
ColorizedAppearances[ims:{(_\[Rule]_RawBoxes)..},
	pixelValues:_?ColorQ|{__?ColorQ}:
		$colorizerDefaultColors]:=
With[{assoc=ToExpression@*First/@Association@ims},
ColorizedAppearances[assoc,pixelValues]
];
ColorizedAppearances[s_String,
	pixelValues:_?ColorQ|{__?ColorQ}:
		$colorizerDefaultColors
	]:=
	With[{resource=FEResourceFind[s]},
		Replace[
			FEFormatResource@
				FirstCase[resource,
					{(_\[Rule](_?ImageQ|_FrontEnd`FileName))..},
					$Failed,\[Infinity]],{
			$Failed\[RuleDelayed]
					Replace[
						FirstCase[resource,
							_?ImageQ|_RawBoxes,
							$Failed,\[Infinity]],{
						i:Except[$Failed]:>
							ColorizedAppearances[{"Default"->i},pixelValues]
							}],
			l_:>
				ColorizedAppearances[l,pixelValues]
			}]
		];
ColorizedAppearances[spec_,
	cd:_Integer|_String?(MatchQ[ColorData[#],_ColorDataFunction]&)]:=
	ColorizedAppearances[spec,
		DeleteDuplicates[
			Table[ColorData[cd][i],{i,100}],
			Norm@(List@@#-List@@#2)<.05&
			]
		];
	*)


(* ::Subsubsection::Closed:: *)
(*ColorizationAdjust*)



(*ColorizationAdjust[color_,appearanceList_List]:=
	MapThread[
		First@#2->
			#@Last@#2&,
		{
			Take[
				With[{cd=
					ColorDistance[color,Black,
						DistanceFunction\[Rule](Abs[#1[[1]]-#2[[1]]]&)]
					},
					With[{rescale=
						If[cd<.5,
							Cos[\[Pi]*cd]^3,
							1/6Max@{Sin[2\[Pi] cd],Tan[\[Pi] cd]}-.01
							]
						},
						If[rescale<0,
							{
								Image[Darker[#,-rescale],
										Interleaving\[Rule]True
										]&,
								Identity,
								Identity
								},
							{
								Identity,
								Image[Lighter[#,rescale],
									Interleaving\[Rule]True
									]&,
								Identity}
							]
						]
					],
				UpTo@Length@appearanceList
				],
			Take[appearanceList,UpTo[3]]
			}];*)


(* ::Subsection:: *)
(*GradientStuff*)



(* ::Subsubsection::Closed:: *)
(*GradientPanelAppearance*)



Options[GradientPanelAppearance]=
	Options@GradientAppearance;
GradientPanelAppearance[
	c:{_?ColorQ,_?ColorQ,_?ColorQ},
	center:
		_?NumericQ|_Scaled|
			{_?NumericQ|_Scaled,_?NumericQ|_Scaled}:
		Scaled[0],
	ops:OptionsPattern[]]:=
	AppearanceReadyImage@
		GradientAppearance[c,center,ops];
GradientPanelAppearance[{c_?ColorQ},
	center:
		_?NumericQ|_Scaled|
			{_?NumericQ|_Scaled,_?NumericQ|_Scaled}:
		Scaled[0],
		ops:OptionsPattern[]]:=
	AppearanceReadyImage@
		GradientAppearance[c,center,ops];
GradientPanelAppearance[c_?ColorQ,
	center:
		_?NumericQ|_Scaled|
			{_?NumericQ|_Scaled,_?NumericQ|_Scaled}:
		Scaled[0],
	ops:OptionsPattern[]]:=
	AppearanceReadyImage@Map[#->GradientAppearance[c,center,ops]&,
		{"Default","Hover"}];
GradientPanelAppearance[Optional[Automatic|Generic,Automatic],
	center:
		_?NumericQ|_Scaled|
			{_?NumericQ|_Scaled,_?NumericQ|_Scaled}:
		Scaled[0],
	ops:OptionsPattern[]
	]:=
	GradientPanelAppearance[GrayLevel[.95],center,ops];
GradientPanelAppearance["Palette",ops___]:=
	GradientPanelAppearance[
		{
			GrayLevel[.85],
			GrayLevel[.9],
			GrayLevel[.96]
			},
		ops,
		FrameStyle->GrayLevel[.6]
		]


(* ::Subsubsection::Closed:: *)
(*GradientButtonAppearance*)



Options[GradientButtonAppearance]=
	Join[
		{
			Appearance->Automatic
			},
		Options[GradientAppearance],
		Options[FrameMasked]
		];
GradientButtonAppearance[c:{__?ColorQ},
	ops:OptionsPattern[]]:=
	AppearanceReadyImage@
		If[OptionValue[RoundingRadius]>0||
				MatchQ[OptionValue@FrameStyle,
					Thick|Thin|_Directive]//TrueQ,
			FrameMasked[#,
				FilterRules[{
					FrameStyle->
						Replace[OptionValue[FrameStyle],{
							Automatic:>
								Darker@First@c,
							d:Thick|Thin|_Thickness:>
								Directive[d,Darker@First@c],
							f_:>
								Replace[f[First@c],
									Except[_?ColorQ]->f
									]
							}],
					ops
					},
					Options@FrameMasked
					]
				]&,
			Identity
			]@
		MapThread[Rule,{
			{"Default","Hover","Pressed"},
			{	
				GradientAppearance[c,Scaled[.25],
					FilterRules[{
						If[OptionValue[RoundingRadius]>0||
								MatchQ[OptionValue@FrameStyle,
									Thick|Thin|_Directive]//TrueQ,
							FrameStyle->None,
							Nothing
							],
						ImageAdjust->
							Replace[OptionValue@ImageAdjust,{
								n:{__?NumericQ}:>
									n,
								{n_,_,_}:>
									n
								}],
						ops
						},
						Options@GradientAppearance
						]
					],
				GradientAppearance[Lighter[#,.2]&/@c,Scaled[.25],
					FilterRules[{
						If[OptionValue[RoundingRadius]>0||
								MatchQ[OptionValue@FrameStyle,
									Thick|Thin|_Directive]//TrueQ,
							FrameStyle->None,
							Nothing
							],
						ImageAdjust->
							Replace[OptionValue@ImageAdjust,{
								n:{__?NumericQ}:>
									n,
								{_,n_,_}:>
									n
								}],
						ops
						},
						Options@GradientAppearance
						]
					],
				GradientAppearance[Darker[#,.1]&/@c,
					Scaled/@{.65,.25},
					FilterRules[{
						If[OptionValue[RoundingRadius]>0||
								MatchQ[OptionValue@FrameStyle,
									Thick|Thin|_Directive]//TrueQ,
							FrameStyle->None,
							Nothing
							],
						ImageAdjust->
							Replace[OptionValue@ImageAdjust,{
								n:{__?NumericQ}:>
									Reverse@n,
								{_,_,n_}:>
									Replace[n,
										Automatic->{-.05,0,0.}
										],
								Automatic->
									{-.05,0,0.}
								}],
						ops
						},
						Options@GradientAppearance
						]
					]
				}
			}
			];
GradientButtonAppearance[
		c_?ColorQ,app:_String|_Symbol:Automatic,
		Except[_?OptionQ]...,
		ops:OptionsPattern[]]:=
	GradientButtonAppearance[
		Replace[Replace[app,Automatic:>OptionValue@Appearance],{
			"Palette":>{c,Lighter[c,.2],Lighter[c,.4]},
			Flat:>{c,Darker[c,.05],Lighter[c,.05]},
			"Shiny":>{Darker[c,.2],Lighter[c,.2],c},
			"Retro":>
				{Gray,c,Gray},
			"Test1":>
				{Lighter[c,.6],c,Darker[c,.6]},
			"Test2":>
				{c,Darker[c,.2],c},
			"Negative":>
				{c,ColorNegate[c],c},
			_->{c,c,c}
			}],
		ops,
		ImageAdjust->{0,.025,-.05}
		];
GradientButtonAppearance[
		app:_String|_Symbol:Automatic,
		Except[_?ColorQ]...,
		c_?ColorQ,
		Except[_?OptionQ]...,
		ops:OptionsPattern[]]:=
		GradientButtonAppearance[c,app,ops];(*
	GradientButtonAppearance[
		Replace[
			Replace[app,Automatic:>OptionValue@Appearance],
			{
				"Palette"\[RuleDelayed]{c,Lighter[c,.2],Lighter[c,.7]},
				Flat:>{c,Darker[c,.05],Lighter[c,.05]},
				"Shiny"\[RuleDelayed]{c,Darker[c,.2],Lighter[c,.2]},
			_->{c,c,c}
			}],
		ops,
		ImageAdjust->{0,.025,-.05}
		];*)
GradientButtonAppearance["Palette",ops:OptionsPattern[]]:=
	GradientButtonAppearance[
		{
			GrayLevel[.85],
			GrayLevel[.9],
			GrayLevel[.96]
			},
		ops,
		FrameStyle->GrayLevel[.6]
		];
GradientButtonAppearance[
	Optional[Automatic|Generic,Automatic],
	app:_String|_Symbol:Automatic,
	ops:OptionsPattern[]]:=
	GradientButtonAppearance[GrayLevel[.95],app,ops];


(* ::Subsubsection::Closed:: *)
(*GradientDropDownAppearance*)



Options[GradientDropDownAppearance]=
	Options@GradientButtonAppearance;
GradientDropDownAppearance[
	h1:_?ColorQ|{__?ColorQ},
	h2:_?ColorQ|{_?ColorQ,_?ColorQ}:{Black,Gray},
	ops:OptionsPattern[]
	]:=
	With[{base=
		GradientButtonAppearance[
			h1,
			ops,
			ImageSize->{20,24},
			ImageCompose->{
				Graphics[{
					First@Flatten@{h2},
					Triangle[{{0,0},{1,-1},{2,0}}]
					},
					ImageSize->10
					]
				}
			]
		},
		If[ListQ@h2,
			Append[base,
				"Disabled"->Lookup[
					GradientButtonAppearance[h1,
						ops,
						ImageSize->{20,24},
						ImageCompose->{
							Graphics[{
								Last@h2,
								Triangle[{{0,0},{1,-1},{2,0}}]
								},
								ImageSize->10
								]
							}
						],
					"Default"
					]
				],
			base
			]
		];
GradientDropDownAppearance[
	Optional[Generic|Automatic,Automatic],
	ops:OptionsPattern[]]:=
	GradientDropDownAppearance[GrayLevel[.95],GrayLevel[.4],
		ops
		];
GradientDropDownAppearance[PopupMenu,ops:OptionsPattern[]]:=
	GradientDropDownAppearance[Hue[0.59,0.71,0.75],White,
		ops];
GradientDropDownAppearance[ActionMenu,ops:OptionsPattern[]]:=
	GradientDropDownAppearance[GrayLevel[.2],White,
		ops];
GradientDropDownAppearance["Palette",ops:OptionsPattern[]]:=
	GradientDropDownAppearance[
		{
			GrayLevel[.85],
			GrayLevel[.9],
			GrayLevel[.96]
			},{Black,Gray},
		ops,
		FrameStyle->GrayLevel[.6]
		];


notRules=
	Except[_Rule|_RuleDelayed|{(_Rule|_RuleDelayed)..}|_FilterRules];


(* ::Subsection:: *)
(*Framed**)



(* ::Subsubsection::Closed:: *)
(*FramedButton*)



Options@FramedButton=
	Normal@Merge[{
		Appearance->"Frameless",
		Options@Button,
		Options@Framed,
		Options@Style,
		"HoverStyle"->None
		},
		First
		];
FramedButton[disp_,expr_:Null,ops:OptionsPattern[]]:=
	With[{
		flops=
			DeleteCases[
				Normal@Merge[{ops,Options@FramedButton},First],
				Alternatives@@
					Normal@Merge[{Options@Button,Options@Framed,Options@Style},First]
				],
		slops=
			FilterRules[{ops},Options@Style]},
		Button[
			Replace[OptionValue@"HoverStyle",{
				None->
					Framed[Style[disp,slops],FilterRules[flops,Options@Framed]],
				s_:>
					Mouseover[
						Framed[Style[disp,slops],FilterRules[flops,Options@Framed]],
						Framed[
							Style[disp,
								FilterRules[
									Cases[Flatten@{s,slops},_Rule|_RuleDelayed],
									Options@Style]],
							FilterRules[
								Cases[Flatten@{s,flops},_Rule|_RuleDelayed],
								Options@Framed]]
						]
				}],
			expr,
			FilterRules[flops,Options@Button]
			]
		];
FramedButton~SetAttributes~HoldRest;


(* ::Subsubsection::Closed:: *)
(*FramedPopupMenu*)



Options@FramedPopupMenu=
	DeleteDuplicatesBy[
		Join[
			{
				Alignment->Right
			},
			Options@PopupMenu,
			Options@Framed,
			Options@Style,
			Options@Pane
			],
		First
		];
FramedPopupMenu[
	var_,
	settings_List,
	expr:Except[_Rule|_RuleDelayed]:Automatic,
	ops:OptionsPattern[]]:=
	Framed[
		Pane[
			PopupMenu[
				var,
				settings,
				Replace[var,
					Verbatim[Dynamic][e_,___]:>e
					],
				Style[
					Replace[
						expr,
						Automatic:>
							Row@{var,Spacer@10,"\[DownPointer]"}
						],
					FilterRules[{ops},
						Except@(
							Alternatives@@(
								Join[
									Options@PopupMenu,
									Options@Framed,
									Options@Pane
									])
							)]
					],
				FilterRules[{ops},
					Options@PopupMenu]
				],
			FilterRules[{ops},
				Options@Pane]
			],
		FilterRules[{ops},
			Options@Framed]
		];


(* ::Subsubsection::Closed:: *)
(*FramedActionMenu*)



Options@FramedActionMenu=
	DeleteDuplicatesBy[
		Join[
			{
				Alignment->Right,
				RoundingRadius->5
			},
			Options@ActionMenu,
			Options@Framed,
			Options@Style,
			Options@Pane
			],
		First
		];
FramedActionMenu[
	name_,
	settings_List,
	ops:OptionsPattern[]]:=
	Framed[
		Pane[
			ActionMenu[
				Style[name,
					FilterRules[{ops},
						Except@(
							Alternatives@@(
								Join[
									Options@PopupMenu,
									Options@Framed,
									Options@Pane
									])
							)]
					],
				settings,
				Appearance->None,
				FilterRules[{ops},
					Options@ActionMenu]
				],
			FilterRules[{ops},
				Options@Pane]
			],
		FilterRules[{ops},
			Options@Framed]
		];


(* ::Subsection:: *)
(*Colored**)



(* ::Subsubsection::Closed:: *)
(*ColoredButton*)



(*ColoredButtonAppearances[
	a:_String|_?ImageQ|{"Default"\[Rule]_,"Hover"\[Rule]_,"Pressed"\[Rule]_},
	color_?ColorQ]:=
	ColorizationAdjust[
		color,
		ColorizedAppearances[a,color]
		];
ColoredButtonAppearances[
	Optional[Automatic,Automatic],
	color_?ColorQ]:=
	ColorizationAdjust[
		color,
		ColorizedAppearances[
			FrontEndResource["NotebookTemplatingExpressions",
				"ButtonDefaultAppearance"],
			color]
		];
ColoredButtonAppearances[Automatic]:=
	FrontEndResource["NotebookTemplatingExpressions",
		"ButtonDefaultAppearance"];
ColoredButtonAppearances[spec_,i:_Integer|_String]:=
	ColorizedAppearances[spec,i];
ColoredButtonAppearances[s_String]:=
	Replace[FEResourceFind[s],{
		{_\[Rule]g_,___}:>
			g,
		_:>
			ColoredButtonAppearances[Automatic]
		}];*)


(*Options[ColoredButton]=
	Options@Button;
ColoredButton[label_,
	expr:notRules:Null,
	ops:OptionsPattern[]]:=
	Button[label,
		expr,
		Appearance\[Rule]
			Replace[
				Flatten@{
					Replace[OptionValue@Appearance,{
						c:_?ColorQ|_String|Automatic:>
							ColoredButtonAppearances[c],
						{s_String,c_}:>
							ColoredButtonAppearances[s,c],
						{l:_List|_?ImageQ,c_}:>
							ColorizedAppearances[l,c]
						}]},{
				a:{__Rule}:>
					DeleteCases[
						Thread[
							{"Default","Pressed","Hover"}->
							Lookup[Association@a,
								{"Default","Pressed","Hover"}]
							],
						_\[Rule]_Missing
						],
				b_:>
					Thread[
						{"Default","Hover","Pressed"}->
							Take[Flatten@ConstantArray[b,3],3]
						]
			}],
		ops,
		Alignment->Top
		];
ColoredButton~SetAttributes~HoldRest;*)


(* ::Subsubsection::Closed:: *)
(*ColoredPanel*)



(*$baseColoredPanel=
	FirstCase[
		FrontEndResource["FEExpressions","HelpViewerToolbar"],
		_Image,
		None,
		\[Infinity]
		]//
		ImagePad[
			ImagePad[
				ImagePad[#,{{0,0},{1,1}},GrayLevel[.8]],
				{{0,0},{1,0}},GrayLevel[.7]
				],
			1,
			RGBColor[0,0,0,0]
			]&;*)


(*$coloredPanelAppearance=
	AppearanceReadyImage[$baseColoredPanel,
		BorderDimensions\[Rule]Automatic
		];*)


(*ColoredPanelAppearances[
	a:_String|_?ImageQ|{"Default"\[Rule]_,"Hover"\[Rule]_,"Pressed"\[Rule]_},
	color_?ColorQ]:=
	ColorizedAppearances[a,color];
ColoredPanelAppearances[
	Optional[Automatic,Automatic],
	color_?ColorQ]:=
	"Default"->ColorizedAppearances[$coloredPanelAppearance,color];
ColoredPanelAppearances[Automatic]:=
	"Default"->$coloredPanelAppearance;
ColoredPanelAppearances[spec_,i:_Integer|_String]:=
	ColorizedAppearances[spec,i];
ColoredButtonAppearances[s_String]:=
	Replace[FEResourceFind[s],{
		{_\[Rule]g_,___}:>
			g,
		_:>
			ColoredButtonAppearances[Automatic]
		}];*)


(*Options[ColoredPanel]=
	Options[Panel];
ColoredPanel[label_,
	ops:OptionsPattern[]]:=
	Panel[label,
		Appearance\[Rule]
			Replace[
				Flatten@{
					Last/@
						Flatten@{
							Replace[OptionValue@Appearance,{
								c:_?ColorQ|_String|Automatic:>
									ColoredPanelAppearances[c],
								{s_String,c_}:>
									ColoredPanelAppearances[s,c],
								{l:_List|_?ImageQ,c_}:>
									ColorizedAppearances[l,c]
								}]}
						},{
					{"Frameless"\[Rule]i_}:>
						i,
					a:{__Rule}:>
						DeleteCases[
							Thread[
								{"Default","Pressed","Hover"}->
								Lookup[Association@a,
									{"Default","Pressed","Hover"}]
								],
							_\[Rule]_Missing
							],
					b_:>
						Thread[
							{"Default","Hover","Pressed"}->
								Take[Flatten@ConstantArray[b,3],3]
							]
				}],
		ops,
		Alignment->Top
		];*)


(* ::Subsubsection::Closed:: *)
(*ColoredPopupMenu*)



(*Options@ColoredPopupMenu=
	DeleteDuplicatesBy[
		Join[
			Options@ColoredButton,
			Options@PopupMenu
			],
		First
		];
ColoredPopupMenu[
	var_,
	settings_List,
	expr:notRules:Automatic,
	ops:OptionsPattern[]]:=
	PopupMenu[
		var,
		settings,
		Replace[var,
			Verbatim[Dynamic][e_,___]\[RuleDelayed]e
			],
		ColoredButton[
			Replace[
				expr,
				Automatic:>
					Row@{var,Spacer@10,"\[DownPointer]"}
				],
			Null,
			Evaluate@FilterRules[{ops},
				Options@ColoredButton]
			],
			FilterRules[{ops},
				FilterRules[Options@PopupMenu,
					Except[Alternatives@@Map[First,Options@ColoredButton]]]
				]
		];*)


(* ::Subsubsection::Closed:: *)
(*ColoredActionMenu*)



(*Options@ColoredActionMenu=
	DeleteDuplicatesBy[
		Join[
			Options@ColoredButton,
			Options@ActionMenu
			],
		First
		];
ColoredActionMenu[expr_,actions_List,ops:OptionsPattern[]]:=
	ActionMenu[
		ColoredButton[expr,Null,Evaluate@FilterRules[{ops},Options@ColoredButton]],
		actions,
		Appearance\[Rule]None,
		FilterRules[{ops},Except[Alternatives@@Map[First,Options@ColoredButton]]]
		]*)


(* ::Subsection:: *)
(*Combos*)



(* ::Subsubsection::Closed:: *)
(*coloredTriangleAppearance*)



(*coloredTriangleAppearance//Clear
coloredTriangleAppearance[img_,fill_?ColorQ]:=
	ReplacePixelValue[img,
		Join[
			Thread[{Range[10,14],16}],
			Thread[{Range[11,13],15}],
			Thread[{Range[11,13],14}],
			{{12,13}}
			]\[Rule]fill
		];
coloredTriangleAppearance[img_,Except[_?ColorQ]..]:=
	img;
coloredTriangleAppearance[img_,fill_,border:Except[_?ColorQ]]:=
	coloredTriangleAppearance[img,fill];
coloredTriangleAppearance[img_,fill_,border_?ColorQ]:=
	Fold[ReplacePixelValue,
		coloredTriangleAppearance[img,fill],
		{
			{
				{9,16},{15,16},
				{10,14},{14,14},
				{12,12}
				}\[Rule]
				If[ColorQ@fill,Blend[{border,fill},.3],border],
			{{10,15},{14,15}}\[Rule]
				If[ColorQ@fill,Blend[{border,fill},.4],border],
			{{11,13},{13,13}}->
				If[ColorQ@fill,Blend[{border,fill},.2],border]
			}
		]*)


(* ::Subsubsection::Closed:: *)
(*PopupDropDown*)



(*Options[PopupDropDown]=
	Options[PopupMenu];
PopupDropDown[var_,settings_List,ops:OptionsPattern[]]:=
	With[{
		dynamicVar=
			Replace[var,{
				Except[_Dynamic|None]:>
					With[{s=Unique@"FE`popupVar$"},
						s=Replace[settings,{
							k_\[Rule]v_\[RuleDelayed]v,
							{k_\[Rule]v_,___}\[RuleDelayed]v,
							{v_,___}\[RuleDelayed]v
							}];
						Dynamic[s]
					]
				}],
		appearance=
			Replace[OptionValue[Appearance],{
				c_?ColorQ\[RuleDelayed]
					ColorizationAdjust[
						c,
						ColorizedAppearances[
							FrontEndResource["NotebookTemplatingExpressions",
								"ButtonDropdownRightAppearance"],
							c]
						],
				{c_?ColorQ,f_}:>
					Map[
						First@#->
							coloredTriangleAppearance[Last@#,f,c]&,
						ColorizationAdjust[
							c,
							ColorizedAppearances[
								FrontEndResource["NotebookTemplatingExpressions",
									"ButtonDropdownRightAppearance"],
								c]
							]
						],
				{c_?ColorQ,f_,b_}:>
					Map[
						First@#->
							coloredTriangleAppearance[Last@#,f,b]&,
						ColorizationAdjust[
							c,
							ColorizedAppearances[
								FrontEndResource["NotebookTemplatingExpressions",
									"ButtonDropdownRightAppearance"],
								c]
							]
						],
				s_String:>
					ColoredButtonAppearances[s],
				{s_String,c_}:>
					ColorizedAppearances[s,c],
				{l:_List|_?ImageQ,c_}:>
					ColorizedAppearances[l,c],
				Except[_List|_?ImageQ]\[RuleDelayed]
					FrontEndResource["NotebookTemplatingExpressions",
						"ButtonDropdownRightAppearance"]
				}],
		imageSize=
			Replace[OptionValue[ImageSize],{
				25\[Rule]
					Automatic,
				s:Except[_List]\[RuleDelayed]
					{Automatic,s},
				{_,25}:>
					Automatic,
				{_,s_}\[RuleDelayed]
					{Automatic,s}
				}],
		frameMargins=
			Replace[OptionValue[FrameMargins],{
				n_Integer:>
					{{0,0},{Floor[n/2],Ceiling[n/2]}},
				{{l_,r_},{b_,t_}}:>
					{{0,0},{b,t}}
				}]
		},
		PopupMenu[
			dynamicVar,
			settings,
			Null,
			Button[Null,
				Appearance\[Rule]appearance,
				ImageSize\[Rule]imageSize,
				FrameMargins\[Rule]frameMargins
				],
			Appearance\[Rule]None,
			FilterRules[{ops},
				Except[ImageSize|Appearance|FrameMargins]]
			]
		];*)


(* ::Subsubsection::Closed:: *)
(*ActionDropDown*)



(*Options[ActionDropDown]=
	Options[ActionMenu];
ActionDropDown[settings_List,ops:OptionsPattern[]]:=
	With[{
		appearance=
			Replace[OptionValue[Appearance],{
				c_?ColorQ\[RuleDelayed]
					ColorizationAdjust[
						c,
						ColorizedAppearances[
							FrontEndResource["NotebookTemplatingExpressions",
								"ButtonDropdownRightAppearance"],
							c]
						],
				{c_?ColorQ,f_?ColorQ}:>
					Map[
						First@#->coloredTriangleAppearance[Last@#,f,f]&,
						ColorizationAdjust[
							c,
							ColorizedAppearances[
								FrontEndResource["NotebookTemplatingExpressions",
									"ButtonDropdownRightAppearance"],
								c]
							]
						],
				{c_?ColorQ,f_?ColorQ,b_?ColorQ}:>
					Map[
						First@#->coloredTriangleAppearance[Last@#,f,b]&,
						ColorizationAdjust[
							c,
							ColorizedAppearances[
								FrontEndResource["NotebookTemplatingExpressions",
									"ButtonDropdownRightAppearance"],
								c]
							]
						],
				s_String:>
					ColoredButtonAppearances[s],
				{s_String,c_}:>
					ColorizedAppearances[s,c],
				{l:_List|_?ImageQ,c_}:>
					ColorizedAppearances[l,c],
				Except[_List|_?ImageQ]\[RuleDelayed]
					FrontEndResource["NotebookTemplatingExpressions",
						"ButtonDropdownRightAppearance"]
				}],
		imageSize=
			Replace[OptionValue[ImageSize],{
				25\[Rule]
					Automatic,
				s:Except[_List]\[RuleDelayed]
					{Automatic,s},
				{_,25}:>
					Automatic,
				{_,s_}\[RuleDelayed]
					{Automatic,s}
				}]
		},
		ActionMenu[
				Button["",
				Appearance\[Rule]appearance,
				ImageSize\[Rule]imageSize,
				FilterRules[{ops},Options@Button]
				],
			settings,
			Appearance\[Rule]None,
			FilterRules[{ops},Except[ImageSize|Appearance]]
			]
		];*)


(* ::Subsubsection::Closed:: *)
(*ButtonPopupMenu*)



(*Options@ButtonPopupMenu=
	DeleteDuplicatesBy[
		Join[
			Options@Button,
			Options@PopupMenu
			],
		First
		];
With[{notRules=notRules},
ButtonPopupMenu[
	label_,
	varList:_List|(_List\[Rule]_),
	buttonCall:notRules:None,
	ops:OptionsPattern[]
	]:=
	ButtonPopupMenu[Automatic,label,varList,buttonCall,ops];
ButtonPopupMenu[
	varList:_List|(_List\[Rule]_),
	buttonCall:notRules:None,
	ops:OptionsPattern[]
	]:=
	ButtonPopupMenu[Automatic,Automatic,varList,buttonCall,ops];
ButtonPopupMenu[
	buttonLabel_,
	label_,
	varList:_List|(_List\[Rule]_),
	buttonCall:notRules:None,
	ops:OptionsPattern[]
	]:=
	With[{
		popVar=
			Replace[label,{
				Automatic:>
					With[{s=Unique@"FE`popupVar$"},
						s=Replace[varList,{
							k_\[Rule]v_\[RuleDelayed]v,
							{k_\[Rule]v_,___}\[RuleDelayed]v,
							{v_,___}\[RuleDelayed]v
							}];
						Dynamic[s]
						],
				Verbatim[Dynamic][h_[s_Symbol,___],e___]:>
					Dynamic[s]
				}],
		defaultElement=
			Replace[varList,{
				(_List\[Rule]d_)\[RuleDelayed]
					d,
				_\[Rule]""
				}],
		appearanceAssoc=
			Association@
				Replace[
					Replace[varList,(l_List\[Rule]_)\[RuleDelayed]l],{
						RuleDelayed[a_,b_]:>
							(a\[Rule]b),
						a:Except[_Rule]:>
							(a\[Rule]a)
					},1],
		imgSize=
			Replace[OptionValue@ImageSize,{
				{{i_?NumericQ,h_},_}:>
					{i-25,h},
				i_?NumericQ:>
					i-25,
				{i_?NumericQ,h_}:>
					{i-25,h},
				{b_List,_}:>
					b
				}],
		useApp=
			Replace[OptionValue[Appearance],{
				PopupMenu\[Rule]{
					{"ButtonDefaultAppearance",GrayLevel[.98]},
					{,White,}
					}
				}]
		},
		With[{call=
			Replace[Unevaluated[buttonCall],{
				f_Function:>
					Hold@f[First@popVar],
				e_:>
					Hold[e]
				}]
			},
		Row[
			{
				Button[
					Replace[buttonLabel,
						Automatic:>
							Replace[Replace[label,Except[_Dynamic]:>popVar],{
								Verbatim[Dynamic][v_Symbol,f___]:>
									Dynamic[Lookup[appearanceAssoc,Key@v,defaultElement],f],
								Verbatim[Dynamic][h_[v_Symbol,s___],f___]:>
									Dynamic[
										h[
											Lookup[appearanceAssoc,Key@v,defaultElement],
											s],f]
								}]
							],
					If[ReleaseHold[call]===None,Null],
					Appearance->
						With[{realApp=
							Replace[
								Replace[useApp,{
									{a_,___}\[RuleDelayed]a
									}],{
									{s_String,c_}:>
										ColoredButtonAppearances[s,c],
									{l_List,c_}:>
										ColoredButtonAppearances[l,c],
									c_:>
										ColoredButtonAppearances[c]
									}
								]
							},
							If[Unevaluated[buttonCall]===None,
								Lookup[realApp,"Default"],
								realApp
								]
							],
					ImageSize\[Rule]imgSize,
					FrameMargins->
						Replace[OptionValue@FrameMargins,
							i_Integer\[RuleDelayed]
								{{i,i},{0,0}}
							],
					FilterRules[{ops},Options@Button]
					],
				PopupDropDown[popVar,
					Replace[varList,(l_\[Rule]_)\[RuleDelayed]l],
					Appearance->
						Replace[
							Replace[useApp,{
								{___,a_}\[RuleDelayed]a
								}],{
								s_String:>
									ColoredButtonAppearances[s],
								{s_String,c_}:>
									ColorizedAppearances[s,c],
								{l_List,c_}:>
									ColorizedAppearances[l,c]
								}],
					FrameMargins->
						Replace[OptionValue@FrameMargins,
							i_Integer\[RuleDelayed]
								{{i,i},{0,0}}
							],
					ImageSize->
						Replace[OptionValue@ImageSize,{
							i_Integer:>
								Automatic,
							{_List,s_}\[RuleDelayed]s
							}],
					ops
					]
				}
			]
			]
		];
];
ButtonPopupMenu~SetAttributes~HoldRest*)


(* ::Subsubsection::Closed:: *)
(*ButtonActionMenu*)



(*Options@ButtonActionMenu=
	DeleteDuplicatesBy[
		Join[
			Options@Button,
			Options@ActionMenu
			],
		First
		];
With[{notRule=notRules},
ButtonActionMenu[
	label_,
	actions_List,
	buttonCall:_?(Not@*OptionQ):None,
	ops:OptionsPattern[]
	]:=
	With[{
		useApp=
			Replace[OptionValue[Appearance],{
				PopupMenu\[Rule]{
					{"ButtonDefaultAppearance",GrayLevel[.98]},
					{,White,}
					}
				}]
		},
	Row[
		{
			Button[label,
				If[buttonCall===None,Null],
				Appearance->
					With[{realApp=
						Replace[
							Replace[useApp,{
								{a_,___}\[RuleDelayed]a
								}],{
								{s_String,c_}:>
									ColoredButtonAppearances[s,c],
								{l_List,c_}:>
									ColoredButtonAppearances[l,c],
								c_:>
									ColoredButtonAppearances[c]
								}
							]
						},
						If[Unevaluated[buttonCall]===None,
							Lookup[realApp,"Default"],
							realApp
							]
						],
				FilterRules[{ops},Options@Button]
				],
			ActionDropDown[
				actions,
				Appearance->
					Replace[
						Replace[useApp,{
							{___,a_}\[RuleDelayed]a
							}],{
							s_String:>
								ColoredButtonAppearances[s],
							{s_String,c_}:>
								ColorizedAppearances[s,c],
							{l_List,c_}:>
								ColorizedAppearances[l,c]
							}],
				ImageSize->
					Replace[OptionValue@ImageSize,{
						i_Integer:>
							Automatic,
						{_List,s_}\[RuleDelayed]s
						}],
				FrameMargins->
					Replace[OptionValue@FrameMargins,
						i_Integer\[RuleDelayed]
							{{i,i},{0,0}}
						],
				ops
				]
			}
		]
		];
];
ButtonActionMenu~SetAttributes~HoldRest*)


(* ::Subsubsection::Closed:: *)
(*ButtonActionPopup*)



(*Options[ButtonActionPopup]=
	Options[ButtonPopupMenu];
With[{notRules=notRules},
ButtonActionPopup[
	label_:Automatic,
	setList:_List|(_List\[Rule]_),
	function:notRules,
	setfunction:notRules:Set,
	ops:OptionsPattern[]
	]:=
	With[{
		dynamicVar=
			Replace[label,{
				Verbatim[Dynamic][v_Symbol,___]:>
					Hold[v],
				Verbatim[Dynamic][_[v_Symbol,___],___]:>
					Hold[v],
				_:>
					With[{s=Unique@"FE`popupVar$"},
						s="";
						Hold[s]
						]
				}]
		},
		Replace[dynamicVar,
				Hold[dv_]:>
			ButtonPopupMenu[
				Automatic,
				Replace[label,{
					Verbatim[Dynamic][v_,dops:(_Rule|_RuleDelayed)...]:>
						Dynamic[v,
							function[#];setfunction[dv,#];&,
							dops],
					Verbatim[Dynamic][v_,f:Except[_Rule|_RuleDelayed],___]:>
						Dynamic[v,
							function[#];f[#];&],
					Automatic:>
						Dynamic[dv,
							function[#];setfunction[dv,#];&],
					f_Function:>
						Dynamic[f[dv],
							function[#];setfunction[dv,#];&],
					None:>
						Dynamic["",function[#];setfunction[dv,#];&],
					_:>
						Dynamic[label,
							function[#];setfunction[dv,#];&]
					}],
				setList,
				Replace[label,{
					Verbatim[Dynamic][v_,___]:>
						function[v],
					_:>
						function[dv]
					}],
				ops
				]
			]
		]
];*)


(* ::Subsection:: *)
(*Misc Interface Elements*)



(* ::Subsubsection::Closed:: *)
(*PaneColumn*)



Options[PaneColumn]=Join[{
Dividers->True,
ItemSize->Automatic,
ImageSize->{Automatic,{Automatic,250}},
Scrollbars->{False,Automatic},
AppearanceElements->None,
Framed->False,
FrameMargins->0,
FrameStyle->Black,
ImageSizeAction->"Scrollable"},
FilterRules[Options[Column],
Except[Dividers|ItemSize]],
FilterRules[Options[Pane],
Except@(
Alternatives@@Join[
Options[Column],
{ImageMargins,ImageSize,Scrollbars,AppearanceElements}
])
],
FilterRules[Options[Framed],Except@(
Alternatives@@Join[
Options[Column],
Options[Pane],
{FrameMargins,FrameStyle}]
)]
];
PaneColumn[things_,ops:OptionsPattern[]]:=Pane[
Column[things,
Dividers->With[{style=Replace[OptionValue@FrameStyle,
l_List:>Last@Cases[l,Except[_List],\[Infinity]]]
},
Switch[OptionValue@Dividers,
True,{
{},Thread[Range[2,Length@things]->style]},
False,{},
_,style
]
],
FilterRules[Join[{ItemSize->If[OptionValue@ItemSize===Automatic,Replace[OptionValue@ImageSize,{
_Integer|_Scaled|Full|{_Integer|_Scaled|Full,_}:>{1000,Automatic},
_:>Automatic
}]
],ops},Options@PaneColumn],Options@Column]
],
FilterRules[Join[{FrameMargins->{{0,-1},{1,1}},ops},Options@PaneColumn],Options@Pane]
]//If[TrueQ@OptionValue@Framed,
Framed[#,FilterRules[Join[{ops},Options@PaneColumn],Options@Framed]]&,
Identity]


(* ::Subsubsection::Closed:: *)
(*HyperlinkBrowse*)



Options[HyperlinkBrowse]=Join[
	{
		Function->None,
		Format->Automatic
		},
	Options@PaneColumn
	];
HyperlinkBrowse[
	links:{__},
	buttonFunction:Except[_Rule|_RuleDelayed]:None,
	formatFunction:Except[_Rule|_RuleDelayed]:Automatic,
	ops:OptionsPattern[]]:=
		With[{
			format=
				Replace[formatFunction,
					Automatic:>
						Replace[OptionValue@Format,
							Automatic:>Replace[{s_String:>FileNameTake@s}]
							]
						],
			function=
				Replace[buttonFunction,
					Automatic:>OptionValue@Function
					]
			},
			PaneColumn[
				With[{f=format@#},
					If[buttonFunction=!=None,
						StatusArea[
							Button[
								Mouseover[
									Style[f,"Hyperlink"],
									Style[f,"HyperlinkActive"]
									],
							buttonFunction@#,
							Appearance->"Frameless",
							BaseStyle->{"Hyperlink"}
							],
							#],
						StatusArea[Hyperlink[f,#],#]		
						]
					]&/@links,
				FilterRules[{ops},
					Options@PaneColumn
					]
				]
			]


(* ::Subsubsection::Closed:: *)
(*CellOpenerView*)



Options[CellOpenerView]=Append[Options@Column,ImageSize->Automatic];
CellOpenerView[{head_,dropDown__},open:True|False:False,ops:OptionsPattern[]]:=With[{
stuff=Max@(First/@ImageDimensions/@(Pane/@Thread[HoldForm[{dropDown}]]))},
With[{
T=Column[{head,dropDown},Dividers->{{},{2->Gray}},ops],
F=Column[{head},Dividers->{{},{2->Gray}},ops]},
Toggler[If[open//TrueQ,T,F],{T,F}]
]
];
CellOpenerView~SetAttributes~HoldFirst;


(* ::Subsubsection::Closed:: *)
(*FileBrowser*)



Clear@FileBrowser;
Options[FileBrowser]=
	Join[
		Options@Pane,
		Options@Framed,
		{
			"MaxLength"->20,
			"FrameWidth"->Automatic,
			"BarSize"->150,
			Function->SystemOpen,
			DeleteFile->Automatic,
			DeleteCases->".*",
			"TopBar"->True,
			"SideBar"->True,
			Sort->
				Function[
					If[StringStartsQ[FileBaseName@#,"_"],
						If[StringStartsQ[FileBaseName@#2,"_"],
							Switch[
								Order[
									StringLength[FileBaseName@#]-
										StringTrim[FileBaseName@#,StartOfString~~"_"..],
										StringLength[FileBaseName@#2]-
											StringTrim[FileBaseName@#2,StartOfString~~"_"..]
									],
								-1,
									True,
								0,
									Order[#,#2]>-1,
								1,
									False
								],
							True
							],
						If[StringStartsQ[FileBaseName@#2,"_"],
							False,
							Order[#,#2]>-1
							]
						]
					],
			Show->All
			}
		];
FileBrowser[
	directory_,
	defaultDirectories:{__String}|Automatic:Automatic,
	ops:OptionsPattern[]]:=
	DynamicModule[{
		browserMaxFileNameLength=
			Replace[OptionValue@"MaxLength",
				Except@_Integer->20
				],
		browserBasePaneNumber=OptionValue@Show,
		browserPaneNumber,
		browserActiveDirectory=ExpandFileName@directory,
		browserActiveFile={""},
		browserActiveClicks=1,
		browserDirectoryFrameWidth=
			Replace[OptionValue@"FrameWidth",Except[_Integer]->250],
		browserSideBarWidth=
			Replace[OptionValue@"BarSize",Except[_Integer]->150],
		browserDeleteFilesPattern=
			Replace[OptionValue@DeleteCases,{
				s_String:>{s}
				}],
		browserFileSortFunction=OptionValue[Sort],
		browserFileFilterPattern="",
		browserOnClickFunction=OptionValue@Function,
		browserTopBarAppearance=Image[CompressedData["
1:eJyF1LtqwzAYhmHTdihk6Z4pd9G1Y1eXXEBMXNPFBbsQcim+NB/w+YBtfMD2
/kfLN4QSPsEjkHgnIelg/OrfT5qmua9q0k+XD8c5Xb/e1OJouz+WbZ4/7T/T
Mp1341lt7pWd8qLdDXngbvi+LwzaIAiEQRuGoTBooygSBm0cx8KgTZJEGJxV
mqYUzjDLMgptnucU2qIoKLRlWVJoq6qi0NZ1TaFtmoZC27YthbbrOgpt3/cU
2mEYKLTjOFJop2mi8PbmeRYG93dZFmHQrusqDNpt24RB63meMOS/+ff/3AC3
g29l
"], "Byte", ColorSpace -> "RGB", Interleaving -> True],
		browserSideBarAppearance=Image[CompressedData["
1:eJyF1Llqw0AUheHBSeEiRWp3eYu0LtPa+AFsopg0MsiBkEfRo2lB+4IktCCp
vxlCMEeNz8A3MMM/3XBfTpfdx0opdV3rbXf83lrW8Wf/rA8H8/p5No33N/PL
OBvW6+lBX260J+1RLZbcsViO4whj2/btneu6wmDveZ4w2Pu+Lwz2QRAIg30Y
hsJAL1EUUf/9nziOKeyTJKGwT9OUwj7LMgr7PM8p7IuioLAvy5LCvqoqCvu6
rinsm6ahsG/blsK+6zoKetX3vTD4n4dhEAb7cRyFwX6aJmGwn+dZGOzJrFrM
rF8mjJc9
"], "Byte", ColorSpace -> "RGB", Interleaving -> True],
		browserDelFile=
			Replace[OptionValue@DeleteFile,
				Automatic:>
					Switch[$OperatingSystem,
						"MacOSX",
							With[{trashBase=
								ExpandFileName@FileNameJoin@{"~",".Trash",FileNameTake@#}
								},
								With[{
									copy=
										If[FileExistsQ@trashBase,
											FileNameJoin@{
												DirectoryName@trashBase,
												FileBaseName@trashBase<>
													DateString["ISODateTime"]<>"."<>
													FileExtension@trashBase
												},
											trashBase
											]
									},
									If[DirectoryQ@#,
										CopyDirectory[#,copy];
										If[FileExistsQ@copy,
											DeleteDirectory[#,DeleteContents->True]
											],
										CopyFile[#,copy];
										If[FileExistsQ@copy,
											DeleteFile@#
											]
										];
									]
								]&
						]
				],
		browserWidthHeight=Replace[OptionValue@ImageSize,{
				{w_,h_}:>{w,h},
				Automatic->{{Automatic,500},250},
				w_:>{w,250}
				}
			]},
		browserPaneNumber=browserBasePaneNumber;
		With[{
				topBar=
					Panel[
						Framed[
							Pane[
								Grid@{
									{
										Framed[
											InputField[
												Dynamic[browserFileFilterPattern,(
														If[#==="",
															browserPaneNumber=browserBasePaneNumber,
															browserPaneNumber=1
															];
														browserFileFilterPattern=#;)&
													],
												String,
												FieldHint->"Filter by...",
												ImageSize->{
													{
														Min@{100,browserDirectoryFrameWidth},
														250
														},
													Automatic
													},
												Appearance->"Frameless"
												],
											RoundingRadius->5,
											FrameStyle->GrayLevel[.8],
											Background->GrayLevel[.98]
											]
										}
									},
								Alignment->Right,
								ImageSize->{
									{
										Min@{250,
											browserDirectoryFrameWidth+
												browserSideBarWidth
												},
										250
										},Automatic}
								],
							FrameMargins->5,
							RoundingRadius->5,
							FrameStyle->Lighter[Gray, 0.5],
							Background->GrayLevel[.875]
							],
					Alignment->Right,
					Appearance->
						browserTopBarAppearance,
					FrameMargins->
						{{5,5},{0,0}},
					ImageSize->(
						Replace[
							First@browserWidthHeight,
							Except[_?NumericQ]:>
									(Replace[browserPaneNumber,{
										Except@_Integer->2,
										n_:>
											Max@{
												FileNameDepth@
													browserActiveDirectory-Max@{n,1}+1,
												2}
										}]*browserDirectoryFrameWidth)
							]+browserSideBarWidth
						)
					],
				sideBar=
					Panel[
						Deploy@Column[Table[
							With[{d=d},
								EventHandler[
									Framed[
										Pane[
											FileBaseName@d,
											Full
											],
										FrameStyle->None,
										Background->
											Dynamic[
												If[browserActiveDirectory===d,
													GrayLevel[.8],None]
												]
										],
									"MouseClicked":>(
										browserActiveDirectory=d;
										browserActiveFile={""}
										)
									]
								],
							{d,
								Replace[
									defaultDirectories,
									Automatic:>{
										$HomeDirectory,
										$UserDocumentsDirectory,
										$UserBaseDirectory}
									]}]
							],
					FrameMargins->None,
					Appearance->browserSideBarAppearance,
					ImageSize->{browserSideBarWidth,Last@browserWidthHeight},
					BaseStyle->"Text"
					],
				panes=
					Dynamic[
						browserActiveDirectory;
						browserActiveFile;
						browserPaneNumber;
						Pane[
							Grid[{
								Table[
									With[{
											d=FileNameTake[browserActiveDirectory,i],
											filterPattern=
												Replace[browserFileFilterPattern,{
													_String?(StringLength@#>0&):>
														(___~~browserFileFilterPattern~~___),
													Except[_StringExpression]:>
														Replace[browserDeleteFilesPattern,{
															{l__}:>
																Except@Alternatives[l],
															s_:>
																Except[s]
															}]
													}]},
											ListPicker[
												Dynamic[
													Replace[browserActiveFile,
														{f_}:>
														Table[
															FileNameJoin@
																Take[
																	FileNameSplit[f],
																	n],
															{n,FileNameDepth@f}
															]
														],
													Function[browserActiveFile=#]
													],
												Replace[
													(#->
														If[
															StringLength@FileNameTake@#>
																browserMaxFileNameLength,
															StringTake[FileNameTake@#,
																Floor[browserMaxFileNameLength/2]-2]
															<>"..."<>
															StringTake[FileNameTake@#,
																-Floor[browserMaxFileNameLength/2]-1],
															FileNameTake@#
															])&/@
															Sort[
																If[MatchQ[filterPattern,_Except],
																	With[{fp=First@filterPattern},
																		DeleteCases[Quiet@FileNames["*",d],
																			_?(StringMatchQ[FileNameTake@#,fp]&)]
																		],
																	Cases[Quiet@FileNames["*",d],
																		_?(StringMatchQ[FileNameTake@#,
																				filterPattern]&)]
																	],
																browserFileSortFunction
																],
													{}:>If[
														browserFileFilterPattern==="",
														browserActiveDirectory=DirectoryName@d,
														{"No files"}
														]
													],
												Multiselection->False,
												ImageSize->{
													browserDirectoryFrameWidth,
													Last@browserWidthHeight(*-20*)},
												Scrollbars->False,
												FrameMargins->None,
												Appearance->"Frameless",
												Background->{{None,GrayLevel@.95}}
												]
											],
										{i,
											Replace[browserPaneNumber,{
													Except@_Integer->2,
													n_:>
														Max@{
															FileNameDepth@
																browserActiveDirectory-Max@{n,1}+1,
															2}
													}],
											FileNameDepth@browserActiveDirectory}
											]},
											Dividers->
												{
													Array[#->Gray&,
														Replace[browserPaneNumber,{
																Except[_Integer?(#>1&)]:>
																	Max@{
																		(FileNameDepth@browserActiveDirectory-2),
																		0
																		},
																_->Max@{browserPaneNumber-2,2}
																}],2],
													{}
													}
											]
												~EventHandler~
												{
													{
														"MouseClicked":>
															If[CurrentValue@"MouseClickCount">1,
																If[Length@browserActiveFile>0,
																	If[First@browserActiveFile=!=""&&
																			FileExistsQ@First@browserActiveFile,
																		browserOnClickFunction@First@browserActiveFile
																		]
																	],
																If[AllTrue[{"OptionKey","ShiftKey"},
																		CurrentValue],
																	If[Length@browserActiveFile>0,
																		If[First@browserActiveFile=!=""&&
																			FileExistsQ@First@browserActiveFile,
																			browserDelFile@First@browserActiveFile;
																			If[!FileExistsQ@First@browserActiveFile,
																				browserActiveFile=Rest@browserActiveFile;
																				];
																			]
																		],
																	If[Length@browserActiveFile>0,
																		If[First@browserActiveFile=!=""&&
																				FileExistsQ@First@browserActiveFile,
																			If[DirectoryQ@First@browserActiveFile,(*
																				Pause[.1];*)
																				browserActiveDirectory=
																					First@browserActiveFile,
																				If[DirectoryName@First@
																							browserActiveFile=!=
																						browserActiveDirectory,
																						browserActiveDirectory=
																							DirectoryName@First@
																								browserActiveFile
																					]
																				]
																			]
																		]
																	]
																],
														"ReturnKeyDown":>
															If[First@browserActiveFile=!=""
																	&&FileExistsQ@First@browserActiveFile,
																browserOnClickFunction@First@browserActiveFile
																],
														"BackspaceKeyDown":>(
															browserActiveDirectory=
																ParentDirectory@browserActiveDirectory;
															browserActiveFile={""}
															),
														PassEventsDown->True
														}
													},
												FilterRules[
													FilterRules[{ops},Except@ImageSize],
													Options@Pane
													],
												ImageSize->browserWidthHeight,
												AppearanceElements->None,
												ScrollPosition->
													With[{
														testPoint=
															Replace[
																First@browserWidthHeight,{
																	Except@_Integer->0,
																	w_:>(w/browserDirectoryFrameWidth)
																	}]
															},
														If[
															(
																MatchQ[browserPaneNumber,Except@_Integer]||
																	browserPaneNumber>testPoint
																)&&(
																FileNameDepth@browserActiveDirectory-1
																)>testPoint,
															Pause[.1];
															{FileNameDepth@browserActiveDirectory*
																browserDirectoryFrameWidth,
																0},
															{testPoint*browserDirectoryFrameWidth,0}]
														]
												],
											TrackedSymbols:>{
												browserActiveDirectory,
												browserActiveFile,
												browserPaneNumber}
											]
										},
									
									Grid[{
											If[OptionValue@"TopBar"//TrueQ,
													{Item[topBar,ItemSize->Full],SpanFromLeft},
													Nothing],
											{
												If[OptionValue@"SideBar"//TrueQ,sideBar,Nothing],
													panes
												}
											},
										Alignment->Right,
										Spacings->{0,.025}
										]//
										Framed[
											Style[#,
												"Text"
												],
											FrameStyle->Gray,
											FrameMargins->None,
											Background->White,
											RoundingRadius->
												If[TrueQ@OptionValue@"TopBar"||
														TrueQ@OptionValue@"SideBar",
													0,	
													5
													],
											FilterRules[
												FilterRules[{ops},Except@ImageSize],
												Options@Framed]
											]&
									]
								]


(* ::Subsubsection::Closed:: *)
(*ComboButton*)



Options[ComboButton]=
	Join[
		Options[FramedButton],
		Options[RoundedButton]
		];
ComboButton[label_,
	expr:Except[_Rule|_RuleDelayed|{(_Rule|_RuleDelayed)..}]:Null,
	ops:OptionsPattern[]]:=
	Replace[OptionValue[Appearance],{
		Default:>
			Button[label,expr,
				Appearance->
					FrontEndResource["MUnitExpressions","ButtonAppearances"],
				FilterRules[{ops},Options@Button]
				],
		"Toolbar":>
			Button[label,expr,
				Appearance->{
					"Default"->
						FrontEnd`FileName[{"Toolbars"},"Button.9.png"],
					"Hover"->FrontEnd`FileName[{"Toolbars"},"Button-Hover.9.png"],
					"Pressed"->
						FrontEnd`FileName[{"Toolbars"},"DefaultButton.9.png"]
						},
				FilterRules[{ops},Options@Button]
				],
		Framed:>
			FramedButton[label,expr,Appearance->None,ops],
		c:_Integer|_?ColorQ:>
			ColoredButton[label,expr,
				Appearance->c,
				ops
				],
		a:
			_List|_Function|
			_Association?(
				KeyMemberQ[#,Background]||
					KeyMemberQ[#,FrameStyle]&):>
				RoundedButton[label,expr,ops],
		s_String:>
			Replace[
				Replace[FEResourceFind[s],
					{_->e_,___}:>e
					],{
				l:{__Rule}:>
					Button[label,expr,Appearance->l,
						FilterRules[{ops},Options@Button]],
				i_?ImageQ:>
					Button[label,expr,Appearance->i,
						FilterRules[{ops},Options@Button]],
				_:>
					Button[label,expr,
						FilterRules[{ops},Options@Button]]
				}],
		e_List:>
			Replace[FrontEndResource@@e,{
				l:{__Rule}:>
					Button[label,expr,Appearance->l,
						FilterRules[{ops},Options@Button]],
				i_?ImageQ:>
					Button[label,expr,Appearance->i,
						FilterRules[{ops},Options@Button]],
				_:>
					Replace[OptionValue[FrameStyle],{
						Except[Automatic|None]:>
							FramedButton[label,expr,ops],
						_:>
							Button[label,expr,FilterRules[{ops},Options@Button]]
						}]
				}],
		_:>
			Replace[OptionValue[FrameStyle],{
				Except[Automatic|None]:>
					FramedButton[label,expr,Appearance->None,ops],
				_:>
					Button[label,expr,FilterRules[{ops},Options@Button]]
				}]
		}];
ComboButton~SetAttributes~HoldRest


(* ::Subsubsection::Closed:: *)
(*HoverAppearButton*)



Options[HoverAppearButton]=
	Options@Button;
HoverAppearButton[l_,e_,ops:OptionsPattern[]]:=
	Button[l,
		e,
		Appearance->{
			"Default"->
			With[{img=
					Lookup[
						FrontEndResource["WAExpressions","ControlEqualAppearance"],
						"Default"]
					},
				Image[
					SetAlphaChannel[img,Blend[{ColorNegate@img,Black},1]],
					"Byte",
					Interleaving->True
					]
				],
			"Hover"->
			Lookup[
				FrontEndResource["WAExpressions","ControlEqualAppearance"],
				"Default"],
			"Pressed"->
			Lookup[FrontEndResource["WAExpressions","ControlEqualGrayAppearance"],
				"Default"]
			},
		FrameMargins->
		{{6,0},{4,4}},
		ops
		];
HoverAppearButton~SetAttributes~HoldAll;


(* ::Subsubsection::Closed:: *)
(*SearchField*)



SearchField[search_:(NotebookFind[InputNotebook[],#,Next,WrapAround->True]&)]:=
	DynamicModule[{
			field,count
			},
		Panel[
			Row@{
				HoverAppearButton[
					RawBoxes@FrontEndResource["FEBitmaps","SearchIcon"],
					If[StringLength@field>0,search@field]
					],
				Spacer[5],
				Style[
					InputField[
						Dynamic@field,String,
						FieldHint->"Search...",
						Appearance->"Frameless"
						],
					GrayLevel[.4]
					]~EventHandler~{
					"ReturnKeyDown":>
					If[StringLength@field>0,search@field]
					}
				},
			Alignment->Center,
			Appearance->
				FrontEndResource["WAExpressions","ControlEqualAppearance"],
			FrameMargins->{{0,3},{-2,-2}}
			],
		Initialization:>
		CompoundExpression[
			field="";
			count=1
			]
		]


(* ::Subsubsection::Closed:: *)
(*File Chooser*)



Options[FileChooser]=
	Join[{
		ButtonFunction->SystemOpen,
		Select->FileExistsQ,
		LabelingFunction->None,
		ImageSize->Automatic
		},
		Options@GradientButtonPopupMenu
		];
FileChooser[lbl:_Dynamic|Automatic:Automatic,
	fileListing:_List|_String?DirectoryQ,
	ops:OptionsPattern[]
	]:=
	With[{fils=
		If[OptionValue[LabelingFunction]===None,
			Identity,
			Replace[#,
				v:Except[_Rule|_RuleDelayed]:>
					v->OptionValue[LabelingFunction][v],
				1]&
			]@
		Select[
			Replace[fileListing,
				_String?DirectoryQ:>FileNames["*",fileListing]],
			OptionValue[Select]@*
				Replace[{(r:Rule|RuleDelayed)[k_,v_]:>k}]
			],
		openFunc=OptionValue@ButtonFunction
		},
		GradientButtonPopupMenu[
			lbl,
			fils,
			openFunc@#&,
			Evaluate@FilterRules[{
				ImageSize->
					Replace[OptionValue[ImageSize],{
						Automatic->
							{{{100,1000},Automatic},Automatic},
						i_Integer:>
							{{i,Automatic},Automatic}
						}],
				Appearance->
					Replace[OptionValue[Appearance],{
						Automatic->
							PopupMenu
						}],
				ops,
				FrameMargins->{{5,5},{0,0}}
				},
				Options@GradientButtonPopupMenu]
			]
		];


(* ::Subsubsection::Closed:: *)
(*Directory Chooser*)



DirectoryChooser[lbl:_Dynamic|Automatic:Automatic,
	dirs:_List|_String?DirectoryQ,
	ops:OptionsPattern[]
	]:=
	FileChooser[lbl,dirs,
		ops,
		Select->DirectoryQ]


(* ::Subsubsection::Closed:: *)
(*PaneWindow*)



Options[PaneWindow]=
	DeleteDuplicatesBy[First]@
		Join[
			{
				Appearance->"Palette",
				WindowTitle->"",
				CloseButton->Automatic,
				ButtonBar->{},
				Background->White,
				FrameStyle->GrayLevel[.7]
				},
			Options@Pane
			];
PaneWindow[content_,
	ops:OptionsPattern[]]:=
	With[{
		topSizeSym=
			If[OptionValue[ImageSize]===Dynamic,
				Unique@paneWindowTitleBarSize
				],
		paneSizeSym=
			If[OptionValue[ImageSize]===Dynamic,
				Unique@paneWindowSize
				]
		},
		With[{
			t=OptionValue[WindowTitle],
			timgSize=
				Replace[
					OptionValue[ImageSize],{
					{a_,_}:>
						If[MatchQ[a,_Dynamic],
							a,
							{a,Automatic}
							],
					Automatic->
						{400,Automatic},
					Dynamic:>
						(
							topSizeSym={400,Automatic};
							Dynamic[topSizeSym]
							)
					}],
			imgSize=
				Replace[OptionValue[ImageSize],{
					{_,b_Dynamic}:>
						b,
					{a_?NumericQ,b_}:>
						{a-5,b},
					Automatic->
						{400,400/GoldenRatio},
					Dynamic:>
						(
							paneSizeSym={400,400/GoldenRatio};
							Dynamic[paneSizeSym,
								{topSizeSym,paneSizeSym}={{#[[1]],Automatic},#};&
								]
							)
					}],
			closeButton=
				!MatchQ[OptionValue[CloseButton],False|None]
			},
			GradientPanel[
				Pane[
					Column[{
						GradientPanel[
							If[closeButton,
								Grid[{{
									Row@{Spacer[5],
										CloseButton[
											Replace[OptionValue[CloseButton],
												Automatic->
													{PanelBox,2}
												]
											]
										},
									t,
									Replace[OptionValue@ButtonBar,{
										r:{__RuleDelayed}:>
											If[Length@r>1,
												GradientButtonBar[
													r,
													Appearance->Flatten@{
														OptionValue@Appearance
														},
													FrameMargins->{{5,5},{0,0}}
													],
												GradientButton[First@First@r,
													Last@Last@r,
													Appearance->Flatten@{
														OptionValue@Appearance
														},
													FrameMargins->{{5,5},{0,0}}
													]
												],
										_->""
										}]
									}},
									ItemSize->
										{{Scaled[.3],Scaled[.4],Scaled[.3]}},
									Alignment->{
										{Left,Center,Right},
										{Center}
										}
									],
								t
								],
							Alignment->
								If[closeButton,
									Left,
									Center
									],
							ImageSize->timgSize,
							Appearance->
								Flatten@{
									OptionValue[Appearance],
									ImagePadding->0
									},
							ImageMargins->None
							],
						Framed[
							Pane[content,
								FilterRules[{
									ImageSize->imgSize,
									ops},
									Options@Pane
									]
								],
							Background->
								OptionValue[Background],
							FrameStyle->
								OptionValue[FrameStyle],
							FrameMargins->None
							]
						},
						Alignment->Center,
						ItemSize->{All,Automatic},
						Spacings->0
						],
					All
					],
				Appearance->{
					ImageAdjust->{0,-.05,-.01}
					},
				FrameMargins->{{2,1},{0,-2}}
				]
			]
		];


(* ::Subsubsection::Closed:: *)
(*closeButtonObjectFind*)



closeButtonObjectFind//Clear;
closeButtonObjectFind[Automatic]:=
	ParentBox@EvaluationBox[];
closeButtonObjectFind[EvaluationBox]:=
		EvaluationBox[];
closeButtonObjectFind[All]:=
		NestWhile[ParentBox,
			EvaluationBox[],
			MatchQ[_BoxObject],
			1,
			\[Infinity],
			-1
			];
closeButtonObjectFind[{ParentBox,n_Integer?Positive}]:>
		Nest[ParentBox,EvaluationBox[],n];
closeButtonObjectFind[{ParentBox,n_Integer?(Not@*Positive)}]:=
		NestWhile[ParentBox,
			EvaluationBox[],
			MatchQ[_BoxObject],
			1,
			\[Infinity],
			(n-1)
			];
closeButtonObjectFind[EvaluationCell]:=
	EvaluationCell[];
closeButtonObjectFind[c:ParentCell|NextCell|PreviousCell]:=
	c@EvaluationCell[];
closeButtonObjectFind[{c:(ParentCell|NextCell|PreviousCell),n_}]:=
	Nest[c,
		EvaluationCell[],
		n
		];
closeButtonObjectFind[boxType_Symbol]:=
	NestWhile[ParentBox,
		EvaluationBox[],
		MatchQ[#,_BoxObject]&&
		!MatchQ[NotebookRead[#],
			Blank[boxType]
			]&
		];
closeButtonObjectFind[{boxType_Symbol,n_}]:=
		Block[{boxTypeCounter=0},
			NestWhile[ParentBox,
				EvaluationBox[],
				MatchQ[#,_BoxObject]&&
				If[MatchQ[NotebookRead[#],
						Blank[boxType]
						],
					boxTypeCounter++;
					boxTypeCounter<n,
					True
					]&
				]
			];
closeButtonObjectFind[f_Function]:=
	NestWhile[ParentBox,
		EvaluationBox[],
		MatchQ[#,_BoxObject]&&
		Not@f[#]&
		];
closeButtonObjectFind[{f_Function,n_}]:=
	Block[{boxTypeCounter=0},
		NestWhile[ParentBox,
			EvaluationBox[],
			MatchQ[#,_BoxObject]&&
			If[f[#],
				boxTypeCounter++;
				boxTypeCounter<n,
				True
				]&
			]
		];
closeButtonObjectFind[b:Except[_List]]:=
	NestWhile[ParentBox,
		EvaluationBox[],
		MatchQ[#,_BoxObject]&&
		!MatchQ[NotebookRead[#],
			b
			]&
		];
closeButtonObjectFind[{b:Except[_List],n_}]:=
	Block[{boxTypeCounter=0},
		NestWhile[ParentBox,
			EvaluationBox[],
			MatchQ[#,_BoxObject]&&
			If[MatchQ[NotebookRead[#],b],
				boxTypeCounter++;
				boxTypeCounter<n,
				True
				]&
			]
		];


(* ::Subsubsection::Closed:: *)
(*CloseButton*)



CloseButton[box_:Automatic]:=
	Button["",
		NotebookDelete@closeButtonObjectFind[box],
		ImageSize->{14,14},
		Appearance->{
			"Default"->
				ToExpression@
					FrontEndResource["FEBitmaps","CircleXIcon"],
			"Hover"->
				ToExpression@
					FrontEndResource["FEBitmaps","CircleXIconHighlight"],
			"Pressed"->
				ToExpression@
					FrontEndResource["FEBitmaps","CircleXIconPressed"]
			}]


(* ::Subsubsection::Closed:: *)
(*IButton*)



Options[IButton]=
	Options[Button];
IButton[lab_,
	cmd:Except[_Rule|_RuleDelayed|{(_Rule|_RuleDelayed)..}]:Null,
	ops:OptionsPattern[]]:=
	Button[lab,cmd,Null,
		Appearance->{
			"Default"->Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UFAciAWBmAWI////TzF2qG+gJeYDYnMgdgNiYyDmJEGvCRBvBuKfQPwfCX8F
4mVArIZHLyMQ1wLxPzS96BhkdioOMxqw6cnLy/tfVVWFzaxENP2WuOy/evXq
/+/fv2Mz4wcQKyCZsQuX29va2v7PmTMHl7/mQPULA/EfXP6YNGkS2BwcZrwF
YmZo3GFVc/jw4f8gADIHTxiD4ikKl/yuXbvAZhCIJyt87rh37x44TAmYoQrE
QkD8G5s8CGzcuBFX3ILwa2h4gMJ1J7o8KAxAAOQfPOExGylurdHTB8hukF/w
xOt3IFZ2QE1nlQT8jY6jHbCnd1B++UtALyh9puDQD8P6QLzWAXu+nQ/ESgT0
I2NuINYFYicg1gZidhL0koypUZ4OFgwARdA9WQ==
"], "Byte", ColorSpace -> "RGB", Interleaving -> True],
			"Hover"->Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UFAciAWBmAWI////TznOYKAl5gNicyB2A2JjIOYkQa8JEG8G4p9A/B8JfwXi
ZUCshkcvIxDXAvE/NL3oGGR2Kg4zGrDqKVX5/7/BHptZiWj6LXHaf/3E///f
v2Iz4wcQKyCZsQun23tC/v9fWIHLX3Og+oWB+A9Of0xLh5iD3Yy3QMwMjTvs
ao5t+A8GIHNwhzEonqJwyu9dDDEDfzxZ4XXH/SuQMMVvhioQCwHxb6zyILBl
Gq64BeHX0PAAhetODHlQGIAAyD+4w2M2UtxaY6QPkN0gv+CO1+9ArPwfNZ1V
EvA3Oo7+jz29g/LLXwJ6QekzBYd+GNYH4rX/sefb+UCsREA/MuYGYl0gdgJi
bSBmJ0Ev6Zga5ekgwQD8UXC/
"], "Byte", ColorSpace -> "RGB", Interleaving -> True, MetaInformation -> Association["XMP" -> Association["BasicSchema" -> Association["CreatorTool" -> "Adobe Photoshop CS6 (Macintosh)"], "MediaManagementSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:0780117407206811808380FD6B980A1F", "DocumentID" -> "xmp.did:0E14DB05E12068118A6D8005FF0E4143"]], "DocumentID" -> "xmp.did:79239F79A90711E2A242D6641682FEA7", "InstanceID" -> "xmp.iid:79239F78A90711E2A242D6641682FEA7", "OriginalDocumentID" -> "xmp.did:0E14DB05E12068118A6D8005FF0E4143"], "RightsManagementSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:0780117407206811808380FD6B980A1F", "DocumentID" -> "xmp.did:0E14DB05E12068118A6D8005FF0E4143"]]], "PagedTextSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:0780117407206811808380FD6B980A1F", "DocumentID" -> "xmp.did:0E14DB05E12068118A6D8005FF0E4143"]]]], "Comments" -> Association["Software" -> "Adobe ImageReady", "XML:com.adobe.xmp" -> "<?xpacket begin=\:feff id=W5M0MpCehiHzreSzNTczkc9d?> <x:xmpmeta xmlns:x=adobe:ns:meta/ x:xmptk=Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27> <rdf:RDF xmlns:rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns#> <rdf:Description rdf:about= xmlns:xmpMM=http://ns.adobe.com/xap/1.0/mm/ xmlns:stRef=http://ns.adobe.com/xap/1.0/sType/ResourceRef# xmlns:xmp=http://ns.adobe.com/xap/1.0/ xmpMM:OriginalDocumentID=xmp.did:0E14DB05E12068118A6D8005FF0E4143 xmpMM:DocumentID=xmp.did:79239F79A90711E2A242D6641682FEA7 xmpMM:InstanceID=xmp.iid:79239F78A90711E2A242D6641682FEA7 xmp:CreatorTool=Adobe Photoshop CS6 (Macintosh)> <xmpMM:DerivedFrom stRef:instanceID=xmp.iid:0780117407206811808380FD6B980A1F stRef:documentID=xmp.did:0E14DB05E12068118A6D8005FF0E4143/> </rdf:Description> </rdf:RDF> </x:xmpmeta> <?xpacket end=r?>"]]],
			"Pressed"->Image[CompressedData["
1:eJxTTMoPSmNiYGAo5gASQYnljkVFiZXBAkBOaF5xZnpeaopnXklqemqRRRIz
UFAciAWBmAWI////TzFOSEigJeYDYnMgdgNiYyDmJEGvCRBvBuKfQPwfCX8F
4mVArIZHLyMQ1wLxPzS96BhkdioOMxqw6cnLy/tfVVWFzaxENP2WuOy/evXq
/+/fv2Mz4wcQKyCZsQuX29va2v7PmTMHl7/mQPULA/EfXP6YNGkS2BwcZrwF
YuYESNxhVXP48OH/IAAyB08Yg+IpCpf8rl27wGYQiCcrfO64d+8eOEwJmKEK
xEJA/BubPAhs3LgRV9yC8GtoeIDCdSe6PCgMQADkHzzhMRspbq3R0wfIbpBf
8MTrdyBWTkBNZ5UE/I2OoxOwp3dQfvlLQC8ofabg0A/D+kC8NgF7vp0PxEoE
9CNjbiDWBWInINYGYnYS9JKMqVGeDhYMAAUuGWI=
"], "Byte", ColorSpace -> "RGB", Interleaving -> True, MetaInformation -> Association["XMP" -> Association["BasicSchema" -> Association["CreatorTool" -> "Adobe Photoshop CS6 (Macintosh)"], "MediaManagementSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:0780117407206811808380FD6B980A1F", "DocumentID" -> "xmp.did:0E14DB05E12068118A6D8005FF0E4143"]], "DocumentID" -> "xmp.did:9DFCAC12A90711E2A242D6641682FEA7", "InstanceID" -> "xmp.iid:9DFCAC11A90711E2A242D6641682FEA7", "OriginalDocumentID" -> "xmp.did:0E14DB05E12068118A6D8005FF0E4143"], "RightsManagementSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:0780117407206811808380FD6B980A1F", "DocumentID" -> "xmp.did:0E14DB05E12068118A6D8005FF0E4143"]]], "PagedTextSchema" -> Association["DerivedFrom" -> Association["DerivedFrom" -> Association["InstanceID" -> "xmp.iid:0780117407206811808380FD6B980A1F", "DocumentID" -> "xmp.did:0E14DB05E12068118A6D8005FF0E4143"]]]], "Comments" -> Association["Software" -> "Adobe ImageReady", "XML:com.adobe.xmp" -> "<?xpacket begin=\:feff id=W5M0MpCehiHzreSzNTczkc9d?> <x:xmpmeta xmlns:x=adobe:ns:meta/ x:xmptk=Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27> <rdf:RDF xmlns:rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns#> <rdf:Description rdf:about= xmlns:xmpMM=http://ns.adobe.com/xap/1.0/mm/ xmlns:stRef=http://ns.adobe.com/xap/1.0/sType/ResourceRef# xmlns:xmp=http://ns.adobe.com/xap/1.0/ xmpMM:OriginalDocumentID=xmp.did:0E14DB05E12068118A6D8005FF0E4143 xmpMM:DocumentID=xmp.did:9DFCAC12A90711E2A242D6641682FEA7 xmpMM:InstanceID=xmp.iid:9DFCAC11A90711E2A242D6641682FEA7 xmp:CreatorTool=Adobe Photoshop CS6 (Macintosh)> <xmpMM:DerivedFrom stRef:instanceID=xmp.iid:0780117407206811808380FD6B980A1F stRef:documentID=xmp.did:0E14DB05E12068118A6D8005FF0E4143/> </rdf:Description> </rdf:RDF> </x:xmpmeta> <?xpacket end=r?>"]]]
			},
		ops
		]


(* ::Subsubsection::Closed:: *)
(*DragPaneDynamicModule*)



Options[DragPaneDynamicModule] =
  Join[
   Options[Pane],
   {
    AutoAction -> False,
    "Modifiers" -> None
    }
   ];
DragPaneDynamicModule[
   exp_,
   {width_, height_},
   ops : OptionsPattern[]
   ] :=
  With[
   {
    boxSize =
     {#[[1]], 3 + Total@#[[2 ;;]]} &@First@
       FrontEndExecute@
        GetBoundingBoxSizePacket[
         Cell[BoxData[ToBoxes[exp]],
          "Output",
          PageWidth -> \[Infinity],
          ShowCellBracket -> False,
           CellMargins -> {{0, 0}, {0, 0}}
          ]
         ],
     mkeys = 
    	 Cases[Flatten@List@OptionValue["Modifiers"], 
    	 	"Shift"|"Control"|"Alt"|"Command"
    	 	]
    },
   DynamicModule[
    {
     scrollX = 0., scrollY = 0.,
     maxWidth =
      If[! NumericQ@width,
       boxSize[[1]],
       Max@{boxSize[[1]], width}
       ],
     boxWidth =
      If[! NumericQ@width, Min@{boxSize[[1]], 360} , width],
      maxHeight =
      If[! NumericQ@height,
       boxSize[[2]],
       Max@{boxSize[[2]], height}
       ],
     boxHeight =
      If[! NumericQ@height, Min@{boxSize[[2]], 360} , height],
     setXScroll,
     setYScroll,
     getXScroll,
     getYScroll,
     scrolling = False,
     refWidth, refX,
     refHeight, refY,
     applyEvent,
     mods = mkeys
     },
    Pane[
     EventHandler[
       Pane[
        Pane[exp, 2*boxSize, Alignment -> {Left, Top}],
        Full,
        ScrollPosition ->
         Dynamic[
          If[TrueQ[scrolling],
           {
            setXScroll[],
            setYScroll[]
            },
           {scrollX, scrollY}
           ],
          Function[
           scrollX =
            Clip[#[[1]], {0., Max@{maxWidth - boxWidth, 0.}}];
           scrollY =
            Clip[#[[2]], {0., Max@{maxHeight - boxHeight, 0.}}];
           ],
          TrackedSymbols :> {scrollX, scrollY}
          ],
         Alignment -> {Left, Top}
        ],
       {
        If[TrueQ@OptionValue[AutoAction],
          "MouseEntered",
          "MouseDown"
          ] :>
         If[applyEvent[],
          refX = scrollX;
          refY = scrollY;
          {refWidth, refHeight} = MousePosition["ScreenAbsolute"];
          scrolling = True
          ],
        If[TrueQ@OptionValue[AutoAction],
          "MouseMoved",
          "MouseDragged"
          ] :>
         If[applyEvent[],
          If[! AllTrue[{refWidth, refHeight}, NumericQ],
           refX = scrollX;
           refY = scrollY;
           {refWidth, refHeight} =
          	 MousePosition["ScreenAbsolute"];
           scrolling = True
           ];
          setXScroll[];
          ],
        If[TrueQ@OptionValue[AutoAction],
          "MouseExited",
          "MouseUp"
          ] :>
         If[applyEvent[],
          scrolling = False;
          setXScroll[];
          setYScroll[];
          Clear[refWidth, refHeight, refX, refY];
          ],
        PassEventsDown->Length@mods>0
        }
       ] // MouseAppearance[#, "PanView"] &,
     FilterRules[
      {
       ImageSize ->
        Dynamic[{boxWidth, boxHeight}],
       ops
       },
      Options[Pane]
      ]
     ],
    Initialization :>
     {
      applyEvent[]:=
       Length@mods==0||
	       Intersection[mods, CurrentValue["ModifierKeys"]]==mods,
      getXScroll[x_] :=
       Clip[
        refX + refWidth - x,
        {0., Max@{maxWidth - boxWidth, 0.}}
        ];
      getXScroll[] :=
       getXScroll[First@MousePosition["ScreenAbsolute"]],
      setXScroll[x___] :=
       scrollX = getXScroll[x],
      getYScroll[y_] :=
       Clip[
        refY + refHeight - y,
        {0., Max@{maxHeight - boxHeight, 0.}}
        ];
      getYScroll[] :=
       getYScroll[Last@MousePosition["ScreenAbsolute"]],
      setYScroll[y___] :=
       scrollY = getYScroll[y]
      }
    ]
   ];


(* ::Subsubsection::Closed:: *)
(*DragPane*)



Options[DragPane] =
  Options[DragPaneDynamicModule];
DragPane[
   exp_,
   w : _?NumericQ | Automatic,
   ops : OptionsPattern[]
   ] :=
  DragPane[exp, {w, Automatic}, ops];
DragPane[
   exp_,
   ops : OptionsPattern[]
   ] :=
  DragPane[exp,
    OptionValue[ImageSize],
   ops
   ];
Format[dp : 
    DragPane[exp_, {width_, height_}, ops : OptionsPattern[]], 
   StandardForm] :=
  Interpretation[
   DragPaneDynamicModule[exp, {width, height}, ops],
   dp
   ];


End[];



