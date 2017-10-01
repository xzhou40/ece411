onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp2_tb/clk
add wave -noupdate /mp2_tb/pmem_resp
add wave -noupdate /mp2_tb/pmem_read
add wave -noupdate /mp2_tb/pmem_write
add wave -noupdate /mp2_tb/pmem_address
add wave -noupdate /mp2_tb/pmem_rdata
add wave -noupdate /mp2_tb/pmem_wdata
add wave -noupdate /mp2_tb/dut/cache/cache_control/state
add wave -noupdate /mp2_tb/dut/cpu/cpu_control/state
add wave -noupdate /mp2_tb/dut/cache/mem_read
add wave -noupdate /mp2_tb/dut/cache/pmem_read
add wave -noupdate -expand /mp2_tb/dut/cpu/cpu_datapath/regfile/data
add wave -noupdate /mp2_tb/dut/cpu/cpu_datapath/mem_rdata
add wave -noupdate /mp2_tb/dut/cpu/cpu_datapath/mem_address
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/pmem_address
add wave -noupdate /mp2_tb/dut/cpu/cpu_datapath/pc/data
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/data_store_A/data
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/data_store_B/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {300791 ps} 0}
configure wave -namecolwidth 293
configure wave -valuecolwidth 81
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
WaveRestoreZoom {2558823 ps} {2777510 ps}
