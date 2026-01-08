**APB protocol**
Designed apb master brigde and slaves integrated both in top module.

apb bridge can handle up to 4 slaves and as we know its not pipelined so can't read and write at the same clock edge.

it has an decoder which is integrated with master it decodes the slave address and outputs the slave select line.
