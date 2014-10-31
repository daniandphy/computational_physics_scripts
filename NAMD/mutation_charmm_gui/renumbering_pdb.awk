#!/bin/awk

BEGIN {FIELDWIDTHS=" 6 5 1 4 1 3 1 1 4 1 3 8 8 8 6 6 6 4"} 
{
	if (NR==1)
		print 

	else if ($1 !="END") 
	{
		atomno++
		
		printf "%6s",$1
		printf "%5d", atomno
		printf "%1s", " "
		printf "%4s", $4
		printf "%1s", " "
		printf "%3s", $6
		printf "%1s", $7
		printf "%1s", chainID
		printf "%4s", int((atomno-1)/3)+1
		printf "%4s", "    "
		printf "%8s", $12
		printf "%8s", $13
		printf "%8s", $14
		printf "%6s", $15
		printf "%6s", $16
		printf "%6s", "      "
		printf "%4s\n", segid
	}

}
END {printf "%3s\n", "END"}
