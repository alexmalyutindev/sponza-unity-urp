#!/bin/zsh

find -f **/*.psd* -delete

find -f **/Arches_Height.tiff* -delete
find -f **/Bricks_AO.tiff* -delete

find -f **/*_Smoothness.* -delete
find -f **/*_Metallic.* -delete 
find -f **/*_MaskMap.* -delete  
find -f **/*_Curvature.* -delete

for TEX in $(find -f **/*_MetallicSmoothness.tif);
do
    echo $TEX
    NAME="${TEX%.*}"
    magick "$TEX" -separate "$NAME-TEMP.png"
    convert "$NAME-TEMP-0.png" "$NAME-TEMP-1.png" "$NAME-TEMP-2.png" "$NAME-TEMP-3.png" -channel All -combine "$NAME.png"
done

find -f **/*_MetallicSmoothness.tiff -delete
find -f **/*_MetallicSmoothness.tif -delete

for TEX in $(find -f **/*_Diffuse.tif);
do
    echo $TEX
    NAME="${TEX%.*}"
    magick "$TEX" -separate "$NAME-TEMP.png"
    convert "$NAME-TEMP-0.png" "$NAME-TEMP-1.png" "$NAME-TEMP-2.png" "$NAME-TEMP-3.png" -channel All -combine "$NAME.png"
done

find -f **/*-TEMP-* -delete  

find -f **/*_Diffuse.tiff -delete
find -f **/*_Diffuse.tif -delete

for DIR in $(find ./Textures -mindepth 1 -not -empty -type d); do
    echo $DIR
    magick mogrify -format png "$DIR/*.tiff"
    magick mogrify -format png "$DIR/*.tif"
    ren "$DIR/*.tiff.meta" "#1.png.meta"
    ren "$DIR/*.tif.meta" "#1.png.meta"
done

find -f **/*.tiff -delete
find -f **/*.tif -delete

magick mogrify -alpha off-if-opaque  **/*_Diffuse.png
