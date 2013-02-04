onerror {resume}
quietly virtual signal -install /tb_cpu/DUT/theCPU/RegisterBlock { (context /tb_cpu/DUT/theCPU/RegisterBlock )(wdat &wsel & wen & clk & nReset &rsel1 &rsel2 &rdat1 &rdat2 &reg &en &BAD1 )} RegisterFile
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Toplevel /tb_cpu/Period
add wave -noupdate -expand -group Toplevel /tb_cpu/clk
add wave -noupdate -expand -group Toplevel /tb_cpu/nReset
add wave -noupdate -expand -group Toplevel /tb_cpu/halt
add wave -noupdate -expand -group Toplevel -radix hexadecimal /tb_cpu/imemData
add wave -noupdate -expand -group Toplevel -radix hexadecimal /tb_cpu/memout
add wave -noupdate -expand -group Toplevel -radix hexadecimal /tb_cpu/dmemDataWrite
add wave -noupdate -expand -group Toplevel -radix hexadecimal /tb_cpu/imemAddr
add wave -noupdate -expand -group Toplevel -radix hexadecimal /tb_cpu/dmemAddr
add wave -noupdate -expand -group Toplevel -radix hexadecimal /tb_cpu/address
add wave -noupdate -group Extender /tb_cpu/DUT/theCPU/ExBlock/Instruction
add wave -noupdate -group Extender /tb_cpu/DUT/theCPU/ExBlock/ExtType
add wave -noupdate -group Extender /tb_cpu/DUT/theCPU/ExBlock/Im32
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/opcode
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/A
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/B
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/aluout
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/negative
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/overflow
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/zero
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/internal_sum
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/internal_sub
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/shiftoutL
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/shiftoutR
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/add_overflow
add wave -noupdate -group ALU /tb_cpu/DUT/theCPU/AluBlock/sub_overflow
add wave -noupdate -expand -group RegisterFile -radix hexadecimal /tb_cpu/DUT/theCPU/RegisterBlock/wdat
add wave -noupdate -expand -group RegisterFile -radix unsigned /tb_cpu/DUT/theCPU/RegisterBlock/wsel
add wave -noupdate -expand -group RegisterFile /tb_cpu/DUT/theCPU/RegisterBlock/wen
add wave -noupdate -expand -group RegisterFile /tb_cpu/DUT/theCPU/RegisterBlock/clk
add wave -noupdate -expand -group RegisterFile /tb_cpu/DUT/theCPU/RegisterBlock/nReset
add wave -noupdate -expand -group RegisterFile -radix unsigned /tb_cpu/DUT/theCPU/RegisterBlock/rsel1
add wave -noupdate -expand -group RegisterFile -radix unsigned /tb_cpu/DUT/theCPU/RegisterBlock/rsel2
add wave -noupdate -expand -group RegisterFile -radix hexadecimal /tb_cpu/DUT/theCPU/RegisterBlock/rdat1
add wave -noupdate -expand -group RegisterFile -radix hexadecimal /tb_cpu/DUT/theCPU/RegisterBlock/rdat2
add wave -noupdate -expand -group RegisterFile -radix hexadecimal /tb_cpu/DUT/theCPU/RegisterBlock/reg
add wave -noupdate -expand -group RegisterFile /tb_cpu/DUT/theCPU/RegisterBlock/en
add wave -noupdate -expand -group RegisterFile /tb_cpu/DUT/theCPU/RegisterBlock/BAD1
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/opcode
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/funct
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/ExtType
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/WriteEnable
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/RegDst
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/AluSrc
add wave -noupdate -expand -group Controller -radix unsigned -childformat {{/tb_cpu/DUT/theCPU/ControllerBlock/ALU_cntrl(2) -radix unsigned} {/tb_cpu/DUT/theCPU/ControllerBlock/ALU_cntrl(1) -radix unsigned} {/tb_cpu/DUT/theCPU/ControllerBlock/ALU_cntrl(0) -radix unsigned}} -radixenum symbolic -subitemconfig {/tb_cpu/DUT/theCPU/ControllerBlock/ALU_cntrl(2) {-height 16 -radix unsigned -radixenum symbolic} /tb_cpu/DUT/theCPU/ControllerBlock/ALU_cntrl(1) {-height 16 -radix unsigned -radixenum symbolic} /tb_cpu/DUT/theCPU/ControllerBlock/ALU_cntrl(0) {-height 16 -radix unsigned -radixenum symbolic}} /tb_cpu/DUT/theCPU/ControllerBlock/ALU_cntrl
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/MemWrite
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/MemOut
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/Branch
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/Jump
add wave -noupdate -expand -group Controller /tb_cpu/DUT/theCPU/ControllerBlock/BNE
add wave -noupdate -group ADDPlus4 /tb_cpu/DUT/theCPU/ADDPC4/A
add wave -noupdate -group ADDPlus4 /tb_cpu/DUT/theCPU/ADDPC4/B
add wave -noupdate -group ADDPlus4 /tb_cpu/DUT/theCPU/ADDPC4/SUM
add wave -noupdate -group ADDPlus4 /tb_cpu/DUT/theCPU/ADDPC4/V
add wave -noupdate -group ADDPlus4 /tb_cpu/DUT/theCPU/ADDPC4/couts
add wave -noupdate -group ADDPlus4 /tb_cpu/DUT/theCPU/ADDPC4/internal_sum
add wave -noupdate -group ADDPlus4 /tb_cpu/DUT/theCPU/ADDPC4/overflow
add wave -noupdate -group AddPlusBranch /tb_cpu/DUT/theCPU/ADDBR/A
add wave -noupdate -group AddPlusBranch /tb_cpu/DUT/theCPU/ADDBR/B
add wave -noupdate -group AddPlusBranch /tb_cpu/DUT/theCPU/ADDBR/SUM
add wave -noupdate -group AddPlusBranch /tb_cpu/DUT/theCPU/ADDBR/V
add wave -noupdate -group AddPlusBranch /tb_cpu/DUT/theCPU/ADDBR/couts
add wave -noupdate -group AddPlusBranch /tb_cpu/DUT/theCPU/ADDBR/internal_sum
add wave -noupdate -group AddPlusBranch /tb_cpu/DUT/theCPU/ADDBR/overflow
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/PC
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/Instruction
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/MemoryData
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/memoryAddress
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/ExtType
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/WriteEnable
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/RegDst
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/AluSrc
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/ALUcntr
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/MemWrite
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/MemOutMux
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/Branch
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/Jump
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/HaltI
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/BNE
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/WriteDataReg
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/zero
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/overflow
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/over1
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/over2
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/negative
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/BusA
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/BusB
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/Im32
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/Bsel
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/PCP4
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/PCJmp
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/JumpAddress
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/BranchAddress
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/AlmostPC
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/nextPC
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/ALUout
add wave -noupdate -expand -group Internal -radix hexadecimal /tb_cpu/DUT/theCPU/shifted
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/rs
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/rt
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/rd
add wave -noupdate -expand -group Internal /tb_cpu/DUT/theCPU/rtd
add wave -noupdate -expand -group LW /tb_cpu/DUT/theCPU/ControllerBlock/memWait
add wave -noupdate -expand -group LW /tb_cpu/DUT/theCPU/ControllerBlock/pastememwait
add wave -noupdate -expand -group LW /tb_cpu/DUT/theCPU/ControllerBlock/nextmemwait
add wave -noupdate -expand -group LW /tb_cpu/DUT/theCPU/ControllerBlock/LW
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 93
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {47 ns}
