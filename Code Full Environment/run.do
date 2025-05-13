vlib work
vlog +acc -f src_files.list +cover=bces -covercells
vsim -voptargs=+acc work.top -classdebug -assertdebug -uvmcontrol=all -cover
run 0
add wave -position insertpoint sim:/top/fifo_if/*
add wave -position insertpoint  \
sim:/top/DUT/mem
coverage save top.ucdb -onexit
run -all
#quit -sim
#vcover report top.ucdb -details -annotate -all -output cov_report.txt
