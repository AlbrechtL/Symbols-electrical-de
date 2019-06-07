#!/bin/bash
ff=PluginFurnitureCatalog.properties
echo "# PluginFurnitureCatalog.properties ( "$(date +"%d-%m-%Y") ")" > $ff
echo "# Copyright (c) 2007-2017 Emmanuel PUYBARET / eTeks <info@eteks.com>." >> $ff
echo -en '\n\n' >> $ff

echo "# Created by script Create2DSymbols.sh ( "$(date +"%d-%m-%Y") ")"  >> $ff
echo "# To update, add new symbols in png-format in plan folder and run ./CreateSymbols.sh"  >> $ff
echo "# Requires ImageMagick and zip"  >> $ff
echo "# Attention:"  >> $ff
echo "# The script resizes (to 256x256, but keeping proportions) the original images and copy the result"  >> $ff
echo "# in catalog folder (if ImageMagick is installed)." >> $ff
echo "# The resulting library is zipped and moved (overwriting files with the same name) to ../"  >> $ff
echo "# Upon restart of SweetHome3D, the library is available. Alternatively, import it from ../"  >> $ff
echo "# The file name without file type suffix will be used as the symbol name: "  >> $ff
#echo "# The filename should have the synthax: SymbolName.Information.png"  >> $ff
echo "# Alphabetical order following the file names."  >> $ff
echo -en '\n\n' >> $ff

echo "id=SweetHome3D#2DSymbols"  >> $ff
echo "name=2DSymbols"  >> $ff
echo "description= Symbols Catalog for use in 2D plan"  >> $ff
echo "version=1.5.7"  >> $ff
echo "license=GPL-3.0"  >> $ff
echo "provider=AlbrechtL (based on dorin)"  >> $ff
echo -en '\n\n' >> $ff

cnt=0
#rm ListOfFile.txt
OIFS=$IFS
IFS=$'\n'
for nn in  `ls plan | sort -V`
do
{
cp originals/$nn catalog/
cp originals/$nn plan/
cn=catalog/$nn
pn=plan/$nn
 echo $nn
 { widthOrig=`convert "$pn" -format '%w' info:`
   depthOrig=`convert "$pn" -format '%h' info:`
   width=$[$widthOrig / 13]
   depth=$[$depthOrig / 13]

   # resize catalog icons
   convert -trim "$cn" "$cn"
   convert "$cn" -resize 256x256 -background transparent -gravity center -extent 256x256 "$cn"

   # make plan icons red
   convert "$pn" -fuzz 50% -fill firebrick3 -opaque black "$pn"
 } || {
  echo "Cannot find convert, a member of the ImageMagick suite. The images are not cropped and resized to 256x256."
  echo -en '\n\n' >> $ff
  echo "convert, a member of the ImageMagick suite, was unavailable when this file was created."  >> $ff
  echo "The images are thus not cropped and resized to 256x256." >> $ff
  echo -en '\n\n' >> $ff
 }
cnt=`expr $cnt + 1`
 fname=${pn%.*} # remove everything after the last dot (e.q. file suffix but leave everything else)
 fname=${fname##*/} #remove path -> filename
 name=${fname%.*} #symbol name
 echo id#$cnt=2DSymbol#$name >> $ff
 echo name#$cnt=$name >> $ff
# echo information#$cnt= >> $ff
 echo category#$cnt="Symbols-electrical-de" >> $ff
 echo icon#$cnt=/$cn >> $ff
 echo planIcon#$cnt=/$pn >> $ff
# echo model#$cnt=/models/$name.obj >> $ff
 echo model#$cnt=/invisibleCube.obj >> $ff
 echo width#$cnt=$width >> $ff
 echo depth#$cnt=$depth >> $ff
 echo height#$cnt=$depth >> $ff
 echo elevation#$cnt=50.0 >> $ff
 echo movable#$cnt=true >> $ff
 echo doorOrWindow#$cnt=false >> $ff
 echo creator#$cnt=dorin >> $ff
 echo -en '\n\n' >> $ff

 # Try to display 2D symbols inside the 3D view
 # extent image to make it smaller inside the 3D view
# cp plan/$nn models/
# convert models/"$nn" -gravity center -background white -extent $[$widthOrig * 2]x$[$depthOrig * 2] models/"$nn"
# convert models/"$nn" -resize "$widthOrig"x"$depthOrig"! models/"$nn"

 # create the OBJ and MTL file
# cp cube.obj.template models/$name.obj
# cp cube.mtl.template models/$name.mtl

# # replace magic keys
# sed -i -e 's/%%MTL_FILE_NAME%%/'"$name"'.mtl/g' models/$name.obj
# sed -i -e 's/%%IMAGE_FILE_NAME%%/'"$name"'.png/g' models/$name.mtl
 }
done

IFS=$OIFS

mylib=${PWD##*/}.sh3f
zip -r $mylib . -x *.git*
mv $mylib ../


