#vlib Proasic3
#vmap Proasic3 Proasic3
#vlog sim/proasic3.v -work Proasic3
vsim -voptargs=+acc work.tb_apes_top -L Proasic3
do stim_test_wave.do
run 2 ms
