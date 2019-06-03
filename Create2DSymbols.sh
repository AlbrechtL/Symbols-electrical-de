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
echo "# The resulting library is zipped and moved (overwriting files with the same name) to ~/.eteks/sweethome3d/furniture/"  >> $ff
echo "# Upon restart of SweetHome3D, the library is available. Alternatively, import it from ~/.eteks/sweethome3d/furniture/"  >> $ff
echo "# The file name without file type suffix will be used as the symbol name: "  >> $ff
#echo "# The filename should have the synthax: SymbolName.Information.png"  >> $ff
echo "# Alphabetical order following the file names."  >> $ff
echo -en '\n\n' >> $ff

echo "id=SweetHome3D#2DSymbols"  >> $ff
echo "name=2DSymbols"  >> $ff
echo "description= Symbols Catalog for use in 2D plan"  >> $ff
echo "version=1.5.5"  >> $ff
echo "license=GPL-3.0"  >> $ff
echo "provider=dorin"  >> $ff
echo -en '\n\n' >> $ff

cnt=0
#rm ListOfFile.txt
OIFS=$IFS
IFS=$'\n'
for nn in  `ls plan | sort -V`
do
{
cp plan/$nn catalog/
cn=catalog/$nn
pn=plan/$nn
 echo $nn
 { width=`convert "$pn" -format '%w' info:`
   depth=`convert "$pn" -format '%h' info:`
   convert -trim "$cn" "$cn"
   convert "$cn" -resize 256x256 -background transparent -gravity center -extent 256x256 "$cn"
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
 echo model#$cnt=/invisibleCube.obj >> $ff
 echo width#$cnt=$width >> $ff
 echo depth#$cnt=$depth >> $ff
 echo height#$cnt=10.0 >> $ff
 echo elevation#$cnt=50.0 >> $ff
 echo movable#$cnt=true >> $ff
 echo doorOrWindow#$cnt=false >> $ff
 echo creator#$cnt=dorin >> $ff
 echo -en '\n\n' >> $ff
 }
done

IFS=$OIFS

mylib=${PWD##*/}.sh3f
zip -r $mylib .
mv $mylib ~/.eteks/sweethome3d/furniture/


