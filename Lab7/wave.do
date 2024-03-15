onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /lab7_S1/DUT/CPU/DP/REGFILE/R0
add wave -noupdate -radix decimal /lab7_S1/DUT/CPU/DP/REGFILE/R3
add wave -noupdate -radix decimal /lab7_S1/DUT/CPU/DP/REGFILE/R6
add wave -noupdate -radix decimal /lab7_S1/DUT/CPU/DP/REGFILE/R7
add wave -noupdate /lab7_S1/DUT/CPU/DP/REGFILE/clk
add wave -noupdate /lab7_S1/DUT/CPU/PC
add wave -noupdate /lab7_S1/DUT/CPU/next_pc
add wave -noupdate /lab7_S1/DUT/CPU/load_pc
add wave -noupdate /lab7_S1/DUT/CPU/reset_pc
add wave -noupdate /lab7_S1/DUT/CPU/mem_addr
add wave -noupdate /lab7_S1/DUT/CPU/mem_cmd
add wave -noupdate /lab7_S1/DUT/CPU/read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {170 ps} 0}
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
WaveRestoreZoom {0 ps} {186 ps}
