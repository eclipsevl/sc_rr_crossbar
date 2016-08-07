onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/xi_sys_core/xi_rr_xbar/i_clk
add wave -noupdate /tb/xi_sys_core/xi_rr_xbar/i_resetb
add wave -noupdate -expand -group {ms0
add wave -noupdate -expand -group {ms0
add wave -noupdate -expand -group {ms0
add wave -noupdate -expand -group {ms0
add wave -noupdate -expand -group {ms0
add wave -noupdate -expand -group {ms0
add wave -noupdate -expand -group {ms1
add wave -noupdate -expand -group {ms1
add wave -noupdate -expand -group {ms1
add wave -noupdate -expand -group {ms1
add wave -noupdate -expand -group {ms1
add wave -noupdate -expand -group {ms1
add wave -noupdate -expand -group {sl0
add wave -noupdate -expand -group {sl0
add wave -noupdate -expand -group {sl0
add wave -noupdate -expand -group {sl0
add wave -noupdate -expand -group {sl0
add wave -noupdate -expand -group {sl0
add wave -noupdate -expand -group {sl1
add wave -noupdate -expand -group {sl1
add wave -noupdate -expand -group {sl1
add wave -noupdate -expand -group {sl1
add wave -noupdate -expand -group {sl1
add wave -noupdate -expand -group {sl1
add wave -noupdate /tb/xi_sys_core/xi_rr_xbar/w_m0s0_enable
add wave -noupdate /tb/xi_sys_core/xi_rr_xbar/w_m0s1_enable
add wave -noupdate /tb/xi_sys_core/xi_rr_xbar/w_m1s0_enable
add wave -noupdate /tb/xi_sys_core/xi_rr_xbar/w_m1s1_enable
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/i_clk
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/i_resetb
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/i_ms0_addr
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/i_ms0_req
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/i_ms1_addr
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/i_ms1_req
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/i_sl0_ack
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/i_sl1_ack
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/o_m0s0_en
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/o_m0s1_en
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/o_m1s0_en
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/o_m1s1_en
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/o_m0_wait
add wave -noupdate -group arbiter /tb/xi_sys_core/xi_rr_xbar/xi_arbiter/o_m1_wait
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1535000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 193
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {10710 ns}