onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_apes_top/Inpulse
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/clk50
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/rst_n
add wave -noupdate /tb_apes_top/Safe_cmd
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/clr
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/enable
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/collect_enable
add wave -noupdate -radix unsigned /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/counter
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/div_count
add wave -noupdate /tb_apes_top/Cnt_Gtclk
add wave -noupdate /tb_apes_top/Cnt_Invload
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/u_cnt_readout/increment
add wave -noupdate -radix unsigned /tb_apes_top/apes_top_uut/u_rocket_readout/u_cnt_readout/word_count
add wave -noupdate /tb_apes_top/Hk_Gtclk
add wave -noupdate /tb_apes_top/Hk_Invload
add wave -noupdate /tb_apes_top/Cnt_Data
add wave -noupdate /tb_apes_top/Hk_Data
add wave -noupdate /tb_apes_top/Hven
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/collect_done
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/cnt_clr
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/cnt_start
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/en_rocket_rd
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/u_cnt_readout/rdout_done
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/clr
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/enable
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/collect_enable
add wave -noupdate -radix unsigned /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/counter
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/div_count
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/div_clk
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/collect_done
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/rdout_done
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/en_rocket_rd
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/cnt_start
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/cnt_clr
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2054350100 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 258
configure wave -valuecolwidth 50
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {4431 us}
