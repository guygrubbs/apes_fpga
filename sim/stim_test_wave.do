onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_apes_top/Ext_clk_50mhz
add wave -noupdate /tb_apes_top/Gse_reset
add wave -noupdate /tb_apes_top/Inpulse
add wave -noupdate /tb_apes_top/Safe_cmd
add wave -noupdate /tb_apes_top/Stim_cmd_n
add wave -noupdate /tb_apes_top/Reset_cmd_n
add wave -noupdate /tb_apes_top/Hven_cmd_n
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/hven_cmd
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/reset_cmd
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/state
add wave -noupdate /tb_apes_top/apes_top_uut/cnt_done
add wave -noupdate /tb_apes_top/apes_top_uut/cnt_start
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/clr
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/enable
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/collect_enable
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/collect_done
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/fsm/rdout_done
add wave -noupdate -radix unsigned /tb_apes_top/apes_top_uut/u_pulse_counters/sync_timer/counter
add wave -noupdate /tb_apes_top/Cnt_Data
add wave -noupdate /tb_apes_top/Cnt_Gtclk
add wave -noupdate /tb_apes_top/Cnt_Invload
add wave -noupdate /tb_apes_top/apes_top_uut/u_rocket_readout/stim_cmd
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/stim_testpulse
add wave -noupdate /tb_apes_top/apes_top_uut/u_pulse_counters/Inpulse
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_apes_top/apes_top_uut/u_pulse_counters/Counts
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1954487193 ps} 0} {{Cursor 2} {2055955697 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {2163010500 ps}
