#!/bin/bash

# step 1: making the movies
# I usually use the "makemovie.tcl" script to make the snapshots
# just "source makemovie.tcl" and then type "make_trajectory_movie_files"
# or you can make the snapshots using the vmd movie maker


# step 2: combining the snapshots
# suppose we have 10 movies, each consists of 200 frames, in the directories
# m1, m2, ..., m10. Each frame is an rgb file named animate.XXXX.rgb
# XXXX being 0000 to 00199

for i in `seq -w 0 224`
do
# if you need cropping, resizing, etc you can apply to that to each individual
# figure using convert command with "-crop", "-resize", etc options
# then you can continue
#    convert +append m1/animate.0$i.rgb m2/animate.0$i.rgb m3/animate.0$i.rgb m4/animate.0$i.rgb m5/animate.0$i.rgb top/animate.0$i.ppm
#    convert +append m6/animate.0$i.rgb m7/animate.0$i.rgb m8/animate.0$i.rgb m9/animate.0$i.rgb m10/animate.0$i.rgb bottom/animate.0$i.ppm
#    convert -append top/animate.0$i.ppm bottom/animate.0$i.ppm all/animate.0$i.ppm
    convert animate.0$i.rgb animate.0$i.ppm
done

# step3: make the movie
# just make the approporiate changes in the movie.prm file and then run
ppmtompeg movie.prm
