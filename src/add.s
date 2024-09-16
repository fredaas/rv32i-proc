.section .text
.global __reset

.balign 16

__reset:
  add t0, t0, t1
  add t2, t0, t1
  add zero, t0, t1
  add t2, t2, t1
  add t3, t3, t3
  add t3, t3, t3
  add t3, t3, t3
  nop
