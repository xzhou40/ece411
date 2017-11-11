onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mp2_tb/clk
add wave -noupdate -radix hexadecimal /mp2_tb/pmem_resp
add wave -noupdate -radix hexadecimal /mp2_tb/pmem_read
add wave -noupdate -radix hexadecimal /mp2_tb/pmem_write
add wave -noupdate -radix hexadecimal /mp2_tb/pmem_address
add wave -noupdate -radix hexadecimal /mp2_tb/pmem_rdata
add wave -noupdate -radix hexadecimal /mp2_tb/pmem_wdata
add wave -noupdate -radix hexadecimal -expand -subitemconfig {{/mp2_tb/dut/cpu/cpu_datapath/regfile/data[7]} {-radix hexadecimal} {/mp2_tb/dut/cpu/cpu_datapath/regfile/data[6]} {-radix hexadecimal} {/mp2_tb/dut/cpu/cpu_datapath/regfile/data[5]} {-radix hexadecimal} {/mp2_tb/dut/cpu/cpu_datapath/regfile/data[4]} {-radix hexadecimal} {/mp2_tb/dut/cpu/cpu_datapath/regfile/data[3]} {-radix hexadecimal} {/mp2_tb/dut/cpu/cpu_datapath/regfile/data[2]} {-radix hexadecimal} {/mp2_tb/dut/cpu/cpu_datapath/regfile/data[1]} {-radix hexadecimal} {/mp2_tb/dut/cpu/cpu_datapath/regfile/data[0]} {-radix hexadecimal}} /mp2_tb/dut/cpu/cpu_datapath/regfile/data
add wave -noupdate -radix hexadecimal {/mp2_tb/dut/cpu/cpu_datapath/regfile/data[2]}
add wave -noupdate -radix hexadecimal -expand -subitemconfig {{/mp2_tb/dut/cache/cache_datapath/data_store_A/data[7]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_A/data[6]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_A/data[5]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_A/data[4]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_A/data[3]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_A/data[2]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_A/data[1]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_A/data[0]} {-radix hexadecimal}} /mp2_tb/dut/cache/cache_datapath/data_store_A/data
add wave -noupdate -radix hexadecimal -expand -subitemconfig {{/mp2_tb/dut/cache/cache_datapath/data_store_B/data[7]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_B/data[6]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_B/data[5]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_B/data[4]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_B/data[3]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_B/data[2]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_B/data[1]} {-radix hexadecimal} {/mp2_tb/dut/cache/cache_datapath/data_store_B/data[0]} {-radix hexadecimal}} /mp2_tb/dut/cache/cache_datapath/data_store_B/data
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu/cpu_control/state
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_datapath/mem_wdata
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cache/cache_control/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5777690 ps} 0}
configure wave -namecolwidth 272
configure wave -valuecolwidth 202
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
WaveRestoreZoom {8575218 ps} {10074989 ps}
