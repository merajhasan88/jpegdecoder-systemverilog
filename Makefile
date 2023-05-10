MODULE=sof_decoding


.PHONY:verilate
verilate: .stamp.verilate

.PHONY:build
build: ./obj_dir/V$(MODULE)


./obj_dir/V$(MODULE): .stamp.obj
	@echo
	@echo "### BUILDING OBJECT ###"
	./obj_dir/V$(MODULE)

.stamp.obj: 
	@echo
	@echo "##### BUILDING SIM #####"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)


.stamp.verilate: .stamp.compile
	@echo
	@echo "### VERILATING ###"
	verilator --trace -cc $(MODULE).sv --exe tb_image.cpp
	@touch .stamp.verilate

.stamp.compile: $(MODULE).sv
	@echo
	@echo "### COMPILING ###"
	verilator -cc $(MODULE).sv 

