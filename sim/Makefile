# Simulacion del CPU de 8 bits con GHDL.
#   make        compila y corre el testbench (tb_cpu)
#   make wave   igual, y guarda las ondas en tb_cpu.ghw (abrir con GTKWave)
#   make clean

GHDL  ?= ghdl
FLAGS := --std=08 -fsynopsys --workdir=build
RTL   := ../rtl

# Orden de dependencias: primero los modulos hoja
SRC := $(RTL)/HA.vhd $(RTL)/ALU_1Bit.vhd $(RTL)/ALU_NBit.vhd \
       $(RTL)/datapath.vhd $(RTL)/control_unit.vhd $(RTL)/CPU_8bit.vhd \
       $(RTL)/mem_programa.vhd $(RTL)/mem_datos.vhd $(RTL)/puertos_salida.vhd \
       $(RTL)/memoria.vhd tb_cpu.vhd

.PHONY: sim wave clean
sim:
	@mkdir -p build
	$(GHDL) -a $(FLAGS) $(SRC)
	$(GHDL) -e $(FLAGS) tb_cpu
	$(GHDL) -r $(FLAGS) tb_cpu --ieee-asserts=disable-at-0 --assert-level=error

wave:
	@mkdir -p build
	$(GHDL) -a $(FLAGS) $(SRC)
	$(GHDL) -e $(FLAGS) tb_cpu
	$(GHDL) -r $(FLAGS) tb_cpu --ieee-asserts=disable-at-0 --wave=tb_cpu.ghw

clean:
	rm -rf build tb_cpu.ghw
