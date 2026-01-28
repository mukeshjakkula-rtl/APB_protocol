# APB protocol
* Designed apb master brigde and slaves, integrated both in top module.
* APB bridge can handle up to 4 slaves and as we know its not pipelined so can't read and write at the same clock edge.
* It has an decoder which is integrated within the  master it decodes the slave address and outputs the slave select line.
* Note : For verification the read transaction takes of 3 clock cycles to complete so we need to have at least 3  to 4 clock cycles delay to read the data which has written to the same address.
