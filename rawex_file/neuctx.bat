#!/bin/tcsh
#ctx_all
#foreach i (*.img)
#mv $i `basename $i .img`.IMG
#end 
foreach i (*.IMG)
mroctx2isis FROM=$i TO=`basename $i .IMG`.cub
rm $i
end  
foreach i (*.cub)
spiceinit FROM=$i
end  
foreach i (*.cub)
ctxcal FROM=$i TO=`basename $i .cub`.cal.cub
rm $i
end 
foreach i (*.cal.cub)
ctxevenodd from=$i to=`basename $i .cal.cub`.eveodd.cub
rm $i
end
#maptemplate map=projection.txt clon=0 projection=SIMPLECYLINDRICAL #targetname=MARS eqradius=3396190 polradius=3396190 targopt=user #londom=180 
#foreach i (*.eveodd.cub) 
#cam2map FROM=$i TO=`basename $i .eveodd.cub`.proj.cub #map=projection.txt
#rm $i
#end
#foreach i (*.proj.cub) 
#isis2std FROM=$i TO=`basename $i .proj.cub`.jp2 format=jp2
#mkdir `basename $1 .txt`/`basename $i .proj.cub`
#mv $i *.j* `basename $1 .txt`/`basename $i .proj.cub`/
#end
