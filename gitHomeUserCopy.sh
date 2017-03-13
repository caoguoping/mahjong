
rm -rf $workRoot/Mahjong*
rm -rf $workRoot/cocosstudio
rm -rf $workRoot/res
rm -rf $workRoot/src
rm -rf $workRoot/frameworks/runtime-src/Classes

 cp -r Classes $workRoot/frameworks/runtime-src/Classes
 cp -r cocosstudio $workRoot/  
 cp -r Mahjong* $workRoot/
 cp -r res  $workRoot/
 cp -r src  $workRoot/
