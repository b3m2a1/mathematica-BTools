Graphics3D[
 Flatten@{
   EdgeForm@Directive[GrayLevel[1], AbsoluteThickness[1]],
   (*GrayLevel[.6],*)
   Hue[.01, 1, .8],
   Table[
    PolyhedronData["Spikey"][[1]] /. 
     a : {_Root, y_, _} :> {n, 0, 0} + a,
    {n, 3, 3}
    ]
   },
 Boxed -> False,
 Lighting -> "Neutral",
 Method -> {"ShrinkWrap" -> True},
 ImageSize -> 32,
 ViewAngle -> 0.365,
 ViewPoint -> {0.156, 2.178, 1.575},
 ViewVertical -> {0.4, 1.215, -0.142}
 ]
