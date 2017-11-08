#!/bin/bash
#merge Clocaenog 30 minute average files into one file
(cat ../2016/CLIMOOR_30Minute_*.dat |
	head -n4 &&
		awk 'FNR<=4{next;}{print}' ../2016/CLIMOOR_30Minute*.dat ../2017/CLIMOOR_30Minute*.dat |
	sort) > ../Merge/Clocaenog.dat
