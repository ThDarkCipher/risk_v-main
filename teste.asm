#la s1, var
lh s1, 0(s1)
sub s1, s1, s2 
sub s1, s1, s2 
beq s1, s2, SAIDA 
srl s1, s1, s2
sh s1, 0(s1) 
SAIDA: 
andi s1, s1, 42
or s1, s1, s0 
sh s1, 0(s1)

.data
var: