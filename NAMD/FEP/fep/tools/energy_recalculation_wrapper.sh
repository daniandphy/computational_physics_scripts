#! /bin/tcsh

#qsub -pe linux_smp_short 48-64 -N ene_recal -j y -o ~/Jobs -cwd  energy_recalculation_wrapper.sh

cd "$PWD"


#############claculating unresrtraint energies

set inp_template=("energy_recalculation.inp");
set inp_cont_template=("energy_recalculation_cont.inp");
set start= (0.0)
set end= (1.0)

set step= (0.03125)

set win= ($start)
echo $win
set cond=`awk -v win=$win -v last=$end 'BEGIN{print win < last}'`
while ( $cond );
	
	echo $win
	sed s/XXXX/$win/g $inp_template >! temp_fwd.inp
	sed s/XXXX/$win/g $inp_template >! temp_bwd.inp
	sed -i s/YYYY/fwd/g  temp_fwd.inp
	sed -i s/YYYY/bwd/g  temp_bwd.inp
	namd2  temp_fwd.inp>! fwd_${win}.log
	namd2  temp_bwd.inp>! bwd_${win}.log

	sed s/XXXX/$win/g $inp__cont_template >! temp_fwd_cont.inp
        sed s/XXXX/$win/g $inp_cont_template >! temp_bwd_cont.inp
        sed -i s/YYYY/fwd/g  temp_fwd_cont.inp
        sed -i s/YYYY/bwd/g  temp_bwd_cont.inp
        namd2  temp_fwd.inp>! fwd_${win}_cont.log
        namd2  temp_bwd.inp>! bwd_${win}_cont.log
	set win=`echo  $win + $step|bc -l`
	set cond=`awk -v win=$win -v last=$end 'BEGIN{print win <= last}'`
	
	
	
end

#############claculating restraint energies
set win=(0.0)
set inp_template=(energy_restr_recalculation.inp)
set inp_cont_template=(energy_restr_recalculation_cont.inp)
sed s/XXXX/$win/g $inp_template >! temp_fwd.inp
sed s/XXXX/$win/g $inp_template >! temp_bwd.inp
sed -i s/YYYY/fwd/g  temp_fwd.inp
sed -i s/YYYY/bwd/g  temp_bwd.inp
namd2  temp_fwd.inp>! fwd_restr.log
namd2  temp_bwd.inp>! bwd_restr.log

sed s/XXXX/$win/g $inp_cont_template >! temp_fwd_cont.inp
sed s/XXXX/$win/g $inp_cont_template >! temp_bwd_cont.inp
sed -i s/YYYY/fwd/g  temp_fwd_cont.inp
sed -i s/YYYY/bwd/g  temp_bwd_cont.inp
namd2  temp_fwd_cont.inp>! fwd_restr_cont.log
namd2  temp_bwd_cont.inp>! bwd_restr_cont.log
