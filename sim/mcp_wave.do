onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_apes_top/Ext_clk_50mhz
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/hk_apes_adc/rst_n
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/dac_rst
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/regw_pls
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/Lcla
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/Lcld
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/Dac_clk
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/Dac_dat
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/CTRL_ENn
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/pa_sm_dac_out
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/dac_reg
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/pa_cnt_dclk
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/pa_sm_dac
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/pa_dac_init
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/pa_dac_shft
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/dac_en_n
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/start_mcp/pa_cnt_shft
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/hven_cmd
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/safe_cmd
add wave -noupdate /tb_apes_top/apes_top_uut/u_dac_adc_top/reset_cmd
add wave -noupdate /tb_apes_top/apes_top_uut/Safe_cmd
add wave -noupdate /tb_apes_top/apes_top_uut/Reset_cmd_n
add wave -noupdate /tb_apes_top/apes_top_uut/Hven_cmd_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6720000000 ps} 0} {{Cursor 2} {0 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 187
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
WaveRestoreZoom {0 ps} {35625 ns}
