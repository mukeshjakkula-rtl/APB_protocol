**APB protocol**
Designed apb master brigde and slaves integrated both in top module.

APB bridge can handle up to 4 slaves and as we know its not pipelined so can't read and write at the same clock edge.

It has an decoder which is integrated with master it decodes the slave address and outputs the slave select line.

The read transaction takes of 3 clock cycles to complete so we need to have at least 3  to 4 clock cycles delay to read the data which has written.
