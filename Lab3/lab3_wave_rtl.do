onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_lab3/DUT/HEX0
add wave -noupdate /tb_lab3/DUT/HEX1
add wave -noupdate /tb_lab3/DUT/HEX2
add wave -noupdate /tb_lab3/DUT/HEX3
add wave -noupdate /tb_lab3/DUT/HEX4
add wave -noupdate /tb_lab3/DUT/HEX5
add wave -noupdate /tb_lab3/DUT/clk
add wave -noupdate /tb_lab3/DUT/rst_n
add wave -noupdate /tb_lab3/DUT/in
add wave -noupdate /tb_lab3/DUT/present_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {372 ps} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ps
update
WaveRestoreZoom {285 ps} {385 ps}
