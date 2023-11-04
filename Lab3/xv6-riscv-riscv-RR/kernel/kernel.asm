
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	92070713          	addi	a4,a4,-1760 # 80008970 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	c4e78793          	addi	a5,a5,-946 # 80005cb0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc81f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dcc78793          	addi	a5,a5,-564 # 80000e78 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	3f0080e7          	jalr	1008(ra) # 8000251a <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	784080e7          	jalr	1924(ra) # 800008be <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	92650513          	addi	a0,a0,-1754 # 80010ab0 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	91648493          	addi	s1,s1,-1770 # 80010ab0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	9a690913          	addi	s2,s2,-1626 # 80010b48 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00001097          	auipc	ra,0x1
    800001c4:	7fe080e7          	jalr	2046(ra) # 800019be <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	19c080e7          	jalr	412(ra) # 80002364 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	ed8080e7          	jalr	-296(ra) # 800020ae <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	2b2080e7          	jalr	690(ra) # 800024c4 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	88a50513          	addi	a0,a0,-1910 # 80010ab0 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	87450513          	addi	a0,a0,-1932 # 80010ab0 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	a46080e7          	jalr	-1466(ra) # 80000c8a <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	8cf72b23          	sw	a5,-1834(a4) # 80010b48 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	560080e7          	jalr	1376(ra) # 800007ec <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54e080e7          	jalr	1358(ra) # 800007ec <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	542080e7          	jalr	1346(ra) # 800007ec <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	538080e7          	jalr	1336(ra) # 800007ec <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00010517          	auipc	a0,0x10
    800002d0:	7e450513          	addi	a0,a0,2020 # 80010ab0 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	902080e7          	jalr	-1790(ra) # 80000bd6 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	27e080e7          	jalr	638(ra) # 80002570 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	7b650513          	addi	a0,a0,1974 # 80010ab0 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	988080e7          	jalr	-1656(ra) # 80000c8a <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	79270713          	addi	a4,a4,1938 # 80010ab0 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	76878793          	addi	a5,a5,1896 # 80010ab0 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7d27a783          	lw	a5,2002(a5) # 80010b48 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	72670713          	addi	a4,a4,1830 # 80010ab0 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	71648493          	addi	s1,s1,1814 # 80010ab0 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	6da70713          	addi	a4,a4,1754 # 80010ab0 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	76f72223          	sw	a5,1892(a4) # 80010b50 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	69e78793          	addi	a5,a5,1694 # 80010ab0 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	70c7ab23          	sw	a2,1814(a5) # 80010b4c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	70a50513          	addi	a0,a0,1802 # 80010b48 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	cda080e7          	jalr	-806(ra) # 80002120 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	65050513          	addi	a0,a0,1616 # 80010ab0 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00021797          	auipc	a5,0x21
    8000047c:	9d078793          	addi	a5,a5,-1584 # 80020e48 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7670713          	addi	a4,a4,-906 # 80000100 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054763          	bltz	a0,80000538 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088c63          	beqz	a7,800004fe <printint+0x62>
    buf[i++] = '-';
    800004ea:	fe070793          	addi	a5,a4,-32
    800004ee:	00878733          	add	a4,a5,s0
    800004f2:	02d00793          	li	a5,45
    800004f6:	fef70823          	sb	a5,-16(a4)
    800004fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fe:	02e05763          	blez	a4,8000052c <printint+0x90>
    80000502:	fd040793          	addi	a5,s0,-48
    80000506:	00e784b3          	add	s1,a5,a4
    8000050a:	fff78913          	addi	s2,a5,-1
    8000050e:	993a                	add	s2,s2,a4
    80000510:	377d                	addiw	a4,a4,-1
    80000512:	1702                	slli	a4,a4,0x20
    80000514:	9301                	srli	a4,a4,0x20
    80000516:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051a:	fff4c503          	lbu	a0,-1(s1)
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	d5e080e7          	jalr	-674(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000526:	14fd                	addi	s1,s1,-1
    80000528:	ff2499e3          	bne	s1,s2,8000051a <printint+0x7e>
}
    8000052c:	70a2                	ld	ra,40(sp)
    8000052e:	7402                	ld	s0,32(sp)
    80000530:	64e2                	ld	s1,24(sp)
    80000532:	6942                	ld	s2,16(sp)
    80000534:	6145                	addi	sp,sp,48
    80000536:	8082                	ret
    x = -xx;
    80000538:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053c:	4885                	li	a7,1
    x = -xx;
    8000053e:	bf95                	j	800004b2 <printint+0x16>

0000000080000540 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000540:	1101                	addi	sp,sp,-32
    80000542:	ec06                	sd	ra,24(sp)
    80000544:	e822                	sd	s0,16(sp)
    80000546:	e426                	sd	s1,8(sp)
    80000548:	1000                	addi	s0,sp,32
    8000054a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054c:	00010797          	auipc	a5,0x10
    80000550:	6207a223          	sw	zero,1572(a5) # 80010b70 <pr+0x18>
  printf("panic: ");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	ac450513          	addi	a0,a0,-1340 # 80008018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
  printf(s);
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
  printf("\n");
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	b5a50513          	addi	a0,a0,-1190 # 800080c8 <digits+0x88>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057e:	4785                	li	a5,1
    80000580:	00008717          	auipc	a4,0x8
    80000584:	3af72823          	sw	a5,944(a4) # 80008930 <panicked>
  for(;;)
    80000588:	a001                	j	80000588 <panic+0x48>

000000008000058a <printf>:
{
    8000058a:	7131                	addi	sp,sp,-192
    8000058c:	fc86                	sd	ra,120(sp)
    8000058e:	f8a2                	sd	s0,112(sp)
    80000590:	f4a6                	sd	s1,104(sp)
    80000592:	f0ca                	sd	s2,96(sp)
    80000594:	ecce                	sd	s3,88(sp)
    80000596:	e8d2                	sd	s4,80(sp)
    80000598:	e4d6                	sd	s5,72(sp)
    8000059a:	e0da                	sd	s6,64(sp)
    8000059c:	fc5e                	sd	s7,56(sp)
    8000059e:	f862                	sd	s8,48(sp)
    800005a0:	f466                	sd	s9,40(sp)
    800005a2:	f06a                	sd	s10,32(sp)
    800005a4:	ec6e                	sd	s11,24(sp)
    800005a6:	0100                	addi	s0,sp,128
    800005a8:	8a2a                	mv	s4,a0
    800005aa:	e40c                	sd	a1,8(s0)
    800005ac:	e810                	sd	a2,16(s0)
    800005ae:	ec14                	sd	a3,24(s0)
    800005b0:	f018                	sd	a4,32(s0)
    800005b2:	f41c                	sd	a5,40(s0)
    800005b4:	03043823          	sd	a6,48(s0)
    800005b8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005bc:	00010d97          	auipc	s11,0x10
    800005c0:	5b4dad83          	lw	s11,1460(s11) # 80010b70 <pr+0x18>
  if(locking)
    800005c4:	020d9b63          	bnez	s11,800005fa <printf+0x70>
  if (fmt == 0)
    800005c8:	040a0263          	beqz	s4,8000060c <printf+0x82>
  va_start(ap, fmt);
    800005cc:	00840793          	addi	a5,s0,8
    800005d0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d4:	000a4503          	lbu	a0,0(s4)
    800005d8:	14050f63          	beqz	a0,80000736 <printf+0x1ac>
    800005dc:	4981                	li	s3,0
    if(c != '%'){
    800005de:	02500a93          	li	s5,37
    switch(c){
    800005e2:	07000b93          	li	s7,112
  consputc('x');
    800005e6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e8:	00008b17          	auipc	s6,0x8
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80008040 <digits>
    switch(c){
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    acquire(&pr.lock);
    800005fa:	00010517          	auipc	a0,0x10
    800005fe:	55e50513          	addi	a0,a0,1374 # 80010b58 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	5d4080e7          	jalr	1492(ra) # 80000bd6 <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    panic("null fmt");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80008028 <etext+0x28>
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f2c080e7          	jalr	-212(ra) # 80000540 <panic>
      consputc(c);
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	c60080e7          	jalr	-928(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000624:	2985                	addiw	s3,s3,1
    80000626:	013a07b3          	add	a5,s4,s3
    8000062a:	0007c503          	lbu	a0,0(a5)
    8000062e:	10050463          	beqz	a0,80000736 <printf+0x1ac>
    if(c != '%'){
    80000632:	ff5515e3          	bne	a0,s5,8000061c <printf+0x92>
    c = fmt[++i] & 0xff;
    80000636:	2985                	addiw	s3,s3,1
    80000638:	013a07b3          	add	a5,s4,s3
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000644:	cbed                	beqz	a5,80000736 <printf+0x1ac>
    switch(c){
    80000646:	05778a63          	beq	a5,s7,8000069a <printf+0x110>
    8000064a:	02fbf663          	bgeu	s7,a5,80000676 <printf+0xec>
    8000064e:	09978863          	beq	a5,s9,800006de <printf+0x154>
    80000652:	07800713          	li	a4,120
    80000656:	0ce79563          	bne	a5,a4,80000720 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4605                	li	a2,1
    80000668:	85ea                	mv	a1,s10
    8000066a:	4388                	lw	a0,0(a5)
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	e30080e7          	jalr	-464(ra) # 8000049c <printint>
      break;
    80000674:	bf45                	j	80000624 <printf+0x9a>
    switch(c){
    80000676:	09578f63          	beq	a5,s5,80000714 <printf+0x18a>
    8000067a:	0b879363          	bne	a5,s8,80000720 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	45a9                	li	a1,10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e0c080e7          	jalr	-500(ra) # 8000049c <printint>
      break;
    80000698:	b771                	j	80000624 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	addi	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006aa:	03000513          	li	a0,48
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	bce080e7          	jalr	-1074(ra) # 8000027c <consputc>
  consputc('x');
    800006b6:	07800513          	li	a0,120
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	bc2080e7          	jalr	-1086(ra) # 8000027c <consputc>
    800006c2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c4:	03c95793          	srli	a5,s2,0x3c
    800006c8:	97da                	add	a5,a5,s6
    800006ca:	0007c503          	lbu	a0,0(a5)
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bae080e7          	jalr	-1106(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d6:	0912                	slli	s2,s2,0x4
    800006d8:	34fd                	addiw	s1,s1,-1
    800006da:	f4ed                	bnez	s1,800006c4 <printf+0x13a>
    800006dc:	b7a1                	j	80000624 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	6384                	ld	s1,0(a5)
    800006ec:	cc89                	beqz	s1,80000706 <printf+0x17c>
      for(; *s; s++)
    800006ee:	0004c503          	lbu	a0,0(s1)
    800006f2:	d90d                	beqz	a0,80000624 <printf+0x9a>
        consputc(*s);
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b88080e7          	jalr	-1144(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fc:	0485                	addi	s1,s1,1
    800006fe:	0004c503          	lbu	a0,0(s1)
    80000702:	f96d                	bnez	a0,800006f4 <printf+0x16a>
    80000704:	b705                	j	80000624 <printf+0x9a>
        s = "(null)";
    80000706:	00008497          	auipc	s1,0x8
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070e:	02800513          	li	a0,40
    80000712:	b7cd                	j	800006f4 <printf+0x16a>
      consputc('%');
    80000714:	8556                	mv	a0,s5
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b66080e7          	jalr	-1178(ra) # 8000027c <consputc>
      break;
    8000071e:	b719                	j	80000624 <printf+0x9a>
      consputc('%');
    80000720:	8556                	mv	a0,s5
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b5a080e7          	jalr	-1190(ra) # 8000027c <consputc>
      consputc(c);
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b50080e7          	jalr	-1200(ra) # 8000027c <consputc>
      break;
    80000734:	bdc5                	j	80000624 <printf+0x9a>
  if(locking)
    80000736:	020d9163          	bnez	s11,80000758 <printf+0x1ce>
}
    8000073a:	70e6                	ld	ra,120(sp)
    8000073c:	7446                	ld	s0,112(sp)
    8000073e:	74a6                	ld	s1,104(sp)
    80000740:	7906                	ld	s2,96(sp)
    80000742:	69e6                	ld	s3,88(sp)
    80000744:	6a46                	ld	s4,80(sp)
    80000746:	6aa6                	ld	s5,72(sp)
    80000748:	6b06                	ld	s6,64(sp)
    8000074a:	7be2                	ld	s7,56(sp)
    8000074c:	7c42                	ld	s8,48(sp)
    8000074e:	7ca2                	ld	s9,40(sp)
    80000750:	7d02                	ld	s10,32(sp)
    80000752:	6de2                	ld	s11,24(sp)
    80000754:	6129                	addi	sp,sp,192
    80000756:	8082                	ret
    release(&pr.lock);
    80000758:	00010517          	auipc	a0,0x10
    8000075c:	40050513          	addi	a0,a0,1024 # 80010b58 <pr>
    80000760:	00000097          	auipc	ra,0x0
    80000764:	52a080e7          	jalr	1322(ra) # 80000c8a <release>
}
    80000768:	bfc9                	j	8000073a <printf+0x1b0>

000000008000076a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000774:	00010497          	auipc	s1,0x10
    80000778:	3e448493          	addi	s1,s1,996 # 80010b58 <pr>
    8000077c:	00008597          	auipc	a1,0x8
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80008038 <etext+0x38>
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	3c0080e7          	jalr	960(ra) # 80000b46 <initlock>
  pr.locking = 1;
    8000078e:	4785                	li	a5,1
    80000790:	cc9c                	sw	a5,24(s1)
}
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret

000000008000079c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079c:	1141                	addi	sp,sp,-16
    8000079e:	e406                	sd	ra,8(sp)
    800007a0:	e022                	sd	s0,0(sp)
    800007a2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ac:	f8000713          	li	a4,-128
    800007b0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b4:	470d                	li	a4,3
    800007b6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007be:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c2:	469d                	li	a3,7
    800007c4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007cc:	00008597          	auipc	a1,0x8
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80008058 <digits+0x18>
    800007d4:	00010517          	auipc	a0,0x10
    800007d8:	3a450513          	addi	a0,a0,932 # 80010b78 <uart_tx_lock>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	36a080e7          	jalr	874(ra) # 80000b46 <initlock>
}
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    800007f6:	84aa                	mv	s1,a0
  push_off();
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	392080e7          	jalr	914(ra) # 80000b8a <push_off>

  if(panicked){
    80000800:	00008797          	auipc	a5,0x8
    80000804:	1307a783          	lw	a5,304(a5) # 80008930 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000808:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080c:	c391                	beqz	a5,80000810 <uartputc_sync+0x24>
    for(;;)
    8000080e:	a001                	j	8000080e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000810:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dfe5                	beqz	a5,80000810 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000081a:	0ff4f513          	zext.b	a0,s1
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	404080e7          	jalr	1028(ra) # 80000c2a <pop_off>
}
    8000082e:	60e2                	ld	ra,24(sp)
    80000830:	6442                	ld	s0,16(sp)
    80000832:	64a2                	ld	s1,8(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000838:	00008797          	auipc	a5,0x8
    8000083c:	1007b783          	ld	a5,256(a5) # 80008938 <uart_tx_r>
    80000840:	00008717          	auipc	a4,0x8
    80000844:	10073703          	ld	a4,256(a4) # 80008940 <uart_tx_w>
    80000848:	06f70a63          	beq	a4,a5,800008bc <uartstart+0x84>
{
    8000084c:	7139                	addi	sp,sp,-64
    8000084e:	fc06                	sd	ra,56(sp)
    80000850:	f822                	sd	s0,48(sp)
    80000852:	f426                	sd	s1,40(sp)
    80000854:	f04a                	sd	s2,32(sp)
    80000856:	ec4e                	sd	s3,24(sp)
    80000858:	e852                	sd	s4,16(sp)
    8000085a:	e456                	sd	s5,8(sp)
    8000085c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000862:	00010a17          	auipc	s4,0x10
    80000866:	316a0a13          	addi	s4,s4,790 # 80010b78 <uart_tx_lock>
    uart_tx_r += 1;
    8000086a:	00008497          	auipc	s1,0x8
    8000086e:	0ce48493          	addi	s1,s1,206 # 80008938 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000872:	00008997          	auipc	s3,0x8
    80000876:	0ce98993          	addi	s3,s3,206 # 80008940 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000087a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087e:	02077713          	andi	a4,a4,32
    80000882:	c705                	beqz	a4,800008aa <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000884:	01f7f713          	andi	a4,a5,31
    80000888:	9752                	add	a4,a4,s4
    8000088a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088e:	0785                	addi	a5,a5,1
    80000890:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000892:	8526                	mv	a0,s1
    80000894:	00002097          	auipc	ra,0x2
    80000898:	88c080e7          	jalr	-1908(ra) # 80002120 <wakeup>
    
    WriteReg(THR, c);
    8000089c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008a0:	609c                	ld	a5,0(s1)
    800008a2:	0009b703          	ld	a4,0(s3)
    800008a6:	fcf71ae3          	bne	a4,a5,8000087a <uartstart+0x42>
  }
}
    800008aa:	70e2                	ld	ra,56(sp)
    800008ac:	7442                	ld	s0,48(sp)
    800008ae:	74a2                	ld	s1,40(sp)
    800008b0:	7902                	ld	s2,32(sp)
    800008b2:	69e2                	ld	s3,24(sp)
    800008b4:	6a42                	ld	s4,16(sp)
    800008b6:	6aa2                	ld	s5,8(sp)
    800008b8:	6121                	addi	sp,sp,64
    800008ba:	8082                	ret
    800008bc:	8082                	ret

00000000800008be <uartputc>:
{
    800008be:	7179                	addi	sp,sp,-48
    800008c0:	f406                	sd	ra,40(sp)
    800008c2:	f022                	sd	s0,32(sp)
    800008c4:	ec26                	sd	s1,24(sp)
    800008c6:	e84a                	sd	s2,16(sp)
    800008c8:	e44e                	sd	s3,8(sp)
    800008ca:	e052                	sd	s4,0(sp)
    800008cc:	1800                	addi	s0,sp,48
    800008ce:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008d0:	00010517          	auipc	a0,0x10
    800008d4:	2a850513          	addi	a0,a0,680 # 80010b78 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	2fe080e7          	jalr	766(ra) # 80000bd6 <acquire>
  if(panicked){
    800008e0:	00008797          	auipc	a5,0x8
    800008e4:	0507a783          	lw	a5,80(a5) # 80008930 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008ea:	00008717          	auipc	a4,0x8
    800008ee:	05673703          	ld	a4,86(a4) # 80008940 <uart_tx_w>
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	0467b783          	ld	a5,70(a5) # 80008938 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fe:	00010997          	auipc	s3,0x10
    80000902:	27a98993          	addi	s3,s3,634 # 80010b78 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	03248493          	addi	s1,s1,50 # 80008938 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	03290913          	addi	s2,s2,50 # 80008940 <uart_tx_w>
    80000916:	00e79f63          	bne	a5,a4,80000934 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091a:	85ce                	mv	a1,s3
    8000091c:	8526                	mv	a0,s1
    8000091e:	00001097          	auipc	ra,0x1
    80000922:	790080e7          	jalr	1936(ra) # 800020ae <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000926:	00093703          	ld	a4,0(s2)
    8000092a:	609c                	ld	a5,0(s1)
    8000092c:	02078793          	addi	a5,a5,32
    80000930:	fee785e3          	beq	a5,a4,8000091a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000934:	00010497          	auipc	s1,0x10
    80000938:	24448493          	addi	s1,s1,580 # 80010b78 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000946:	0705                	addi	a4,a4,1
    80000948:	00008797          	auipc	a5,0x8
    8000094c:	fee7bc23          	sd	a4,-8(a5) # 80008940 <uart_tx_w>
  uartstart();
    80000950:	00000097          	auipc	ra,0x0
    80000954:	ee8080e7          	jalr	-280(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    80000958:	8526                	mv	a0,s1
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	330080e7          	jalr	816(ra) # 80000c8a <release>
}
    80000962:	70a2                	ld	ra,40(sp)
    80000964:	7402                	ld	s0,32(sp)
    80000966:	64e2                	ld	s1,24(sp)
    80000968:	6942                	ld	s2,16(sp)
    8000096a:	69a2                	ld	s3,8(sp)
    8000096c:	6a02                	ld	s4,0(sp)
    8000096e:	6145                	addi	sp,sp,48
    80000970:	8082                	ret
    for(;;)
    80000972:	a001                	j	80000972 <uartputc+0xb4>

0000000080000974 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000974:	1141                	addi	sp,sp,-16
    80000976:	e422                	sd	s0,8(sp)
    80000978:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000097a:	100007b7          	lui	a5,0x10000
    8000097e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000982:	8b85                	andi	a5,a5,1
    80000984:	cb81                	beqz	a5,80000994 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000986:	100007b7          	lui	a5,0x10000
    8000098a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098e:	6422                	ld	s0,8(sp)
    80000990:	0141                	addi	sp,sp,16
    80000992:	8082                	ret
    return -1;
    80000994:	557d                	li	a0,-1
    80000996:	bfe5                	j	8000098e <uartgetc+0x1a>

0000000080000998 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000998:	1101                	addi	sp,sp,-32
    8000099a:	ec06                	sd	ra,24(sp)
    8000099c:	e822                	sd	s0,16(sp)
    8000099e:	e426                	sd	s1,8(sp)
    800009a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a2:	54fd                	li	s1,-1
    800009a4:	a029                	j	800009ae <uartintr+0x16>
      break;
    consoleintr(c);
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	918080e7          	jalr	-1768(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fc6080e7          	jalr	-58(ra) # 80000974 <uartgetc>
    if(c == -1)
    800009b6:	fe9518e3          	bne	a0,s1,800009a6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009ba:	00010497          	auipc	s1,0x10
    800009be:	1be48493          	addi	s1,s1,446 # 80010b78 <uart_tx_lock>
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	212080e7          	jalr	530(ra) # 80000bd6 <acquire>
  uartstart();
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	e6c080e7          	jalr	-404(ra) # 80000838 <uartstart>
  release(&uart_tx_lock);
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	2b4080e7          	jalr	692(ra) # 80000c8a <release>
}
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret

00000000800009e8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	e04a                	sd	s2,0(sp)
    800009f2:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f4:	03451793          	slli	a5,a0,0x34
    800009f8:	ebb9                	bnez	a5,80000a4e <kfree+0x66>
    800009fa:	84aa                	mv	s1,a0
    800009fc:	00021797          	auipc	a5,0x21
    80000a00:	5e478793          	addi	a5,a5,1508 # 80021fe0 <end>
    80000a04:	04f56563          	bltu	a0,a5,80000a4e <kfree+0x66>
    80000a08:	47c5                	li	a5,17
    80000a0a:	07ee                	slli	a5,a5,0x1b
    80000a0c:	04f57163          	bgeu	a0,a5,80000a4e <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a10:	6605                	lui	a2,0x1
    80000a12:	4585                	li	a1,1
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	2be080e7          	jalr	702(ra) # 80000cd2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1c:	00010917          	auipc	s2,0x10
    80000a20:	19490913          	addi	s2,s2,404 # 80010bb0 <kmem>
    80000a24:	854a                	mv	a0,s2
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	1b0080e7          	jalr	432(ra) # 80000bd6 <acquire>
  r->next = kmem.freelist;
    80000a2e:	01893783          	ld	a5,24(s2)
    80000a32:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a34:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a38:	854a                	mv	a0,s2
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	250080e7          	jalr	592(ra) # 80000c8a <release>
}
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6902                	ld	s2,0(sp)
    80000a4a:	6105                	addi	sp,sp,32
    80000a4c:	8082                	ret
    panic("kfree");
    80000a4e:	00007517          	auipc	a0,0x7
    80000a52:	61250513          	addi	a0,a0,1554 # 80008060 <digits+0x20>
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	aea080e7          	jalr	-1302(ra) # 80000540 <panic>

0000000080000a5e <freerange>:
{
    80000a5e:	7179                	addi	sp,sp,-48
    80000a60:	f406                	sd	ra,40(sp)
    80000a62:	f022                	sd	s0,32(sp)
    80000a64:	ec26                	sd	s1,24(sp)
    80000a66:	e84a                	sd	s2,16(sp)
    80000a68:	e44e                	sd	s3,8(sp)
    80000a6a:	e052                	sd	s4,0(sp)
    80000a6c:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a74:	00e504b3          	add	s1,a0,a4
    80000a78:	777d                	lui	a4,0xfffff
    80000a7a:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	94be                	add	s1,s1,a5
    80000a7e:	0095ee63          	bltu	a1,s1,80000a9a <freerange+0x3c>
    80000a82:	892e                	mv	s2,a1
    kfree(p);
    80000a84:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a86:	6985                	lui	s3,0x1
    kfree(p);
    80000a88:	01448533          	add	a0,s1,s4
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	f5c080e7          	jalr	-164(ra) # 800009e8 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a94:	94ce                	add	s1,s1,s3
    80000a96:	fe9979e3          	bgeu	s2,s1,80000a88 <freerange+0x2a>
}
    80000a9a:	70a2                	ld	ra,40(sp)
    80000a9c:	7402                	ld	s0,32(sp)
    80000a9e:	64e2                	ld	s1,24(sp)
    80000aa0:	6942                	ld	s2,16(sp)
    80000aa2:	69a2                	ld	s3,8(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	6145                	addi	sp,sp,48
    80000aa8:	8082                	ret

0000000080000aaa <kinit>:
{
    80000aaa:	1141                	addi	sp,sp,-16
    80000aac:	e406                	sd	ra,8(sp)
    80000aae:	e022                	sd	s0,0(sp)
    80000ab0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ab2:	00007597          	auipc	a1,0x7
    80000ab6:	5b658593          	addi	a1,a1,1462 # 80008068 <digits+0x28>
    80000aba:	00010517          	auipc	a0,0x10
    80000abe:	0f650513          	addi	a0,a0,246 # 80010bb0 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00021517          	auipc	a0,0x21
    80000ad2:	51250513          	addi	a0,a0,1298 # 80021fe0 <end>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f88080e7          	jalr	-120(ra) # 80000a5e <freerange>
}
    80000ade:	60a2                	ld	ra,8(sp)
    80000ae0:	6402                	ld	s0,0(sp)
    80000ae2:	0141                	addi	sp,sp,16
    80000ae4:	8082                	ret

0000000080000ae6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000af0:	00010497          	auipc	s1,0x10
    80000af4:	0c048493          	addi	s1,s1,192 # 80010bb0 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	0dc080e7          	jalr	220(ra) # 80000bd6 <acquire>
  r = kmem.freelist;
    80000b02:	6c84                	ld	s1,24(s1)
  if(r)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	0a850513          	addi	a0,a0,168 # 80010bb0 <kmem>
    80000b10:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	178080e7          	jalr	376(ra) # 80000c8a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	4595                	li	a1,5
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1b2080e7          	jalr	434(ra) # 80000cd2 <memset>
  return (void*)r;
}
    80000b28:	8526                	mv	a0,s1
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	addi	sp,sp,32
    80000b32:	8082                	ret
  release(&kmem.lock);
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	07c50513          	addi	a0,a0,124 # 80010bb0 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	14e080e7          	jalr	334(ra) # 80000c8a <release>
  if(r)
    80000b44:	b7d5                	j	80000b28 <kalloc+0x42>

0000000080000b46 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e422                	sd	s0,8(sp)
    80000b4a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b4c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b52:	00053823          	sd	zero,16(a0)
}
    80000b56:	6422                	ld	s0,8(sp)
    80000b58:	0141                	addi	sp,sp,16
    80000b5a:	8082                	ret

0000000080000b5c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b5c:	411c                	lw	a5,0(a0)
    80000b5e:	e399                	bnez	a5,80000b64 <holding+0x8>
    80000b60:	4501                	li	a0,0
  return r;
}
    80000b62:	8082                	ret
{
    80000b64:	1101                	addi	sp,sp,-32
    80000b66:	ec06                	sd	ra,24(sp)
    80000b68:	e822                	sd	s0,16(sp)
    80000b6a:	e426                	sd	s1,8(sp)
    80000b6c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6e:	6904                	ld	s1,16(a0)
    80000b70:	00001097          	auipc	ra,0x1
    80000b74:	e32080e7          	jalr	-462(ra) # 800019a2 <mycpu>
    80000b78:	40a48533          	sub	a0,s1,a0
    80000b7c:	00153513          	seqz	a0,a0
}
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret

0000000080000b8a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b94:	100024f3          	csrr	s1,sstatus
    80000b98:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b9c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ba2:	00001097          	auipc	ra,0x1
    80000ba6:	e00080e7          	jalr	-512(ra) # 800019a2 <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cf89                	beqz	a5,80000bc6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	df4080e7          	jalr	-524(ra) # 800019a2 <mycpu>
    80000bb6:	5d3c                	lw	a5,120(a0)
    80000bb8:	2785                	addiw	a5,a5,1
    80000bba:	dd3c                	sw	a5,120(a0)
}
    80000bbc:	60e2                	ld	ra,24(sp)
    80000bbe:	6442                	ld	s0,16(sp)
    80000bc0:	64a2                	ld	s1,8(sp)
    80000bc2:	6105                	addi	sp,sp,32
    80000bc4:	8082                	ret
    mycpu()->intena = old;
    80000bc6:	00001097          	auipc	ra,0x1
    80000bca:	ddc080e7          	jalr	-548(ra) # 800019a2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bce:	8085                	srli	s1,s1,0x1
    80000bd0:	8885                	andi	s1,s1,1
    80000bd2:	dd64                	sw	s1,124(a0)
    80000bd4:	bfe9                	j	80000bae <push_off+0x24>

0000000080000bd6 <acquire>:
{
    80000bd6:	1101                	addi	sp,sp,-32
    80000bd8:	ec06                	sd	ra,24(sp)
    80000bda:	e822                	sd	s0,16(sp)
    80000bdc:	e426                	sd	s1,8(sp)
    80000bde:	1000                	addi	s0,sp,32
    80000be0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	fa8080e7          	jalr	-88(ra) # 80000b8a <push_off>
  if(holding(lk))
    80000bea:	8526                	mv	a0,s1
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	f70080e7          	jalr	-144(ra) # 80000b5c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf4:	4705                	li	a4,1
  if(holding(lk))
    80000bf6:	e115                	bnez	a0,80000c1a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf8:	87ba                	mv	a5,a4
    80000bfa:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfe:	2781                	sext.w	a5,a5
    80000c00:	ffe5                	bnez	a5,80000bf8 <acquire+0x22>
  __sync_synchronize();
    80000c02:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c06:	00001097          	auipc	ra,0x1
    80000c0a:	d9c080e7          	jalr	-612(ra) # 800019a2 <mycpu>
    80000c0e:	e888                	sd	a0,16(s1)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    panic("acquire");
    80000c1a:	00007517          	auipc	a0,0x7
    80000c1e:	45650513          	addi	a0,a0,1110 # 80008070 <digits+0x30>
    80000c22:	00000097          	auipc	ra,0x0
    80000c26:	91e080e7          	jalr	-1762(ra) # 80000540 <panic>

0000000080000c2a <pop_off>:

void
pop_off(void)
{
    80000c2a:	1141                	addi	sp,sp,-16
    80000c2c:	e406                	sd	ra,8(sp)
    80000c2e:	e022                	sd	s0,0(sp)
    80000c30:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	d70080e7          	jalr	-656(ra) # 800019a2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c40:	e78d                	bnez	a5,80000c6a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	02f05b63          	blez	a5,80000c7a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c48:	37fd                	addiw	a5,a5,-1
    80000c4a:	0007871b          	sext.w	a4,a5
    80000c4e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c50:	eb09                	bnez	a4,80000c62 <pop_off+0x38>
    80000c52:	5d7c                	lw	a5,124(a0)
    80000c54:	c799                	beqz	a5,80000c62 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c62:	60a2                	ld	ra,8(sp)
    80000c64:	6402                	ld	s0,0(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret
    panic("pop_off - interruptible");
    80000c6a:	00007517          	auipc	a0,0x7
    80000c6e:	40e50513          	addi	a0,a0,1038 # 80008078 <digits+0x38>
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8ce080e7          	jalr	-1842(ra) # 80000540 <panic>
    panic("pop_off");
    80000c7a:	00007517          	auipc	a0,0x7
    80000c7e:	41650513          	addi	a0,a0,1046 # 80008090 <digits+0x50>
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	8be080e7          	jalr	-1858(ra) # 80000540 <panic>

0000000080000c8a <release>:
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	ec6080e7          	jalr	-314(ra) # 80000b5c <holding>
    80000c9e:	c115                	beqz	a0,80000cc2 <release+0x38>
  lk->cpu = 0;
    80000ca0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca8:	0f50000f          	fence	iorw,ow
    80000cac:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	f7a080e7          	jalr	-134(ra) # 80000c2a <pop_off>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    panic("release");
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	3d650513          	addi	a0,a0,982 # 80008098 <digits+0x58>
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	876080e7          	jalr	-1930(ra) # 80000540 <panic>

0000000080000cd2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd2:	1141                	addi	sp,sp,-16
    80000cd4:	e422                	sd	s0,8(sp)
    80000cd6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd8:	ca19                	beqz	a2,80000cee <memset+0x1c>
    80000cda:	87aa                	mv	a5,a0
    80000cdc:	1602                	slli	a2,a2,0x20
    80000cde:	9201                	srli	a2,a2,0x20
    80000ce0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce8:	0785                	addi	a5,a5,1
    80000cea:	fee79de3          	bne	a5,a4,80000ce4 <memset+0x12>
  }
  return dst;
}
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e422                	sd	s0,8(sp)
    80000cf8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfa:	ca05                	beqz	a2,80000d2a <memcmp+0x36>
    80000cfc:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d00:	1682                	slli	a3,a3,0x20
    80000d02:	9281                	srli	a3,a3,0x20
    80000d04:	0685                	addi	a3,a3,1
    80000d06:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d08:	00054783          	lbu	a5,0(a0)
    80000d0c:	0005c703          	lbu	a4,0(a1)
    80000d10:	00e79863          	bne	a5,a4,80000d20 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d14:	0505                	addi	a0,a0,1
    80000d16:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d18:	fed518e3          	bne	a0,a3,80000d08 <memcmp+0x14>
  }

  return 0;
    80000d1c:	4501                	li	a0,0
    80000d1e:	a019                	j	80000d24 <memcmp+0x30>
      return *s1 - *s2;
    80000d20:	40e7853b          	subw	a0,a5,a4
}
    80000d24:	6422                	ld	s0,8(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
  return 0;
    80000d2a:	4501                	li	a0,0
    80000d2c:	bfe5                	j	80000d24 <memcmp+0x30>

0000000080000d2e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d34:	c205                	beqz	a2,80000d54 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d36:	02a5e263          	bltu	a1,a0,80000d5a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d3a:	1602                	slli	a2,a2,0x20
    80000d3c:	9201                	srli	a2,a2,0x20
    80000d3e:	00c587b3          	add	a5,a1,a2
{
    80000d42:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d44:	0585                	addi	a1,a1,1
    80000d46:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd021>
    80000d48:	fff5c683          	lbu	a3,-1(a1)
    80000d4c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d50:	fef59ae3          	bne	a1,a5,80000d44 <memmove+0x16>

  return dst;
}
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
  if(s < d && s + n > d){
    80000d5a:	02061693          	slli	a3,a2,0x20
    80000d5e:	9281                	srli	a3,a3,0x20
    80000d60:	00d58733          	add	a4,a1,a3
    80000d64:	fce57be3          	bgeu	a0,a4,80000d3a <memmove+0xc>
    d += n;
    80000d68:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6a:	fff6079b          	addiw	a5,a2,-1
    80000d6e:	1782                	slli	a5,a5,0x20
    80000d70:	9381                	srli	a5,a5,0x20
    80000d72:	fff7c793          	not	a5,a5
    80000d76:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d78:	177d                	addi	a4,a4,-1
    80000d7a:	16fd                	addi	a3,a3,-1
    80000d7c:	00074603          	lbu	a2,0(a4)
    80000d80:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d84:	fee79ae3          	bne	a5,a4,80000d78 <memmove+0x4a>
    80000d88:	b7f1                	j	80000d54 <memmove+0x26>

0000000080000d8a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	f9c080e7          	jalr	-100(ra) # 80000d2e <memmove>
}
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    n--, p++, q++;
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc0:	4501                	li	a0,0
    80000dc2:	a809                	j	80000dd4 <strncmp+0x32>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a039                	j	80000dd4 <strncmp+0x32>
  if(n == 0)
    80000dc8:	ca09                	beqz	a2,80000dda <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dca:	00054503          	lbu	a0,0(a0)
    80000dce:	0005c783          	lbu	a5,0(a1)
    80000dd2:	9d1d                	subw	a0,a0,a5
}
    80000dd4:	6422                	ld	s0,8(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret
    return 0;
    80000dda:	4501                	li	a0,0
    80000ddc:	bfe5                	j	80000dd4 <strncmp+0x32>

0000000080000dde <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dde:	1141                	addi	sp,sp,-16
    80000de0:	e422                	sd	s0,8(sp)
    80000de2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de4:	872a                	mv	a4,a0
    80000de6:	8832                	mv	a6,a2
    80000de8:	367d                	addiw	a2,a2,-1
    80000dea:	01005963          	blez	a6,80000dfc <strncpy+0x1e>
    80000dee:	0705                	addi	a4,a4,1
    80000df0:	0005c783          	lbu	a5,0(a1)
    80000df4:	fef70fa3          	sb	a5,-1(a4)
    80000df8:	0585                	addi	a1,a1,1
    80000dfa:	f7f5                	bnez	a5,80000de6 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dfc:	86ba                	mv	a3,a4
    80000dfe:	00c05c63          	blez	a2,80000e16 <strncpy+0x38>
    *s++ = 0;
    80000e02:	0685                	addi	a3,a3,1
    80000e04:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e08:	40d707bb          	subw	a5,a4,a3
    80000e0c:	37fd                	addiw	a5,a5,-1
    80000e0e:	010787bb          	addw	a5,a5,a6
    80000e12:	fef048e3          	bgtz	a5,80000e02 <strncpy+0x24>
  return os;
}
    80000e16:	6422                	ld	s0,8(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret

0000000080000e1c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e22:	02c05363          	blez	a2,80000e48 <safestrcpy+0x2c>
    80000e26:	fff6069b          	addiw	a3,a2,-1
    80000e2a:	1682                	slli	a3,a3,0x20
    80000e2c:	9281                	srli	a3,a3,0x20
    80000e2e:	96ae                	add	a3,a3,a1
    80000e30:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e32:	00d58963          	beq	a1,a3,80000e44 <safestrcpy+0x28>
    80000e36:	0585                	addi	a1,a1,1
    80000e38:	0785                	addi	a5,a5,1
    80000e3a:	fff5c703          	lbu	a4,-1(a1)
    80000e3e:	fee78fa3          	sb	a4,-1(a5)
    80000e42:	fb65                	bnez	a4,80000e32 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e44:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strlen>:

int
strlen(const char *s)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e54:	00054783          	lbu	a5,0(a0)
    80000e58:	cf91                	beqz	a5,80000e74 <strlen+0x26>
    80000e5a:	0505                	addi	a0,a0,1
    80000e5c:	87aa                	mv	a5,a0
    80000e5e:	4685                	li	a3,1
    80000e60:	9e89                	subw	a3,a3,a0
    80000e62:	00f6853b          	addw	a0,a3,a5
    80000e66:	0785                	addi	a5,a5,1
    80000e68:	fff7c703          	lbu	a4,-1(a5)
    80000e6c:	fb7d                	bnez	a4,80000e62 <strlen+0x14>
    ;
  return n;
}
    80000e6e:	6422                	ld	s0,8(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e74:	4501                	li	a0,0
    80000e76:	bfe5                	j	80000e6e <strlen+0x20>

0000000080000e78 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e406                	sd	ra,8(sp)
    80000e7c:	e022                	sd	s0,0(sp)
    80000e7e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e80:	00001097          	auipc	ra,0x1
    80000e84:	b12080e7          	jalr	-1262(ra) # 80001992 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e88:	00008717          	auipc	a4,0x8
    80000e8c:	ac070713          	addi	a4,a4,-1344 # 80008948 <started>
  if(cpuid() == 0){
    80000e90:	c139                	beqz	a0,80000ed6 <main+0x5e>
    while(started == 0)
    80000e92:	431c                	lw	a5,0(a4)
    80000e94:	2781                	sext.w	a5,a5
    80000e96:	dff5                	beqz	a5,80000e92 <main+0x1a>
      ;
    __sync_synchronize();
    80000e98:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	af6080e7          	jalr	-1290(ra) # 80001992 <cpuid>
    80000ea4:	85aa                	mv	a1,a0
    80000ea6:	00007517          	auipc	a0,0x7
    80000eaa:	21250513          	addi	a0,a0,530 # 800080b8 <digits+0x78>
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	6dc080e7          	jalr	1756(ra) # 8000058a <printf>
    kvminithart();    // turn on paging
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	0d8080e7          	jalr	216(ra) # 80000f8e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ebe:	00002097          	auipc	ra,0x2
    80000ec2:	86e080e7          	jalr	-1938(ra) # 8000272c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	e2a080e7          	jalr	-470(ra) # 80005cf0 <plicinithart>
  }

  scheduler();        
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	ff2080e7          	jalr	-14(ra) # 80001ec0 <scheduler>
    consoleinit();
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	57a080e7          	jalr	1402(ra) # 80000450 <consoleinit>
    printfinit();
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	88c080e7          	jalr	-1908(ra) # 8000076a <printfinit>
    printf("\n");
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	1e250513          	addi	a0,a0,482 # 800080c8 <digits+0x88>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	69c080e7          	jalr	1692(ra) # 8000058a <printf>
    printf("xv6 kernel is booting\n");
    80000ef6:	00007517          	auipc	a0,0x7
    80000efa:	1aa50513          	addi	a0,a0,426 # 800080a0 <digits+0x60>
    80000efe:	fffff097          	auipc	ra,0xfffff
    80000f02:	68c080e7          	jalr	1676(ra) # 8000058a <printf>
    printf("\n");
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	1c250513          	addi	a0,a0,450 # 800080c8 <digits+0x88>
    80000f0e:	fffff097          	auipc	ra,0xfffff
    80000f12:	67c080e7          	jalr	1660(ra) # 8000058a <printf>
    kinit();         // physical page allocator
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	b94080e7          	jalr	-1132(ra) # 80000aaa <kinit>
    kvminit();       // create kernel page table
    80000f1e:	00000097          	auipc	ra,0x0
    80000f22:	326080e7          	jalr	806(ra) # 80001244 <kvminit>
    kvminithart();   // turn on paging
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	068080e7          	jalr	104(ra) # 80000f8e <kvminithart>
    procinit();      // process table
    80000f2e:	00001097          	auipc	ra,0x1
    80000f32:	99e080e7          	jalr	-1634(ra) # 800018cc <procinit>
    trapinit();      // trap vectors
    80000f36:	00001097          	auipc	ra,0x1
    80000f3a:	7ce080e7          	jalr	1998(ra) # 80002704 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00001097          	auipc	ra,0x1
    80000f42:	7ee080e7          	jalr	2030(ra) # 8000272c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	d94080e7          	jalr	-620(ra) # 80005cda <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	da2080e7          	jalr	-606(ra) # 80005cf0 <plicinithart>
    binit();         // buffer cache
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	f40080e7          	jalr	-192(ra) # 80002e96 <binit>
    iinit();         // inode table
    80000f5e:	00002097          	auipc	ra,0x2
    80000f62:	5e0080e7          	jalr	1504(ra) # 8000353e <iinit>
    fileinit();      // file table
    80000f66:	00003097          	auipc	ra,0x3
    80000f6a:	586080e7          	jalr	1414(ra) # 800044ec <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	e8a080e7          	jalr	-374(ra) # 80005df8 <virtio_disk_init>
    userinit();      // first user process
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	d2c080e7          	jalr	-724(ra) # 80001ca2 <userinit>
    __sync_synchronize();
    80000f7e:	0ff0000f          	fence
    started = 1;
    80000f82:	4785                	li	a5,1
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	9cf72223          	sw	a5,-1596(a4) # 80008948 <started>
    80000f8c:	b789                	j	80000ece <main+0x56>

0000000080000f8e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e422                	sd	s0,8(sp)
    80000f92:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f94:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	9b87b783          	ld	a5,-1608(a5) # 80008950 <kernel_pagetable>
    80000fa0:	83b1                	srli	a5,a5,0xc
    80000fa2:	577d                	li	a4,-1
    80000fa4:	177e                	slli	a4,a4,0x3f
    80000fa6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000fac:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000fb0:	6422                	ld	s0,8(sp)
    80000fb2:	0141                	addi	sp,sp,16
    80000fb4:	8082                	ret

0000000080000fb6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb6:	7139                	addi	sp,sp,-64
    80000fb8:	fc06                	sd	ra,56(sp)
    80000fba:	f822                	sd	s0,48(sp)
    80000fbc:	f426                	sd	s1,40(sp)
    80000fbe:	f04a                	sd	s2,32(sp)
    80000fc0:	ec4e                	sd	s3,24(sp)
    80000fc2:	e852                	sd	s4,16(sp)
    80000fc4:	e456                	sd	s5,8(sp)
    80000fc6:	e05a                	sd	s6,0(sp)
    80000fc8:	0080                	addi	s0,sp,64
    80000fca:	84aa                	mv	s1,a0
    80000fcc:	89ae                	mv	s3,a1
    80000fce:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fd0:	57fd                	li	a5,-1
    80000fd2:	83e9                	srli	a5,a5,0x1a
    80000fd4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd6:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd8:	04b7f263          	bgeu	a5,a1,8000101c <walk+0x66>
    panic("walk");
    80000fdc:	00007517          	auipc	a0,0x7
    80000fe0:	0f450513          	addi	a0,a0,244 # 800080d0 <digits+0x90>
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	55c080e7          	jalr	1372(ra) # 80000540 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fec:	060a8663          	beqz	s5,80001058 <walk+0xa2>
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	af6080e7          	jalr	-1290(ra) # 80000ae6 <kalloc>
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	c529                	beqz	a0,80001044 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffc:	6605                	lui	a2,0x1
    80000ffe:	4581                	li	a1,0
    80001000:	00000097          	auipc	ra,0x0
    80001004:	cd2080e7          	jalr	-814(ra) # 80000cd2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001008:	00c4d793          	srli	a5,s1,0xc
    8000100c:	07aa                	slli	a5,a5,0xa
    8000100e:	0017e793          	ori	a5,a5,1
    80001012:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001016:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd017>
    80001018:	036a0063          	beq	s4,s6,80001038 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101c:	0149d933          	srl	s2,s3,s4
    80001020:	1ff97913          	andi	s2,s2,511
    80001024:	090e                	slli	s2,s2,0x3
    80001026:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001028:	00093483          	ld	s1,0(s2)
    8000102c:	0014f793          	andi	a5,s1,1
    80001030:	dfd5                	beqz	a5,80000fec <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001032:	80a9                	srli	s1,s1,0xa
    80001034:	04b2                	slli	s1,s1,0xc
    80001036:	b7c5                	j	80001016 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001038:	00c9d513          	srli	a0,s3,0xc
    8000103c:	1ff57513          	andi	a0,a0,511
    80001040:	050e                	slli	a0,a0,0x3
    80001042:	9526                	add	a0,a0,s1
}
    80001044:	70e2                	ld	ra,56(sp)
    80001046:	7442                	ld	s0,48(sp)
    80001048:	74a2                	ld	s1,40(sp)
    8000104a:	7902                	ld	s2,32(sp)
    8000104c:	69e2                	ld	s3,24(sp)
    8000104e:	6a42                	ld	s4,16(sp)
    80001050:	6aa2                	ld	s5,8(sp)
    80001052:	6b02                	ld	s6,0(sp)
    80001054:	6121                	addi	sp,sp,64
    80001056:	8082                	ret
        return 0;
    80001058:	4501                	li	a0,0
    8000105a:	b7ed                	j	80001044 <walk+0x8e>

000000008000105c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105c:	57fd                	li	a5,-1
    8000105e:	83e9                	srli	a5,a5,0x1a
    80001060:	00b7f463          	bgeu	a5,a1,80001068 <walkaddr+0xc>
    return 0;
    80001064:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001066:	8082                	ret
{
    80001068:	1141                	addi	sp,sp,-16
    8000106a:	e406                	sd	ra,8(sp)
    8000106c:	e022                	sd	s0,0(sp)
    8000106e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001070:	4601                	li	a2,0
    80001072:	00000097          	auipc	ra,0x0
    80001076:	f44080e7          	jalr	-188(ra) # 80000fb6 <walk>
  if(pte == 0)
    8000107a:	c105                	beqz	a0,8000109a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107e:	0117f693          	andi	a3,a5,17
    80001082:	4745                	li	a4,17
    return 0;
    80001084:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001086:	00e68663          	beq	a3,a4,80001092 <walkaddr+0x36>
}
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	addi	sp,sp,16
    80001090:	8082                	ret
  pa = PTE2PA(*pte);
    80001092:	83a9                	srli	a5,a5,0xa
    80001094:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001098:	bfcd                	j	8000108a <walkaddr+0x2e>
    return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7fd                	j	8000108a <walkaddr+0x2e>

000000008000109e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109e:	715d                	addi	sp,sp,-80
    800010a0:	e486                	sd	ra,72(sp)
    800010a2:	e0a2                	sd	s0,64(sp)
    800010a4:	fc26                	sd	s1,56(sp)
    800010a6:	f84a                	sd	s2,48(sp)
    800010a8:	f44e                	sd	s3,40(sp)
    800010aa:	f052                	sd	s4,32(sp)
    800010ac:	ec56                	sd	s5,24(sp)
    800010ae:	e85a                	sd	s6,16(sp)
    800010b0:	e45e                	sd	s7,8(sp)
    800010b2:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010b4:	c639                	beqz	a2,80001102 <mappages+0x64>
    800010b6:	8aaa                	mv	s5,a0
    800010b8:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010ba:	777d                	lui	a4,0xfffff
    800010bc:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010c0:	fff58993          	addi	s3,a1,-1
    800010c4:	99b2                	add	s3,s3,a2
    800010c6:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010ca:	893e                	mv	s2,a5
    800010cc:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010d0:	6b85                	lui	s7,0x1
    800010d2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d6:	4605                	li	a2,1
    800010d8:	85ca                	mv	a1,s2
    800010da:	8556                	mv	a0,s5
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	eda080e7          	jalr	-294(ra) # 80000fb6 <walk>
    800010e4:	cd1d                	beqz	a0,80001122 <mappages+0x84>
    if(*pte & PTE_V)
    800010e6:	611c                	ld	a5,0(a0)
    800010e8:	8b85                	andi	a5,a5,1
    800010ea:	e785                	bnez	a5,80001112 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010ec:	80b1                	srli	s1,s1,0xc
    800010ee:	04aa                	slli	s1,s1,0xa
    800010f0:	0164e4b3          	or	s1,s1,s6
    800010f4:	0014e493          	ori	s1,s1,1
    800010f8:	e104                	sd	s1,0(a0)
    if(a == last)
    800010fa:	05390063          	beq	s2,s3,8000113a <mappages+0x9c>
    a += PGSIZE;
    800010fe:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001100:	bfc9                	j	800010d2 <mappages+0x34>
    panic("mappages: size");
    80001102:	00007517          	auipc	a0,0x7
    80001106:	fd650513          	addi	a0,a0,-42 # 800080d8 <digits+0x98>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	436080e7          	jalr	1078(ra) # 80000540 <panic>
      panic("mappages: remap");
    80001112:	00007517          	auipc	a0,0x7
    80001116:	fd650513          	addi	a0,a0,-42 # 800080e8 <digits+0xa8>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	426080e7          	jalr	1062(ra) # 80000540 <panic>
      return -1;
    80001122:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001124:	60a6                	ld	ra,72(sp)
    80001126:	6406                	ld	s0,64(sp)
    80001128:	74e2                	ld	s1,56(sp)
    8000112a:	7942                	ld	s2,48(sp)
    8000112c:	79a2                	ld	s3,40(sp)
    8000112e:	7a02                	ld	s4,32(sp)
    80001130:	6ae2                	ld	s5,24(sp)
    80001132:	6b42                	ld	s6,16(sp)
    80001134:	6ba2                	ld	s7,8(sp)
    80001136:	6161                	addi	sp,sp,80
    80001138:	8082                	ret
  return 0;
    8000113a:	4501                	li	a0,0
    8000113c:	b7e5                	j	80001124 <mappages+0x86>

000000008000113e <kvmmap>:
{
    8000113e:	1141                	addi	sp,sp,-16
    80001140:	e406                	sd	ra,8(sp)
    80001142:	e022                	sd	s0,0(sp)
    80001144:	0800                	addi	s0,sp,16
    80001146:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001148:	86b2                	mv	a3,a2
    8000114a:	863e                	mv	a2,a5
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f52080e7          	jalr	-174(ra) # 8000109e <mappages>
    80001154:	e509                	bnez	a0,8000115e <kvmmap+0x20>
}
    80001156:	60a2                	ld	ra,8(sp)
    80001158:	6402                	ld	s0,0(sp)
    8000115a:	0141                	addi	sp,sp,16
    8000115c:	8082                	ret
    panic("kvmmap");
    8000115e:	00007517          	auipc	a0,0x7
    80001162:	f9a50513          	addi	a0,a0,-102 # 800080f8 <digits+0xb8>
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3da080e7          	jalr	986(ra) # 80000540 <panic>

000000008000116e <kvmmake>:
{
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	e04a                	sd	s2,0(sp)
    80001178:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	96c080e7          	jalr	-1684(ra) # 80000ae6 <kalloc>
    80001182:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001184:	6605                	lui	a2,0x1
    80001186:	4581                	li	a1,0
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	b4a080e7          	jalr	-1206(ra) # 80000cd2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001190:	4719                	li	a4,6
    80001192:	6685                	lui	a3,0x1
    80001194:	10000637          	lui	a2,0x10000
    80001198:	100005b7          	lui	a1,0x10000
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	fa0080e7          	jalr	-96(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011a6:	4719                	li	a4,6
    800011a8:	6685                	lui	a3,0x1
    800011aa:	10001637          	lui	a2,0x10001
    800011ae:	100015b7          	lui	a1,0x10001
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f8a080e7          	jalr	-118(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011bc:	4719                	li	a4,6
    800011be:	004006b7          	lui	a3,0x400
    800011c2:	0c000637          	lui	a2,0xc000
    800011c6:	0c0005b7          	lui	a1,0xc000
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f72080e7          	jalr	-142(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011d4:	00007917          	auipc	s2,0x7
    800011d8:	e2c90913          	addi	s2,s2,-468 # 80008000 <etext>
    800011dc:	4729                	li	a4,10
    800011de:	80007697          	auipc	a3,0x80007
    800011e2:	e2268693          	addi	a3,a3,-478 # 8000 <_entry-0x7fff8000>
    800011e6:	4605                	li	a2,1
    800011e8:	067e                	slli	a2,a2,0x1f
    800011ea:	85b2                	mv	a1,a2
    800011ec:	8526                	mv	a0,s1
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	f50080e7          	jalr	-176(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011f6:	4719                	li	a4,6
    800011f8:	46c5                	li	a3,17
    800011fa:	06ee                	slli	a3,a3,0x1b
    800011fc:	412686b3          	sub	a3,a3,s2
    80001200:	864a                	mv	a2,s2
    80001202:	85ca                	mv	a1,s2
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	f38080e7          	jalr	-200(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000120e:	4729                	li	a4,10
    80001210:	6685                	lui	a3,0x1
    80001212:	00006617          	auipc	a2,0x6
    80001216:	dee60613          	addi	a2,a2,-530 # 80007000 <_trampoline>
    8000121a:	040005b7          	lui	a1,0x4000
    8000121e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001220:	05b2                	slli	a1,a1,0xc
    80001222:	8526                	mv	a0,s1
    80001224:	00000097          	auipc	ra,0x0
    80001228:	f1a080e7          	jalr	-230(ra) # 8000113e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	608080e7          	jalr	1544(ra) # 80001836 <proc_mapstacks>
}
    80001236:	8526                	mv	a0,s1
    80001238:	60e2                	ld	ra,24(sp)
    8000123a:	6442                	ld	s0,16(sp)
    8000123c:	64a2                	ld	s1,8(sp)
    8000123e:	6902                	ld	s2,0(sp)
    80001240:	6105                	addi	sp,sp,32
    80001242:	8082                	ret

0000000080001244 <kvminit>:
{
    80001244:	1141                	addi	sp,sp,-16
    80001246:	e406                	sd	ra,8(sp)
    80001248:	e022                	sd	s0,0(sp)
    8000124a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f22080e7          	jalr	-222(ra) # 8000116e <kvmmake>
    80001254:	00007797          	auipc	a5,0x7
    80001258:	6ea7be23          	sd	a0,1788(a5) # 80008950 <kernel_pagetable>
}
    8000125c:	60a2                	ld	ra,8(sp)
    8000125e:	6402                	ld	s0,0(sp)
    80001260:	0141                	addi	sp,sp,16
    80001262:	8082                	ret

0000000080001264 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001264:	715d                	addi	sp,sp,-80
    80001266:	e486                	sd	ra,72(sp)
    80001268:	e0a2                	sd	s0,64(sp)
    8000126a:	fc26                	sd	s1,56(sp)
    8000126c:	f84a                	sd	s2,48(sp)
    8000126e:	f44e                	sd	s3,40(sp)
    80001270:	f052                	sd	s4,32(sp)
    80001272:	ec56                	sd	s5,24(sp)
    80001274:	e85a                	sd	s6,16(sp)
    80001276:	e45e                	sd	s7,8(sp)
    80001278:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000127a:	03459793          	slli	a5,a1,0x34
    8000127e:	e795                	bnez	a5,800012aa <uvmunmap+0x46>
    80001280:	8a2a                	mv	s4,a0
    80001282:	892e                	mv	s2,a1
    80001284:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001286:	0632                	slli	a2,a2,0xc
    80001288:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000128c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000128e:	6b05                	lui	s6,0x1
    80001290:	0735e263          	bltu	a1,s3,800012f4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	74e2                	ld	s1,56(sp)
    8000129a:	7942                	ld	s2,48(sp)
    8000129c:	79a2                	ld	s3,40(sp)
    8000129e:	7a02                	ld	s4,32(sp)
    800012a0:	6ae2                	ld	s5,24(sp)
    800012a2:	6b42                	ld	s6,16(sp)
    800012a4:	6ba2                	ld	s7,8(sp)
    800012a6:	6161                	addi	sp,sp,80
    800012a8:	8082                	ret
    panic("uvmunmap: not aligned");
    800012aa:	00007517          	auipc	a0,0x7
    800012ae:	e5650513          	addi	a0,a0,-426 # 80008100 <digits+0xc0>
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	28e080e7          	jalr	654(ra) # 80000540 <panic>
      panic("uvmunmap: walk");
    800012ba:	00007517          	auipc	a0,0x7
    800012be:	e5e50513          	addi	a0,a0,-418 # 80008118 <digits+0xd8>
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	27e080e7          	jalr	638(ra) # 80000540 <panic>
      panic("uvmunmap: not mapped");
    800012ca:	00007517          	auipc	a0,0x7
    800012ce:	e5e50513          	addi	a0,a0,-418 # 80008128 <digits+0xe8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	26e080e7          	jalr	622(ra) # 80000540 <panic>
      panic("uvmunmap: not a leaf");
    800012da:	00007517          	auipc	a0,0x7
    800012de:	e6650513          	addi	a0,a0,-410 # 80008140 <digits+0x100>
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	25e080e7          	jalr	606(ra) # 80000540 <panic>
    *pte = 0;
    800012ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ee:	995a                	add	s2,s2,s6
    800012f0:	fb3972e3          	bgeu	s2,s3,80001294 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012f4:	4601                	li	a2,0
    800012f6:	85ca                	mv	a1,s2
    800012f8:	8552                	mv	a0,s4
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	cbc080e7          	jalr	-836(ra) # 80000fb6 <walk>
    80001302:	84aa                	mv	s1,a0
    80001304:	d95d                	beqz	a0,800012ba <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001306:	6108                	ld	a0,0(a0)
    80001308:	00157793          	andi	a5,a0,1
    8000130c:	dfdd                	beqz	a5,800012ca <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000130e:	3ff57793          	andi	a5,a0,1023
    80001312:	fd7784e3          	beq	a5,s7,800012da <uvmunmap+0x76>
    if(do_free){
    80001316:	fc0a8ae3          	beqz	s5,800012ea <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000131a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000131c:	0532                	slli	a0,a0,0xc
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	6ca080e7          	jalr	1738(ra) # 800009e8 <kfree>
    80001326:	b7d1                	j	800012ea <uvmunmap+0x86>

0000000080001328 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	e426                	sd	s1,8(sp)
    80001330:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	7b4080e7          	jalr	1972(ra) # 80000ae6 <kalloc>
    8000133a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000133c:	c519                	beqz	a0,8000134a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000133e:	6605                	lui	a2,0x1
    80001340:	4581                	li	a1,0
    80001342:	00000097          	auipc	ra,0x0
    80001346:	990080e7          	jalr	-1648(ra) # 80000cd2 <memset>
  return pagetable;
}
    8000134a:	8526                	mv	a0,s1
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret

0000000080001356 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001356:	7179                	addi	sp,sp,-48
    80001358:	f406                	sd	ra,40(sp)
    8000135a:	f022                	sd	s0,32(sp)
    8000135c:	ec26                	sd	s1,24(sp)
    8000135e:	e84a                	sd	s2,16(sp)
    80001360:	e44e                	sd	s3,8(sp)
    80001362:	e052                	sd	s4,0(sp)
    80001364:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001366:	6785                	lui	a5,0x1
    80001368:	04f67863          	bgeu	a2,a5,800013b8 <uvmfirst+0x62>
    8000136c:	8a2a                	mv	s4,a0
    8000136e:	89ae                	mv	s3,a1
    80001370:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	774080e7          	jalr	1908(ra) # 80000ae6 <kalloc>
    8000137a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000137c:	6605                	lui	a2,0x1
    8000137e:	4581                	li	a1,0
    80001380:	00000097          	auipc	ra,0x0
    80001384:	952080e7          	jalr	-1710(ra) # 80000cd2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001388:	4779                	li	a4,30
    8000138a:	86ca                	mv	a3,s2
    8000138c:	6605                	lui	a2,0x1
    8000138e:	4581                	li	a1,0
    80001390:	8552                	mv	a0,s4
    80001392:	00000097          	auipc	ra,0x0
    80001396:	d0c080e7          	jalr	-756(ra) # 8000109e <mappages>
  memmove(mem, src, sz);
    8000139a:	8626                	mv	a2,s1
    8000139c:	85ce                	mv	a1,s3
    8000139e:	854a                	mv	a0,s2
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	98e080e7          	jalr	-1650(ra) # 80000d2e <memmove>
}
    800013a8:	70a2                	ld	ra,40(sp)
    800013aa:	7402                	ld	s0,32(sp)
    800013ac:	64e2                	ld	s1,24(sp)
    800013ae:	6942                	ld	s2,16(sp)
    800013b0:	69a2                	ld	s3,8(sp)
    800013b2:	6a02                	ld	s4,0(sp)
    800013b4:	6145                	addi	sp,sp,48
    800013b6:	8082                	ret
    panic("uvmfirst: more than a page");
    800013b8:	00007517          	auipc	a0,0x7
    800013bc:	da050513          	addi	a0,a0,-608 # 80008158 <digits+0x118>
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	180080e7          	jalr	384(ra) # 80000540 <panic>

00000000800013c8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013c8:	1101                	addi	sp,sp,-32
    800013ca:	ec06                	sd	ra,24(sp)
    800013cc:	e822                	sd	s0,16(sp)
    800013ce:	e426                	sd	s1,8(sp)
    800013d0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013d2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013d4:	00b67d63          	bgeu	a2,a1,800013ee <uvmdealloc+0x26>
    800013d8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013da:	6785                	lui	a5,0x1
    800013dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013de:	00f60733          	add	a4,a2,a5
    800013e2:	76fd                	lui	a3,0xfffff
    800013e4:	8f75                	and	a4,a4,a3
    800013e6:	97ae                	add	a5,a5,a1
    800013e8:	8ff5                	and	a5,a5,a3
    800013ea:	00f76863          	bltu	a4,a5,800013fa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013fa:	8f99                	sub	a5,a5,a4
    800013fc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013fe:	4685                	li	a3,1
    80001400:	0007861b          	sext.w	a2,a5
    80001404:	85ba                	mv	a1,a4
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	e5e080e7          	jalr	-418(ra) # 80001264 <uvmunmap>
    8000140e:	b7c5                	j	800013ee <uvmdealloc+0x26>

0000000080001410 <uvmalloc>:
  if(newsz < oldsz)
    80001410:	0ab66563          	bltu	a2,a1,800014ba <uvmalloc+0xaa>
{
    80001414:	7139                	addi	sp,sp,-64
    80001416:	fc06                	sd	ra,56(sp)
    80001418:	f822                	sd	s0,48(sp)
    8000141a:	f426                	sd	s1,40(sp)
    8000141c:	f04a                	sd	s2,32(sp)
    8000141e:	ec4e                	sd	s3,24(sp)
    80001420:	e852                	sd	s4,16(sp)
    80001422:	e456                	sd	s5,8(sp)
    80001424:	e05a                	sd	s6,0(sp)
    80001426:	0080                	addi	s0,sp,64
    80001428:	8aaa                	mv	s5,a0
    8000142a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000142c:	6785                	lui	a5,0x1
    8000142e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001430:	95be                	add	a1,a1,a5
    80001432:	77fd                	lui	a5,0xfffff
    80001434:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001438:	08c9f363          	bgeu	s3,a2,800014be <uvmalloc+0xae>
    8000143c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000143e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	6a4080e7          	jalr	1700(ra) # 80000ae6 <kalloc>
    8000144a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000144c:	c51d                	beqz	a0,8000147a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000144e:	6605                	lui	a2,0x1
    80001450:	4581                	li	a1,0
    80001452:	00000097          	auipc	ra,0x0
    80001456:	880080e7          	jalr	-1920(ra) # 80000cd2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000145a:	875a                	mv	a4,s6
    8000145c:	86a6                	mv	a3,s1
    8000145e:	6605                	lui	a2,0x1
    80001460:	85ca                	mv	a1,s2
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	c3a080e7          	jalr	-966(ra) # 8000109e <mappages>
    8000146c:	e90d                	bnez	a0,8000149e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000146e:	6785                	lui	a5,0x1
    80001470:	993e                	add	s2,s2,a5
    80001472:	fd4968e3          	bltu	s2,s4,80001442 <uvmalloc+0x32>
  return newsz;
    80001476:	8552                	mv	a0,s4
    80001478:	a809                	j	8000148a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000147a:	864e                	mv	a2,s3
    8000147c:	85ca                	mv	a1,s2
    8000147e:	8556                	mv	a0,s5
    80001480:	00000097          	auipc	ra,0x0
    80001484:	f48080e7          	jalr	-184(ra) # 800013c8 <uvmdealloc>
      return 0;
    80001488:	4501                	li	a0,0
}
    8000148a:	70e2                	ld	ra,56(sp)
    8000148c:	7442                	ld	s0,48(sp)
    8000148e:	74a2                	ld	s1,40(sp)
    80001490:	7902                	ld	s2,32(sp)
    80001492:	69e2                	ld	s3,24(sp)
    80001494:	6a42                	ld	s4,16(sp)
    80001496:	6aa2                	ld	s5,8(sp)
    80001498:	6b02                	ld	s6,0(sp)
    8000149a:	6121                	addi	sp,sp,64
    8000149c:	8082                	ret
      kfree(mem);
    8000149e:	8526                	mv	a0,s1
    800014a0:	fffff097          	auipc	ra,0xfffff
    800014a4:	548080e7          	jalr	1352(ra) # 800009e8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014a8:	864e                	mv	a2,s3
    800014aa:	85ca                	mv	a1,s2
    800014ac:	8556                	mv	a0,s5
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	f1a080e7          	jalr	-230(ra) # 800013c8 <uvmdealloc>
      return 0;
    800014b6:	4501                	li	a0,0
    800014b8:	bfc9                	j	8000148a <uvmalloc+0x7a>
    return oldsz;
    800014ba:	852e                	mv	a0,a1
}
    800014bc:	8082                	ret
  return newsz;
    800014be:	8532                	mv	a0,a2
    800014c0:	b7e9                	j	8000148a <uvmalloc+0x7a>

00000000800014c2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014c2:	7179                	addi	sp,sp,-48
    800014c4:	f406                	sd	ra,40(sp)
    800014c6:	f022                	sd	s0,32(sp)
    800014c8:	ec26                	sd	s1,24(sp)
    800014ca:	e84a                	sd	s2,16(sp)
    800014cc:	e44e                	sd	s3,8(sp)
    800014ce:	e052                	sd	s4,0(sp)
    800014d0:	1800                	addi	s0,sp,48
    800014d2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014d4:	84aa                	mv	s1,a0
    800014d6:	6905                	lui	s2,0x1
    800014d8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014da:	4985                	li	s3,1
    800014dc:	a829                	j	800014f6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014de:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014e0:	00c79513          	slli	a0,a5,0xc
    800014e4:	00000097          	auipc	ra,0x0
    800014e8:	fde080e7          	jalr	-34(ra) # 800014c2 <freewalk>
      pagetable[i] = 0;
    800014ec:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014f0:	04a1                	addi	s1,s1,8
    800014f2:	03248163          	beq	s1,s2,80001514 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014f6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f8:	00f7f713          	andi	a4,a5,15
    800014fc:	ff3701e3          	beq	a4,s3,800014de <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001500:	8b85                	andi	a5,a5,1
    80001502:	d7fd                	beqz	a5,800014f0 <freewalk+0x2e>
      panic("freewalk: leaf");
    80001504:	00007517          	auipc	a0,0x7
    80001508:	c7450513          	addi	a0,a0,-908 # 80008178 <digits+0x138>
    8000150c:	fffff097          	auipc	ra,0xfffff
    80001510:	034080e7          	jalr	52(ra) # 80000540 <panic>
    }
  }
  kfree((void*)pagetable);
    80001514:	8552                	mv	a0,s4
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	4d2080e7          	jalr	1234(ra) # 800009e8 <kfree>
}
    8000151e:	70a2                	ld	ra,40(sp)
    80001520:	7402                	ld	s0,32(sp)
    80001522:	64e2                	ld	s1,24(sp)
    80001524:	6942                	ld	s2,16(sp)
    80001526:	69a2                	ld	s3,8(sp)
    80001528:	6a02                	ld	s4,0(sp)
    8000152a:	6145                	addi	sp,sp,48
    8000152c:	8082                	ret

000000008000152e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000152e:	1101                	addi	sp,sp,-32
    80001530:	ec06                	sd	ra,24(sp)
    80001532:	e822                	sd	s0,16(sp)
    80001534:	e426                	sd	s1,8(sp)
    80001536:	1000                	addi	s0,sp,32
    80001538:	84aa                	mv	s1,a0
  if(sz > 0)
    8000153a:	e999                	bnez	a1,80001550 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	f84080e7          	jalr	-124(ra) # 800014c2 <freewalk>
}
    80001546:	60e2                	ld	ra,24(sp)
    80001548:	6442                	ld	s0,16(sp)
    8000154a:	64a2                	ld	s1,8(sp)
    8000154c:	6105                	addi	sp,sp,32
    8000154e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001550:	6785                	lui	a5,0x1
    80001552:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001554:	95be                	add	a1,a1,a5
    80001556:	4685                	li	a3,1
    80001558:	00c5d613          	srli	a2,a1,0xc
    8000155c:	4581                	li	a1,0
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	d06080e7          	jalr	-762(ra) # 80001264 <uvmunmap>
    80001566:	bfd9                	j	8000153c <uvmfree+0xe>

0000000080001568 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001568:	c679                	beqz	a2,80001636 <uvmcopy+0xce>
{
    8000156a:	715d                	addi	sp,sp,-80
    8000156c:	e486                	sd	ra,72(sp)
    8000156e:	e0a2                	sd	s0,64(sp)
    80001570:	fc26                	sd	s1,56(sp)
    80001572:	f84a                	sd	s2,48(sp)
    80001574:	f44e                	sd	s3,40(sp)
    80001576:	f052                	sd	s4,32(sp)
    80001578:	ec56                	sd	s5,24(sp)
    8000157a:	e85a                	sd	s6,16(sp)
    8000157c:	e45e                	sd	s7,8(sp)
    8000157e:	0880                	addi	s0,sp,80
    80001580:	8b2a                	mv	s6,a0
    80001582:	8aae                	mv	s5,a1
    80001584:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001586:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001588:	4601                	li	a2,0
    8000158a:	85ce                	mv	a1,s3
    8000158c:	855a                	mv	a0,s6
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	a28080e7          	jalr	-1496(ra) # 80000fb6 <walk>
    80001596:	c531                	beqz	a0,800015e2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001598:	6118                	ld	a4,0(a0)
    8000159a:	00177793          	andi	a5,a4,1
    8000159e:	cbb1                	beqz	a5,800015f2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015a0:	00a75593          	srli	a1,a4,0xa
    800015a4:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015a8:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	53a080e7          	jalr	1338(ra) # 80000ae6 <kalloc>
    800015b4:	892a                	mv	s2,a0
    800015b6:	c939                	beqz	a0,8000160c <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015b8:	6605                	lui	a2,0x1
    800015ba:	85de                	mv	a1,s7
    800015bc:	fffff097          	auipc	ra,0xfffff
    800015c0:	772080e7          	jalr	1906(ra) # 80000d2e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015c4:	8726                	mv	a4,s1
    800015c6:	86ca                	mv	a3,s2
    800015c8:	6605                	lui	a2,0x1
    800015ca:	85ce                	mv	a1,s3
    800015cc:	8556                	mv	a0,s5
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	ad0080e7          	jalr	-1328(ra) # 8000109e <mappages>
    800015d6:	e515                	bnez	a0,80001602 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015d8:	6785                	lui	a5,0x1
    800015da:	99be                	add	s3,s3,a5
    800015dc:	fb49e6e3          	bltu	s3,s4,80001588 <uvmcopy+0x20>
    800015e0:	a081                	j	80001620 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015e2:	00007517          	auipc	a0,0x7
    800015e6:	ba650513          	addi	a0,a0,-1114 # 80008188 <digits+0x148>
    800015ea:	fffff097          	auipc	ra,0xfffff
    800015ee:	f56080e7          	jalr	-170(ra) # 80000540 <panic>
      panic("uvmcopy: page not present");
    800015f2:	00007517          	auipc	a0,0x7
    800015f6:	bb650513          	addi	a0,a0,-1098 # 800081a8 <digits+0x168>
    800015fa:	fffff097          	auipc	ra,0xfffff
    800015fe:	f46080e7          	jalr	-186(ra) # 80000540 <panic>
      kfree(mem);
    80001602:	854a                	mv	a0,s2
    80001604:	fffff097          	auipc	ra,0xfffff
    80001608:	3e4080e7          	jalr	996(ra) # 800009e8 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000160c:	4685                	li	a3,1
    8000160e:	00c9d613          	srli	a2,s3,0xc
    80001612:	4581                	li	a1,0
    80001614:	8556                	mv	a0,s5
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	c4e080e7          	jalr	-946(ra) # 80001264 <uvmunmap>
  return -1;
    8000161e:	557d                	li	a0,-1
}
    80001620:	60a6                	ld	ra,72(sp)
    80001622:	6406                	ld	s0,64(sp)
    80001624:	74e2                	ld	s1,56(sp)
    80001626:	7942                	ld	s2,48(sp)
    80001628:	79a2                	ld	s3,40(sp)
    8000162a:	7a02                	ld	s4,32(sp)
    8000162c:	6ae2                	ld	s5,24(sp)
    8000162e:	6b42                	ld	s6,16(sp)
    80001630:	6ba2                	ld	s7,8(sp)
    80001632:	6161                	addi	sp,sp,80
    80001634:	8082                	ret
  return 0;
    80001636:	4501                	li	a0,0
}
    80001638:	8082                	ret

000000008000163a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000163a:	1141                	addi	sp,sp,-16
    8000163c:	e406                	sd	ra,8(sp)
    8000163e:	e022                	sd	s0,0(sp)
    80001640:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001642:	4601                	li	a2,0
    80001644:	00000097          	auipc	ra,0x0
    80001648:	972080e7          	jalr	-1678(ra) # 80000fb6 <walk>
  if(pte == 0)
    8000164c:	c901                	beqz	a0,8000165c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000164e:	611c                	ld	a5,0(a0)
    80001650:	9bbd                	andi	a5,a5,-17
    80001652:	e11c                	sd	a5,0(a0)
}
    80001654:	60a2                	ld	ra,8(sp)
    80001656:	6402                	ld	s0,0(sp)
    80001658:	0141                	addi	sp,sp,16
    8000165a:	8082                	ret
    panic("uvmclear");
    8000165c:	00007517          	auipc	a0,0x7
    80001660:	b6c50513          	addi	a0,a0,-1172 # 800081c8 <digits+0x188>
    80001664:	fffff097          	auipc	ra,0xfffff
    80001668:	edc080e7          	jalr	-292(ra) # 80000540 <panic>

000000008000166c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000166c:	c6bd                	beqz	a3,800016da <copyout+0x6e>
{
    8000166e:	715d                	addi	sp,sp,-80
    80001670:	e486                	sd	ra,72(sp)
    80001672:	e0a2                	sd	s0,64(sp)
    80001674:	fc26                	sd	s1,56(sp)
    80001676:	f84a                	sd	s2,48(sp)
    80001678:	f44e                	sd	s3,40(sp)
    8000167a:	f052                	sd	s4,32(sp)
    8000167c:	ec56                	sd	s5,24(sp)
    8000167e:	e85a                	sd	s6,16(sp)
    80001680:	e45e                	sd	s7,8(sp)
    80001682:	e062                	sd	s8,0(sp)
    80001684:	0880                	addi	s0,sp,80
    80001686:	8b2a                	mv	s6,a0
    80001688:	8c2e                	mv	s8,a1
    8000168a:	8a32                	mv	s4,a2
    8000168c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000168e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001690:	6a85                	lui	s5,0x1
    80001692:	a015                	j	800016b6 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001694:	9562                	add	a0,a0,s8
    80001696:	0004861b          	sext.w	a2,s1
    8000169a:	85d2                	mv	a1,s4
    8000169c:	41250533          	sub	a0,a0,s2
    800016a0:	fffff097          	auipc	ra,0xfffff
    800016a4:	68e080e7          	jalr	1678(ra) # 80000d2e <memmove>

    len -= n;
    800016a8:	409989b3          	sub	s3,s3,s1
    src += n;
    800016ac:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016ae:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016b2:	02098263          	beqz	s3,800016d6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016b6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016ba:	85ca                	mv	a1,s2
    800016bc:	855a                	mv	a0,s6
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	99e080e7          	jalr	-1634(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    800016c6:	cd01                	beqz	a0,800016de <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016c8:	418904b3          	sub	s1,s2,s8
    800016cc:	94d6                	add	s1,s1,s5
    800016ce:	fc99f3e3          	bgeu	s3,s1,80001694 <copyout+0x28>
    800016d2:	84ce                	mv	s1,s3
    800016d4:	b7c1                	j	80001694 <copyout+0x28>
  }
  return 0;
    800016d6:	4501                	li	a0,0
    800016d8:	a021                	j	800016e0 <copyout+0x74>
    800016da:	4501                	li	a0,0
}
    800016dc:	8082                	ret
      return -1;
    800016de:	557d                	li	a0,-1
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6c02                	ld	s8,0(sp)
    800016f4:	6161                	addi	sp,sp,80
    800016f6:	8082                	ret

00000000800016f8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016f8:	caa5                	beqz	a3,80001768 <copyin+0x70>
{
    800016fa:	715d                	addi	sp,sp,-80
    800016fc:	e486                	sd	ra,72(sp)
    800016fe:	e0a2                	sd	s0,64(sp)
    80001700:	fc26                	sd	s1,56(sp)
    80001702:	f84a                	sd	s2,48(sp)
    80001704:	f44e                	sd	s3,40(sp)
    80001706:	f052                	sd	s4,32(sp)
    80001708:	ec56                	sd	s5,24(sp)
    8000170a:	e85a                	sd	s6,16(sp)
    8000170c:	e45e                	sd	s7,8(sp)
    8000170e:	e062                	sd	s8,0(sp)
    80001710:	0880                	addi	s0,sp,80
    80001712:	8b2a                	mv	s6,a0
    80001714:	8a2e                	mv	s4,a1
    80001716:	8c32                	mv	s8,a2
    80001718:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000171a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000171c:	6a85                	lui	s5,0x1
    8000171e:	a01d                	j	80001744 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001720:	018505b3          	add	a1,a0,s8
    80001724:	0004861b          	sext.w	a2,s1
    80001728:	412585b3          	sub	a1,a1,s2
    8000172c:	8552                	mv	a0,s4
    8000172e:	fffff097          	auipc	ra,0xfffff
    80001732:	600080e7          	jalr	1536(ra) # 80000d2e <memmove>

    len -= n;
    80001736:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000173a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000173c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001740:	02098263          	beqz	s3,80001764 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001744:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001748:	85ca                	mv	a1,s2
    8000174a:	855a                	mv	a0,s6
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	910080e7          	jalr	-1776(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    80001754:	cd01                	beqz	a0,8000176c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001756:	418904b3          	sub	s1,s2,s8
    8000175a:	94d6                	add	s1,s1,s5
    8000175c:	fc99f2e3          	bgeu	s3,s1,80001720 <copyin+0x28>
    80001760:	84ce                	mv	s1,s3
    80001762:	bf7d                	j	80001720 <copyin+0x28>
  }
  return 0;
    80001764:	4501                	li	a0,0
    80001766:	a021                	j	8000176e <copyin+0x76>
    80001768:	4501                	li	a0,0
}
    8000176a:	8082                	ret
      return -1;
    8000176c:	557d                	li	a0,-1
}
    8000176e:	60a6                	ld	ra,72(sp)
    80001770:	6406                	ld	s0,64(sp)
    80001772:	74e2                	ld	s1,56(sp)
    80001774:	7942                	ld	s2,48(sp)
    80001776:	79a2                	ld	s3,40(sp)
    80001778:	7a02                	ld	s4,32(sp)
    8000177a:	6ae2                	ld	s5,24(sp)
    8000177c:	6b42                	ld	s6,16(sp)
    8000177e:	6ba2                	ld	s7,8(sp)
    80001780:	6c02                	ld	s8,0(sp)
    80001782:	6161                	addi	sp,sp,80
    80001784:	8082                	ret

0000000080001786 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001786:	c2dd                	beqz	a3,8000182c <copyinstr+0xa6>
{
    80001788:	715d                	addi	sp,sp,-80
    8000178a:	e486                	sd	ra,72(sp)
    8000178c:	e0a2                	sd	s0,64(sp)
    8000178e:	fc26                	sd	s1,56(sp)
    80001790:	f84a                	sd	s2,48(sp)
    80001792:	f44e                	sd	s3,40(sp)
    80001794:	f052                	sd	s4,32(sp)
    80001796:	ec56                	sd	s5,24(sp)
    80001798:	e85a                	sd	s6,16(sp)
    8000179a:	e45e                	sd	s7,8(sp)
    8000179c:	0880                	addi	s0,sp,80
    8000179e:	8a2a                	mv	s4,a0
    800017a0:	8b2e                	mv	s6,a1
    800017a2:	8bb2                	mv	s7,a2
    800017a4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017a6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017a8:	6985                	lui	s3,0x1
    800017aa:	a02d                	j	800017d4 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017ac:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017b0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017b2:	37fd                	addiw	a5,a5,-1
    800017b4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017b8:	60a6                	ld	ra,72(sp)
    800017ba:	6406                	ld	s0,64(sp)
    800017bc:	74e2                	ld	s1,56(sp)
    800017be:	7942                	ld	s2,48(sp)
    800017c0:	79a2                	ld	s3,40(sp)
    800017c2:	7a02                	ld	s4,32(sp)
    800017c4:	6ae2                	ld	s5,24(sp)
    800017c6:	6b42                	ld	s6,16(sp)
    800017c8:	6ba2                	ld	s7,8(sp)
    800017ca:	6161                	addi	sp,sp,80
    800017cc:	8082                	ret
    srcva = va0 + PGSIZE;
    800017ce:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017d2:	c8a9                	beqz	s1,80001824 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017d4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017d8:	85ca                	mv	a1,s2
    800017da:	8552                	mv	a0,s4
    800017dc:	00000097          	auipc	ra,0x0
    800017e0:	880080e7          	jalr	-1920(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    800017e4:	c131                	beqz	a0,80001828 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017e6:	417906b3          	sub	a3,s2,s7
    800017ea:	96ce                	add	a3,a3,s3
    800017ec:	00d4f363          	bgeu	s1,a3,800017f2 <copyinstr+0x6c>
    800017f0:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017f2:	955e                	add	a0,a0,s7
    800017f4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017f8:	daf9                	beqz	a3,800017ce <copyinstr+0x48>
    800017fa:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017fc:	41650633          	sub	a2,a0,s6
    80001800:	fff48593          	addi	a1,s1,-1
    80001804:	95da                	add	a1,a1,s6
    while(n > 0){
    80001806:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80001808:	00f60733          	add	a4,a2,a5
    8000180c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd020>
    80001810:	df51                	beqz	a4,800017ac <copyinstr+0x26>
        *dst = *p;
    80001812:	00e78023          	sb	a4,0(a5)
      --max;
    80001816:	40f584b3          	sub	s1,a1,a5
      dst++;
    8000181a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000181c:	fed796e3          	bne	a5,a3,80001808 <copyinstr+0x82>
      dst++;
    80001820:	8b3e                	mv	s6,a5
    80001822:	b775                	j	800017ce <copyinstr+0x48>
    80001824:	4781                	li	a5,0
    80001826:	b771                	j	800017b2 <copyinstr+0x2c>
      return -1;
    80001828:	557d                	li	a0,-1
    8000182a:	b779                	j	800017b8 <copyinstr+0x32>
  int got_null = 0;
    8000182c:	4781                	li	a5,0
  if(got_null){
    8000182e:	37fd                	addiw	a5,a5,-1
    80001830:	0007851b          	sext.w	a0,a5
}
    80001834:	8082                	ret

0000000080001836 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001836:	7139                	addi	sp,sp,-64
    80001838:	fc06                	sd	ra,56(sp)
    8000183a:	f822                	sd	s0,48(sp)
    8000183c:	f426                	sd	s1,40(sp)
    8000183e:	f04a                	sd	s2,32(sp)
    80001840:	ec4e                	sd	s3,24(sp)
    80001842:	e852                	sd	s4,16(sp)
    80001844:	e456                	sd	s5,8(sp)
    80001846:	e05a                	sd	s6,0(sp)
    80001848:	0080                	addi	s0,sp,64
    8000184a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000184c:	0000f497          	auipc	s1,0xf
    80001850:	7b448493          	addi	s1,s1,1972 # 80011000 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001854:	8b26                	mv	s6,s1
    80001856:	00006a97          	auipc	s5,0x6
    8000185a:	7aaa8a93          	addi	s5,s5,1962 # 80008000 <etext>
    8000185e:	04000937          	lui	s2,0x4000
    80001862:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001864:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001866:	00015a17          	auipc	s4,0x15
    8000186a:	39aa0a13          	addi	s4,s4,922 # 80016c00 <tickslock>
    char *pa = kalloc();
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	278080e7          	jalr	632(ra) # 80000ae6 <kalloc>
    80001876:	862a                	mv	a2,a0
    if(pa == 0)
    80001878:	c131                	beqz	a0,800018bc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000187a:	416485b3          	sub	a1,s1,s6
    8000187e:	8591                	srai	a1,a1,0x4
    80001880:	000ab783          	ld	a5,0(s5)
    80001884:	02f585b3          	mul	a1,a1,a5
    80001888:	2585                	addiw	a1,a1,1
    8000188a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000188e:	4719                	li	a4,6
    80001890:	6685                	lui	a3,0x1
    80001892:	40b905b3          	sub	a1,s2,a1
    80001896:	854e                	mv	a0,s3
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	8a6080e7          	jalr	-1882(ra) # 8000113e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	17048493          	addi	s1,s1,368
    800018a4:	fd4495e3          	bne	s1,s4,8000186e <proc_mapstacks+0x38>
  }
}
    800018a8:	70e2                	ld	ra,56(sp)
    800018aa:	7442                	ld	s0,48(sp)
    800018ac:	74a2                	ld	s1,40(sp)
    800018ae:	7902                	ld	s2,32(sp)
    800018b0:	69e2                	ld	s3,24(sp)
    800018b2:	6a42                	ld	s4,16(sp)
    800018b4:	6aa2                	ld	s5,8(sp)
    800018b6:	6b02                	ld	s6,0(sp)
    800018b8:	6121                	addi	sp,sp,64
    800018ba:	8082                	ret
      panic("kalloc");
    800018bc:	00007517          	auipc	a0,0x7
    800018c0:	91c50513          	addi	a0,a0,-1764 # 800081d8 <digits+0x198>
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	c7c080e7          	jalr	-900(ra) # 80000540 <panic>

00000000800018cc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018cc:	715d                	addi	sp,sp,-80
    800018ce:	e486                	sd	ra,72(sp)
    800018d0:	e0a2                	sd	s0,64(sp)
    800018d2:	fc26                	sd	s1,56(sp)
    800018d4:	f84a                	sd	s2,48(sp)
    800018d6:	f44e                	sd	s3,40(sp)
    800018d8:	f052                	sd	s4,32(sp)
    800018da:	ec56                	sd	s5,24(sp)
    800018dc:	e85a                	sd	s6,16(sp)
    800018de:	e45e                	sd	s7,8(sp)
    800018e0:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018e2:	00007597          	auipc	a1,0x7
    800018e6:	8fe58593          	addi	a1,a1,-1794 # 800081e0 <digits+0x1a0>
    800018ea:	0000f517          	auipc	a0,0xf
    800018ee:	2e650513          	addi	a0,a0,742 # 80010bd0 <pid_lock>
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	254080e7          	jalr	596(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018fa:	00007597          	auipc	a1,0x7
    800018fe:	8ee58593          	addi	a1,a1,-1810 # 800081e8 <digits+0x1a8>
    80001902:	0000f517          	auipc	a0,0xf
    80001906:	2e650513          	addi	a0,a0,742 # 80010be8 <wait_lock>
    8000190a:	fffff097          	auipc	ra,0xfffff
    8000190e:	23c080e7          	jalr	572(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001912:	0000f497          	auipc	s1,0xf
    80001916:	6ee48493          	addi	s1,s1,1774 # 80011000 <proc>
      initlock(&p->lock, "proc");
    8000191a:	00007b97          	auipc	s7,0x7
    8000191e:	8deb8b93          	addi	s7,s7,-1826 # 800081f8 <digits+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001922:	8b26                	mv	s6,s1
    80001924:	00006a97          	auipc	s5,0x6
    80001928:	6dca8a93          	addi	s5,s5,1756 # 80008000 <etext>
    8000192c:	04000937          	lui	s2,0x4000
    80001930:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001932:	0932                	slli	s2,s2,0xc
      p->times_executed = 0;
      p->priority = NPRIO - 1;
    80001934:	4a09                	li	s4,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80001936:	00015997          	auipc	s3,0x15
    8000193a:	2ca98993          	addi	s3,s3,714 # 80016c00 <tickslock>
      initlock(&p->lock, "proc");
    8000193e:	85de                	mv	a1,s7
    80001940:	8526                	mv	a0,s1
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	204080e7          	jalr	516(ra) # 80000b46 <initlock>
      p->state = UNUSED;
    8000194a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000194e:	416487b3          	sub	a5,s1,s6
    80001952:	8791                	srai	a5,a5,0x4
    80001954:	000ab703          	ld	a4,0(s5)
    80001958:	02e787b3          	mul	a5,a5,a4
    8000195c:	2785                	addiw	a5,a5,1
    8000195e:	00d7979b          	slliw	a5,a5,0xd
    80001962:	40f907b3          	sub	a5,s2,a5
    80001966:	e4bc                	sd	a5,72(s1)
      p->times_executed = 0;
    80001968:	0204ac23          	sw	zero,56(s1)
      p->priority = NPRIO - 1;
    8000196c:	0344aa23          	sw	s4,52(s1)
      p->last_executed = 0;
    80001970:	0204ae23          	sw	zero,60(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001974:	17048493          	addi	s1,s1,368
    80001978:	fd3493e3          	bne	s1,s3,8000193e <procinit+0x72>
  }
}
    8000197c:	60a6                	ld	ra,72(sp)
    8000197e:	6406                	ld	s0,64(sp)
    80001980:	74e2                	ld	s1,56(sp)
    80001982:	7942                	ld	s2,48(sp)
    80001984:	79a2                	ld	s3,40(sp)
    80001986:	7a02                	ld	s4,32(sp)
    80001988:	6ae2                	ld	s5,24(sp)
    8000198a:	6b42                	ld	s6,16(sp)
    8000198c:	6ba2                	ld	s7,8(sp)
    8000198e:	6161                	addi	sp,sp,80
    80001990:	8082                	ret

0000000080001992 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001992:	1141                	addi	sp,sp,-16
    80001994:	e422                	sd	s0,8(sp)
    80001996:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001998:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000199a:	2501                	sext.w	a0,a0
    8000199c:	6422                	ld	s0,8(sp)
    8000199e:	0141                	addi	sp,sp,16
    800019a0:	8082                	ret

00000000800019a2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800019a2:	1141                	addi	sp,sp,-16
    800019a4:	e422                	sd	s0,8(sp)
    800019a6:	0800                	addi	s0,sp,16
    800019a8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800019aa:	2781                	sext.w	a5,a5
    800019ac:	079e                	slli	a5,a5,0x7
  return c;
}
    800019ae:	0000f517          	auipc	a0,0xf
    800019b2:	25250513          	addi	a0,a0,594 # 80010c00 <cpus>
    800019b6:	953e                	add	a0,a0,a5
    800019b8:	6422                	ld	s0,8(sp)
    800019ba:	0141                	addi	sp,sp,16
    800019bc:	8082                	ret

00000000800019be <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800019be:	1101                	addi	sp,sp,-32
    800019c0:	ec06                	sd	ra,24(sp)
    800019c2:	e822                	sd	s0,16(sp)
    800019c4:	e426                	sd	s1,8(sp)
    800019c6:	1000                	addi	s0,sp,32
  push_off();
    800019c8:	fffff097          	auipc	ra,0xfffff
    800019cc:	1c2080e7          	jalr	450(ra) # 80000b8a <push_off>
    800019d0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019d2:	2781                	sext.w	a5,a5
    800019d4:	079e                	slli	a5,a5,0x7
    800019d6:	0000f717          	auipc	a4,0xf
    800019da:	1fa70713          	addi	a4,a4,506 # 80010bd0 <pid_lock>
    800019de:	97ba                	add	a5,a5,a4
    800019e0:	7b84                	ld	s1,48(a5)
  pop_off();
    800019e2:	fffff097          	auipc	ra,0xfffff
    800019e6:	248080e7          	jalr	584(ra) # 80000c2a <pop_off>
  return p;
}
    800019ea:	8526                	mv	a0,s1
    800019ec:	60e2                	ld	ra,24(sp)
    800019ee:	6442                	ld	s0,16(sp)
    800019f0:	64a2                	ld	s1,8(sp)
    800019f2:	6105                	addi	sp,sp,32
    800019f4:	8082                	ret

00000000800019f6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019f6:	1141                	addi	sp,sp,-16
    800019f8:	e406                	sd	ra,8(sp)
    800019fa:	e022                	sd	s0,0(sp)
    800019fc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019fe:	00000097          	auipc	ra,0x0
    80001a02:	fc0080e7          	jalr	-64(ra) # 800019be <myproc>
    80001a06:	fffff097          	auipc	ra,0xfffff
    80001a0a:	284080e7          	jalr	644(ra) # 80000c8a <release>

  if (first) {
    80001a0e:	00007797          	auipc	a5,0x7
    80001a12:	eb27a783          	lw	a5,-334(a5) # 800088c0 <first.1>
    80001a16:	eb89                	bnez	a5,80001a28 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a18:	00001097          	auipc	ra,0x1
    80001a1c:	d2c080e7          	jalr	-724(ra) # 80002744 <usertrapret>
}
    80001a20:	60a2                	ld	ra,8(sp)
    80001a22:	6402                	ld	s0,0(sp)
    80001a24:	0141                	addi	sp,sp,16
    80001a26:	8082                	ret
    first = 0;
    80001a28:	00007797          	auipc	a5,0x7
    80001a2c:	e807ac23          	sw	zero,-360(a5) # 800088c0 <first.1>
    fsinit(ROOTDEV);
    80001a30:	4505                	li	a0,1
    80001a32:	00002097          	auipc	ra,0x2
    80001a36:	a8c080e7          	jalr	-1396(ra) # 800034be <fsinit>
    80001a3a:	bff9                	j	80001a18 <forkret+0x22>

0000000080001a3c <allocpid>:
{
    80001a3c:	1101                	addi	sp,sp,-32
    80001a3e:	ec06                	sd	ra,24(sp)
    80001a40:	e822                	sd	s0,16(sp)
    80001a42:	e426                	sd	s1,8(sp)
    80001a44:	e04a                	sd	s2,0(sp)
    80001a46:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a48:	0000f917          	auipc	s2,0xf
    80001a4c:	18890913          	addi	s2,s2,392 # 80010bd0 <pid_lock>
    80001a50:	854a                	mv	a0,s2
    80001a52:	fffff097          	auipc	ra,0xfffff
    80001a56:	184080e7          	jalr	388(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a5a:	00007797          	auipc	a5,0x7
    80001a5e:	e6a78793          	addi	a5,a5,-406 # 800088c4 <nextpid>
    80001a62:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a64:	0014871b          	addiw	a4,s1,1
    80001a68:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a6a:	854a                	mv	a0,s2
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	21e080e7          	jalr	542(ra) # 80000c8a <release>
}
    80001a74:	8526                	mv	a0,s1
    80001a76:	60e2                	ld	ra,24(sp)
    80001a78:	6442                	ld	s0,16(sp)
    80001a7a:	64a2                	ld	s1,8(sp)
    80001a7c:	6902                	ld	s2,0(sp)
    80001a7e:	6105                	addi	sp,sp,32
    80001a80:	8082                	ret

0000000080001a82 <proc_pagetable>:
{
    80001a82:	1101                	addi	sp,sp,-32
    80001a84:	ec06                	sd	ra,24(sp)
    80001a86:	e822                	sd	s0,16(sp)
    80001a88:	e426                	sd	s1,8(sp)
    80001a8a:	e04a                	sd	s2,0(sp)
    80001a8c:	1000                	addi	s0,sp,32
    80001a8e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a90:	00000097          	auipc	ra,0x0
    80001a94:	898080e7          	jalr	-1896(ra) # 80001328 <uvmcreate>
    80001a98:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a9a:	c121                	beqz	a0,80001ada <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a9c:	4729                	li	a4,10
    80001a9e:	00005697          	auipc	a3,0x5
    80001aa2:	56268693          	addi	a3,a3,1378 # 80007000 <_trampoline>
    80001aa6:	6605                	lui	a2,0x1
    80001aa8:	040005b7          	lui	a1,0x4000
    80001aac:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aae:	05b2                	slli	a1,a1,0xc
    80001ab0:	fffff097          	auipc	ra,0xfffff
    80001ab4:	5ee080e7          	jalr	1518(ra) # 8000109e <mappages>
    80001ab8:	02054863          	bltz	a0,80001ae8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001abc:	4719                	li	a4,6
    80001abe:	06093683          	ld	a3,96(s2)
    80001ac2:	6605                	lui	a2,0x1
    80001ac4:	020005b7          	lui	a1,0x2000
    80001ac8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aca:	05b6                	slli	a1,a1,0xd
    80001acc:	8526                	mv	a0,s1
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	5d0080e7          	jalr	1488(ra) # 8000109e <mappages>
    80001ad6:	02054163          	bltz	a0,80001af8 <proc_pagetable+0x76>
}
    80001ada:	8526                	mv	a0,s1
    80001adc:	60e2                	ld	ra,24(sp)
    80001ade:	6442                	ld	s0,16(sp)
    80001ae0:	64a2                	ld	s1,8(sp)
    80001ae2:	6902                	ld	s2,0(sp)
    80001ae4:	6105                	addi	sp,sp,32
    80001ae6:	8082                	ret
    uvmfree(pagetable, 0);
    80001ae8:	4581                	li	a1,0
    80001aea:	8526                	mv	a0,s1
    80001aec:	00000097          	auipc	ra,0x0
    80001af0:	a42080e7          	jalr	-1470(ra) # 8000152e <uvmfree>
    return 0;
    80001af4:	4481                	li	s1,0
    80001af6:	b7d5                	j	80001ada <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001af8:	4681                	li	a3,0
    80001afa:	4605                	li	a2,1
    80001afc:	040005b7          	lui	a1,0x4000
    80001b00:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b02:	05b2                	slli	a1,a1,0xc
    80001b04:	8526                	mv	a0,s1
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	75e080e7          	jalr	1886(ra) # 80001264 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b0e:	4581                	li	a1,0
    80001b10:	8526                	mv	a0,s1
    80001b12:	00000097          	auipc	ra,0x0
    80001b16:	a1c080e7          	jalr	-1508(ra) # 8000152e <uvmfree>
    return 0;
    80001b1a:	4481                	li	s1,0
    80001b1c:	bf7d                	j	80001ada <proc_pagetable+0x58>

0000000080001b1e <proc_freepagetable>:
{
    80001b1e:	1101                	addi	sp,sp,-32
    80001b20:	ec06                	sd	ra,24(sp)
    80001b22:	e822                	sd	s0,16(sp)
    80001b24:	e426                	sd	s1,8(sp)
    80001b26:	e04a                	sd	s2,0(sp)
    80001b28:	1000                	addi	s0,sp,32
    80001b2a:	84aa                	mv	s1,a0
    80001b2c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b2e:	4681                	li	a3,0
    80001b30:	4605                	li	a2,1
    80001b32:	040005b7          	lui	a1,0x4000
    80001b36:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b38:	05b2                	slli	a1,a1,0xc
    80001b3a:	fffff097          	auipc	ra,0xfffff
    80001b3e:	72a080e7          	jalr	1834(ra) # 80001264 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b42:	4681                	li	a3,0
    80001b44:	4605                	li	a2,1
    80001b46:	020005b7          	lui	a1,0x2000
    80001b4a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b4c:	05b6                	slli	a1,a1,0xd
    80001b4e:	8526                	mv	a0,s1
    80001b50:	fffff097          	auipc	ra,0xfffff
    80001b54:	714080e7          	jalr	1812(ra) # 80001264 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b58:	85ca                	mv	a1,s2
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	00000097          	auipc	ra,0x0
    80001b60:	9d2080e7          	jalr	-1582(ra) # 8000152e <uvmfree>
}
    80001b64:	60e2                	ld	ra,24(sp)
    80001b66:	6442                	ld	s0,16(sp)
    80001b68:	64a2                	ld	s1,8(sp)
    80001b6a:	6902                	ld	s2,0(sp)
    80001b6c:	6105                	addi	sp,sp,32
    80001b6e:	8082                	ret

0000000080001b70 <freeproc>:
{
    80001b70:	1101                	addi	sp,sp,-32
    80001b72:	ec06                	sd	ra,24(sp)
    80001b74:	e822                	sd	s0,16(sp)
    80001b76:	e426                	sd	s1,8(sp)
    80001b78:	1000                	addi	s0,sp,32
    80001b7a:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b7c:	7128                	ld	a0,96(a0)
    80001b7e:	c509                	beqz	a0,80001b88 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b80:	fffff097          	auipc	ra,0xfffff
    80001b84:	e68080e7          	jalr	-408(ra) # 800009e8 <kfree>
  p->trapframe = 0;
    80001b88:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001b8c:	6ca8                	ld	a0,88(s1)
    80001b8e:	c511                	beqz	a0,80001b9a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b90:	68ac                	ld	a1,80(s1)
    80001b92:	00000097          	auipc	ra,0x0
    80001b96:	f8c080e7          	jalr	-116(ra) # 80001b1e <proc_freepagetable>
  p->pagetable = 0;
    80001b9a:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001b9e:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001ba2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ba6:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001baa:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001bae:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001bb2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001bb6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001bba:	0004ac23          	sw	zero,24(s1)
  p->times_executed = 0;
    80001bbe:	0204ac23          	sw	zero,56(s1)
  p->priority = 0;
    80001bc2:	0204aa23          	sw	zero,52(s1)
  p->last_executed = 0;
    80001bc6:	0204ae23          	sw	zero,60(s1)
}
    80001bca:	60e2                	ld	ra,24(sp)
    80001bcc:	6442                	ld	s0,16(sp)
    80001bce:	64a2                	ld	s1,8(sp)
    80001bd0:	6105                	addi	sp,sp,32
    80001bd2:	8082                	ret

0000000080001bd4 <allocproc>:
{
    80001bd4:	1101                	addi	sp,sp,-32
    80001bd6:	ec06                	sd	ra,24(sp)
    80001bd8:	e822                	sd	s0,16(sp)
    80001bda:	e426                	sd	s1,8(sp)
    80001bdc:	e04a                	sd	s2,0(sp)
    80001bde:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001be0:	0000f497          	auipc	s1,0xf
    80001be4:	42048493          	addi	s1,s1,1056 # 80011000 <proc>
    80001be8:	00015917          	auipc	s2,0x15
    80001bec:	01890913          	addi	s2,s2,24 # 80016c00 <tickslock>
    acquire(&p->lock);
    80001bf0:	8526                	mv	a0,s1
    80001bf2:	fffff097          	auipc	ra,0xfffff
    80001bf6:	fe4080e7          	jalr	-28(ra) # 80000bd6 <acquire>
    if(p->state == UNUSED) {
    80001bfa:	4c9c                	lw	a5,24(s1)
    80001bfc:	cf81                	beqz	a5,80001c14 <allocproc+0x40>
      release(&p->lock);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	08a080e7          	jalr	138(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c08:	17048493          	addi	s1,s1,368
    80001c0c:	ff2492e3          	bne	s1,s2,80001bf0 <allocproc+0x1c>
  return 0;
    80001c10:	4481                	li	s1,0
    80001c12:	a889                	j	80001c64 <allocproc+0x90>
  p->pid = allocpid();
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	e28080e7          	jalr	-472(ra) # 80001a3c <allocpid>
    80001c1c:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c1e:	4785                	li	a5,1
    80001c20:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c22:	fffff097          	auipc	ra,0xfffff
    80001c26:	ec4080e7          	jalr	-316(ra) # 80000ae6 <kalloc>
    80001c2a:	892a                	mv	s2,a0
    80001c2c:	f0a8                	sd	a0,96(s1)
    80001c2e:	c131                	beqz	a0,80001c72 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001c30:	8526                	mv	a0,s1
    80001c32:	00000097          	auipc	ra,0x0
    80001c36:	e50080e7          	jalr	-432(ra) # 80001a82 <proc_pagetable>
    80001c3a:	892a                	mv	s2,a0
    80001c3c:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001c3e:	c531                	beqz	a0,80001c8a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001c40:	07000613          	li	a2,112
    80001c44:	4581                	li	a1,0
    80001c46:	06848513          	addi	a0,s1,104
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	088080e7          	jalr	136(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001c52:	00000797          	auipc	a5,0x0
    80001c56:	da478793          	addi	a5,a5,-604 # 800019f6 <forkret>
    80001c5a:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c5c:	64bc                	ld	a5,72(s1)
    80001c5e:	6705                	lui	a4,0x1
    80001c60:	97ba                	add	a5,a5,a4
    80001c62:	f8bc                	sd	a5,112(s1)
}
    80001c64:	8526                	mv	a0,s1
    80001c66:	60e2                	ld	ra,24(sp)
    80001c68:	6442                	ld	s0,16(sp)
    80001c6a:	64a2                	ld	s1,8(sp)
    80001c6c:	6902                	ld	s2,0(sp)
    80001c6e:	6105                	addi	sp,sp,32
    80001c70:	8082                	ret
    freeproc(p);
    80001c72:	8526                	mv	a0,s1
    80001c74:	00000097          	auipc	ra,0x0
    80001c78:	efc080e7          	jalr	-260(ra) # 80001b70 <freeproc>
    release(&p->lock);
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	00c080e7          	jalr	12(ra) # 80000c8a <release>
    return 0;
    80001c86:	84ca                	mv	s1,s2
    80001c88:	bff1                	j	80001c64 <allocproc+0x90>
    freeproc(p);
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	00000097          	auipc	ra,0x0
    80001c90:	ee4080e7          	jalr	-284(ra) # 80001b70 <freeproc>
    release(&p->lock);
    80001c94:	8526                	mv	a0,s1
    80001c96:	fffff097          	auipc	ra,0xfffff
    80001c9a:	ff4080e7          	jalr	-12(ra) # 80000c8a <release>
    return 0;
    80001c9e:	84ca                	mv	s1,s2
    80001ca0:	b7d1                	j	80001c64 <allocproc+0x90>

0000000080001ca2 <userinit>:
{
    80001ca2:	1101                	addi	sp,sp,-32
    80001ca4:	ec06                	sd	ra,24(sp)
    80001ca6:	e822                	sd	s0,16(sp)
    80001ca8:	e426                	sd	s1,8(sp)
    80001caa:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cac:	00000097          	auipc	ra,0x0
    80001cb0:	f28080e7          	jalr	-216(ra) # 80001bd4 <allocproc>
    80001cb4:	84aa                	mv	s1,a0
  initproc = p;
    80001cb6:	00007797          	auipc	a5,0x7
    80001cba:	caa7b123          	sd	a0,-862(a5) # 80008958 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001cbe:	03400613          	li	a2,52
    80001cc2:	00007597          	auipc	a1,0x7
    80001cc6:	c0e58593          	addi	a1,a1,-1010 # 800088d0 <initcode>
    80001cca:	6d28                	ld	a0,88(a0)
    80001ccc:	fffff097          	auipc	ra,0xfffff
    80001cd0:	68a080e7          	jalr	1674(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001cd4:	6785                	lui	a5,0x1
    80001cd6:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cd8:	70b8                	ld	a4,96(s1)
    80001cda:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cde:	70b8                	ld	a4,96(s1)
    80001ce0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ce2:	4641                	li	a2,16
    80001ce4:	00006597          	auipc	a1,0x6
    80001ce8:	51c58593          	addi	a1,a1,1308 # 80008200 <digits+0x1c0>
    80001cec:	16048513          	addi	a0,s1,352
    80001cf0:	fffff097          	auipc	ra,0xfffff
    80001cf4:	12c080e7          	jalr	300(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001cf8:	00006517          	auipc	a0,0x6
    80001cfc:	51850513          	addi	a0,a0,1304 # 80008210 <digits+0x1d0>
    80001d00:	00002097          	auipc	ra,0x2
    80001d04:	1e8080e7          	jalr	488(ra) # 80003ee8 <namei>
    80001d08:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001d0c:	478d                	li	a5,3
    80001d0e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d10:	8526                	mv	a0,s1
    80001d12:	fffff097          	auipc	ra,0xfffff
    80001d16:	f78080e7          	jalr	-136(ra) # 80000c8a <release>
}
    80001d1a:	60e2                	ld	ra,24(sp)
    80001d1c:	6442                	ld	s0,16(sp)
    80001d1e:	64a2                	ld	s1,8(sp)
    80001d20:	6105                	addi	sp,sp,32
    80001d22:	8082                	ret

0000000080001d24 <growproc>:
{
    80001d24:	1101                	addi	sp,sp,-32
    80001d26:	ec06                	sd	ra,24(sp)
    80001d28:	e822                	sd	s0,16(sp)
    80001d2a:	e426                	sd	s1,8(sp)
    80001d2c:	e04a                	sd	s2,0(sp)
    80001d2e:	1000                	addi	s0,sp,32
    80001d30:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	c8c080e7          	jalr	-884(ra) # 800019be <myproc>
    80001d3a:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d3c:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001d3e:	01204c63          	bgtz	s2,80001d56 <growproc+0x32>
  } else if(n < 0){
    80001d42:	02094663          	bltz	s2,80001d6e <growproc+0x4a>
  p->sz = sz;
    80001d46:	e8ac                	sd	a1,80(s1)
  return 0;
    80001d48:	4501                	li	a0,0
}
    80001d4a:	60e2                	ld	ra,24(sp)
    80001d4c:	6442                	ld	s0,16(sp)
    80001d4e:	64a2                	ld	s1,8(sp)
    80001d50:	6902                	ld	s2,0(sp)
    80001d52:	6105                	addi	sp,sp,32
    80001d54:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d56:	4691                	li	a3,4
    80001d58:	00b90633          	add	a2,s2,a1
    80001d5c:	6d28                	ld	a0,88(a0)
    80001d5e:	fffff097          	auipc	ra,0xfffff
    80001d62:	6b2080e7          	jalr	1714(ra) # 80001410 <uvmalloc>
    80001d66:	85aa                	mv	a1,a0
    80001d68:	fd79                	bnez	a0,80001d46 <growproc+0x22>
      return -1;
    80001d6a:	557d                	li	a0,-1
    80001d6c:	bff9                	j	80001d4a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d6e:	00b90633          	add	a2,s2,a1
    80001d72:	6d28                	ld	a0,88(a0)
    80001d74:	fffff097          	auipc	ra,0xfffff
    80001d78:	654080e7          	jalr	1620(ra) # 800013c8 <uvmdealloc>
    80001d7c:	85aa                	mv	a1,a0
    80001d7e:	b7e1                	j	80001d46 <growproc+0x22>

0000000080001d80 <fork>:
{
    80001d80:	7139                	addi	sp,sp,-64
    80001d82:	fc06                	sd	ra,56(sp)
    80001d84:	f822                	sd	s0,48(sp)
    80001d86:	f426                	sd	s1,40(sp)
    80001d88:	f04a                	sd	s2,32(sp)
    80001d8a:	ec4e                	sd	s3,24(sp)
    80001d8c:	e852                	sd	s4,16(sp)
    80001d8e:	e456                	sd	s5,8(sp)
    80001d90:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d92:	00000097          	auipc	ra,0x0
    80001d96:	c2c080e7          	jalr	-980(ra) # 800019be <myproc>
    80001d9a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d9c:	00000097          	auipc	ra,0x0
    80001da0:	e38080e7          	jalr	-456(ra) # 80001bd4 <allocproc>
    80001da4:	10050c63          	beqz	a0,80001ebc <fork+0x13c>
    80001da8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001daa:	050ab603          	ld	a2,80(s5)
    80001dae:	6d2c                	ld	a1,88(a0)
    80001db0:	058ab503          	ld	a0,88(s5)
    80001db4:	fffff097          	auipc	ra,0xfffff
    80001db8:	7b4080e7          	jalr	1972(ra) # 80001568 <uvmcopy>
    80001dbc:	04054863          	bltz	a0,80001e0c <fork+0x8c>
  np->sz = p->sz;
    80001dc0:	050ab783          	ld	a5,80(s5)
    80001dc4:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001dc8:	060ab683          	ld	a3,96(s5)
    80001dcc:	87b6                	mv	a5,a3
    80001dce:	060a3703          	ld	a4,96(s4)
    80001dd2:	12068693          	addi	a3,a3,288
    80001dd6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dda:	6788                	ld	a0,8(a5)
    80001ddc:	6b8c                	ld	a1,16(a5)
    80001dde:	6f90                	ld	a2,24(a5)
    80001de0:	01073023          	sd	a6,0(a4)
    80001de4:	e708                	sd	a0,8(a4)
    80001de6:	eb0c                	sd	a1,16(a4)
    80001de8:	ef10                	sd	a2,24(a4)
    80001dea:	02078793          	addi	a5,a5,32
    80001dee:	02070713          	addi	a4,a4,32
    80001df2:	fed792e3          	bne	a5,a3,80001dd6 <fork+0x56>
  np->trapframe->a0 = 0;
    80001df6:	060a3783          	ld	a5,96(s4)
    80001dfa:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001dfe:	0d8a8493          	addi	s1,s5,216
    80001e02:	0d8a0913          	addi	s2,s4,216
    80001e06:	158a8993          	addi	s3,s5,344
    80001e0a:	a00d                	j	80001e2c <fork+0xac>
    freeproc(np);
    80001e0c:	8552                	mv	a0,s4
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	d62080e7          	jalr	-670(ra) # 80001b70 <freeproc>
    release(&np->lock);
    80001e16:	8552                	mv	a0,s4
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	e72080e7          	jalr	-398(ra) # 80000c8a <release>
    return -1;
    80001e20:	597d                	li	s2,-1
    80001e22:	a059                	j	80001ea8 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e24:	04a1                	addi	s1,s1,8
    80001e26:	0921                	addi	s2,s2,8
    80001e28:	01348b63          	beq	s1,s3,80001e3e <fork+0xbe>
    if(p->ofile[i])
    80001e2c:	6088                	ld	a0,0(s1)
    80001e2e:	d97d                	beqz	a0,80001e24 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e30:	00002097          	auipc	ra,0x2
    80001e34:	74e080e7          	jalr	1870(ra) # 8000457e <filedup>
    80001e38:	00a93023          	sd	a0,0(s2)
    80001e3c:	b7e5                	j	80001e24 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e3e:	158ab503          	ld	a0,344(s5)
    80001e42:	00002097          	auipc	ra,0x2
    80001e46:	8bc080e7          	jalr	-1860(ra) # 800036fe <idup>
    80001e4a:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e4e:	4641                	li	a2,16
    80001e50:	160a8593          	addi	a1,s5,352
    80001e54:	160a0513          	addi	a0,s4,352
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	fc4080e7          	jalr	-60(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001e60:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e64:	8552                	mv	a0,s4
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	e24080e7          	jalr	-476(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80001e6e:	0000f497          	auipc	s1,0xf
    80001e72:	d7a48493          	addi	s1,s1,-646 # 80010be8 <wait_lock>
    80001e76:	8526                	mv	a0,s1
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	d5e080e7          	jalr	-674(ra) # 80000bd6 <acquire>
  np->parent = p;
    80001e80:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001e84:	8526                	mv	a0,s1
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	e04080e7          	jalr	-508(ra) # 80000c8a <release>
  acquire(&np->lock);
    80001e8e:	8552                	mv	a0,s4
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	d46080e7          	jalr	-698(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80001e98:	478d                	li	a5,3
    80001e9a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e9e:	8552                	mv	a0,s4
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	dea080e7          	jalr	-534(ra) # 80000c8a <release>
}
    80001ea8:	854a                	mv	a0,s2
    80001eaa:	70e2                	ld	ra,56(sp)
    80001eac:	7442                	ld	s0,48(sp)
    80001eae:	74a2                	ld	s1,40(sp)
    80001eb0:	7902                	ld	s2,32(sp)
    80001eb2:	69e2                	ld	s3,24(sp)
    80001eb4:	6a42                	ld	s4,16(sp)
    80001eb6:	6aa2                	ld	s5,8(sp)
    80001eb8:	6121                	addi	sp,sp,64
    80001eba:	8082                	ret
    return -1;
    80001ebc:	597d                	li	s2,-1
    80001ebe:	b7ed                	j	80001ea8 <fork+0x128>

0000000080001ec0 <scheduler>:
{
    80001ec0:	715d                	addi	sp,sp,-80
    80001ec2:	e486                	sd	ra,72(sp)
    80001ec4:	e0a2                	sd	s0,64(sp)
    80001ec6:	fc26                	sd	s1,56(sp)
    80001ec8:	f84a                	sd	s2,48(sp)
    80001eca:	f44e                	sd	s3,40(sp)
    80001ecc:	f052                	sd	s4,32(sp)
    80001ece:	ec56                	sd	s5,24(sp)
    80001ed0:	e85a                	sd	s6,16(sp)
    80001ed2:	e45e                	sd	s7,8(sp)
    80001ed4:	e062                	sd	s8,0(sp)
    80001ed6:	0880                	addi	s0,sp,80
    80001ed8:	8792                	mv	a5,tp
  int id = r_tp();
    80001eda:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001edc:	00779b93          	slli	s7,a5,0x7
    80001ee0:	0000f717          	auipc	a4,0xf
    80001ee4:	cf070713          	addi	a4,a4,-784 # 80010bd0 <pid_lock>
    80001ee8:	975e                	add	a4,a4,s7
    80001eea:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001eee:	0000f717          	auipc	a4,0xf
    80001ef2:	d1a70713          	addi	a4,a4,-742 # 80010c08 <cpus+0x8>
    80001ef6:	9bba                	add	s7,s7,a4
        c->proc = p;
    80001ef8:	079e                	slli	a5,a5,0x7
    80001efa:	0000fa17          	auipc	s4,0xf
    80001efe:	cd6a0a13          	addi	s4,s4,-810 # 80010bd0 <pid_lock>
    80001f02:	9a3e                	add	s4,s4,a5
        acquire(&tickslock);
    80001f04:	00015a97          	auipc	s5,0x15
    80001f08:	cfca8a93          	addi	s5,s5,-772 # 80016c00 <tickslock>
        p->last_executed = ticks;
    80001f0c:	00007c17          	auipc	s8,0x7
    80001f10:	a54c0c13          	addi	s8,s8,-1452 # 80008960 <ticks>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f14:	00015997          	auipc	s3,0x15
    80001f18:	cec98993          	addi	s3,s3,-788 # 80016c00 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f20:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f24:	10079073          	csrw	sstatus,a5
    80001f28:	0000f497          	auipc	s1,0xf
    80001f2c:	0d848493          	addi	s1,s1,216 # 80011000 <proc>
      if(p->state == RUNNABLE) {
    80001f30:	490d                	li	s2,3
        p->state = RUNNING;
    80001f32:	4b11                	li	s6,4
    80001f34:	a811                	j	80001f48 <scheduler+0x88>
      release(&p->lock);
    80001f36:	8526                	mv	a0,s1
    80001f38:	fffff097          	auipc	ra,0xfffff
    80001f3c:	d52080e7          	jalr	-686(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f40:	17048493          	addi	s1,s1,368
    80001f44:	fd348ce3          	beq	s1,s3,80001f1c <scheduler+0x5c>
      acquire(&p->lock);
    80001f48:	8526                	mv	a0,s1
    80001f4a:	fffff097          	auipc	ra,0xfffff
    80001f4e:	c8c080e7          	jalr	-884(ra) # 80000bd6 <acquire>
      if(p->state == RUNNABLE) {
    80001f52:	4c9c                	lw	a5,24(s1)
    80001f54:	ff2791e3          	bne	a5,s2,80001f36 <scheduler+0x76>
        p->state = RUNNING;
    80001f58:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f5c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f60:	06848593          	addi	a1,s1,104
    80001f64:	855e                	mv	a0,s7
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	734080e7          	jalr	1844(ra) # 8000269a <swtch>
        p->times_executed ++;
    80001f6e:	5c9c                	lw	a5,56(s1)
    80001f70:	2785                	addiw	a5,a5,1
    80001f72:	dc9c                	sw	a5,56(s1)
        acquire(&tickslock);
    80001f74:	8556                	mv	a0,s5
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	c60080e7          	jalr	-928(ra) # 80000bd6 <acquire>
        p->last_executed = ticks;
    80001f7e:	000c2783          	lw	a5,0(s8)
    80001f82:	dcdc                	sw	a5,60(s1)
        release(&tickslock);
    80001f84:	8556                	mv	a0,s5
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	d04080e7          	jalr	-764(ra) # 80000c8a <release>
        c->proc = 0;
    80001f8e:	020a3823          	sd	zero,48(s4)
    80001f92:	b755                	j	80001f36 <scheduler+0x76>

0000000080001f94 <sched>:
{
    80001f94:	7179                	addi	sp,sp,-48
    80001f96:	f406                	sd	ra,40(sp)
    80001f98:	f022                	sd	s0,32(sp)
    80001f9a:	ec26                	sd	s1,24(sp)
    80001f9c:	e84a                	sd	s2,16(sp)
    80001f9e:	e44e                	sd	s3,8(sp)
    80001fa0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fa2:	00000097          	auipc	ra,0x0
    80001fa6:	a1c080e7          	jalr	-1508(ra) # 800019be <myproc>
    80001faa:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	bb0080e7          	jalr	-1104(ra) # 80000b5c <holding>
    80001fb4:	c93d                	beqz	a0,8000202a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fb6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fb8:	2781                	sext.w	a5,a5
    80001fba:	079e                	slli	a5,a5,0x7
    80001fbc:	0000f717          	auipc	a4,0xf
    80001fc0:	c1470713          	addi	a4,a4,-1004 # 80010bd0 <pid_lock>
    80001fc4:	97ba                	add	a5,a5,a4
    80001fc6:	0a87a703          	lw	a4,168(a5)
    80001fca:	4785                	li	a5,1
    80001fcc:	06f71763          	bne	a4,a5,8000203a <sched+0xa6>
  if(p->state == RUNNING)
    80001fd0:	4c98                	lw	a4,24(s1)
    80001fd2:	4791                	li	a5,4
    80001fd4:	06f70b63          	beq	a4,a5,8000204a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fd8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fdc:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001fde:	efb5                	bnez	a5,8000205a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fe0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001fe2:	0000f917          	auipc	s2,0xf
    80001fe6:	bee90913          	addi	s2,s2,-1042 # 80010bd0 <pid_lock>
    80001fea:	2781                	sext.w	a5,a5
    80001fec:	079e                	slli	a5,a5,0x7
    80001fee:	97ca                	add	a5,a5,s2
    80001ff0:	0ac7a983          	lw	s3,172(a5)
    80001ff4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001ff6:	2781                	sext.w	a5,a5
    80001ff8:	079e                	slli	a5,a5,0x7
    80001ffa:	0000f597          	auipc	a1,0xf
    80001ffe:	c0e58593          	addi	a1,a1,-1010 # 80010c08 <cpus+0x8>
    80002002:	95be                	add	a1,a1,a5
    80002004:	06848513          	addi	a0,s1,104
    80002008:	00000097          	auipc	ra,0x0
    8000200c:	692080e7          	jalr	1682(ra) # 8000269a <swtch>
    80002010:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002012:	2781                	sext.w	a5,a5
    80002014:	079e                	slli	a5,a5,0x7
    80002016:	993e                	add	s2,s2,a5
    80002018:	0b392623          	sw	s3,172(s2)
}
    8000201c:	70a2                	ld	ra,40(sp)
    8000201e:	7402                	ld	s0,32(sp)
    80002020:	64e2                	ld	s1,24(sp)
    80002022:	6942                	ld	s2,16(sp)
    80002024:	69a2                	ld	s3,8(sp)
    80002026:	6145                	addi	sp,sp,48
    80002028:	8082                	ret
    panic("sched p->lock");
    8000202a:	00006517          	auipc	a0,0x6
    8000202e:	1ee50513          	addi	a0,a0,494 # 80008218 <digits+0x1d8>
    80002032:	ffffe097          	auipc	ra,0xffffe
    80002036:	50e080e7          	jalr	1294(ra) # 80000540 <panic>
    panic("sched locks");
    8000203a:	00006517          	auipc	a0,0x6
    8000203e:	1ee50513          	addi	a0,a0,494 # 80008228 <digits+0x1e8>
    80002042:	ffffe097          	auipc	ra,0xffffe
    80002046:	4fe080e7          	jalr	1278(ra) # 80000540 <panic>
    panic("sched running");
    8000204a:	00006517          	auipc	a0,0x6
    8000204e:	1ee50513          	addi	a0,a0,494 # 80008238 <digits+0x1f8>
    80002052:	ffffe097          	auipc	ra,0xffffe
    80002056:	4ee080e7          	jalr	1262(ra) # 80000540 <panic>
    panic("sched interruptible");
    8000205a:	00006517          	auipc	a0,0x6
    8000205e:	1ee50513          	addi	a0,a0,494 # 80008248 <digits+0x208>
    80002062:	ffffe097          	auipc	ra,0xffffe
    80002066:	4de080e7          	jalr	1246(ra) # 80000540 <panic>

000000008000206a <yield>:
{
    8000206a:	1101                	addi	sp,sp,-32
    8000206c:	ec06                	sd	ra,24(sp)
    8000206e:	e822                	sd	s0,16(sp)
    80002070:	e426                	sd	s1,8(sp)
    80002072:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002074:	00000097          	auipc	ra,0x0
    80002078:	94a080e7          	jalr	-1718(ra) # 800019be <myproc>
    8000207c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	b58080e7          	jalr	-1192(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    80002086:	478d                	li	a5,3
    80002088:	cc9c                	sw	a5,24(s1)
  if (p->priority != 0)
    8000208a:	58dc                	lw	a5,52(s1)
    8000208c:	c399                	beqz	a5,80002092 <yield+0x28>
    p->priority --;
    8000208e:	37fd                	addiw	a5,a5,-1
    80002090:	d8dc                	sw	a5,52(s1)
  sched();
    80002092:	00000097          	auipc	ra,0x0
    80002096:	f02080e7          	jalr	-254(ra) # 80001f94 <sched>
  release(&p->lock);
    8000209a:	8526                	mv	a0,s1
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	bee080e7          	jalr	-1042(ra) # 80000c8a <release>
}
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800020ae:	7179                	addi	sp,sp,-48
    800020b0:	f406                	sd	ra,40(sp)
    800020b2:	f022                	sd	s0,32(sp)
    800020b4:	ec26                	sd	s1,24(sp)
    800020b6:	e84a                	sd	s2,16(sp)
    800020b8:	e44e                	sd	s3,8(sp)
    800020ba:	1800                	addi	s0,sp,48
    800020bc:	89aa                	mv	s3,a0
    800020be:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	8fe080e7          	jalr	-1794(ra) # 800019be <myproc>
    800020c8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	b0c080e7          	jalr	-1268(ra) # 80000bd6 <acquire>
  release(lk);
    800020d2:	854a                	mv	a0,s2
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	bb6080e7          	jalr	-1098(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    800020dc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800020e0:	4789                	li	a5,2
    800020e2:	cc9c                	sw	a5,24(s1)

  //Aumentar prioridad
  if (p->priority < NPRIO - 1)
    800020e4:	58dc                	lw	a5,52(s1)
    800020e6:	4705                	li	a4,1
    800020e8:	02f75963          	bge	a4,a5,8000211a <sleep+0x6c>
  {
    p->priority ++;
  }

  sched();
    800020ec:	00000097          	auipc	ra,0x0
    800020f0:	ea8080e7          	jalr	-344(ra) # 80001f94 <sched>

  // Tidy up.
  p->chan = 0;
    800020f4:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800020f8:	8526                	mv	a0,s1
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	b90080e7          	jalr	-1136(ra) # 80000c8a <release>
  acquire(lk);
    80002102:	854a                	mv	a0,s2
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	ad2080e7          	jalr	-1326(ra) # 80000bd6 <acquire>
}
    8000210c:	70a2                	ld	ra,40(sp)
    8000210e:	7402                	ld	s0,32(sp)
    80002110:	64e2                	ld	s1,24(sp)
    80002112:	6942                	ld	s2,16(sp)
    80002114:	69a2                	ld	s3,8(sp)
    80002116:	6145                	addi	sp,sp,48
    80002118:	8082                	ret
    p->priority ++;
    8000211a:	2785                	addiw	a5,a5,1
    8000211c:	d8dc                	sw	a5,52(s1)
    8000211e:	b7f9                	j	800020ec <sleep+0x3e>

0000000080002120 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002120:	7139                	addi	sp,sp,-64
    80002122:	fc06                	sd	ra,56(sp)
    80002124:	f822                	sd	s0,48(sp)
    80002126:	f426                	sd	s1,40(sp)
    80002128:	f04a                	sd	s2,32(sp)
    8000212a:	ec4e                	sd	s3,24(sp)
    8000212c:	e852                	sd	s4,16(sp)
    8000212e:	e456                	sd	s5,8(sp)
    80002130:	0080                	addi	s0,sp,64
    80002132:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002134:	0000f497          	auipc	s1,0xf
    80002138:	ecc48493          	addi	s1,s1,-308 # 80011000 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000213c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000213e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002140:	00015917          	auipc	s2,0x15
    80002144:	ac090913          	addi	s2,s2,-1344 # 80016c00 <tickslock>
    80002148:	a811                	j	8000215c <wakeup+0x3c>
      }
      release(&p->lock);
    8000214a:	8526                	mv	a0,s1
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	b3e080e7          	jalr	-1218(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002154:	17048493          	addi	s1,s1,368
    80002158:	03248663          	beq	s1,s2,80002184 <wakeup+0x64>
    if(p != myproc()){
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	862080e7          	jalr	-1950(ra) # 800019be <myproc>
    80002164:	fea488e3          	beq	s1,a0,80002154 <wakeup+0x34>
      acquire(&p->lock);
    80002168:	8526                	mv	a0,s1
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	a6c080e7          	jalr	-1428(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002172:	4c9c                	lw	a5,24(s1)
    80002174:	fd379be3          	bne	a5,s3,8000214a <wakeup+0x2a>
    80002178:	709c                	ld	a5,32(s1)
    8000217a:	fd4798e3          	bne	a5,s4,8000214a <wakeup+0x2a>
        p->state = RUNNABLE;
    8000217e:	0154ac23          	sw	s5,24(s1)
    80002182:	b7e1                	j	8000214a <wakeup+0x2a>
    }
  }
}
    80002184:	70e2                	ld	ra,56(sp)
    80002186:	7442                	ld	s0,48(sp)
    80002188:	74a2                	ld	s1,40(sp)
    8000218a:	7902                	ld	s2,32(sp)
    8000218c:	69e2                	ld	s3,24(sp)
    8000218e:	6a42                	ld	s4,16(sp)
    80002190:	6aa2                	ld	s5,8(sp)
    80002192:	6121                	addi	sp,sp,64
    80002194:	8082                	ret

0000000080002196 <reparent>:
{
    80002196:	7179                	addi	sp,sp,-48
    80002198:	f406                	sd	ra,40(sp)
    8000219a:	f022                	sd	s0,32(sp)
    8000219c:	ec26                	sd	s1,24(sp)
    8000219e:	e84a                	sd	s2,16(sp)
    800021a0:	e44e                	sd	s3,8(sp)
    800021a2:	e052                	sd	s4,0(sp)
    800021a4:	1800                	addi	s0,sp,48
    800021a6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021a8:	0000f497          	auipc	s1,0xf
    800021ac:	e5848493          	addi	s1,s1,-424 # 80011000 <proc>
      pp->parent = initproc;
    800021b0:	00006a17          	auipc	s4,0x6
    800021b4:	7a8a0a13          	addi	s4,s4,1960 # 80008958 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021b8:	00015997          	auipc	s3,0x15
    800021bc:	a4898993          	addi	s3,s3,-1464 # 80016c00 <tickslock>
    800021c0:	a029                	j	800021ca <reparent+0x34>
    800021c2:	17048493          	addi	s1,s1,368
    800021c6:	01348d63          	beq	s1,s3,800021e0 <reparent+0x4a>
    if(pp->parent == p){
    800021ca:	60bc                	ld	a5,64(s1)
    800021cc:	ff279be3          	bne	a5,s2,800021c2 <reparent+0x2c>
      pp->parent = initproc;
    800021d0:	000a3503          	ld	a0,0(s4)
    800021d4:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800021d6:	00000097          	auipc	ra,0x0
    800021da:	f4a080e7          	jalr	-182(ra) # 80002120 <wakeup>
    800021de:	b7d5                	j	800021c2 <reparent+0x2c>
}
    800021e0:	70a2                	ld	ra,40(sp)
    800021e2:	7402                	ld	s0,32(sp)
    800021e4:	64e2                	ld	s1,24(sp)
    800021e6:	6942                	ld	s2,16(sp)
    800021e8:	69a2                	ld	s3,8(sp)
    800021ea:	6a02                	ld	s4,0(sp)
    800021ec:	6145                	addi	sp,sp,48
    800021ee:	8082                	ret

00000000800021f0 <exit>:
{
    800021f0:	7179                	addi	sp,sp,-48
    800021f2:	f406                	sd	ra,40(sp)
    800021f4:	f022                	sd	s0,32(sp)
    800021f6:	ec26                	sd	s1,24(sp)
    800021f8:	e84a                	sd	s2,16(sp)
    800021fa:	e44e                	sd	s3,8(sp)
    800021fc:	e052                	sd	s4,0(sp)
    800021fe:	1800                	addi	s0,sp,48
    80002200:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	7bc080e7          	jalr	1980(ra) # 800019be <myproc>
    8000220a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000220c:	00006797          	auipc	a5,0x6
    80002210:	74c7b783          	ld	a5,1868(a5) # 80008958 <initproc>
    80002214:	0d850493          	addi	s1,a0,216
    80002218:	15850913          	addi	s2,a0,344
    8000221c:	02a79363          	bne	a5,a0,80002242 <exit+0x52>
    panic("init exiting");
    80002220:	00006517          	auipc	a0,0x6
    80002224:	04050513          	addi	a0,a0,64 # 80008260 <digits+0x220>
    80002228:	ffffe097          	auipc	ra,0xffffe
    8000222c:	318080e7          	jalr	792(ra) # 80000540 <panic>
      fileclose(f);
    80002230:	00002097          	auipc	ra,0x2
    80002234:	3a0080e7          	jalr	928(ra) # 800045d0 <fileclose>
      p->ofile[fd] = 0;
    80002238:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000223c:	04a1                	addi	s1,s1,8
    8000223e:	01248563          	beq	s1,s2,80002248 <exit+0x58>
    if(p->ofile[fd]){
    80002242:	6088                	ld	a0,0(s1)
    80002244:	f575                	bnez	a0,80002230 <exit+0x40>
    80002246:	bfdd                	j	8000223c <exit+0x4c>
  begin_op();
    80002248:	00002097          	auipc	ra,0x2
    8000224c:	ec0080e7          	jalr	-320(ra) # 80004108 <begin_op>
  iput(p->cwd);
    80002250:	1589b503          	ld	a0,344(s3)
    80002254:	00001097          	auipc	ra,0x1
    80002258:	6a2080e7          	jalr	1698(ra) # 800038f6 <iput>
  end_op();
    8000225c:	00002097          	auipc	ra,0x2
    80002260:	f2a080e7          	jalr	-214(ra) # 80004186 <end_op>
  p->cwd = 0;
    80002264:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80002268:	0000f497          	auipc	s1,0xf
    8000226c:	98048493          	addi	s1,s1,-1664 # 80010be8 <wait_lock>
    80002270:	8526                	mv	a0,s1
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	964080e7          	jalr	-1692(ra) # 80000bd6 <acquire>
  reparent(p);
    8000227a:	854e                	mv	a0,s3
    8000227c:	00000097          	auipc	ra,0x0
    80002280:	f1a080e7          	jalr	-230(ra) # 80002196 <reparent>
  wakeup(p->parent);
    80002284:	0409b503          	ld	a0,64(s3)
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	e98080e7          	jalr	-360(ra) # 80002120 <wakeup>
  acquire(&p->lock);
    80002290:	854e                	mv	a0,s3
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	944080e7          	jalr	-1724(ra) # 80000bd6 <acquire>
  p->xstate = status;
    8000229a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000229e:	4795                	li	a5,5
    800022a0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800022a4:	8526                	mv	a0,s1
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	9e4080e7          	jalr	-1564(ra) # 80000c8a <release>
  sched();
    800022ae:	00000097          	auipc	ra,0x0
    800022b2:	ce6080e7          	jalr	-794(ra) # 80001f94 <sched>
  panic("zombie exit");
    800022b6:	00006517          	auipc	a0,0x6
    800022ba:	fba50513          	addi	a0,a0,-70 # 80008270 <digits+0x230>
    800022be:	ffffe097          	auipc	ra,0xffffe
    800022c2:	282080e7          	jalr	642(ra) # 80000540 <panic>

00000000800022c6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800022c6:	7179                	addi	sp,sp,-48
    800022c8:	f406                	sd	ra,40(sp)
    800022ca:	f022                	sd	s0,32(sp)
    800022cc:	ec26                	sd	s1,24(sp)
    800022ce:	e84a                	sd	s2,16(sp)
    800022d0:	e44e                	sd	s3,8(sp)
    800022d2:	1800                	addi	s0,sp,48
    800022d4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800022d6:	0000f497          	auipc	s1,0xf
    800022da:	d2a48493          	addi	s1,s1,-726 # 80011000 <proc>
    800022de:	00015997          	auipc	s3,0x15
    800022e2:	92298993          	addi	s3,s3,-1758 # 80016c00 <tickslock>
    acquire(&p->lock);
    800022e6:	8526                	mv	a0,s1
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	8ee080e7          	jalr	-1810(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    800022f0:	589c                	lw	a5,48(s1)
    800022f2:	01278d63          	beq	a5,s2,8000230c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800022f6:	8526                	mv	a0,s1
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	992080e7          	jalr	-1646(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002300:	17048493          	addi	s1,s1,368
    80002304:	ff3491e3          	bne	s1,s3,800022e6 <kill+0x20>
  }
  return -1;
    80002308:	557d                	li	a0,-1
    8000230a:	a829                	j	80002324 <kill+0x5e>
      p->killed = 1;
    8000230c:	4785                	li	a5,1
    8000230e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002310:	4c98                	lw	a4,24(s1)
    80002312:	4789                	li	a5,2
    80002314:	00f70f63          	beq	a4,a5,80002332 <kill+0x6c>
      release(&p->lock);
    80002318:	8526                	mv	a0,s1
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	970080e7          	jalr	-1680(ra) # 80000c8a <release>
      return 0;
    80002322:	4501                	li	a0,0
}
    80002324:	70a2                	ld	ra,40(sp)
    80002326:	7402                	ld	s0,32(sp)
    80002328:	64e2                	ld	s1,24(sp)
    8000232a:	6942                	ld	s2,16(sp)
    8000232c:	69a2                	ld	s3,8(sp)
    8000232e:	6145                	addi	sp,sp,48
    80002330:	8082                	ret
        p->state = RUNNABLE;
    80002332:	478d                	li	a5,3
    80002334:	cc9c                	sw	a5,24(s1)
    80002336:	b7cd                	j	80002318 <kill+0x52>

0000000080002338 <setkilled>:

void
setkilled(struct proc *p)
{
    80002338:	1101                	addi	sp,sp,-32
    8000233a:	ec06                	sd	ra,24(sp)
    8000233c:	e822                	sd	s0,16(sp)
    8000233e:	e426                	sd	s1,8(sp)
    80002340:	1000                	addi	s0,sp,32
    80002342:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	892080e7          	jalr	-1902(ra) # 80000bd6 <acquire>
  p->killed = 1;
    8000234c:	4785                	li	a5,1
    8000234e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002350:	8526                	mv	a0,s1
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	938080e7          	jalr	-1736(ra) # 80000c8a <release>
}
    8000235a:	60e2                	ld	ra,24(sp)
    8000235c:	6442                	ld	s0,16(sp)
    8000235e:	64a2                	ld	s1,8(sp)
    80002360:	6105                	addi	sp,sp,32
    80002362:	8082                	ret

0000000080002364 <killed>:

int
killed(struct proc *p)
{
    80002364:	1101                	addi	sp,sp,-32
    80002366:	ec06                	sd	ra,24(sp)
    80002368:	e822                	sd	s0,16(sp)
    8000236a:	e426                	sd	s1,8(sp)
    8000236c:	e04a                	sd	s2,0(sp)
    8000236e:	1000                	addi	s0,sp,32
    80002370:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002372:	fffff097          	auipc	ra,0xfffff
    80002376:	864080e7          	jalr	-1948(ra) # 80000bd6 <acquire>
  k = p->killed;
    8000237a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000237e:	8526                	mv	a0,s1
    80002380:	fffff097          	auipc	ra,0xfffff
    80002384:	90a080e7          	jalr	-1782(ra) # 80000c8a <release>
  return k;
}
    80002388:	854a                	mv	a0,s2
    8000238a:	60e2                	ld	ra,24(sp)
    8000238c:	6442                	ld	s0,16(sp)
    8000238e:	64a2                	ld	s1,8(sp)
    80002390:	6902                	ld	s2,0(sp)
    80002392:	6105                	addi	sp,sp,32
    80002394:	8082                	ret

0000000080002396 <wait>:
{
    80002396:	715d                	addi	sp,sp,-80
    80002398:	e486                	sd	ra,72(sp)
    8000239a:	e0a2                	sd	s0,64(sp)
    8000239c:	fc26                	sd	s1,56(sp)
    8000239e:	f84a                	sd	s2,48(sp)
    800023a0:	f44e                	sd	s3,40(sp)
    800023a2:	f052                	sd	s4,32(sp)
    800023a4:	ec56                	sd	s5,24(sp)
    800023a6:	e85a                	sd	s6,16(sp)
    800023a8:	e45e                	sd	s7,8(sp)
    800023aa:	e062                	sd	s8,0(sp)
    800023ac:	0880                	addi	s0,sp,80
    800023ae:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800023b0:	fffff097          	auipc	ra,0xfffff
    800023b4:	60e080e7          	jalr	1550(ra) # 800019be <myproc>
    800023b8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800023ba:	0000f517          	auipc	a0,0xf
    800023be:	82e50513          	addi	a0,a0,-2002 # 80010be8 <wait_lock>
    800023c2:	fffff097          	auipc	ra,0xfffff
    800023c6:	814080e7          	jalr	-2028(ra) # 80000bd6 <acquire>
    havekids = 0;
    800023ca:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800023cc:	4a15                	li	s4,5
        havekids = 1;
    800023ce:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023d0:	00015997          	auipc	s3,0x15
    800023d4:	83098993          	addi	s3,s3,-2000 # 80016c00 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800023d8:	0000fc17          	auipc	s8,0xf
    800023dc:	810c0c13          	addi	s8,s8,-2032 # 80010be8 <wait_lock>
    havekids = 0;
    800023e0:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023e2:	0000f497          	auipc	s1,0xf
    800023e6:	c1e48493          	addi	s1,s1,-994 # 80011000 <proc>
    800023ea:	a0bd                	j	80002458 <wait+0xc2>
          pid = pp->pid;
    800023ec:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800023f0:	000b0e63          	beqz	s6,8000240c <wait+0x76>
    800023f4:	4691                	li	a3,4
    800023f6:	02c48613          	addi	a2,s1,44
    800023fa:	85da                	mv	a1,s6
    800023fc:	05893503          	ld	a0,88(s2)
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	26c080e7          	jalr	620(ra) # 8000166c <copyout>
    80002408:	02054563          	bltz	a0,80002432 <wait+0x9c>
          freeproc(pp);
    8000240c:	8526                	mv	a0,s1
    8000240e:	fffff097          	auipc	ra,0xfffff
    80002412:	762080e7          	jalr	1890(ra) # 80001b70 <freeproc>
          release(&pp->lock);
    80002416:	8526                	mv	a0,s1
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	872080e7          	jalr	-1934(ra) # 80000c8a <release>
          release(&wait_lock);
    80002420:	0000e517          	auipc	a0,0xe
    80002424:	7c850513          	addi	a0,a0,1992 # 80010be8 <wait_lock>
    80002428:	fffff097          	auipc	ra,0xfffff
    8000242c:	862080e7          	jalr	-1950(ra) # 80000c8a <release>
          return pid;
    80002430:	a0b5                	j	8000249c <wait+0x106>
            release(&pp->lock);
    80002432:	8526                	mv	a0,s1
    80002434:	fffff097          	auipc	ra,0xfffff
    80002438:	856080e7          	jalr	-1962(ra) # 80000c8a <release>
            release(&wait_lock);
    8000243c:	0000e517          	auipc	a0,0xe
    80002440:	7ac50513          	addi	a0,a0,1964 # 80010be8 <wait_lock>
    80002444:	fffff097          	auipc	ra,0xfffff
    80002448:	846080e7          	jalr	-1978(ra) # 80000c8a <release>
            return -1;
    8000244c:	59fd                	li	s3,-1
    8000244e:	a0b9                	j	8000249c <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002450:	17048493          	addi	s1,s1,368
    80002454:	03348463          	beq	s1,s3,8000247c <wait+0xe6>
      if(pp->parent == p){
    80002458:	60bc                	ld	a5,64(s1)
    8000245a:	ff279be3          	bne	a5,s2,80002450 <wait+0xba>
        acquire(&pp->lock);
    8000245e:	8526                	mv	a0,s1
    80002460:	ffffe097          	auipc	ra,0xffffe
    80002464:	776080e7          	jalr	1910(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    80002468:	4c9c                	lw	a5,24(s1)
    8000246a:	f94781e3          	beq	a5,s4,800023ec <wait+0x56>
        release(&pp->lock);
    8000246e:	8526                	mv	a0,s1
    80002470:	fffff097          	auipc	ra,0xfffff
    80002474:	81a080e7          	jalr	-2022(ra) # 80000c8a <release>
        havekids = 1;
    80002478:	8756                	mv	a4,s5
    8000247a:	bfd9                	j	80002450 <wait+0xba>
    if(!havekids || killed(p)){
    8000247c:	c719                	beqz	a4,8000248a <wait+0xf4>
    8000247e:	854a                	mv	a0,s2
    80002480:	00000097          	auipc	ra,0x0
    80002484:	ee4080e7          	jalr	-284(ra) # 80002364 <killed>
    80002488:	c51d                	beqz	a0,800024b6 <wait+0x120>
      release(&wait_lock);
    8000248a:	0000e517          	auipc	a0,0xe
    8000248e:	75e50513          	addi	a0,a0,1886 # 80010be8 <wait_lock>
    80002492:	ffffe097          	auipc	ra,0xffffe
    80002496:	7f8080e7          	jalr	2040(ra) # 80000c8a <release>
      return -1;
    8000249a:	59fd                	li	s3,-1
}
    8000249c:	854e                	mv	a0,s3
    8000249e:	60a6                	ld	ra,72(sp)
    800024a0:	6406                	ld	s0,64(sp)
    800024a2:	74e2                	ld	s1,56(sp)
    800024a4:	7942                	ld	s2,48(sp)
    800024a6:	79a2                	ld	s3,40(sp)
    800024a8:	7a02                	ld	s4,32(sp)
    800024aa:	6ae2                	ld	s5,24(sp)
    800024ac:	6b42                	ld	s6,16(sp)
    800024ae:	6ba2                	ld	s7,8(sp)
    800024b0:	6c02                	ld	s8,0(sp)
    800024b2:	6161                	addi	sp,sp,80
    800024b4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800024b6:	85e2                	mv	a1,s8
    800024b8:	854a                	mv	a0,s2
    800024ba:	00000097          	auipc	ra,0x0
    800024be:	bf4080e7          	jalr	-1036(ra) # 800020ae <sleep>
    havekids = 0;
    800024c2:	bf39                	j	800023e0 <wait+0x4a>

00000000800024c4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024c4:	7179                	addi	sp,sp,-48
    800024c6:	f406                	sd	ra,40(sp)
    800024c8:	f022                	sd	s0,32(sp)
    800024ca:	ec26                	sd	s1,24(sp)
    800024cc:	e84a                	sd	s2,16(sp)
    800024ce:	e44e                	sd	s3,8(sp)
    800024d0:	e052                	sd	s4,0(sp)
    800024d2:	1800                	addi	s0,sp,48
    800024d4:	84aa                	mv	s1,a0
    800024d6:	892e                	mv	s2,a1
    800024d8:	89b2                	mv	s3,a2
    800024da:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024dc:	fffff097          	auipc	ra,0xfffff
    800024e0:	4e2080e7          	jalr	1250(ra) # 800019be <myproc>
  if(user_dst){
    800024e4:	c08d                	beqz	s1,80002506 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024e6:	86d2                	mv	a3,s4
    800024e8:	864e                	mv	a2,s3
    800024ea:	85ca                	mv	a1,s2
    800024ec:	6d28                	ld	a0,88(a0)
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	17e080e7          	jalr	382(ra) # 8000166c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024f6:	70a2                	ld	ra,40(sp)
    800024f8:	7402                	ld	s0,32(sp)
    800024fa:	64e2                	ld	s1,24(sp)
    800024fc:	6942                	ld	s2,16(sp)
    800024fe:	69a2                	ld	s3,8(sp)
    80002500:	6a02                	ld	s4,0(sp)
    80002502:	6145                	addi	sp,sp,48
    80002504:	8082                	ret
    memmove((char *)dst, src, len);
    80002506:	000a061b          	sext.w	a2,s4
    8000250a:	85ce                	mv	a1,s3
    8000250c:	854a                	mv	a0,s2
    8000250e:	fffff097          	auipc	ra,0xfffff
    80002512:	820080e7          	jalr	-2016(ra) # 80000d2e <memmove>
    return 0;
    80002516:	8526                	mv	a0,s1
    80002518:	bff9                	j	800024f6 <either_copyout+0x32>

000000008000251a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000251a:	7179                	addi	sp,sp,-48
    8000251c:	f406                	sd	ra,40(sp)
    8000251e:	f022                	sd	s0,32(sp)
    80002520:	ec26                	sd	s1,24(sp)
    80002522:	e84a                	sd	s2,16(sp)
    80002524:	e44e                	sd	s3,8(sp)
    80002526:	e052                	sd	s4,0(sp)
    80002528:	1800                	addi	s0,sp,48
    8000252a:	892a                	mv	s2,a0
    8000252c:	84ae                	mv	s1,a1
    8000252e:	89b2                	mv	s3,a2
    80002530:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002532:	fffff097          	auipc	ra,0xfffff
    80002536:	48c080e7          	jalr	1164(ra) # 800019be <myproc>
  if(user_src){
    8000253a:	c08d                	beqz	s1,8000255c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000253c:	86d2                	mv	a3,s4
    8000253e:	864e                	mv	a2,s3
    80002540:	85ca                	mv	a1,s2
    80002542:	6d28                	ld	a0,88(a0)
    80002544:	fffff097          	auipc	ra,0xfffff
    80002548:	1b4080e7          	jalr	436(ra) # 800016f8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000254c:	70a2                	ld	ra,40(sp)
    8000254e:	7402                	ld	s0,32(sp)
    80002550:	64e2                	ld	s1,24(sp)
    80002552:	6942                	ld	s2,16(sp)
    80002554:	69a2                	ld	s3,8(sp)
    80002556:	6a02                	ld	s4,0(sp)
    80002558:	6145                	addi	sp,sp,48
    8000255a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000255c:	000a061b          	sext.w	a2,s4
    80002560:	85ce                	mv	a1,s3
    80002562:	854a                	mv	a0,s2
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	7ca080e7          	jalr	1994(ra) # 80000d2e <memmove>
    return 0;
    8000256c:	8526                	mv	a0,s1
    8000256e:	bff9                	j	8000254c <either_copyin+0x32>

0000000080002570 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002570:	715d                	addi	sp,sp,-80
    80002572:	e486                	sd	ra,72(sp)
    80002574:	e0a2                	sd	s0,64(sp)
    80002576:	fc26                	sd	s1,56(sp)
    80002578:	f84a                	sd	s2,48(sp)
    8000257a:	f44e                	sd	s3,40(sp)
    8000257c:	f052                	sd	s4,32(sp)
    8000257e:	ec56                	sd	s5,24(sp)
    80002580:	e85a                	sd	s6,16(sp)
    80002582:	e45e                	sd	s7,8(sp)
    80002584:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002586:	00006517          	auipc	a0,0x6
    8000258a:	b4250513          	addi	a0,a0,-1214 # 800080c8 <digits+0x88>
    8000258e:	ffffe097          	auipc	ra,0xffffe
    80002592:	ffc080e7          	jalr	-4(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002596:	0000f497          	auipc	s1,0xf
    8000259a:	bca48493          	addi	s1,s1,-1078 # 80011160 <proc+0x160>
    8000259e:	00014917          	auipc	s2,0x14
    800025a2:	7c290913          	addi	s2,s2,1986 # 80016d60 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025a6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800025a8:	00006997          	auipc	s3,0x6
    800025ac:	cd898993          	addi	s3,s3,-808 # 80008280 <digits+0x240>
    printf("%d %s %s Priority : 0, Times executed : %d, Last time executed : %d", p->pid, state, p->name,p->times_executed,p->last_executed);
    800025b0:	00006a97          	auipc	s5,0x6
    800025b4:	cd8a8a93          	addi	s5,s5,-808 # 80008288 <digits+0x248>
    printf("\n");
    800025b8:	00006a17          	auipc	s4,0x6
    800025bc:	b10a0a13          	addi	s4,s4,-1264 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025c0:	00006b97          	auipc	s7,0x6
    800025c4:	d80b8b93          	addi	s7,s7,-640 # 80008340 <states.0>
    800025c8:	a02d                	j	800025f2 <procdump+0x82>
    printf("%d %s %s Priority : 0, Times executed : %d, Last time executed : %d", p->pid, state, p->name,p->times_executed,p->last_executed);
    800025ca:	edc6a783          	lw	a5,-292(a3)
    800025ce:	ed86a703          	lw	a4,-296(a3)
    800025d2:	ed06a583          	lw	a1,-304(a3)
    800025d6:	8556                	mv	a0,s5
    800025d8:	ffffe097          	auipc	ra,0xffffe
    800025dc:	fb2080e7          	jalr	-78(ra) # 8000058a <printf>
    printf("\n");
    800025e0:	8552                	mv	a0,s4
    800025e2:	ffffe097          	auipc	ra,0xffffe
    800025e6:	fa8080e7          	jalr	-88(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025ea:	17048493          	addi	s1,s1,368
    800025ee:	03248263          	beq	s1,s2,80002612 <procdump+0xa2>
    if(p->state == UNUSED)
    800025f2:	86a6                	mv	a3,s1
    800025f4:	eb84a783          	lw	a5,-328(s1)
    800025f8:	dbed                	beqz	a5,800025ea <procdump+0x7a>
      state = "???";
    800025fa:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025fc:	fcfb67e3          	bltu	s6,a5,800025ca <procdump+0x5a>
    80002600:	02079713          	slli	a4,a5,0x20
    80002604:	01d75793          	srli	a5,a4,0x1d
    80002608:	97de                	add	a5,a5,s7
    8000260a:	6390                	ld	a2,0(a5)
    8000260c:	fe5d                	bnez	a2,800025ca <procdump+0x5a>
      state = "???";
    8000260e:	864e                	mv	a2,s3
    80002610:	bf6d                	j	800025ca <procdump+0x5a>
  }
}
    80002612:	60a6                	ld	ra,72(sp)
    80002614:	6406                	ld	s0,64(sp)
    80002616:	74e2                	ld	s1,56(sp)
    80002618:	7942                	ld	s2,48(sp)
    8000261a:	79a2                	ld	s3,40(sp)
    8000261c:	7a02                	ld	s4,32(sp)
    8000261e:	6ae2                	ld	s5,24(sp)
    80002620:	6b42                	ld	s6,16(sp)
    80002622:	6ba2                	ld	s7,8(sp)
    80002624:	6161                	addi	sp,sp,80
    80002626:	8082                	ret

0000000080002628 <pstat>:

//Implementacion pstat 
int pstat(int pid) {
    80002628:	7179                	addi	sp,sp,-48
    8000262a:	f406                	sd	ra,40(sp)
    8000262c:	f022                	sd	s0,32(sp)
    8000262e:	ec26                	sd	s1,24(sp)
    80002630:	e84a                	sd	s2,16(sp)
    80002632:	e44e                	sd	s3,8(sp)
    80002634:	1800                	addi	s0,sp,48
    80002636:	892a                	mv	s2,a0
    struct proc *p;
    for(p = proc; p < &proc[NPROC]; p++) {
    80002638:	0000f497          	auipc	s1,0xf
    8000263c:	9c848493          	addi	s1,s1,-1592 # 80011000 <proc>
    80002640:	00014997          	auipc	s3,0x14
    80002644:	5c098993          	addi	s3,s3,1472 # 80016c00 <tickslock>
      acquire(&p->lock);
    80002648:	8526                	mv	a0,s1
    8000264a:	ffffe097          	auipc	ra,0xffffe
    8000264e:	58c080e7          	jalr	1420(ra) # 80000bd6 <acquire>
      if(p->pid == pid) {
    80002652:	589c                	lw	a5,48(s1)
    80002654:	01278c63          	beq	a5,s2,8000266c <pstat+0x44>
        printf("Priority : 0, Times executed : %d, Last time executed : %d", p->times_executed,p->last_executed);
        release(&p->lock);
        break;
      }
      release(&p->lock);
    80002658:	8526                	mv	a0,s1
    8000265a:	ffffe097          	auipc	ra,0xffffe
    8000265e:	630080e7          	jalr	1584(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002662:	17048493          	addi	s1,s1,368
    80002666:	ff3491e3          	bne	s1,s3,80002648 <pstat+0x20>
    8000266a:	a005                	j	8000268a <pstat+0x62>
        printf("Priority : 0, Times executed : %d, Last time executed : %d", p->times_executed,p->last_executed);
    8000266c:	5cd0                	lw	a2,60(s1)
    8000266e:	5c8c                	lw	a1,56(s1)
    80002670:	00006517          	auipc	a0,0x6
    80002674:	c6050513          	addi	a0,a0,-928 # 800082d0 <digits+0x290>
    80002678:	ffffe097          	auipc	ra,0xffffe
    8000267c:	f12080e7          	jalr	-238(ra) # 8000058a <printf>
        release(&p->lock);
    80002680:	8526                	mv	a0,s1
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	608080e7          	jalr	1544(ra) # 80000c8a <release>
    }
    return 0;
}
    8000268a:	4501                	li	a0,0
    8000268c:	70a2                	ld	ra,40(sp)
    8000268e:	7402                	ld	s0,32(sp)
    80002690:	64e2                	ld	s1,24(sp)
    80002692:	6942                	ld	s2,16(sp)
    80002694:	69a2                	ld	s3,8(sp)
    80002696:	6145                	addi	sp,sp,48
    80002698:	8082                	ret

000000008000269a <swtch>:
    8000269a:	00153023          	sd	ra,0(a0)
    8000269e:	00253423          	sd	sp,8(a0)
    800026a2:	e900                	sd	s0,16(a0)
    800026a4:	ed04                	sd	s1,24(a0)
    800026a6:	03253023          	sd	s2,32(a0)
    800026aa:	03353423          	sd	s3,40(a0)
    800026ae:	03453823          	sd	s4,48(a0)
    800026b2:	03553c23          	sd	s5,56(a0)
    800026b6:	05653023          	sd	s6,64(a0)
    800026ba:	05753423          	sd	s7,72(a0)
    800026be:	05853823          	sd	s8,80(a0)
    800026c2:	05953c23          	sd	s9,88(a0)
    800026c6:	07a53023          	sd	s10,96(a0)
    800026ca:	07b53423          	sd	s11,104(a0)
    800026ce:	0005b083          	ld	ra,0(a1)
    800026d2:	0085b103          	ld	sp,8(a1)
    800026d6:	6980                	ld	s0,16(a1)
    800026d8:	6d84                	ld	s1,24(a1)
    800026da:	0205b903          	ld	s2,32(a1)
    800026de:	0285b983          	ld	s3,40(a1)
    800026e2:	0305ba03          	ld	s4,48(a1)
    800026e6:	0385ba83          	ld	s5,56(a1)
    800026ea:	0405bb03          	ld	s6,64(a1)
    800026ee:	0485bb83          	ld	s7,72(a1)
    800026f2:	0505bc03          	ld	s8,80(a1)
    800026f6:	0585bc83          	ld	s9,88(a1)
    800026fa:	0605bd03          	ld	s10,96(a1)
    800026fe:	0685bd83          	ld	s11,104(a1)
    80002702:	8082                	ret

0000000080002704 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002704:	1141                	addi	sp,sp,-16
    80002706:	e406                	sd	ra,8(sp)
    80002708:	e022                	sd	s0,0(sp)
    8000270a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000270c:	00006597          	auipc	a1,0x6
    80002710:	c6458593          	addi	a1,a1,-924 # 80008370 <states.0+0x30>
    80002714:	00014517          	auipc	a0,0x14
    80002718:	4ec50513          	addi	a0,a0,1260 # 80016c00 <tickslock>
    8000271c:	ffffe097          	auipc	ra,0xffffe
    80002720:	42a080e7          	jalr	1066(ra) # 80000b46 <initlock>
}
    80002724:	60a2                	ld	ra,8(sp)
    80002726:	6402                	ld	s0,0(sp)
    80002728:	0141                	addi	sp,sp,16
    8000272a:	8082                	ret

000000008000272c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000272c:	1141                	addi	sp,sp,-16
    8000272e:	e422                	sd	s0,8(sp)
    80002730:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002732:	00003797          	auipc	a5,0x3
    80002736:	4ee78793          	addi	a5,a5,1262 # 80005c20 <kernelvec>
    8000273a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000273e:	6422                	ld	s0,8(sp)
    80002740:	0141                	addi	sp,sp,16
    80002742:	8082                	ret

0000000080002744 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002744:	1141                	addi	sp,sp,-16
    80002746:	e406                	sd	ra,8(sp)
    80002748:	e022                	sd	s0,0(sp)
    8000274a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000274c:	fffff097          	auipc	ra,0xfffff
    80002750:	272080e7          	jalr	626(ra) # 800019be <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002754:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002758:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000275a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000275e:	00005697          	auipc	a3,0x5
    80002762:	8a268693          	addi	a3,a3,-1886 # 80007000 <_trampoline>
    80002766:	00005717          	auipc	a4,0x5
    8000276a:	89a70713          	addi	a4,a4,-1894 # 80007000 <_trampoline>
    8000276e:	8f15                	sub	a4,a4,a3
    80002770:	040007b7          	lui	a5,0x4000
    80002774:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002776:	07b2                	slli	a5,a5,0xc
    80002778:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000277a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000277e:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002780:	18002673          	csrr	a2,satp
    80002784:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002786:	7130                	ld	a2,96(a0)
    80002788:	6538                	ld	a4,72(a0)
    8000278a:	6585                	lui	a1,0x1
    8000278c:	972e                	add	a4,a4,a1
    8000278e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002790:	7138                	ld	a4,96(a0)
    80002792:	00000617          	auipc	a2,0x0
    80002796:	13060613          	addi	a2,a2,304 # 800028c2 <usertrap>
    8000279a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000279c:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000279e:	8612                	mv	a2,tp
    800027a0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027a2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800027a6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800027aa:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027ae:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800027b2:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800027b4:	6f18                	ld	a4,24(a4)
    800027b6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800027ba:	6d28                	ld	a0,88(a0)
    800027bc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800027be:	00005717          	auipc	a4,0x5
    800027c2:	8de70713          	addi	a4,a4,-1826 # 8000709c <userret>
    800027c6:	8f15                	sub	a4,a4,a3
    800027c8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800027ca:	577d                	li	a4,-1
    800027cc:	177e                	slli	a4,a4,0x3f
    800027ce:	8d59                	or	a0,a0,a4
    800027d0:	9782                	jalr	a5
}
    800027d2:	60a2                	ld	ra,8(sp)
    800027d4:	6402                	ld	s0,0(sp)
    800027d6:	0141                	addi	sp,sp,16
    800027d8:	8082                	ret

00000000800027da <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027da:	1101                	addi	sp,sp,-32
    800027dc:	ec06                	sd	ra,24(sp)
    800027de:	e822                	sd	s0,16(sp)
    800027e0:	e426                	sd	s1,8(sp)
    800027e2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027e4:	00014497          	auipc	s1,0x14
    800027e8:	41c48493          	addi	s1,s1,1052 # 80016c00 <tickslock>
    800027ec:	8526                	mv	a0,s1
    800027ee:	ffffe097          	auipc	ra,0xffffe
    800027f2:	3e8080e7          	jalr	1000(ra) # 80000bd6 <acquire>
  ticks++;
    800027f6:	00006517          	auipc	a0,0x6
    800027fa:	16a50513          	addi	a0,a0,362 # 80008960 <ticks>
    800027fe:	411c                	lw	a5,0(a0)
    80002800:	2785                	addiw	a5,a5,1
    80002802:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002804:	00000097          	auipc	ra,0x0
    80002808:	91c080e7          	jalr	-1764(ra) # 80002120 <wakeup>
  release(&tickslock);
    8000280c:	8526                	mv	a0,s1
    8000280e:	ffffe097          	auipc	ra,0xffffe
    80002812:	47c080e7          	jalr	1148(ra) # 80000c8a <release>
}
    80002816:	60e2                	ld	ra,24(sp)
    80002818:	6442                	ld	s0,16(sp)
    8000281a:	64a2                	ld	s1,8(sp)
    8000281c:	6105                	addi	sp,sp,32
    8000281e:	8082                	ret

0000000080002820 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002820:	1101                	addi	sp,sp,-32
    80002822:	ec06                	sd	ra,24(sp)
    80002824:	e822                	sd	s0,16(sp)
    80002826:	e426                	sd	s1,8(sp)
    80002828:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000282a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000282e:	00074d63          	bltz	a4,80002848 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002832:	57fd                	li	a5,-1
    80002834:	17fe                	slli	a5,a5,0x3f
    80002836:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002838:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000283a:	06f70363          	beq	a4,a5,800028a0 <devintr+0x80>
  }
}
    8000283e:	60e2                	ld	ra,24(sp)
    80002840:	6442                	ld	s0,16(sp)
    80002842:	64a2                	ld	s1,8(sp)
    80002844:	6105                	addi	sp,sp,32
    80002846:	8082                	ret
     (scause & 0xff) == 9){
    80002848:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    8000284c:	46a5                	li	a3,9
    8000284e:	fed792e3          	bne	a5,a3,80002832 <devintr+0x12>
    int irq = plic_claim();
    80002852:	00003097          	auipc	ra,0x3
    80002856:	4d6080e7          	jalr	1238(ra) # 80005d28 <plic_claim>
    8000285a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000285c:	47a9                	li	a5,10
    8000285e:	02f50763          	beq	a0,a5,8000288c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002862:	4785                	li	a5,1
    80002864:	02f50963          	beq	a0,a5,80002896 <devintr+0x76>
    return 1;
    80002868:	4505                	li	a0,1
    } else if(irq){
    8000286a:	d8f1                	beqz	s1,8000283e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000286c:	85a6                	mv	a1,s1
    8000286e:	00006517          	auipc	a0,0x6
    80002872:	b0a50513          	addi	a0,a0,-1270 # 80008378 <states.0+0x38>
    80002876:	ffffe097          	auipc	ra,0xffffe
    8000287a:	d14080e7          	jalr	-748(ra) # 8000058a <printf>
      plic_complete(irq);
    8000287e:	8526                	mv	a0,s1
    80002880:	00003097          	auipc	ra,0x3
    80002884:	4cc080e7          	jalr	1228(ra) # 80005d4c <plic_complete>
    return 1;
    80002888:	4505                	li	a0,1
    8000288a:	bf55                	j	8000283e <devintr+0x1e>
      uartintr();
    8000288c:	ffffe097          	auipc	ra,0xffffe
    80002890:	10c080e7          	jalr	268(ra) # 80000998 <uartintr>
    80002894:	b7ed                	j	8000287e <devintr+0x5e>
      virtio_disk_intr();
    80002896:	00004097          	auipc	ra,0x4
    8000289a:	97e080e7          	jalr	-1666(ra) # 80006214 <virtio_disk_intr>
    8000289e:	b7c5                	j	8000287e <devintr+0x5e>
    if(cpuid() == 0){
    800028a0:	fffff097          	auipc	ra,0xfffff
    800028a4:	0f2080e7          	jalr	242(ra) # 80001992 <cpuid>
    800028a8:	c901                	beqz	a0,800028b8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800028aa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800028ae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800028b0:	14479073          	csrw	sip,a5
    return 2;
    800028b4:	4509                	li	a0,2
    800028b6:	b761                	j	8000283e <devintr+0x1e>
      clockintr();
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	f22080e7          	jalr	-222(ra) # 800027da <clockintr>
    800028c0:	b7ed                	j	800028aa <devintr+0x8a>

00000000800028c2 <usertrap>:
{
    800028c2:	1101                	addi	sp,sp,-32
    800028c4:	ec06                	sd	ra,24(sp)
    800028c6:	e822                	sd	s0,16(sp)
    800028c8:	e426                	sd	s1,8(sp)
    800028ca:	e04a                	sd	s2,0(sp)
    800028cc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ce:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800028d2:	1007f793          	andi	a5,a5,256
    800028d6:	e3b1                	bnez	a5,8000291a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028d8:	00003797          	auipc	a5,0x3
    800028dc:	34878793          	addi	a5,a5,840 # 80005c20 <kernelvec>
    800028e0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028e4:	fffff097          	auipc	ra,0xfffff
    800028e8:	0da080e7          	jalr	218(ra) # 800019be <myproc>
    800028ec:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028ee:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028f0:	14102773          	csrr	a4,sepc
    800028f4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028f6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028fa:	47a1                	li	a5,8
    800028fc:	02f70763          	beq	a4,a5,8000292a <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002900:	00000097          	auipc	ra,0x0
    80002904:	f20080e7          	jalr	-224(ra) # 80002820 <devintr>
    80002908:	892a                	mv	s2,a0
    8000290a:	c151                	beqz	a0,8000298e <usertrap+0xcc>
  if(killed(p))
    8000290c:	8526                	mv	a0,s1
    8000290e:	00000097          	auipc	ra,0x0
    80002912:	a56080e7          	jalr	-1450(ra) # 80002364 <killed>
    80002916:	c929                	beqz	a0,80002968 <usertrap+0xa6>
    80002918:	a099                	j	8000295e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    8000291a:	00006517          	auipc	a0,0x6
    8000291e:	a7e50513          	addi	a0,a0,-1410 # 80008398 <states.0+0x58>
    80002922:	ffffe097          	auipc	ra,0xffffe
    80002926:	c1e080e7          	jalr	-994(ra) # 80000540 <panic>
    if(killed(p))
    8000292a:	00000097          	auipc	ra,0x0
    8000292e:	a3a080e7          	jalr	-1478(ra) # 80002364 <killed>
    80002932:	e921                	bnez	a0,80002982 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002934:	70b8                	ld	a4,96(s1)
    80002936:	6f1c                	ld	a5,24(a4)
    80002938:	0791                	addi	a5,a5,4
    8000293a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000293c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002940:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002944:	10079073          	csrw	sstatus,a5
    syscall();
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	2d4080e7          	jalr	724(ra) # 80002c1c <syscall>
  if(killed(p))
    80002950:	8526                	mv	a0,s1
    80002952:	00000097          	auipc	ra,0x0
    80002956:	a12080e7          	jalr	-1518(ra) # 80002364 <killed>
    8000295a:	c911                	beqz	a0,8000296e <usertrap+0xac>
    8000295c:	4901                	li	s2,0
    exit(-1);
    8000295e:	557d                	li	a0,-1
    80002960:	00000097          	auipc	ra,0x0
    80002964:	890080e7          	jalr	-1904(ra) # 800021f0 <exit>
  if(which_dev == 2)
    80002968:	4789                	li	a5,2
    8000296a:	04f90f63          	beq	s2,a5,800029c8 <usertrap+0x106>
  usertrapret();
    8000296e:	00000097          	auipc	ra,0x0
    80002972:	dd6080e7          	jalr	-554(ra) # 80002744 <usertrapret>
}
    80002976:	60e2                	ld	ra,24(sp)
    80002978:	6442                	ld	s0,16(sp)
    8000297a:	64a2                	ld	s1,8(sp)
    8000297c:	6902                	ld	s2,0(sp)
    8000297e:	6105                	addi	sp,sp,32
    80002980:	8082                	ret
      exit(-1);
    80002982:	557d                	li	a0,-1
    80002984:	00000097          	auipc	ra,0x0
    80002988:	86c080e7          	jalr	-1940(ra) # 800021f0 <exit>
    8000298c:	b765                	j	80002934 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000298e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002992:	5890                	lw	a2,48(s1)
    80002994:	00006517          	auipc	a0,0x6
    80002998:	a2450513          	addi	a0,a0,-1500 # 800083b8 <states.0+0x78>
    8000299c:	ffffe097          	auipc	ra,0xffffe
    800029a0:	bee080e7          	jalr	-1042(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029a4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029a8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029ac:	00006517          	auipc	a0,0x6
    800029b0:	a3c50513          	addi	a0,a0,-1476 # 800083e8 <states.0+0xa8>
    800029b4:	ffffe097          	auipc	ra,0xffffe
    800029b8:	bd6080e7          	jalr	-1066(ra) # 8000058a <printf>
    setkilled(p);
    800029bc:	8526                	mv	a0,s1
    800029be:	00000097          	auipc	ra,0x0
    800029c2:	97a080e7          	jalr	-1670(ra) # 80002338 <setkilled>
    800029c6:	b769                	j	80002950 <usertrap+0x8e>
    yield();
    800029c8:	fffff097          	auipc	ra,0xfffff
    800029cc:	6a2080e7          	jalr	1698(ra) # 8000206a <yield>
    800029d0:	bf79                	j	8000296e <usertrap+0xac>

00000000800029d2 <kerneltrap>:
{
    800029d2:	7179                	addi	sp,sp,-48
    800029d4:	f406                	sd	ra,40(sp)
    800029d6:	f022                	sd	s0,32(sp)
    800029d8:	ec26                	sd	s1,24(sp)
    800029da:	e84a                	sd	s2,16(sp)
    800029dc:	e44e                	sd	s3,8(sp)
    800029de:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029e0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029e4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029e8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029ec:	1004f793          	andi	a5,s1,256
    800029f0:	cb85                	beqz	a5,80002a20 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029f2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029f6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029f8:	ef85                	bnez	a5,80002a30 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029fa:	00000097          	auipc	ra,0x0
    800029fe:	e26080e7          	jalr	-474(ra) # 80002820 <devintr>
    80002a02:	cd1d                	beqz	a0,80002a40 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a04:	4789                	li	a5,2
    80002a06:	06f50a63          	beq	a0,a5,80002a7a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a0a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a0e:	10049073          	csrw	sstatus,s1
}
    80002a12:	70a2                	ld	ra,40(sp)
    80002a14:	7402                	ld	s0,32(sp)
    80002a16:	64e2                	ld	s1,24(sp)
    80002a18:	6942                	ld	s2,16(sp)
    80002a1a:	69a2                	ld	s3,8(sp)
    80002a1c:	6145                	addi	sp,sp,48
    80002a1e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a20:	00006517          	auipc	a0,0x6
    80002a24:	9e850513          	addi	a0,a0,-1560 # 80008408 <states.0+0xc8>
    80002a28:	ffffe097          	auipc	ra,0xffffe
    80002a2c:	b18080e7          	jalr	-1256(ra) # 80000540 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a30:	00006517          	auipc	a0,0x6
    80002a34:	a0050513          	addi	a0,a0,-1536 # 80008430 <states.0+0xf0>
    80002a38:	ffffe097          	auipc	ra,0xffffe
    80002a3c:	b08080e7          	jalr	-1272(ra) # 80000540 <panic>
    printf("scause %p\n", scause);
    80002a40:	85ce                	mv	a1,s3
    80002a42:	00006517          	auipc	a0,0x6
    80002a46:	a0e50513          	addi	a0,a0,-1522 # 80008450 <states.0+0x110>
    80002a4a:	ffffe097          	auipc	ra,0xffffe
    80002a4e:	b40080e7          	jalr	-1216(ra) # 8000058a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a52:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a56:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a5a:	00006517          	auipc	a0,0x6
    80002a5e:	a0650513          	addi	a0,a0,-1530 # 80008460 <states.0+0x120>
    80002a62:	ffffe097          	auipc	ra,0xffffe
    80002a66:	b28080e7          	jalr	-1240(ra) # 8000058a <printf>
    panic("kerneltrap");
    80002a6a:	00006517          	auipc	a0,0x6
    80002a6e:	a0e50513          	addi	a0,a0,-1522 # 80008478 <states.0+0x138>
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	ace080e7          	jalr	-1330(ra) # 80000540 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a7a:	fffff097          	auipc	ra,0xfffff
    80002a7e:	f44080e7          	jalr	-188(ra) # 800019be <myproc>
    80002a82:	d541                	beqz	a0,80002a0a <kerneltrap+0x38>
    80002a84:	fffff097          	auipc	ra,0xfffff
    80002a88:	f3a080e7          	jalr	-198(ra) # 800019be <myproc>
    80002a8c:	4d18                	lw	a4,24(a0)
    80002a8e:	4791                	li	a5,4
    80002a90:	f6f71de3          	bne	a4,a5,80002a0a <kerneltrap+0x38>
    yield();
    80002a94:	fffff097          	auipc	ra,0xfffff
    80002a98:	5d6080e7          	jalr	1494(ra) # 8000206a <yield>
    80002a9c:	b7bd                	j	80002a0a <kerneltrap+0x38>

0000000080002a9e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a9e:	1101                	addi	sp,sp,-32
    80002aa0:	ec06                	sd	ra,24(sp)
    80002aa2:	e822                	sd	s0,16(sp)
    80002aa4:	e426                	sd	s1,8(sp)
    80002aa6:	1000                	addi	s0,sp,32
    80002aa8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002aaa:	fffff097          	auipc	ra,0xfffff
    80002aae:	f14080e7          	jalr	-236(ra) # 800019be <myproc>
  switch (n) {
    80002ab2:	4795                	li	a5,5
    80002ab4:	0497e163          	bltu	a5,s1,80002af6 <argraw+0x58>
    80002ab8:	048a                	slli	s1,s1,0x2
    80002aba:	00006717          	auipc	a4,0x6
    80002abe:	9f670713          	addi	a4,a4,-1546 # 800084b0 <states.0+0x170>
    80002ac2:	94ba                	add	s1,s1,a4
    80002ac4:	409c                	lw	a5,0(s1)
    80002ac6:	97ba                	add	a5,a5,a4
    80002ac8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002aca:	713c                	ld	a5,96(a0)
    80002acc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ace:	60e2                	ld	ra,24(sp)
    80002ad0:	6442                	ld	s0,16(sp)
    80002ad2:	64a2                	ld	s1,8(sp)
    80002ad4:	6105                	addi	sp,sp,32
    80002ad6:	8082                	ret
    return p->trapframe->a1;
    80002ad8:	713c                	ld	a5,96(a0)
    80002ada:	7fa8                	ld	a0,120(a5)
    80002adc:	bfcd                	j	80002ace <argraw+0x30>
    return p->trapframe->a2;
    80002ade:	713c                	ld	a5,96(a0)
    80002ae0:	63c8                	ld	a0,128(a5)
    80002ae2:	b7f5                	j	80002ace <argraw+0x30>
    return p->trapframe->a3;
    80002ae4:	713c                	ld	a5,96(a0)
    80002ae6:	67c8                	ld	a0,136(a5)
    80002ae8:	b7dd                	j	80002ace <argraw+0x30>
    return p->trapframe->a4;
    80002aea:	713c                	ld	a5,96(a0)
    80002aec:	6bc8                	ld	a0,144(a5)
    80002aee:	b7c5                	j	80002ace <argraw+0x30>
    return p->trapframe->a5;
    80002af0:	713c                	ld	a5,96(a0)
    80002af2:	6fc8                	ld	a0,152(a5)
    80002af4:	bfe9                	j	80002ace <argraw+0x30>
  panic("argraw");
    80002af6:	00006517          	auipc	a0,0x6
    80002afa:	99250513          	addi	a0,a0,-1646 # 80008488 <states.0+0x148>
    80002afe:	ffffe097          	auipc	ra,0xffffe
    80002b02:	a42080e7          	jalr	-1470(ra) # 80000540 <panic>

0000000080002b06 <fetchaddr>:
{
    80002b06:	1101                	addi	sp,sp,-32
    80002b08:	ec06                	sd	ra,24(sp)
    80002b0a:	e822                	sd	s0,16(sp)
    80002b0c:	e426                	sd	s1,8(sp)
    80002b0e:	e04a                	sd	s2,0(sp)
    80002b10:	1000                	addi	s0,sp,32
    80002b12:	84aa                	mv	s1,a0
    80002b14:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b16:	fffff097          	auipc	ra,0xfffff
    80002b1a:	ea8080e7          	jalr	-344(ra) # 800019be <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b1e:	693c                	ld	a5,80(a0)
    80002b20:	02f4f863          	bgeu	s1,a5,80002b50 <fetchaddr+0x4a>
    80002b24:	00848713          	addi	a4,s1,8
    80002b28:	02e7e663          	bltu	a5,a4,80002b54 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b2c:	46a1                	li	a3,8
    80002b2e:	8626                	mv	a2,s1
    80002b30:	85ca                	mv	a1,s2
    80002b32:	6d28                	ld	a0,88(a0)
    80002b34:	fffff097          	auipc	ra,0xfffff
    80002b38:	bc4080e7          	jalr	-1084(ra) # 800016f8 <copyin>
    80002b3c:	00a03533          	snez	a0,a0
    80002b40:	40a00533          	neg	a0,a0
}
    80002b44:	60e2                	ld	ra,24(sp)
    80002b46:	6442                	ld	s0,16(sp)
    80002b48:	64a2                	ld	s1,8(sp)
    80002b4a:	6902                	ld	s2,0(sp)
    80002b4c:	6105                	addi	sp,sp,32
    80002b4e:	8082                	ret
    return -1;
    80002b50:	557d                	li	a0,-1
    80002b52:	bfcd                	j	80002b44 <fetchaddr+0x3e>
    80002b54:	557d                	li	a0,-1
    80002b56:	b7fd                	j	80002b44 <fetchaddr+0x3e>

0000000080002b58 <fetchstr>:
{
    80002b58:	7179                	addi	sp,sp,-48
    80002b5a:	f406                	sd	ra,40(sp)
    80002b5c:	f022                	sd	s0,32(sp)
    80002b5e:	ec26                	sd	s1,24(sp)
    80002b60:	e84a                	sd	s2,16(sp)
    80002b62:	e44e                	sd	s3,8(sp)
    80002b64:	1800                	addi	s0,sp,48
    80002b66:	892a                	mv	s2,a0
    80002b68:	84ae                	mv	s1,a1
    80002b6a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b6c:	fffff097          	auipc	ra,0xfffff
    80002b70:	e52080e7          	jalr	-430(ra) # 800019be <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002b74:	86ce                	mv	a3,s3
    80002b76:	864a                	mv	a2,s2
    80002b78:	85a6                	mv	a1,s1
    80002b7a:	6d28                	ld	a0,88(a0)
    80002b7c:	fffff097          	auipc	ra,0xfffff
    80002b80:	c0a080e7          	jalr	-1014(ra) # 80001786 <copyinstr>
    80002b84:	00054e63          	bltz	a0,80002ba0 <fetchstr+0x48>
  return strlen(buf);
    80002b88:	8526                	mv	a0,s1
    80002b8a:	ffffe097          	auipc	ra,0xffffe
    80002b8e:	2c4080e7          	jalr	708(ra) # 80000e4e <strlen>
}
    80002b92:	70a2                	ld	ra,40(sp)
    80002b94:	7402                	ld	s0,32(sp)
    80002b96:	64e2                	ld	s1,24(sp)
    80002b98:	6942                	ld	s2,16(sp)
    80002b9a:	69a2                	ld	s3,8(sp)
    80002b9c:	6145                	addi	sp,sp,48
    80002b9e:	8082                	ret
    return -1;
    80002ba0:	557d                	li	a0,-1
    80002ba2:	bfc5                	j	80002b92 <fetchstr+0x3a>

0000000080002ba4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ba4:	1101                	addi	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	e426                	sd	s1,8(sp)
    80002bac:	1000                	addi	s0,sp,32
    80002bae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bb0:	00000097          	auipc	ra,0x0
    80002bb4:	eee080e7          	jalr	-274(ra) # 80002a9e <argraw>
    80002bb8:	c088                	sw	a0,0(s1)
}
    80002bba:	60e2                	ld	ra,24(sp)
    80002bbc:	6442                	ld	s0,16(sp)
    80002bbe:	64a2                	ld	s1,8(sp)
    80002bc0:	6105                	addi	sp,sp,32
    80002bc2:	8082                	ret

0000000080002bc4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002bc4:	1101                	addi	sp,sp,-32
    80002bc6:	ec06                	sd	ra,24(sp)
    80002bc8:	e822                	sd	s0,16(sp)
    80002bca:	e426                	sd	s1,8(sp)
    80002bcc:	1000                	addi	s0,sp,32
    80002bce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	ece080e7          	jalr	-306(ra) # 80002a9e <argraw>
    80002bd8:	e088                	sd	a0,0(s1)
}
    80002bda:	60e2                	ld	ra,24(sp)
    80002bdc:	6442                	ld	s0,16(sp)
    80002bde:	64a2                	ld	s1,8(sp)
    80002be0:	6105                	addi	sp,sp,32
    80002be2:	8082                	ret

0000000080002be4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002be4:	7179                	addi	sp,sp,-48
    80002be6:	f406                	sd	ra,40(sp)
    80002be8:	f022                	sd	s0,32(sp)
    80002bea:	ec26                	sd	s1,24(sp)
    80002bec:	e84a                	sd	s2,16(sp)
    80002bee:	1800                	addi	s0,sp,48
    80002bf0:	84ae                	mv	s1,a1
    80002bf2:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002bf4:	fd840593          	addi	a1,s0,-40
    80002bf8:	00000097          	auipc	ra,0x0
    80002bfc:	fcc080e7          	jalr	-52(ra) # 80002bc4 <argaddr>
  return fetchstr(addr, buf, max);
    80002c00:	864a                	mv	a2,s2
    80002c02:	85a6                	mv	a1,s1
    80002c04:	fd843503          	ld	a0,-40(s0)
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	f50080e7          	jalr	-176(ra) # 80002b58 <fetchstr>
}
    80002c10:	70a2                	ld	ra,40(sp)
    80002c12:	7402                	ld	s0,32(sp)
    80002c14:	64e2                	ld	s1,24(sp)
    80002c16:	6942                	ld	s2,16(sp)
    80002c18:	6145                	addi	sp,sp,48
    80002c1a:	8082                	ret

0000000080002c1c <syscall>:
[SYS_pstat]   sys_pstat,
};

void
syscall(void)
{
    80002c1c:	1101                	addi	sp,sp,-32
    80002c1e:	ec06                	sd	ra,24(sp)
    80002c20:	e822                	sd	s0,16(sp)
    80002c22:	e426                	sd	s1,8(sp)
    80002c24:	e04a                	sd	s2,0(sp)
    80002c26:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c28:	fffff097          	auipc	ra,0xfffff
    80002c2c:	d96080e7          	jalr	-618(ra) # 800019be <myproc>
    80002c30:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c32:	06053903          	ld	s2,96(a0)
    80002c36:	0a893783          	ld	a5,168(s2)
    80002c3a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c3e:	37fd                	addiw	a5,a5,-1
    80002c40:	4755                	li	a4,21
    80002c42:	00f76f63          	bltu	a4,a5,80002c60 <syscall+0x44>
    80002c46:	00369713          	slli	a4,a3,0x3
    80002c4a:	00006797          	auipc	a5,0x6
    80002c4e:	87e78793          	addi	a5,a5,-1922 # 800084c8 <syscalls>
    80002c52:	97ba                	add	a5,a5,a4
    80002c54:	639c                	ld	a5,0(a5)
    80002c56:	c789                	beqz	a5,80002c60 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c58:	9782                	jalr	a5
    80002c5a:	06a93823          	sd	a0,112(s2)
    80002c5e:	a839                	j	80002c7c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c60:	16048613          	addi	a2,s1,352
    80002c64:	588c                	lw	a1,48(s1)
    80002c66:	00006517          	auipc	a0,0x6
    80002c6a:	82a50513          	addi	a0,a0,-2006 # 80008490 <states.0+0x150>
    80002c6e:	ffffe097          	auipc	ra,0xffffe
    80002c72:	91c080e7          	jalr	-1764(ra) # 8000058a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c76:	70bc                	ld	a5,96(s1)
    80002c78:	577d                	li	a4,-1
    80002c7a:	fbb8                	sd	a4,112(a5)
  }
}
    80002c7c:	60e2                	ld	ra,24(sp)
    80002c7e:	6442                	ld	s0,16(sp)
    80002c80:	64a2                	ld	s1,8(sp)
    80002c82:	6902                	ld	s2,0(sp)
    80002c84:	6105                	addi	sp,sp,32
    80002c86:	8082                	ret

0000000080002c88 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c88:	1101                	addi	sp,sp,-32
    80002c8a:	ec06                	sd	ra,24(sp)
    80002c8c:	e822                	sd	s0,16(sp)
    80002c8e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002c90:	fec40593          	addi	a1,s0,-20
    80002c94:	4501                	li	a0,0
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	f0e080e7          	jalr	-242(ra) # 80002ba4 <argint>
  exit(n);
    80002c9e:	fec42503          	lw	a0,-20(s0)
    80002ca2:	fffff097          	auipc	ra,0xfffff
    80002ca6:	54e080e7          	jalr	1358(ra) # 800021f0 <exit>
  return 0;  // not reached
}
    80002caa:	4501                	li	a0,0
    80002cac:	60e2                	ld	ra,24(sp)
    80002cae:	6442                	ld	s0,16(sp)
    80002cb0:	6105                	addi	sp,sp,32
    80002cb2:	8082                	ret

0000000080002cb4 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002cb4:	1141                	addi	sp,sp,-16
    80002cb6:	e406                	sd	ra,8(sp)
    80002cb8:	e022                	sd	s0,0(sp)
    80002cba:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	d02080e7          	jalr	-766(ra) # 800019be <myproc>
}
    80002cc4:	5908                	lw	a0,48(a0)
    80002cc6:	60a2                	ld	ra,8(sp)
    80002cc8:	6402                	ld	s0,0(sp)
    80002cca:	0141                	addi	sp,sp,16
    80002ccc:	8082                	ret

0000000080002cce <sys_fork>:

uint64
sys_fork(void)
{
    80002cce:	1141                	addi	sp,sp,-16
    80002cd0:	e406                	sd	ra,8(sp)
    80002cd2:	e022                	sd	s0,0(sp)
    80002cd4:	0800                	addi	s0,sp,16
  return fork();
    80002cd6:	fffff097          	auipc	ra,0xfffff
    80002cda:	0aa080e7          	jalr	170(ra) # 80001d80 <fork>
}
    80002cde:	60a2                	ld	ra,8(sp)
    80002ce0:	6402                	ld	s0,0(sp)
    80002ce2:	0141                	addi	sp,sp,16
    80002ce4:	8082                	ret

0000000080002ce6 <sys_wait>:

uint64
sys_wait(void)
{
    80002ce6:	1101                	addi	sp,sp,-32
    80002ce8:	ec06                	sd	ra,24(sp)
    80002cea:	e822                	sd	s0,16(sp)
    80002cec:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002cee:	fe840593          	addi	a1,s0,-24
    80002cf2:	4501                	li	a0,0
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	ed0080e7          	jalr	-304(ra) # 80002bc4 <argaddr>
  return wait(p);
    80002cfc:	fe843503          	ld	a0,-24(s0)
    80002d00:	fffff097          	auipc	ra,0xfffff
    80002d04:	696080e7          	jalr	1686(ra) # 80002396 <wait>
}
    80002d08:	60e2                	ld	ra,24(sp)
    80002d0a:	6442                	ld	s0,16(sp)
    80002d0c:	6105                	addi	sp,sp,32
    80002d0e:	8082                	ret

0000000080002d10 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d10:	7179                	addi	sp,sp,-48
    80002d12:	f406                	sd	ra,40(sp)
    80002d14:	f022                	sd	s0,32(sp)
    80002d16:	ec26                	sd	s1,24(sp)
    80002d18:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d1a:	fdc40593          	addi	a1,s0,-36
    80002d1e:	4501                	li	a0,0
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	e84080e7          	jalr	-380(ra) # 80002ba4 <argint>
  addr = myproc()->sz;
    80002d28:	fffff097          	auipc	ra,0xfffff
    80002d2c:	c96080e7          	jalr	-874(ra) # 800019be <myproc>
    80002d30:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    80002d32:	fdc42503          	lw	a0,-36(s0)
    80002d36:	fffff097          	auipc	ra,0xfffff
    80002d3a:	fee080e7          	jalr	-18(ra) # 80001d24 <growproc>
    80002d3e:	00054863          	bltz	a0,80002d4e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002d42:	8526                	mv	a0,s1
    80002d44:	70a2                	ld	ra,40(sp)
    80002d46:	7402                	ld	s0,32(sp)
    80002d48:	64e2                	ld	s1,24(sp)
    80002d4a:	6145                	addi	sp,sp,48
    80002d4c:	8082                	ret
    return -1;
    80002d4e:	54fd                	li	s1,-1
    80002d50:	bfcd                	j	80002d42 <sys_sbrk+0x32>

0000000080002d52 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d52:	7139                	addi	sp,sp,-64
    80002d54:	fc06                	sd	ra,56(sp)
    80002d56:	f822                	sd	s0,48(sp)
    80002d58:	f426                	sd	s1,40(sp)
    80002d5a:	f04a                	sd	s2,32(sp)
    80002d5c:	ec4e                	sd	s3,24(sp)
    80002d5e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d60:	fcc40593          	addi	a1,s0,-52
    80002d64:	4501                	li	a0,0
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	e3e080e7          	jalr	-450(ra) # 80002ba4 <argint>
  acquire(&tickslock);
    80002d6e:	00014517          	auipc	a0,0x14
    80002d72:	e9250513          	addi	a0,a0,-366 # 80016c00 <tickslock>
    80002d76:	ffffe097          	auipc	ra,0xffffe
    80002d7a:	e60080e7          	jalr	-416(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    80002d7e:	00006917          	auipc	s2,0x6
    80002d82:	be292903          	lw	s2,-1054(s2) # 80008960 <ticks>
  while(ticks - ticks0 < n){
    80002d86:	fcc42783          	lw	a5,-52(s0)
    80002d8a:	cf9d                	beqz	a5,80002dc8 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d8c:	00014997          	auipc	s3,0x14
    80002d90:	e7498993          	addi	s3,s3,-396 # 80016c00 <tickslock>
    80002d94:	00006497          	auipc	s1,0x6
    80002d98:	bcc48493          	addi	s1,s1,-1076 # 80008960 <ticks>
    if(killed(myproc())){
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	c22080e7          	jalr	-990(ra) # 800019be <myproc>
    80002da4:	fffff097          	auipc	ra,0xfffff
    80002da8:	5c0080e7          	jalr	1472(ra) # 80002364 <killed>
    80002dac:	ed15                	bnez	a0,80002de8 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002dae:	85ce                	mv	a1,s3
    80002db0:	8526                	mv	a0,s1
    80002db2:	fffff097          	auipc	ra,0xfffff
    80002db6:	2fc080e7          	jalr	764(ra) # 800020ae <sleep>
  while(ticks - ticks0 < n){
    80002dba:	409c                	lw	a5,0(s1)
    80002dbc:	412787bb          	subw	a5,a5,s2
    80002dc0:	fcc42703          	lw	a4,-52(s0)
    80002dc4:	fce7ece3          	bltu	a5,a4,80002d9c <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002dc8:	00014517          	auipc	a0,0x14
    80002dcc:	e3850513          	addi	a0,a0,-456 # 80016c00 <tickslock>
    80002dd0:	ffffe097          	auipc	ra,0xffffe
    80002dd4:	eba080e7          	jalr	-326(ra) # 80000c8a <release>
  return 0;
    80002dd8:	4501                	li	a0,0
}
    80002dda:	70e2                	ld	ra,56(sp)
    80002ddc:	7442                	ld	s0,48(sp)
    80002dde:	74a2                	ld	s1,40(sp)
    80002de0:	7902                	ld	s2,32(sp)
    80002de2:	69e2                	ld	s3,24(sp)
    80002de4:	6121                	addi	sp,sp,64
    80002de6:	8082                	ret
      release(&tickslock);
    80002de8:	00014517          	auipc	a0,0x14
    80002dec:	e1850513          	addi	a0,a0,-488 # 80016c00 <tickslock>
    80002df0:	ffffe097          	auipc	ra,0xffffe
    80002df4:	e9a080e7          	jalr	-358(ra) # 80000c8a <release>
      return -1;
    80002df8:	557d                	li	a0,-1
    80002dfa:	b7c5                	j	80002dda <sys_sleep+0x88>

0000000080002dfc <sys_kill>:

uint64
sys_kill(void)
{
    80002dfc:	1101                	addi	sp,sp,-32
    80002dfe:	ec06                	sd	ra,24(sp)
    80002e00:	e822                	sd	s0,16(sp)
    80002e02:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e04:	fec40593          	addi	a1,s0,-20
    80002e08:	4501                	li	a0,0
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	d9a080e7          	jalr	-614(ra) # 80002ba4 <argint>
  return kill(pid);
    80002e12:	fec42503          	lw	a0,-20(s0)
    80002e16:	fffff097          	auipc	ra,0xfffff
    80002e1a:	4b0080e7          	jalr	1200(ra) # 800022c6 <kill>
}
    80002e1e:	60e2                	ld	ra,24(sp)
    80002e20:	6442                	ld	s0,16(sp)
    80002e22:	6105                	addi	sp,sp,32
    80002e24:	8082                	ret

0000000080002e26 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e26:	1101                	addi	sp,sp,-32
    80002e28:	ec06                	sd	ra,24(sp)
    80002e2a:	e822                	sd	s0,16(sp)
    80002e2c:	e426                	sd	s1,8(sp)
    80002e2e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e30:	00014517          	auipc	a0,0x14
    80002e34:	dd050513          	addi	a0,a0,-560 # 80016c00 <tickslock>
    80002e38:	ffffe097          	auipc	ra,0xffffe
    80002e3c:	d9e080e7          	jalr	-610(ra) # 80000bd6 <acquire>
  xticks = ticks;
    80002e40:	00006497          	auipc	s1,0x6
    80002e44:	b204a483          	lw	s1,-1248(s1) # 80008960 <ticks>
  release(&tickslock);
    80002e48:	00014517          	auipc	a0,0x14
    80002e4c:	db850513          	addi	a0,a0,-584 # 80016c00 <tickslock>
    80002e50:	ffffe097          	auipc	ra,0xffffe
    80002e54:	e3a080e7          	jalr	-454(ra) # 80000c8a <release>
  return xticks;
}
    80002e58:	02049513          	slli	a0,s1,0x20
    80002e5c:	9101                	srli	a0,a0,0x20
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6105                	addi	sp,sp,32
    80002e66:	8082                	ret

0000000080002e68 <sys_pstat>:

//Implementacion de la syscall pstat
uint64
sys_pstat(void)
{
    80002e68:	1101                	addi	sp,sp,-32
    80002e6a:	ec06                	sd	ra,24(sp)
    80002e6c:	e822                	sd	s0,16(sp)
    80002e6e:	1000                	addi	s0,sp,32
  int pid;
  argint(0,&pid);
    80002e70:	fec40593          	addi	a1,s0,-20
    80002e74:	4501                	li	a0,0
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	d2e080e7          	jalr	-722(ra) # 80002ba4 <argint>
  pstat(pid);
    80002e7e:	fec42503          	lw	a0,-20(s0)
    80002e82:	fffff097          	auipc	ra,0xfffff
    80002e86:	7a6080e7          	jalr	1958(ra) # 80002628 <pstat>
  return pid;
}
    80002e8a:	fec42503          	lw	a0,-20(s0)
    80002e8e:	60e2                	ld	ra,24(sp)
    80002e90:	6442                	ld	s0,16(sp)
    80002e92:	6105                	addi	sp,sp,32
    80002e94:	8082                	ret

0000000080002e96 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e96:	7179                	addi	sp,sp,-48
    80002e98:	f406                	sd	ra,40(sp)
    80002e9a:	f022                	sd	s0,32(sp)
    80002e9c:	ec26                	sd	s1,24(sp)
    80002e9e:	e84a                	sd	s2,16(sp)
    80002ea0:	e44e                	sd	s3,8(sp)
    80002ea2:	e052                	sd	s4,0(sp)
    80002ea4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ea6:	00005597          	auipc	a1,0x5
    80002eaa:	6da58593          	addi	a1,a1,1754 # 80008580 <syscalls+0xb8>
    80002eae:	00014517          	auipc	a0,0x14
    80002eb2:	d6a50513          	addi	a0,a0,-662 # 80016c18 <bcache>
    80002eb6:	ffffe097          	auipc	ra,0xffffe
    80002eba:	c90080e7          	jalr	-880(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ebe:	0001c797          	auipc	a5,0x1c
    80002ec2:	d5a78793          	addi	a5,a5,-678 # 8001ec18 <bcache+0x8000>
    80002ec6:	0001c717          	auipc	a4,0x1c
    80002eca:	fba70713          	addi	a4,a4,-70 # 8001ee80 <bcache+0x8268>
    80002ece:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ed2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ed6:	00014497          	auipc	s1,0x14
    80002eda:	d5a48493          	addi	s1,s1,-678 # 80016c30 <bcache+0x18>
    b->next = bcache.head.next;
    80002ede:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ee0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ee2:	00005a17          	auipc	s4,0x5
    80002ee6:	6a6a0a13          	addi	s4,s4,1702 # 80008588 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002eea:	2b893783          	ld	a5,696(s2)
    80002eee:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002ef0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ef4:	85d2                	mv	a1,s4
    80002ef6:	01048513          	addi	a0,s1,16
    80002efa:	00001097          	auipc	ra,0x1
    80002efe:	4c8080e7          	jalr	1224(ra) # 800043c2 <initsleeplock>
    bcache.head.next->prev = b;
    80002f02:	2b893783          	ld	a5,696(s2)
    80002f06:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f08:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f0c:	45848493          	addi	s1,s1,1112
    80002f10:	fd349de3          	bne	s1,s3,80002eea <binit+0x54>
  }
}
    80002f14:	70a2                	ld	ra,40(sp)
    80002f16:	7402                	ld	s0,32(sp)
    80002f18:	64e2                	ld	s1,24(sp)
    80002f1a:	6942                	ld	s2,16(sp)
    80002f1c:	69a2                	ld	s3,8(sp)
    80002f1e:	6a02                	ld	s4,0(sp)
    80002f20:	6145                	addi	sp,sp,48
    80002f22:	8082                	ret

0000000080002f24 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f24:	7179                	addi	sp,sp,-48
    80002f26:	f406                	sd	ra,40(sp)
    80002f28:	f022                	sd	s0,32(sp)
    80002f2a:	ec26                	sd	s1,24(sp)
    80002f2c:	e84a                	sd	s2,16(sp)
    80002f2e:	e44e                	sd	s3,8(sp)
    80002f30:	1800                	addi	s0,sp,48
    80002f32:	892a                	mv	s2,a0
    80002f34:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f36:	00014517          	auipc	a0,0x14
    80002f3a:	ce250513          	addi	a0,a0,-798 # 80016c18 <bcache>
    80002f3e:	ffffe097          	auipc	ra,0xffffe
    80002f42:	c98080e7          	jalr	-872(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f46:	0001c497          	auipc	s1,0x1c
    80002f4a:	f8a4b483          	ld	s1,-118(s1) # 8001eed0 <bcache+0x82b8>
    80002f4e:	0001c797          	auipc	a5,0x1c
    80002f52:	f3278793          	addi	a5,a5,-206 # 8001ee80 <bcache+0x8268>
    80002f56:	02f48f63          	beq	s1,a5,80002f94 <bread+0x70>
    80002f5a:	873e                	mv	a4,a5
    80002f5c:	a021                	j	80002f64 <bread+0x40>
    80002f5e:	68a4                	ld	s1,80(s1)
    80002f60:	02e48a63          	beq	s1,a4,80002f94 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f64:	449c                	lw	a5,8(s1)
    80002f66:	ff279ce3          	bne	a5,s2,80002f5e <bread+0x3a>
    80002f6a:	44dc                	lw	a5,12(s1)
    80002f6c:	ff3799e3          	bne	a5,s3,80002f5e <bread+0x3a>
      b->refcnt++;
    80002f70:	40bc                	lw	a5,64(s1)
    80002f72:	2785                	addiw	a5,a5,1
    80002f74:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f76:	00014517          	auipc	a0,0x14
    80002f7a:	ca250513          	addi	a0,a0,-862 # 80016c18 <bcache>
    80002f7e:	ffffe097          	auipc	ra,0xffffe
    80002f82:	d0c080e7          	jalr	-756(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80002f86:	01048513          	addi	a0,s1,16
    80002f8a:	00001097          	auipc	ra,0x1
    80002f8e:	472080e7          	jalr	1138(ra) # 800043fc <acquiresleep>
      return b;
    80002f92:	a8b9                	j	80002ff0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f94:	0001c497          	auipc	s1,0x1c
    80002f98:	f344b483          	ld	s1,-204(s1) # 8001eec8 <bcache+0x82b0>
    80002f9c:	0001c797          	auipc	a5,0x1c
    80002fa0:	ee478793          	addi	a5,a5,-284 # 8001ee80 <bcache+0x8268>
    80002fa4:	00f48863          	beq	s1,a5,80002fb4 <bread+0x90>
    80002fa8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002faa:	40bc                	lw	a5,64(s1)
    80002fac:	cf81                	beqz	a5,80002fc4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fae:	64a4                	ld	s1,72(s1)
    80002fb0:	fee49de3          	bne	s1,a4,80002faa <bread+0x86>
  panic("bget: no buffers");
    80002fb4:	00005517          	auipc	a0,0x5
    80002fb8:	5dc50513          	addi	a0,a0,1500 # 80008590 <syscalls+0xc8>
    80002fbc:	ffffd097          	auipc	ra,0xffffd
    80002fc0:	584080e7          	jalr	1412(ra) # 80000540 <panic>
      b->dev = dev;
    80002fc4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002fc8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002fcc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002fd0:	4785                	li	a5,1
    80002fd2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fd4:	00014517          	auipc	a0,0x14
    80002fd8:	c4450513          	addi	a0,a0,-956 # 80016c18 <bcache>
    80002fdc:	ffffe097          	auipc	ra,0xffffe
    80002fe0:	cae080e7          	jalr	-850(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80002fe4:	01048513          	addi	a0,s1,16
    80002fe8:	00001097          	auipc	ra,0x1
    80002fec:	414080e7          	jalr	1044(ra) # 800043fc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ff0:	409c                	lw	a5,0(s1)
    80002ff2:	cb89                	beqz	a5,80003004 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ff4:	8526                	mv	a0,s1
    80002ff6:	70a2                	ld	ra,40(sp)
    80002ff8:	7402                	ld	s0,32(sp)
    80002ffa:	64e2                	ld	s1,24(sp)
    80002ffc:	6942                	ld	s2,16(sp)
    80002ffe:	69a2                	ld	s3,8(sp)
    80003000:	6145                	addi	sp,sp,48
    80003002:	8082                	ret
    virtio_disk_rw(b, 0);
    80003004:	4581                	li	a1,0
    80003006:	8526                	mv	a0,s1
    80003008:	00003097          	auipc	ra,0x3
    8000300c:	fda080e7          	jalr	-38(ra) # 80005fe2 <virtio_disk_rw>
    b->valid = 1;
    80003010:	4785                	li	a5,1
    80003012:	c09c                	sw	a5,0(s1)
  return b;
    80003014:	b7c5                	j	80002ff4 <bread+0xd0>

0000000080003016 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003016:	1101                	addi	sp,sp,-32
    80003018:	ec06                	sd	ra,24(sp)
    8000301a:	e822                	sd	s0,16(sp)
    8000301c:	e426                	sd	s1,8(sp)
    8000301e:	1000                	addi	s0,sp,32
    80003020:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003022:	0541                	addi	a0,a0,16
    80003024:	00001097          	auipc	ra,0x1
    80003028:	472080e7          	jalr	1138(ra) # 80004496 <holdingsleep>
    8000302c:	cd01                	beqz	a0,80003044 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000302e:	4585                	li	a1,1
    80003030:	8526                	mv	a0,s1
    80003032:	00003097          	auipc	ra,0x3
    80003036:	fb0080e7          	jalr	-80(ra) # 80005fe2 <virtio_disk_rw>
}
    8000303a:	60e2                	ld	ra,24(sp)
    8000303c:	6442                	ld	s0,16(sp)
    8000303e:	64a2                	ld	s1,8(sp)
    80003040:	6105                	addi	sp,sp,32
    80003042:	8082                	ret
    panic("bwrite");
    80003044:	00005517          	auipc	a0,0x5
    80003048:	56450513          	addi	a0,a0,1380 # 800085a8 <syscalls+0xe0>
    8000304c:	ffffd097          	auipc	ra,0xffffd
    80003050:	4f4080e7          	jalr	1268(ra) # 80000540 <panic>

0000000080003054 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003054:	1101                	addi	sp,sp,-32
    80003056:	ec06                	sd	ra,24(sp)
    80003058:	e822                	sd	s0,16(sp)
    8000305a:	e426                	sd	s1,8(sp)
    8000305c:	e04a                	sd	s2,0(sp)
    8000305e:	1000                	addi	s0,sp,32
    80003060:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003062:	01050913          	addi	s2,a0,16
    80003066:	854a                	mv	a0,s2
    80003068:	00001097          	auipc	ra,0x1
    8000306c:	42e080e7          	jalr	1070(ra) # 80004496 <holdingsleep>
    80003070:	c92d                	beqz	a0,800030e2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003072:	854a                	mv	a0,s2
    80003074:	00001097          	auipc	ra,0x1
    80003078:	3de080e7          	jalr	990(ra) # 80004452 <releasesleep>

  acquire(&bcache.lock);
    8000307c:	00014517          	auipc	a0,0x14
    80003080:	b9c50513          	addi	a0,a0,-1124 # 80016c18 <bcache>
    80003084:	ffffe097          	auipc	ra,0xffffe
    80003088:	b52080e7          	jalr	-1198(ra) # 80000bd6 <acquire>
  b->refcnt--;
    8000308c:	40bc                	lw	a5,64(s1)
    8000308e:	37fd                	addiw	a5,a5,-1
    80003090:	0007871b          	sext.w	a4,a5
    80003094:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003096:	eb05                	bnez	a4,800030c6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003098:	68bc                	ld	a5,80(s1)
    8000309a:	64b8                	ld	a4,72(s1)
    8000309c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000309e:	64bc                	ld	a5,72(s1)
    800030a0:	68b8                	ld	a4,80(s1)
    800030a2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800030a4:	0001c797          	auipc	a5,0x1c
    800030a8:	b7478793          	addi	a5,a5,-1164 # 8001ec18 <bcache+0x8000>
    800030ac:	2b87b703          	ld	a4,696(a5)
    800030b0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800030b2:	0001c717          	auipc	a4,0x1c
    800030b6:	dce70713          	addi	a4,a4,-562 # 8001ee80 <bcache+0x8268>
    800030ba:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800030bc:	2b87b703          	ld	a4,696(a5)
    800030c0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030c2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800030c6:	00014517          	auipc	a0,0x14
    800030ca:	b5250513          	addi	a0,a0,-1198 # 80016c18 <bcache>
    800030ce:	ffffe097          	auipc	ra,0xffffe
    800030d2:	bbc080e7          	jalr	-1092(ra) # 80000c8a <release>
}
    800030d6:	60e2                	ld	ra,24(sp)
    800030d8:	6442                	ld	s0,16(sp)
    800030da:	64a2                	ld	s1,8(sp)
    800030dc:	6902                	ld	s2,0(sp)
    800030de:	6105                	addi	sp,sp,32
    800030e0:	8082                	ret
    panic("brelse");
    800030e2:	00005517          	auipc	a0,0x5
    800030e6:	4ce50513          	addi	a0,a0,1230 # 800085b0 <syscalls+0xe8>
    800030ea:	ffffd097          	auipc	ra,0xffffd
    800030ee:	456080e7          	jalr	1110(ra) # 80000540 <panic>

00000000800030f2 <bpin>:

void
bpin(struct buf *b) {
    800030f2:	1101                	addi	sp,sp,-32
    800030f4:	ec06                	sd	ra,24(sp)
    800030f6:	e822                	sd	s0,16(sp)
    800030f8:	e426                	sd	s1,8(sp)
    800030fa:	1000                	addi	s0,sp,32
    800030fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030fe:	00014517          	auipc	a0,0x14
    80003102:	b1a50513          	addi	a0,a0,-1254 # 80016c18 <bcache>
    80003106:	ffffe097          	auipc	ra,0xffffe
    8000310a:	ad0080e7          	jalr	-1328(ra) # 80000bd6 <acquire>
  b->refcnt++;
    8000310e:	40bc                	lw	a5,64(s1)
    80003110:	2785                	addiw	a5,a5,1
    80003112:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003114:	00014517          	auipc	a0,0x14
    80003118:	b0450513          	addi	a0,a0,-1276 # 80016c18 <bcache>
    8000311c:	ffffe097          	auipc	ra,0xffffe
    80003120:	b6e080e7          	jalr	-1170(ra) # 80000c8a <release>
}
    80003124:	60e2                	ld	ra,24(sp)
    80003126:	6442                	ld	s0,16(sp)
    80003128:	64a2                	ld	s1,8(sp)
    8000312a:	6105                	addi	sp,sp,32
    8000312c:	8082                	ret

000000008000312e <bunpin>:

void
bunpin(struct buf *b) {
    8000312e:	1101                	addi	sp,sp,-32
    80003130:	ec06                	sd	ra,24(sp)
    80003132:	e822                	sd	s0,16(sp)
    80003134:	e426                	sd	s1,8(sp)
    80003136:	1000                	addi	s0,sp,32
    80003138:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000313a:	00014517          	auipc	a0,0x14
    8000313e:	ade50513          	addi	a0,a0,-1314 # 80016c18 <bcache>
    80003142:	ffffe097          	auipc	ra,0xffffe
    80003146:	a94080e7          	jalr	-1388(ra) # 80000bd6 <acquire>
  b->refcnt--;
    8000314a:	40bc                	lw	a5,64(s1)
    8000314c:	37fd                	addiw	a5,a5,-1
    8000314e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003150:	00014517          	auipc	a0,0x14
    80003154:	ac850513          	addi	a0,a0,-1336 # 80016c18 <bcache>
    80003158:	ffffe097          	auipc	ra,0xffffe
    8000315c:	b32080e7          	jalr	-1230(ra) # 80000c8a <release>
}
    80003160:	60e2                	ld	ra,24(sp)
    80003162:	6442                	ld	s0,16(sp)
    80003164:	64a2                	ld	s1,8(sp)
    80003166:	6105                	addi	sp,sp,32
    80003168:	8082                	ret

000000008000316a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000316a:	1101                	addi	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	e04a                	sd	s2,0(sp)
    80003174:	1000                	addi	s0,sp,32
    80003176:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003178:	00d5d59b          	srliw	a1,a1,0xd
    8000317c:	0001c797          	auipc	a5,0x1c
    80003180:	1787a783          	lw	a5,376(a5) # 8001f2f4 <sb+0x1c>
    80003184:	9dbd                	addw	a1,a1,a5
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	d9e080e7          	jalr	-610(ra) # 80002f24 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000318e:	0074f713          	andi	a4,s1,7
    80003192:	4785                	li	a5,1
    80003194:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003198:	14ce                	slli	s1,s1,0x33
    8000319a:	90d9                	srli	s1,s1,0x36
    8000319c:	00950733          	add	a4,a0,s1
    800031a0:	05874703          	lbu	a4,88(a4)
    800031a4:	00e7f6b3          	and	a3,a5,a4
    800031a8:	c69d                	beqz	a3,800031d6 <bfree+0x6c>
    800031aa:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800031ac:	94aa                	add	s1,s1,a0
    800031ae:	fff7c793          	not	a5,a5
    800031b2:	8f7d                	and	a4,a4,a5
    800031b4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800031b8:	00001097          	auipc	ra,0x1
    800031bc:	126080e7          	jalr	294(ra) # 800042de <log_write>
  brelse(bp);
    800031c0:	854a                	mv	a0,s2
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	e92080e7          	jalr	-366(ra) # 80003054 <brelse>
}
    800031ca:	60e2                	ld	ra,24(sp)
    800031cc:	6442                	ld	s0,16(sp)
    800031ce:	64a2                	ld	s1,8(sp)
    800031d0:	6902                	ld	s2,0(sp)
    800031d2:	6105                	addi	sp,sp,32
    800031d4:	8082                	ret
    panic("freeing free block");
    800031d6:	00005517          	auipc	a0,0x5
    800031da:	3e250513          	addi	a0,a0,994 # 800085b8 <syscalls+0xf0>
    800031de:	ffffd097          	auipc	ra,0xffffd
    800031e2:	362080e7          	jalr	866(ra) # 80000540 <panic>

00000000800031e6 <balloc>:
{
    800031e6:	711d                	addi	sp,sp,-96
    800031e8:	ec86                	sd	ra,88(sp)
    800031ea:	e8a2                	sd	s0,80(sp)
    800031ec:	e4a6                	sd	s1,72(sp)
    800031ee:	e0ca                	sd	s2,64(sp)
    800031f0:	fc4e                	sd	s3,56(sp)
    800031f2:	f852                	sd	s4,48(sp)
    800031f4:	f456                	sd	s5,40(sp)
    800031f6:	f05a                	sd	s6,32(sp)
    800031f8:	ec5e                	sd	s7,24(sp)
    800031fa:	e862                	sd	s8,16(sp)
    800031fc:	e466                	sd	s9,8(sp)
    800031fe:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003200:	0001c797          	auipc	a5,0x1c
    80003204:	0dc7a783          	lw	a5,220(a5) # 8001f2dc <sb+0x4>
    80003208:	cff5                	beqz	a5,80003304 <balloc+0x11e>
    8000320a:	8baa                	mv	s7,a0
    8000320c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000320e:	0001cb17          	auipc	s6,0x1c
    80003212:	0cab0b13          	addi	s6,s6,202 # 8001f2d8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003216:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003218:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000321a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000321c:	6c89                	lui	s9,0x2
    8000321e:	a061                	j	800032a6 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003220:	97ca                	add	a5,a5,s2
    80003222:	8e55                	or	a2,a2,a3
    80003224:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003228:	854a                	mv	a0,s2
    8000322a:	00001097          	auipc	ra,0x1
    8000322e:	0b4080e7          	jalr	180(ra) # 800042de <log_write>
        brelse(bp);
    80003232:	854a                	mv	a0,s2
    80003234:	00000097          	auipc	ra,0x0
    80003238:	e20080e7          	jalr	-480(ra) # 80003054 <brelse>
  bp = bread(dev, bno);
    8000323c:	85a6                	mv	a1,s1
    8000323e:	855e                	mv	a0,s7
    80003240:	00000097          	auipc	ra,0x0
    80003244:	ce4080e7          	jalr	-796(ra) # 80002f24 <bread>
    80003248:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000324a:	40000613          	li	a2,1024
    8000324e:	4581                	li	a1,0
    80003250:	05850513          	addi	a0,a0,88
    80003254:	ffffe097          	auipc	ra,0xffffe
    80003258:	a7e080e7          	jalr	-1410(ra) # 80000cd2 <memset>
  log_write(bp);
    8000325c:	854a                	mv	a0,s2
    8000325e:	00001097          	auipc	ra,0x1
    80003262:	080080e7          	jalr	128(ra) # 800042de <log_write>
  brelse(bp);
    80003266:	854a                	mv	a0,s2
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	dec080e7          	jalr	-532(ra) # 80003054 <brelse>
}
    80003270:	8526                	mv	a0,s1
    80003272:	60e6                	ld	ra,88(sp)
    80003274:	6446                	ld	s0,80(sp)
    80003276:	64a6                	ld	s1,72(sp)
    80003278:	6906                	ld	s2,64(sp)
    8000327a:	79e2                	ld	s3,56(sp)
    8000327c:	7a42                	ld	s4,48(sp)
    8000327e:	7aa2                	ld	s5,40(sp)
    80003280:	7b02                	ld	s6,32(sp)
    80003282:	6be2                	ld	s7,24(sp)
    80003284:	6c42                	ld	s8,16(sp)
    80003286:	6ca2                	ld	s9,8(sp)
    80003288:	6125                	addi	sp,sp,96
    8000328a:	8082                	ret
    brelse(bp);
    8000328c:	854a                	mv	a0,s2
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	dc6080e7          	jalr	-570(ra) # 80003054 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003296:	015c87bb          	addw	a5,s9,s5
    8000329a:	00078a9b          	sext.w	s5,a5
    8000329e:	004b2703          	lw	a4,4(s6)
    800032a2:	06eaf163          	bgeu	s5,a4,80003304 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800032a6:	41fad79b          	sraiw	a5,s5,0x1f
    800032aa:	0137d79b          	srliw	a5,a5,0x13
    800032ae:	015787bb          	addw	a5,a5,s5
    800032b2:	40d7d79b          	sraiw	a5,a5,0xd
    800032b6:	01cb2583          	lw	a1,28(s6)
    800032ba:	9dbd                	addw	a1,a1,a5
    800032bc:	855e                	mv	a0,s7
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	c66080e7          	jalr	-922(ra) # 80002f24 <bread>
    800032c6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032c8:	004b2503          	lw	a0,4(s6)
    800032cc:	000a849b          	sext.w	s1,s5
    800032d0:	8762                	mv	a4,s8
    800032d2:	faa4fde3          	bgeu	s1,a0,8000328c <balloc+0xa6>
      m = 1 << (bi % 8);
    800032d6:	00777693          	andi	a3,a4,7
    800032da:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800032de:	41f7579b          	sraiw	a5,a4,0x1f
    800032e2:	01d7d79b          	srliw	a5,a5,0x1d
    800032e6:	9fb9                	addw	a5,a5,a4
    800032e8:	4037d79b          	sraiw	a5,a5,0x3
    800032ec:	00f90633          	add	a2,s2,a5
    800032f0:	05864603          	lbu	a2,88(a2)
    800032f4:	00c6f5b3          	and	a1,a3,a2
    800032f8:	d585                	beqz	a1,80003220 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032fa:	2705                	addiw	a4,a4,1
    800032fc:	2485                	addiw	s1,s1,1
    800032fe:	fd471ae3          	bne	a4,s4,800032d2 <balloc+0xec>
    80003302:	b769                	j	8000328c <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003304:	00005517          	auipc	a0,0x5
    80003308:	2cc50513          	addi	a0,a0,716 # 800085d0 <syscalls+0x108>
    8000330c:	ffffd097          	auipc	ra,0xffffd
    80003310:	27e080e7          	jalr	638(ra) # 8000058a <printf>
  return 0;
    80003314:	4481                	li	s1,0
    80003316:	bfa9                	j	80003270 <balloc+0x8a>

0000000080003318 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003318:	7179                	addi	sp,sp,-48
    8000331a:	f406                	sd	ra,40(sp)
    8000331c:	f022                	sd	s0,32(sp)
    8000331e:	ec26                	sd	s1,24(sp)
    80003320:	e84a                	sd	s2,16(sp)
    80003322:	e44e                	sd	s3,8(sp)
    80003324:	e052                	sd	s4,0(sp)
    80003326:	1800                	addi	s0,sp,48
    80003328:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000332a:	47ad                	li	a5,11
    8000332c:	02b7e863          	bltu	a5,a1,8000335c <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80003330:	02059793          	slli	a5,a1,0x20
    80003334:	01e7d593          	srli	a1,a5,0x1e
    80003338:	00b504b3          	add	s1,a0,a1
    8000333c:	0504a903          	lw	s2,80(s1)
    80003340:	06091e63          	bnez	s2,800033bc <bmap+0xa4>
      addr = balloc(ip->dev);
    80003344:	4108                	lw	a0,0(a0)
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	ea0080e7          	jalr	-352(ra) # 800031e6 <balloc>
    8000334e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003352:	06090563          	beqz	s2,800033bc <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80003356:	0524a823          	sw	s2,80(s1)
    8000335a:	a08d                	j	800033bc <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000335c:	ff45849b          	addiw	s1,a1,-12
    80003360:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003364:	0ff00793          	li	a5,255
    80003368:	08e7e563          	bltu	a5,a4,800033f2 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000336c:	08052903          	lw	s2,128(a0)
    80003370:	00091d63          	bnez	s2,8000338a <bmap+0x72>
      addr = balloc(ip->dev);
    80003374:	4108                	lw	a0,0(a0)
    80003376:	00000097          	auipc	ra,0x0
    8000337a:	e70080e7          	jalr	-400(ra) # 800031e6 <balloc>
    8000337e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003382:	02090d63          	beqz	s2,800033bc <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003386:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000338a:	85ca                	mv	a1,s2
    8000338c:	0009a503          	lw	a0,0(s3)
    80003390:	00000097          	auipc	ra,0x0
    80003394:	b94080e7          	jalr	-1132(ra) # 80002f24 <bread>
    80003398:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000339a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000339e:	02049713          	slli	a4,s1,0x20
    800033a2:	01e75593          	srli	a1,a4,0x1e
    800033a6:	00b784b3          	add	s1,a5,a1
    800033aa:	0004a903          	lw	s2,0(s1)
    800033ae:	02090063          	beqz	s2,800033ce <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800033b2:	8552                	mv	a0,s4
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	ca0080e7          	jalr	-864(ra) # 80003054 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800033bc:	854a                	mv	a0,s2
    800033be:	70a2                	ld	ra,40(sp)
    800033c0:	7402                	ld	s0,32(sp)
    800033c2:	64e2                	ld	s1,24(sp)
    800033c4:	6942                	ld	s2,16(sp)
    800033c6:	69a2                	ld	s3,8(sp)
    800033c8:	6a02                	ld	s4,0(sp)
    800033ca:	6145                	addi	sp,sp,48
    800033cc:	8082                	ret
      addr = balloc(ip->dev);
    800033ce:	0009a503          	lw	a0,0(s3)
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	e14080e7          	jalr	-492(ra) # 800031e6 <balloc>
    800033da:	0005091b          	sext.w	s2,a0
      if(addr){
    800033de:	fc090ae3          	beqz	s2,800033b2 <bmap+0x9a>
        a[bn] = addr;
    800033e2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800033e6:	8552                	mv	a0,s4
    800033e8:	00001097          	auipc	ra,0x1
    800033ec:	ef6080e7          	jalr	-266(ra) # 800042de <log_write>
    800033f0:	b7c9                	j	800033b2 <bmap+0x9a>
  panic("bmap: out of range");
    800033f2:	00005517          	auipc	a0,0x5
    800033f6:	1f650513          	addi	a0,a0,502 # 800085e8 <syscalls+0x120>
    800033fa:	ffffd097          	auipc	ra,0xffffd
    800033fe:	146080e7          	jalr	326(ra) # 80000540 <panic>

0000000080003402 <iget>:
{
    80003402:	7179                	addi	sp,sp,-48
    80003404:	f406                	sd	ra,40(sp)
    80003406:	f022                	sd	s0,32(sp)
    80003408:	ec26                	sd	s1,24(sp)
    8000340a:	e84a                	sd	s2,16(sp)
    8000340c:	e44e                	sd	s3,8(sp)
    8000340e:	e052                	sd	s4,0(sp)
    80003410:	1800                	addi	s0,sp,48
    80003412:	89aa                	mv	s3,a0
    80003414:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003416:	0001c517          	auipc	a0,0x1c
    8000341a:	ee250513          	addi	a0,a0,-286 # 8001f2f8 <itable>
    8000341e:	ffffd097          	auipc	ra,0xffffd
    80003422:	7b8080e7          	jalr	1976(ra) # 80000bd6 <acquire>
  empty = 0;
    80003426:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003428:	0001c497          	auipc	s1,0x1c
    8000342c:	ee848493          	addi	s1,s1,-280 # 8001f310 <itable+0x18>
    80003430:	0001e697          	auipc	a3,0x1e
    80003434:	97068693          	addi	a3,a3,-1680 # 80020da0 <log>
    80003438:	a039                	j	80003446 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000343a:	02090b63          	beqz	s2,80003470 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000343e:	08848493          	addi	s1,s1,136
    80003442:	02d48a63          	beq	s1,a3,80003476 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003446:	449c                	lw	a5,8(s1)
    80003448:	fef059e3          	blez	a5,8000343a <iget+0x38>
    8000344c:	4098                	lw	a4,0(s1)
    8000344e:	ff3716e3          	bne	a4,s3,8000343a <iget+0x38>
    80003452:	40d8                	lw	a4,4(s1)
    80003454:	ff4713e3          	bne	a4,s4,8000343a <iget+0x38>
      ip->ref++;
    80003458:	2785                	addiw	a5,a5,1
    8000345a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000345c:	0001c517          	auipc	a0,0x1c
    80003460:	e9c50513          	addi	a0,a0,-356 # 8001f2f8 <itable>
    80003464:	ffffe097          	auipc	ra,0xffffe
    80003468:	826080e7          	jalr	-2010(ra) # 80000c8a <release>
      return ip;
    8000346c:	8926                	mv	s2,s1
    8000346e:	a03d                	j	8000349c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003470:	f7f9                	bnez	a5,8000343e <iget+0x3c>
    80003472:	8926                	mv	s2,s1
    80003474:	b7e9                	j	8000343e <iget+0x3c>
  if(empty == 0)
    80003476:	02090c63          	beqz	s2,800034ae <iget+0xac>
  ip->dev = dev;
    8000347a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000347e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003482:	4785                	li	a5,1
    80003484:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003488:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000348c:	0001c517          	auipc	a0,0x1c
    80003490:	e6c50513          	addi	a0,a0,-404 # 8001f2f8 <itable>
    80003494:	ffffd097          	auipc	ra,0xffffd
    80003498:	7f6080e7          	jalr	2038(ra) # 80000c8a <release>
}
    8000349c:	854a                	mv	a0,s2
    8000349e:	70a2                	ld	ra,40(sp)
    800034a0:	7402                	ld	s0,32(sp)
    800034a2:	64e2                	ld	s1,24(sp)
    800034a4:	6942                	ld	s2,16(sp)
    800034a6:	69a2                	ld	s3,8(sp)
    800034a8:	6a02                	ld	s4,0(sp)
    800034aa:	6145                	addi	sp,sp,48
    800034ac:	8082                	ret
    panic("iget: no inodes");
    800034ae:	00005517          	auipc	a0,0x5
    800034b2:	15250513          	addi	a0,a0,338 # 80008600 <syscalls+0x138>
    800034b6:	ffffd097          	auipc	ra,0xffffd
    800034ba:	08a080e7          	jalr	138(ra) # 80000540 <panic>

00000000800034be <fsinit>:
fsinit(int dev) {
    800034be:	7179                	addi	sp,sp,-48
    800034c0:	f406                	sd	ra,40(sp)
    800034c2:	f022                	sd	s0,32(sp)
    800034c4:	ec26                	sd	s1,24(sp)
    800034c6:	e84a                	sd	s2,16(sp)
    800034c8:	e44e                	sd	s3,8(sp)
    800034ca:	1800                	addi	s0,sp,48
    800034cc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800034ce:	4585                	li	a1,1
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	a54080e7          	jalr	-1452(ra) # 80002f24 <bread>
    800034d8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800034da:	0001c997          	auipc	s3,0x1c
    800034de:	dfe98993          	addi	s3,s3,-514 # 8001f2d8 <sb>
    800034e2:	02000613          	li	a2,32
    800034e6:	05850593          	addi	a1,a0,88
    800034ea:	854e                	mv	a0,s3
    800034ec:	ffffe097          	auipc	ra,0xffffe
    800034f0:	842080e7          	jalr	-1982(ra) # 80000d2e <memmove>
  brelse(bp);
    800034f4:	8526                	mv	a0,s1
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	b5e080e7          	jalr	-1186(ra) # 80003054 <brelse>
  if(sb.magic != FSMAGIC)
    800034fe:	0009a703          	lw	a4,0(s3)
    80003502:	102037b7          	lui	a5,0x10203
    80003506:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000350a:	02f71263          	bne	a4,a5,8000352e <fsinit+0x70>
  initlog(dev, &sb);
    8000350e:	0001c597          	auipc	a1,0x1c
    80003512:	dca58593          	addi	a1,a1,-566 # 8001f2d8 <sb>
    80003516:	854a                	mv	a0,s2
    80003518:	00001097          	auipc	ra,0x1
    8000351c:	b4a080e7          	jalr	-1206(ra) # 80004062 <initlog>
}
    80003520:	70a2                	ld	ra,40(sp)
    80003522:	7402                	ld	s0,32(sp)
    80003524:	64e2                	ld	s1,24(sp)
    80003526:	6942                	ld	s2,16(sp)
    80003528:	69a2                	ld	s3,8(sp)
    8000352a:	6145                	addi	sp,sp,48
    8000352c:	8082                	ret
    panic("invalid file system");
    8000352e:	00005517          	auipc	a0,0x5
    80003532:	0e250513          	addi	a0,a0,226 # 80008610 <syscalls+0x148>
    80003536:	ffffd097          	auipc	ra,0xffffd
    8000353a:	00a080e7          	jalr	10(ra) # 80000540 <panic>

000000008000353e <iinit>:
{
    8000353e:	7179                	addi	sp,sp,-48
    80003540:	f406                	sd	ra,40(sp)
    80003542:	f022                	sd	s0,32(sp)
    80003544:	ec26                	sd	s1,24(sp)
    80003546:	e84a                	sd	s2,16(sp)
    80003548:	e44e                	sd	s3,8(sp)
    8000354a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000354c:	00005597          	auipc	a1,0x5
    80003550:	0dc58593          	addi	a1,a1,220 # 80008628 <syscalls+0x160>
    80003554:	0001c517          	auipc	a0,0x1c
    80003558:	da450513          	addi	a0,a0,-604 # 8001f2f8 <itable>
    8000355c:	ffffd097          	auipc	ra,0xffffd
    80003560:	5ea080e7          	jalr	1514(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003564:	0001c497          	auipc	s1,0x1c
    80003568:	dbc48493          	addi	s1,s1,-580 # 8001f320 <itable+0x28>
    8000356c:	0001e997          	auipc	s3,0x1e
    80003570:	84498993          	addi	s3,s3,-1980 # 80020db0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003574:	00005917          	auipc	s2,0x5
    80003578:	0bc90913          	addi	s2,s2,188 # 80008630 <syscalls+0x168>
    8000357c:	85ca                	mv	a1,s2
    8000357e:	8526                	mv	a0,s1
    80003580:	00001097          	auipc	ra,0x1
    80003584:	e42080e7          	jalr	-446(ra) # 800043c2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003588:	08848493          	addi	s1,s1,136
    8000358c:	ff3498e3          	bne	s1,s3,8000357c <iinit+0x3e>
}
    80003590:	70a2                	ld	ra,40(sp)
    80003592:	7402                	ld	s0,32(sp)
    80003594:	64e2                	ld	s1,24(sp)
    80003596:	6942                	ld	s2,16(sp)
    80003598:	69a2                	ld	s3,8(sp)
    8000359a:	6145                	addi	sp,sp,48
    8000359c:	8082                	ret

000000008000359e <ialloc>:
{
    8000359e:	715d                	addi	sp,sp,-80
    800035a0:	e486                	sd	ra,72(sp)
    800035a2:	e0a2                	sd	s0,64(sp)
    800035a4:	fc26                	sd	s1,56(sp)
    800035a6:	f84a                	sd	s2,48(sp)
    800035a8:	f44e                	sd	s3,40(sp)
    800035aa:	f052                	sd	s4,32(sp)
    800035ac:	ec56                	sd	s5,24(sp)
    800035ae:	e85a                	sd	s6,16(sp)
    800035b0:	e45e                	sd	s7,8(sp)
    800035b2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800035b4:	0001c717          	auipc	a4,0x1c
    800035b8:	d3072703          	lw	a4,-720(a4) # 8001f2e4 <sb+0xc>
    800035bc:	4785                	li	a5,1
    800035be:	04e7fa63          	bgeu	a5,a4,80003612 <ialloc+0x74>
    800035c2:	8aaa                	mv	s5,a0
    800035c4:	8bae                	mv	s7,a1
    800035c6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800035c8:	0001ca17          	auipc	s4,0x1c
    800035cc:	d10a0a13          	addi	s4,s4,-752 # 8001f2d8 <sb>
    800035d0:	00048b1b          	sext.w	s6,s1
    800035d4:	0044d593          	srli	a1,s1,0x4
    800035d8:	018a2783          	lw	a5,24(s4)
    800035dc:	9dbd                	addw	a1,a1,a5
    800035de:	8556                	mv	a0,s5
    800035e0:	00000097          	auipc	ra,0x0
    800035e4:	944080e7          	jalr	-1724(ra) # 80002f24 <bread>
    800035e8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035ea:	05850993          	addi	s3,a0,88
    800035ee:	00f4f793          	andi	a5,s1,15
    800035f2:	079a                	slli	a5,a5,0x6
    800035f4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035f6:	00099783          	lh	a5,0(s3)
    800035fa:	c3a1                	beqz	a5,8000363a <ialloc+0x9c>
    brelse(bp);
    800035fc:	00000097          	auipc	ra,0x0
    80003600:	a58080e7          	jalr	-1448(ra) # 80003054 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003604:	0485                	addi	s1,s1,1
    80003606:	00ca2703          	lw	a4,12(s4)
    8000360a:	0004879b          	sext.w	a5,s1
    8000360e:	fce7e1e3          	bltu	a5,a4,800035d0 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003612:	00005517          	auipc	a0,0x5
    80003616:	02650513          	addi	a0,a0,38 # 80008638 <syscalls+0x170>
    8000361a:	ffffd097          	auipc	ra,0xffffd
    8000361e:	f70080e7          	jalr	-144(ra) # 8000058a <printf>
  return 0;
    80003622:	4501                	li	a0,0
}
    80003624:	60a6                	ld	ra,72(sp)
    80003626:	6406                	ld	s0,64(sp)
    80003628:	74e2                	ld	s1,56(sp)
    8000362a:	7942                	ld	s2,48(sp)
    8000362c:	79a2                	ld	s3,40(sp)
    8000362e:	7a02                	ld	s4,32(sp)
    80003630:	6ae2                	ld	s5,24(sp)
    80003632:	6b42                	ld	s6,16(sp)
    80003634:	6ba2                	ld	s7,8(sp)
    80003636:	6161                	addi	sp,sp,80
    80003638:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000363a:	04000613          	li	a2,64
    8000363e:	4581                	li	a1,0
    80003640:	854e                	mv	a0,s3
    80003642:	ffffd097          	auipc	ra,0xffffd
    80003646:	690080e7          	jalr	1680(ra) # 80000cd2 <memset>
      dip->type = type;
    8000364a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000364e:	854a                	mv	a0,s2
    80003650:	00001097          	auipc	ra,0x1
    80003654:	c8e080e7          	jalr	-882(ra) # 800042de <log_write>
      brelse(bp);
    80003658:	854a                	mv	a0,s2
    8000365a:	00000097          	auipc	ra,0x0
    8000365e:	9fa080e7          	jalr	-1542(ra) # 80003054 <brelse>
      return iget(dev, inum);
    80003662:	85da                	mv	a1,s6
    80003664:	8556                	mv	a0,s5
    80003666:	00000097          	auipc	ra,0x0
    8000366a:	d9c080e7          	jalr	-612(ra) # 80003402 <iget>
    8000366e:	bf5d                	j	80003624 <ialloc+0x86>

0000000080003670 <iupdate>:
{
    80003670:	1101                	addi	sp,sp,-32
    80003672:	ec06                	sd	ra,24(sp)
    80003674:	e822                	sd	s0,16(sp)
    80003676:	e426                	sd	s1,8(sp)
    80003678:	e04a                	sd	s2,0(sp)
    8000367a:	1000                	addi	s0,sp,32
    8000367c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000367e:	415c                	lw	a5,4(a0)
    80003680:	0047d79b          	srliw	a5,a5,0x4
    80003684:	0001c597          	auipc	a1,0x1c
    80003688:	c6c5a583          	lw	a1,-916(a1) # 8001f2f0 <sb+0x18>
    8000368c:	9dbd                	addw	a1,a1,a5
    8000368e:	4108                	lw	a0,0(a0)
    80003690:	00000097          	auipc	ra,0x0
    80003694:	894080e7          	jalr	-1900(ra) # 80002f24 <bread>
    80003698:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000369a:	05850793          	addi	a5,a0,88
    8000369e:	40d8                	lw	a4,4(s1)
    800036a0:	8b3d                	andi	a4,a4,15
    800036a2:	071a                	slli	a4,a4,0x6
    800036a4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800036a6:	04449703          	lh	a4,68(s1)
    800036aa:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800036ae:	04649703          	lh	a4,70(s1)
    800036b2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800036b6:	04849703          	lh	a4,72(s1)
    800036ba:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800036be:	04a49703          	lh	a4,74(s1)
    800036c2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800036c6:	44f8                	lw	a4,76(s1)
    800036c8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800036ca:	03400613          	li	a2,52
    800036ce:	05048593          	addi	a1,s1,80
    800036d2:	00c78513          	addi	a0,a5,12
    800036d6:	ffffd097          	auipc	ra,0xffffd
    800036da:	658080e7          	jalr	1624(ra) # 80000d2e <memmove>
  log_write(bp);
    800036de:	854a                	mv	a0,s2
    800036e0:	00001097          	auipc	ra,0x1
    800036e4:	bfe080e7          	jalr	-1026(ra) # 800042de <log_write>
  brelse(bp);
    800036e8:	854a                	mv	a0,s2
    800036ea:	00000097          	auipc	ra,0x0
    800036ee:	96a080e7          	jalr	-1686(ra) # 80003054 <brelse>
}
    800036f2:	60e2                	ld	ra,24(sp)
    800036f4:	6442                	ld	s0,16(sp)
    800036f6:	64a2                	ld	s1,8(sp)
    800036f8:	6902                	ld	s2,0(sp)
    800036fa:	6105                	addi	sp,sp,32
    800036fc:	8082                	ret

00000000800036fe <idup>:
{
    800036fe:	1101                	addi	sp,sp,-32
    80003700:	ec06                	sd	ra,24(sp)
    80003702:	e822                	sd	s0,16(sp)
    80003704:	e426                	sd	s1,8(sp)
    80003706:	1000                	addi	s0,sp,32
    80003708:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000370a:	0001c517          	auipc	a0,0x1c
    8000370e:	bee50513          	addi	a0,a0,-1042 # 8001f2f8 <itable>
    80003712:	ffffd097          	auipc	ra,0xffffd
    80003716:	4c4080e7          	jalr	1220(ra) # 80000bd6 <acquire>
  ip->ref++;
    8000371a:	449c                	lw	a5,8(s1)
    8000371c:	2785                	addiw	a5,a5,1
    8000371e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003720:	0001c517          	auipc	a0,0x1c
    80003724:	bd850513          	addi	a0,a0,-1064 # 8001f2f8 <itable>
    80003728:	ffffd097          	auipc	ra,0xffffd
    8000372c:	562080e7          	jalr	1378(ra) # 80000c8a <release>
}
    80003730:	8526                	mv	a0,s1
    80003732:	60e2                	ld	ra,24(sp)
    80003734:	6442                	ld	s0,16(sp)
    80003736:	64a2                	ld	s1,8(sp)
    80003738:	6105                	addi	sp,sp,32
    8000373a:	8082                	ret

000000008000373c <ilock>:
{
    8000373c:	1101                	addi	sp,sp,-32
    8000373e:	ec06                	sd	ra,24(sp)
    80003740:	e822                	sd	s0,16(sp)
    80003742:	e426                	sd	s1,8(sp)
    80003744:	e04a                	sd	s2,0(sp)
    80003746:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003748:	c115                	beqz	a0,8000376c <ilock+0x30>
    8000374a:	84aa                	mv	s1,a0
    8000374c:	451c                	lw	a5,8(a0)
    8000374e:	00f05f63          	blez	a5,8000376c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003752:	0541                	addi	a0,a0,16
    80003754:	00001097          	auipc	ra,0x1
    80003758:	ca8080e7          	jalr	-856(ra) # 800043fc <acquiresleep>
  if(ip->valid == 0){
    8000375c:	40bc                	lw	a5,64(s1)
    8000375e:	cf99                	beqz	a5,8000377c <ilock+0x40>
}
    80003760:	60e2                	ld	ra,24(sp)
    80003762:	6442                	ld	s0,16(sp)
    80003764:	64a2                	ld	s1,8(sp)
    80003766:	6902                	ld	s2,0(sp)
    80003768:	6105                	addi	sp,sp,32
    8000376a:	8082                	ret
    panic("ilock");
    8000376c:	00005517          	auipc	a0,0x5
    80003770:	ee450513          	addi	a0,a0,-284 # 80008650 <syscalls+0x188>
    80003774:	ffffd097          	auipc	ra,0xffffd
    80003778:	dcc080e7          	jalr	-564(ra) # 80000540 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000377c:	40dc                	lw	a5,4(s1)
    8000377e:	0047d79b          	srliw	a5,a5,0x4
    80003782:	0001c597          	auipc	a1,0x1c
    80003786:	b6e5a583          	lw	a1,-1170(a1) # 8001f2f0 <sb+0x18>
    8000378a:	9dbd                	addw	a1,a1,a5
    8000378c:	4088                	lw	a0,0(s1)
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	796080e7          	jalr	1942(ra) # 80002f24 <bread>
    80003796:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003798:	05850593          	addi	a1,a0,88
    8000379c:	40dc                	lw	a5,4(s1)
    8000379e:	8bbd                	andi	a5,a5,15
    800037a0:	079a                	slli	a5,a5,0x6
    800037a2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037a4:	00059783          	lh	a5,0(a1)
    800037a8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037ac:	00259783          	lh	a5,2(a1)
    800037b0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800037b4:	00459783          	lh	a5,4(a1)
    800037b8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800037bc:	00659783          	lh	a5,6(a1)
    800037c0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800037c4:	459c                	lw	a5,8(a1)
    800037c6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800037c8:	03400613          	li	a2,52
    800037cc:	05b1                	addi	a1,a1,12
    800037ce:	05048513          	addi	a0,s1,80
    800037d2:	ffffd097          	auipc	ra,0xffffd
    800037d6:	55c080e7          	jalr	1372(ra) # 80000d2e <memmove>
    brelse(bp);
    800037da:	854a                	mv	a0,s2
    800037dc:	00000097          	auipc	ra,0x0
    800037e0:	878080e7          	jalr	-1928(ra) # 80003054 <brelse>
    ip->valid = 1;
    800037e4:	4785                	li	a5,1
    800037e6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037e8:	04449783          	lh	a5,68(s1)
    800037ec:	fbb5                	bnez	a5,80003760 <ilock+0x24>
      panic("ilock: no type");
    800037ee:	00005517          	auipc	a0,0x5
    800037f2:	e6a50513          	addi	a0,a0,-406 # 80008658 <syscalls+0x190>
    800037f6:	ffffd097          	auipc	ra,0xffffd
    800037fa:	d4a080e7          	jalr	-694(ra) # 80000540 <panic>

00000000800037fe <iunlock>:
{
    800037fe:	1101                	addi	sp,sp,-32
    80003800:	ec06                	sd	ra,24(sp)
    80003802:	e822                	sd	s0,16(sp)
    80003804:	e426                	sd	s1,8(sp)
    80003806:	e04a                	sd	s2,0(sp)
    80003808:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000380a:	c905                	beqz	a0,8000383a <iunlock+0x3c>
    8000380c:	84aa                	mv	s1,a0
    8000380e:	01050913          	addi	s2,a0,16
    80003812:	854a                	mv	a0,s2
    80003814:	00001097          	auipc	ra,0x1
    80003818:	c82080e7          	jalr	-894(ra) # 80004496 <holdingsleep>
    8000381c:	cd19                	beqz	a0,8000383a <iunlock+0x3c>
    8000381e:	449c                	lw	a5,8(s1)
    80003820:	00f05d63          	blez	a5,8000383a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003824:	854a                	mv	a0,s2
    80003826:	00001097          	auipc	ra,0x1
    8000382a:	c2c080e7          	jalr	-980(ra) # 80004452 <releasesleep>
}
    8000382e:	60e2                	ld	ra,24(sp)
    80003830:	6442                	ld	s0,16(sp)
    80003832:	64a2                	ld	s1,8(sp)
    80003834:	6902                	ld	s2,0(sp)
    80003836:	6105                	addi	sp,sp,32
    80003838:	8082                	ret
    panic("iunlock");
    8000383a:	00005517          	auipc	a0,0x5
    8000383e:	e2e50513          	addi	a0,a0,-466 # 80008668 <syscalls+0x1a0>
    80003842:	ffffd097          	auipc	ra,0xffffd
    80003846:	cfe080e7          	jalr	-770(ra) # 80000540 <panic>

000000008000384a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000384a:	7179                	addi	sp,sp,-48
    8000384c:	f406                	sd	ra,40(sp)
    8000384e:	f022                	sd	s0,32(sp)
    80003850:	ec26                	sd	s1,24(sp)
    80003852:	e84a                	sd	s2,16(sp)
    80003854:	e44e                	sd	s3,8(sp)
    80003856:	e052                	sd	s4,0(sp)
    80003858:	1800                	addi	s0,sp,48
    8000385a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000385c:	05050493          	addi	s1,a0,80
    80003860:	08050913          	addi	s2,a0,128
    80003864:	a021                	j	8000386c <itrunc+0x22>
    80003866:	0491                	addi	s1,s1,4
    80003868:	01248d63          	beq	s1,s2,80003882 <itrunc+0x38>
    if(ip->addrs[i]){
    8000386c:	408c                	lw	a1,0(s1)
    8000386e:	dde5                	beqz	a1,80003866 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003870:	0009a503          	lw	a0,0(s3)
    80003874:	00000097          	auipc	ra,0x0
    80003878:	8f6080e7          	jalr	-1802(ra) # 8000316a <bfree>
      ip->addrs[i] = 0;
    8000387c:	0004a023          	sw	zero,0(s1)
    80003880:	b7dd                	j	80003866 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003882:	0809a583          	lw	a1,128(s3)
    80003886:	e185                	bnez	a1,800038a6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003888:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000388c:	854e                	mv	a0,s3
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	de2080e7          	jalr	-542(ra) # 80003670 <iupdate>
}
    80003896:	70a2                	ld	ra,40(sp)
    80003898:	7402                	ld	s0,32(sp)
    8000389a:	64e2                	ld	s1,24(sp)
    8000389c:	6942                	ld	s2,16(sp)
    8000389e:	69a2                	ld	s3,8(sp)
    800038a0:	6a02                	ld	s4,0(sp)
    800038a2:	6145                	addi	sp,sp,48
    800038a4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038a6:	0009a503          	lw	a0,0(s3)
    800038aa:	fffff097          	auipc	ra,0xfffff
    800038ae:	67a080e7          	jalr	1658(ra) # 80002f24 <bread>
    800038b2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800038b4:	05850493          	addi	s1,a0,88
    800038b8:	45850913          	addi	s2,a0,1112
    800038bc:	a021                	j	800038c4 <itrunc+0x7a>
    800038be:	0491                	addi	s1,s1,4
    800038c0:	01248b63          	beq	s1,s2,800038d6 <itrunc+0x8c>
      if(a[j])
    800038c4:	408c                	lw	a1,0(s1)
    800038c6:	dde5                	beqz	a1,800038be <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800038c8:	0009a503          	lw	a0,0(s3)
    800038cc:	00000097          	auipc	ra,0x0
    800038d0:	89e080e7          	jalr	-1890(ra) # 8000316a <bfree>
    800038d4:	b7ed                	j	800038be <itrunc+0x74>
    brelse(bp);
    800038d6:	8552                	mv	a0,s4
    800038d8:	fffff097          	auipc	ra,0xfffff
    800038dc:	77c080e7          	jalr	1916(ra) # 80003054 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038e0:	0809a583          	lw	a1,128(s3)
    800038e4:	0009a503          	lw	a0,0(s3)
    800038e8:	00000097          	auipc	ra,0x0
    800038ec:	882080e7          	jalr	-1918(ra) # 8000316a <bfree>
    ip->addrs[NDIRECT] = 0;
    800038f0:	0809a023          	sw	zero,128(s3)
    800038f4:	bf51                	j	80003888 <itrunc+0x3e>

00000000800038f6 <iput>:
{
    800038f6:	1101                	addi	sp,sp,-32
    800038f8:	ec06                	sd	ra,24(sp)
    800038fa:	e822                	sd	s0,16(sp)
    800038fc:	e426                	sd	s1,8(sp)
    800038fe:	e04a                	sd	s2,0(sp)
    80003900:	1000                	addi	s0,sp,32
    80003902:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003904:	0001c517          	auipc	a0,0x1c
    80003908:	9f450513          	addi	a0,a0,-1548 # 8001f2f8 <itable>
    8000390c:	ffffd097          	auipc	ra,0xffffd
    80003910:	2ca080e7          	jalr	714(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003914:	4498                	lw	a4,8(s1)
    80003916:	4785                	li	a5,1
    80003918:	02f70363          	beq	a4,a5,8000393e <iput+0x48>
  ip->ref--;
    8000391c:	449c                	lw	a5,8(s1)
    8000391e:	37fd                	addiw	a5,a5,-1
    80003920:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003922:	0001c517          	auipc	a0,0x1c
    80003926:	9d650513          	addi	a0,a0,-1578 # 8001f2f8 <itable>
    8000392a:	ffffd097          	auipc	ra,0xffffd
    8000392e:	360080e7          	jalr	864(ra) # 80000c8a <release>
}
    80003932:	60e2                	ld	ra,24(sp)
    80003934:	6442                	ld	s0,16(sp)
    80003936:	64a2                	ld	s1,8(sp)
    80003938:	6902                	ld	s2,0(sp)
    8000393a:	6105                	addi	sp,sp,32
    8000393c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000393e:	40bc                	lw	a5,64(s1)
    80003940:	dff1                	beqz	a5,8000391c <iput+0x26>
    80003942:	04a49783          	lh	a5,74(s1)
    80003946:	fbf9                	bnez	a5,8000391c <iput+0x26>
    acquiresleep(&ip->lock);
    80003948:	01048913          	addi	s2,s1,16
    8000394c:	854a                	mv	a0,s2
    8000394e:	00001097          	auipc	ra,0x1
    80003952:	aae080e7          	jalr	-1362(ra) # 800043fc <acquiresleep>
    release(&itable.lock);
    80003956:	0001c517          	auipc	a0,0x1c
    8000395a:	9a250513          	addi	a0,a0,-1630 # 8001f2f8 <itable>
    8000395e:	ffffd097          	auipc	ra,0xffffd
    80003962:	32c080e7          	jalr	812(ra) # 80000c8a <release>
    itrunc(ip);
    80003966:	8526                	mv	a0,s1
    80003968:	00000097          	auipc	ra,0x0
    8000396c:	ee2080e7          	jalr	-286(ra) # 8000384a <itrunc>
    ip->type = 0;
    80003970:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003974:	8526                	mv	a0,s1
    80003976:	00000097          	auipc	ra,0x0
    8000397a:	cfa080e7          	jalr	-774(ra) # 80003670 <iupdate>
    ip->valid = 0;
    8000397e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003982:	854a                	mv	a0,s2
    80003984:	00001097          	auipc	ra,0x1
    80003988:	ace080e7          	jalr	-1330(ra) # 80004452 <releasesleep>
    acquire(&itable.lock);
    8000398c:	0001c517          	auipc	a0,0x1c
    80003990:	96c50513          	addi	a0,a0,-1684 # 8001f2f8 <itable>
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	242080e7          	jalr	578(ra) # 80000bd6 <acquire>
    8000399c:	b741                	j	8000391c <iput+0x26>

000000008000399e <iunlockput>:
{
    8000399e:	1101                	addi	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	1000                	addi	s0,sp,32
    800039a8:	84aa                	mv	s1,a0
  iunlock(ip);
    800039aa:	00000097          	auipc	ra,0x0
    800039ae:	e54080e7          	jalr	-428(ra) # 800037fe <iunlock>
  iput(ip);
    800039b2:	8526                	mv	a0,s1
    800039b4:	00000097          	auipc	ra,0x0
    800039b8:	f42080e7          	jalr	-190(ra) # 800038f6 <iput>
}
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6105                	addi	sp,sp,32
    800039c4:	8082                	ret

00000000800039c6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039c6:	1141                	addi	sp,sp,-16
    800039c8:	e422                	sd	s0,8(sp)
    800039ca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800039cc:	411c                	lw	a5,0(a0)
    800039ce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039d0:	415c                	lw	a5,4(a0)
    800039d2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039d4:	04451783          	lh	a5,68(a0)
    800039d8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800039dc:	04a51783          	lh	a5,74(a0)
    800039e0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039e4:	04c56783          	lwu	a5,76(a0)
    800039e8:	e99c                	sd	a5,16(a1)
}
    800039ea:	6422                	ld	s0,8(sp)
    800039ec:	0141                	addi	sp,sp,16
    800039ee:	8082                	ret

00000000800039f0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039f0:	457c                	lw	a5,76(a0)
    800039f2:	0ed7e963          	bltu	a5,a3,80003ae4 <readi+0xf4>
{
    800039f6:	7159                	addi	sp,sp,-112
    800039f8:	f486                	sd	ra,104(sp)
    800039fa:	f0a2                	sd	s0,96(sp)
    800039fc:	eca6                	sd	s1,88(sp)
    800039fe:	e8ca                	sd	s2,80(sp)
    80003a00:	e4ce                	sd	s3,72(sp)
    80003a02:	e0d2                	sd	s4,64(sp)
    80003a04:	fc56                	sd	s5,56(sp)
    80003a06:	f85a                	sd	s6,48(sp)
    80003a08:	f45e                	sd	s7,40(sp)
    80003a0a:	f062                	sd	s8,32(sp)
    80003a0c:	ec66                	sd	s9,24(sp)
    80003a0e:	e86a                	sd	s10,16(sp)
    80003a10:	e46e                	sd	s11,8(sp)
    80003a12:	1880                	addi	s0,sp,112
    80003a14:	8b2a                	mv	s6,a0
    80003a16:	8bae                	mv	s7,a1
    80003a18:	8a32                	mv	s4,a2
    80003a1a:	84b6                	mv	s1,a3
    80003a1c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a1e:	9f35                	addw	a4,a4,a3
    return 0;
    80003a20:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a22:	0ad76063          	bltu	a4,a3,80003ac2 <readi+0xd2>
  if(off + n > ip->size)
    80003a26:	00e7f463          	bgeu	a5,a4,80003a2e <readi+0x3e>
    n = ip->size - off;
    80003a2a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a2e:	0a0a8963          	beqz	s5,80003ae0 <readi+0xf0>
    80003a32:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a34:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a38:	5c7d                	li	s8,-1
    80003a3a:	a82d                	j	80003a74 <readi+0x84>
    80003a3c:	020d1d93          	slli	s11,s10,0x20
    80003a40:	020ddd93          	srli	s11,s11,0x20
    80003a44:	05890613          	addi	a2,s2,88
    80003a48:	86ee                	mv	a3,s11
    80003a4a:	963a                	add	a2,a2,a4
    80003a4c:	85d2                	mv	a1,s4
    80003a4e:	855e                	mv	a0,s7
    80003a50:	fffff097          	auipc	ra,0xfffff
    80003a54:	a74080e7          	jalr	-1420(ra) # 800024c4 <either_copyout>
    80003a58:	05850d63          	beq	a0,s8,80003ab2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003a5c:	854a                	mv	a0,s2
    80003a5e:	fffff097          	auipc	ra,0xfffff
    80003a62:	5f6080e7          	jalr	1526(ra) # 80003054 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a66:	013d09bb          	addw	s3,s10,s3
    80003a6a:	009d04bb          	addw	s1,s10,s1
    80003a6e:	9a6e                	add	s4,s4,s11
    80003a70:	0559f763          	bgeu	s3,s5,80003abe <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003a74:	00a4d59b          	srliw	a1,s1,0xa
    80003a78:	855a                	mv	a0,s6
    80003a7a:	00000097          	auipc	ra,0x0
    80003a7e:	89e080e7          	jalr	-1890(ra) # 80003318 <bmap>
    80003a82:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003a86:	cd85                	beqz	a1,80003abe <readi+0xce>
    bp = bread(ip->dev, addr);
    80003a88:	000b2503          	lw	a0,0(s6)
    80003a8c:	fffff097          	auipc	ra,0xfffff
    80003a90:	498080e7          	jalr	1176(ra) # 80002f24 <bread>
    80003a94:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a96:	3ff4f713          	andi	a4,s1,1023
    80003a9a:	40ec87bb          	subw	a5,s9,a4
    80003a9e:	413a86bb          	subw	a3,s5,s3
    80003aa2:	8d3e                	mv	s10,a5
    80003aa4:	2781                	sext.w	a5,a5
    80003aa6:	0006861b          	sext.w	a2,a3
    80003aaa:	f8f679e3          	bgeu	a2,a5,80003a3c <readi+0x4c>
    80003aae:	8d36                	mv	s10,a3
    80003ab0:	b771                	j	80003a3c <readi+0x4c>
      brelse(bp);
    80003ab2:	854a                	mv	a0,s2
    80003ab4:	fffff097          	auipc	ra,0xfffff
    80003ab8:	5a0080e7          	jalr	1440(ra) # 80003054 <brelse>
      tot = -1;
    80003abc:	59fd                	li	s3,-1
  }
  return tot;
    80003abe:	0009851b          	sext.w	a0,s3
}
    80003ac2:	70a6                	ld	ra,104(sp)
    80003ac4:	7406                	ld	s0,96(sp)
    80003ac6:	64e6                	ld	s1,88(sp)
    80003ac8:	6946                	ld	s2,80(sp)
    80003aca:	69a6                	ld	s3,72(sp)
    80003acc:	6a06                	ld	s4,64(sp)
    80003ace:	7ae2                	ld	s5,56(sp)
    80003ad0:	7b42                	ld	s6,48(sp)
    80003ad2:	7ba2                	ld	s7,40(sp)
    80003ad4:	7c02                	ld	s8,32(sp)
    80003ad6:	6ce2                	ld	s9,24(sp)
    80003ad8:	6d42                	ld	s10,16(sp)
    80003ada:	6da2                	ld	s11,8(sp)
    80003adc:	6165                	addi	sp,sp,112
    80003ade:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae0:	89d6                	mv	s3,s5
    80003ae2:	bff1                	j	80003abe <readi+0xce>
    return 0;
    80003ae4:	4501                	li	a0,0
}
    80003ae6:	8082                	ret

0000000080003ae8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ae8:	457c                	lw	a5,76(a0)
    80003aea:	10d7e863          	bltu	a5,a3,80003bfa <writei+0x112>
{
    80003aee:	7159                	addi	sp,sp,-112
    80003af0:	f486                	sd	ra,104(sp)
    80003af2:	f0a2                	sd	s0,96(sp)
    80003af4:	eca6                	sd	s1,88(sp)
    80003af6:	e8ca                	sd	s2,80(sp)
    80003af8:	e4ce                	sd	s3,72(sp)
    80003afa:	e0d2                	sd	s4,64(sp)
    80003afc:	fc56                	sd	s5,56(sp)
    80003afe:	f85a                	sd	s6,48(sp)
    80003b00:	f45e                	sd	s7,40(sp)
    80003b02:	f062                	sd	s8,32(sp)
    80003b04:	ec66                	sd	s9,24(sp)
    80003b06:	e86a                	sd	s10,16(sp)
    80003b08:	e46e                	sd	s11,8(sp)
    80003b0a:	1880                	addi	s0,sp,112
    80003b0c:	8aaa                	mv	s5,a0
    80003b0e:	8bae                	mv	s7,a1
    80003b10:	8a32                	mv	s4,a2
    80003b12:	8936                	mv	s2,a3
    80003b14:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b16:	00e687bb          	addw	a5,a3,a4
    80003b1a:	0ed7e263          	bltu	a5,a3,80003bfe <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b1e:	00043737          	lui	a4,0x43
    80003b22:	0ef76063          	bltu	a4,a5,80003c02 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b26:	0c0b0863          	beqz	s6,80003bf6 <writei+0x10e>
    80003b2a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b2c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b30:	5c7d                	li	s8,-1
    80003b32:	a091                	j	80003b76 <writei+0x8e>
    80003b34:	020d1d93          	slli	s11,s10,0x20
    80003b38:	020ddd93          	srli	s11,s11,0x20
    80003b3c:	05848513          	addi	a0,s1,88
    80003b40:	86ee                	mv	a3,s11
    80003b42:	8652                	mv	a2,s4
    80003b44:	85de                	mv	a1,s7
    80003b46:	953a                	add	a0,a0,a4
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	9d2080e7          	jalr	-1582(ra) # 8000251a <either_copyin>
    80003b50:	07850263          	beq	a0,s8,80003bb4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b54:	8526                	mv	a0,s1
    80003b56:	00000097          	auipc	ra,0x0
    80003b5a:	788080e7          	jalr	1928(ra) # 800042de <log_write>
    brelse(bp);
    80003b5e:	8526                	mv	a0,s1
    80003b60:	fffff097          	auipc	ra,0xfffff
    80003b64:	4f4080e7          	jalr	1268(ra) # 80003054 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b68:	013d09bb          	addw	s3,s10,s3
    80003b6c:	012d093b          	addw	s2,s10,s2
    80003b70:	9a6e                	add	s4,s4,s11
    80003b72:	0569f663          	bgeu	s3,s6,80003bbe <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003b76:	00a9559b          	srliw	a1,s2,0xa
    80003b7a:	8556                	mv	a0,s5
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	79c080e7          	jalr	1948(ra) # 80003318 <bmap>
    80003b84:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003b88:	c99d                	beqz	a1,80003bbe <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003b8a:	000aa503          	lw	a0,0(s5)
    80003b8e:	fffff097          	auipc	ra,0xfffff
    80003b92:	396080e7          	jalr	918(ra) # 80002f24 <bread>
    80003b96:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b98:	3ff97713          	andi	a4,s2,1023
    80003b9c:	40ec87bb          	subw	a5,s9,a4
    80003ba0:	413b06bb          	subw	a3,s6,s3
    80003ba4:	8d3e                	mv	s10,a5
    80003ba6:	2781                	sext.w	a5,a5
    80003ba8:	0006861b          	sext.w	a2,a3
    80003bac:	f8f674e3          	bgeu	a2,a5,80003b34 <writei+0x4c>
    80003bb0:	8d36                	mv	s10,a3
    80003bb2:	b749                	j	80003b34 <writei+0x4c>
      brelse(bp);
    80003bb4:	8526                	mv	a0,s1
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	49e080e7          	jalr	1182(ra) # 80003054 <brelse>
  }

  if(off > ip->size)
    80003bbe:	04caa783          	lw	a5,76(s5)
    80003bc2:	0127f463          	bgeu	a5,s2,80003bca <writei+0xe2>
    ip->size = off;
    80003bc6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003bca:	8556                	mv	a0,s5
    80003bcc:	00000097          	auipc	ra,0x0
    80003bd0:	aa4080e7          	jalr	-1372(ra) # 80003670 <iupdate>

  return tot;
    80003bd4:	0009851b          	sext.w	a0,s3
}
    80003bd8:	70a6                	ld	ra,104(sp)
    80003bda:	7406                	ld	s0,96(sp)
    80003bdc:	64e6                	ld	s1,88(sp)
    80003bde:	6946                	ld	s2,80(sp)
    80003be0:	69a6                	ld	s3,72(sp)
    80003be2:	6a06                	ld	s4,64(sp)
    80003be4:	7ae2                	ld	s5,56(sp)
    80003be6:	7b42                	ld	s6,48(sp)
    80003be8:	7ba2                	ld	s7,40(sp)
    80003bea:	7c02                	ld	s8,32(sp)
    80003bec:	6ce2                	ld	s9,24(sp)
    80003bee:	6d42                	ld	s10,16(sp)
    80003bf0:	6da2                	ld	s11,8(sp)
    80003bf2:	6165                	addi	sp,sp,112
    80003bf4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bf6:	89da                	mv	s3,s6
    80003bf8:	bfc9                	j	80003bca <writei+0xe2>
    return -1;
    80003bfa:	557d                	li	a0,-1
}
    80003bfc:	8082                	ret
    return -1;
    80003bfe:	557d                	li	a0,-1
    80003c00:	bfe1                	j	80003bd8 <writei+0xf0>
    return -1;
    80003c02:	557d                	li	a0,-1
    80003c04:	bfd1                	j	80003bd8 <writei+0xf0>

0000000080003c06 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c06:	1141                	addi	sp,sp,-16
    80003c08:	e406                	sd	ra,8(sp)
    80003c0a:	e022                	sd	s0,0(sp)
    80003c0c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c0e:	4639                	li	a2,14
    80003c10:	ffffd097          	auipc	ra,0xffffd
    80003c14:	192080e7          	jalr	402(ra) # 80000da2 <strncmp>
}
    80003c18:	60a2                	ld	ra,8(sp)
    80003c1a:	6402                	ld	s0,0(sp)
    80003c1c:	0141                	addi	sp,sp,16
    80003c1e:	8082                	ret

0000000080003c20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c20:	7139                	addi	sp,sp,-64
    80003c22:	fc06                	sd	ra,56(sp)
    80003c24:	f822                	sd	s0,48(sp)
    80003c26:	f426                	sd	s1,40(sp)
    80003c28:	f04a                	sd	s2,32(sp)
    80003c2a:	ec4e                	sd	s3,24(sp)
    80003c2c:	e852                	sd	s4,16(sp)
    80003c2e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c30:	04451703          	lh	a4,68(a0)
    80003c34:	4785                	li	a5,1
    80003c36:	00f71a63          	bne	a4,a5,80003c4a <dirlookup+0x2a>
    80003c3a:	892a                	mv	s2,a0
    80003c3c:	89ae                	mv	s3,a1
    80003c3e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c40:	457c                	lw	a5,76(a0)
    80003c42:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c44:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c46:	e79d                	bnez	a5,80003c74 <dirlookup+0x54>
    80003c48:	a8a5                	j	80003cc0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c4a:	00005517          	auipc	a0,0x5
    80003c4e:	a2650513          	addi	a0,a0,-1498 # 80008670 <syscalls+0x1a8>
    80003c52:	ffffd097          	auipc	ra,0xffffd
    80003c56:	8ee080e7          	jalr	-1810(ra) # 80000540 <panic>
      panic("dirlookup read");
    80003c5a:	00005517          	auipc	a0,0x5
    80003c5e:	a2e50513          	addi	a0,a0,-1490 # 80008688 <syscalls+0x1c0>
    80003c62:	ffffd097          	auipc	ra,0xffffd
    80003c66:	8de080e7          	jalr	-1826(ra) # 80000540 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c6a:	24c1                	addiw	s1,s1,16
    80003c6c:	04c92783          	lw	a5,76(s2)
    80003c70:	04f4f763          	bgeu	s1,a5,80003cbe <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c74:	4741                	li	a4,16
    80003c76:	86a6                	mv	a3,s1
    80003c78:	fc040613          	addi	a2,s0,-64
    80003c7c:	4581                	li	a1,0
    80003c7e:	854a                	mv	a0,s2
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	d70080e7          	jalr	-656(ra) # 800039f0 <readi>
    80003c88:	47c1                	li	a5,16
    80003c8a:	fcf518e3          	bne	a0,a5,80003c5a <dirlookup+0x3a>
    if(de.inum == 0)
    80003c8e:	fc045783          	lhu	a5,-64(s0)
    80003c92:	dfe1                	beqz	a5,80003c6a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c94:	fc240593          	addi	a1,s0,-62
    80003c98:	854e                	mv	a0,s3
    80003c9a:	00000097          	auipc	ra,0x0
    80003c9e:	f6c080e7          	jalr	-148(ra) # 80003c06 <namecmp>
    80003ca2:	f561                	bnez	a0,80003c6a <dirlookup+0x4a>
      if(poff)
    80003ca4:	000a0463          	beqz	s4,80003cac <dirlookup+0x8c>
        *poff = off;
    80003ca8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cac:	fc045583          	lhu	a1,-64(s0)
    80003cb0:	00092503          	lw	a0,0(s2)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	74e080e7          	jalr	1870(ra) # 80003402 <iget>
    80003cbc:	a011                	j	80003cc0 <dirlookup+0xa0>
  return 0;
    80003cbe:	4501                	li	a0,0
}
    80003cc0:	70e2                	ld	ra,56(sp)
    80003cc2:	7442                	ld	s0,48(sp)
    80003cc4:	74a2                	ld	s1,40(sp)
    80003cc6:	7902                	ld	s2,32(sp)
    80003cc8:	69e2                	ld	s3,24(sp)
    80003cca:	6a42                	ld	s4,16(sp)
    80003ccc:	6121                	addi	sp,sp,64
    80003cce:	8082                	ret

0000000080003cd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003cd0:	711d                	addi	sp,sp,-96
    80003cd2:	ec86                	sd	ra,88(sp)
    80003cd4:	e8a2                	sd	s0,80(sp)
    80003cd6:	e4a6                	sd	s1,72(sp)
    80003cd8:	e0ca                	sd	s2,64(sp)
    80003cda:	fc4e                	sd	s3,56(sp)
    80003cdc:	f852                	sd	s4,48(sp)
    80003cde:	f456                	sd	s5,40(sp)
    80003ce0:	f05a                	sd	s6,32(sp)
    80003ce2:	ec5e                	sd	s7,24(sp)
    80003ce4:	e862                	sd	s8,16(sp)
    80003ce6:	e466                	sd	s9,8(sp)
    80003ce8:	e06a                	sd	s10,0(sp)
    80003cea:	1080                	addi	s0,sp,96
    80003cec:	84aa                	mv	s1,a0
    80003cee:	8b2e                	mv	s6,a1
    80003cf0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003cf2:	00054703          	lbu	a4,0(a0)
    80003cf6:	02f00793          	li	a5,47
    80003cfa:	02f70363          	beq	a4,a5,80003d20 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003cfe:	ffffe097          	auipc	ra,0xffffe
    80003d02:	cc0080e7          	jalr	-832(ra) # 800019be <myproc>
    80003d06:	15853503          	ld	a0,344(a0)
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	9f4080e7          	jalr	-1548(ra) # 800036fe <idup>
    80003d12:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d14:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d18:	4cb5                	li	s9,13
  len = path - s;
    80003d1a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d1c:	4c05                	li	s8,1
    80003d1e:	a87d                	j	80003ddc <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003d20:	4585                	li	a1,1
    80003d22:	4505                	li	a0,1
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	6de080e7          	jalr	1758(ra) # 80003402 <iget>
    80003d2c:	8a2a                	mv	s4,a0
    80003d2e:	b7dd                	j	80003d14 <namex+0x44>
      iunlockput(ip);
    80003d30:	8552                	mv	a0,s4
    80003d32:	00000097          	auipc	ra,0x0
    80003d36:	c6c080e7          	jalr	-916(ra) # 8000399e <iunlockput>
      return 0;
    80003d3a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d3c:	8552                	mv	a0,s4
    80003d3e:	60e6                	ld	ra,88(sp)
    80003d40:	6446                	ld	s0,80(sp)
    80003d42:	64a6                	ld	s1,72(sp)
    80003d44:	6906                	ld	s2,64(sp)
    80003d46:	79e2                	ld	s3,56(sp)
    80003d48:	7a42                	ld	s4,48(sp)
    80003d4a:	7aa2                	ld	s5,40(sp)
    80003d4c:	7b02                	ld	s6,32(sp)
    80003d4e:	6be2                	ld	s7,24(sp)
    80003d50:	6c42                	ld	s8,16(sp)
    80003d52:	6ca2                	ld	s9,8(sp)
    80003d54:	6d02                	ld	s10,0(sp)
    80003d56:	6125                	addi	sp,sp,96
    80003d58:	8082                	ret
      iunlock(ip);
    80003d5a:	8552                	mv	a0,s4
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	aa2080e7          	jalr	-1374(ra) # 800037fe <iunlock>
      return ip;
    80003d64:	bfe1                	j	80003d3c <namex+0x6c>
      iunlockput(ip);
    80003d66:	8552                	mv	a0,s4
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	c36080e7          	jalr	-970(ra) # 8000399e <iunlockput>
      return 0;
    80003d70:	8a4e                	mv	s4,s3
    80003d72:	b7e9                	j	80003d3c <namex+0x6c>
  len = path - s;
    80003d74:	40998633          	sub	a2,s3,s1
    80003d78:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003d7c:	09acd863          	bge	s9,s10,80003e0c <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003d80:	4639                	li	a2,14
    80003d82:	85a6                	mv	a1,s1
    80003d84:	8556                	mv	a0,s5
    80003d86:	ffffd097          	auipc	ra,0xffffd
    80003d8a:	fa8080e7          	jalr	-88(ra) # 80000d2e <memmove>
    80003d8e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003d90:	0004c783          	lbu	a5,0(s1)
    80003d94:	01279763          	bne	a5,s2,80003da2 <namex+0xd2>
    path++;
    80003d98:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d9a:	0004c783          	lbu	a5,0(s1)
    80003d9e:	ff278de3          	beq	a5,s2,80003d98 <namex+0xc8>
    ilock(ip);
    80003da2:	8552                	mv	a0,s4
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	998080e7          	jalr	-1640(ra) # 8000373c <ilock>
    if(ip->type != T_DIR){
    80003dac:	044a1783          	lh	a5,68(s4)
    80003db0:	f98790e3          	bne	a5,s8,80003d30 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003db4:	000b0563          	beqz	s6,80003dbe <namex+0xee>
    80003db8:	0004c783          	lbu	a5,0(s1)
    80003dbc:	dfd9                	beqz	a5,80003d5a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dbe:	865e                	mv	a2,s7
    80003dc0:	85d6                	mv	a1,s5
    80003dc2:	8552                	mv	a0,s4
    80003dc4:	00000097          	auipc	ra,0x0
    80003dc8:	e5c080e7          	jalr	-420(ra) # 80003c20 <dirlookup>
    80003dcc:	89aa                	mv	s3,a0
    80003dce:	dd41                	beqz	a0,80003d66 <namex+0x96>
    iunlockput(ip);
    80003dd0:	8552                	mv	a0,s4
    80003dd2:	00000097          	auipc	ra,0x0
    80003dd6:	bcc080e7          	jalr	-1076(ra) # 8000399e <iunlockput>
    ip = next;
    80003dda:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003ddc:	0004c783          	lbu	a5,0(s1)
    80003de0:	01279763          	bne	a5,s2,80003dee <namex+0x11e>
    path++;
    80003de4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003de6:	0004c783          	lbu	a5,0(s1)
    80003dea:	ff278de3          	beq	a5,s2,80003de4 <namex+0x114>
  if(*path == 0)
    80003dee:	cb9d                	beqz	a5,80003e24 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003df0:	0004c783          	lbu	a5,0(s1)
    80003df4:	89a6                	mv	s3,s1
  len = path - s;
    80003df6:	8d5e                	mv	s10,s7
    80003df8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003dfa:	01278963          	beq	a5,s2,80003e0c <namex+0x13c>
    80003dfe:	dbbd                	beqz	a5,80003d74 <namex+0xa4>
    path++;
    80003e00:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e02:	0009c783          	lbu	a5,0(s3)
    80003e06:	ff279ce3          	bne	a5,s2,80003dfe <namex+0x12e>
    80003e0a:	b7ad                	j	80003d74 <namex+0xa4>
    memmove(name, s, len);
    80003e0c:	2601                	sext.w	a2,a2
    80003e0e:	85a6                	mv	a1,s1
    80003e10:	8556                	mv	a0,s5
    80003e12:	ffffd097          	auipc	ra,0xffffd
    80003e16:	f1c080e7          	jalr	-228(ra) # 80000d2e <memmove>
    name[len] = 0;
    80003e1a:	9d56                	add	s10,s10,s5
    80003e1c:	000d0023          	sb	zero,0(s10)
    80003e20:	84ce                	mv	s1,s3
    80003e22:	b7bd                	j	80003d90 <namex+0xc0>
  if(nameiparent){
    80003e24:	f00b0ce3          	beqz	s6,80003d3c <namex+0x6c>
    iput(ip);
    80003e28:	8552                	mv	a0,s4
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	acc080e7          	jalr	-1332(ra) # 800038f6 <iput>
    return 0;
    80003e32:	4a01                	li	s4,0
    80003e34:	b721                	j	80003d3c <namex+0x6c>

0000000080003e36 <dirlink>:
{
    80003e36:	7139                	addi	sp,sp,-64
    80003e38:	fc06                	sd	ra,56(sp)
    80003e3a:	f822                	sd	s0,48(sp)
    80003e3c:	f426                	sd	s1,40(sp)
    80003e3e:	f04a                	sd	s2,32(sp)
    80003e40:	ec4e                	sd	s3,24(sp)
    80003e42:	e852                	sd	s4,16(sp)
    80003e44:	0080                	addi	s0,sp,64
    80003e46:	892a                	mv	s2,a0
    80003e48:	8a2e                	mv	s4,a1
    80003e4a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e4c:	4601                	li	a2,0
    80003e4e:	00000097          	auipc	ra,0x0
    80003e52:	dd2080e7          	jalr	-558(ra) # 80003c20 <dirlookup>
    80003e56:	e93d                	bnez	a0,80003ecc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e58:	04c92483          	lw	s1,76(s2)
    80003e5c:	c49d                	beqz	s1,80003e8a <dirlink+0x54>
    80003e5e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e60:	4741                	li	a4,16
    80003e62:	86a6                	mv	a3,s1
    80003e64:	fc040613          	addi	a2,s0,-64
    80003e68:	4581                	li	a1,0
    80003e6a:	854a                	mv	a0,s2
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	b84080e7          	jalr	-1148(ra) # 800039f0 <readi>
    80003e74:	47c1                	li	a5,16
    80003e76:	06f51163          	bne	a0,a5,80003ed8 <dirlink+0xa2>
    if(de.inum == 0)
    80003e7a:	fc045783          	lhu	a5,-64(s0)
    80003e7e:	c791                	beqz	a5,80003e8a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e80:	24c1                	addiw	s1,s1,16
    80003e82:	04c92783          	lw	a5,76(s2)
    80003e86:	fcf4ede3          	bltu	s1,a5,80003e60 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e8a:	4639                	li	a2,14
    80003e8c:	85d2                	mv	a1,s4
    80003e8e:	fc240513          	addi	a0,s0,-62
    80003e92:	ffffd097          	auipc	ra,0xffffd
    80003e96:	f4c080e7          	jalr	-180(ra) # 80000dde <strncpy>
  de.inum = inum;
    80003e9a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e9e:	4741                	li	a4,16
    80003ea0:	86a6                	mv	a3,s1
    80003ea2:	fc040613          	addi	a2,s0,-64
    80003ea6:	4581                	li	a1,0
    80003ea8:	854a                	mv	a0,s2
    80003eaa:	00000097          	auipc	ra,0x0
    80003eae:	c3e080e7          	jalr	-962(ra) # 80003ae8 <writei>
    80003eb2:	1541                	addi	a0,a0,-16
    80003eb4:	00a03533          	snez	a0,a0
    80003eb8:	40a00533          	neg	a0,a0
}
    80003ebc:	70e2                	ld	ra,56(sp)
    80003ebe:	7442                	ld	s0,48(sp)
    80003ec0:	74a2                	ld	s1,40(sp)
    80003ec2:	7902                	ld	s2,32(sp)
    80003ec4:	69e2                	ld	s3,24(sp)
    80003ec6:	6a42                	ld	s4,16(sp)
    80003ec8:	6121                	addi	sp,sp,64
    80003eca:	8082                	ret
    iput(ip);
    80003ecc:	00000097          	auipc	ra,0x0
    80003ed0:	a2a080e7          	jalr	-1494(ra) # 800038f6 <iput>
    return -1;
    80003ed4:	557d                	li	a0,-1
    80003ed6:	b7dd                	j	80003ebc <dirlink+0x86>
      panic("dirlink read");
    80003ed8:	00004517          	auipc	a0,0x4
    80003edc:	7c050513          	addi	a0,a0,1984 # 80008698 <syscalls+0x1d0>
    80003ee0:	ffffc097          	auipc	ra,0xffffc
    80003ee4:	660080e7          	jalr	1632(ra) # 80000540 <panic>

0000000080003ee8 <namei>:

struct inode*
namei(char *path)
{
    80003ee8:	1101                	addi	sp,sp,-32
    80003eea:	ec06                	sd	ra,24(sp)
    80003eec:	e822                	sd	s0,16(sp)
    80003eee:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ef0:	fe040613          	addi	a2,s0,-32
    80003ef4:	4581                	li	a1,0
    80003ef6:	00000097          	auipc	ra,0x0
    80003efa:	dda080e7          	jalr	-550(ra) # 80003cd0 <namex>
}
    80003efe:	60e2                	ld	ra,24(sp)
    80003f00:	6442                	ld	s0,16(sp)
    80003f02:	6105                	addi	sp,sp,32
    80003f04:	8082                	ret

0000000080003f06 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f06:	1141                	addi	sp,sp,-16
    80003f08:	e406                	sd	ra,8(sp)
    80003f0a:	e022                	sd	s0,0(sp)
    80003f0c:	0800                	addi	s0,sp,16
    80003f0e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f10:	4585                	li	a1,1
    80003f12:	00000097          	auipc	ra,0x0
    80003f16:	dbe080e7          	jalr	-578(ra) # 80003cd0 <namex>
}
    80003f1a:	60a2                	ld	ra,8(sp)
    80003f1c:	6402                	ld	s0,0(sp)
    80003f1e:	0141                	addi	sp,sp,16
    80003f20:	8082                	ret

0000000080003f22 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f22:	1101                	addi	sp,sp,-32
    80003f24:	ec06                	sd	ra,24(sp)
    80003f26:	e822                	sd	s0,16(sp)
    80003f28:	e426                	sd	s1,8(sp)
    80003f2a:	e04a                	sd	s2,0(sp)
    80003f2c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f2e:	0001d917          	auipc	s2,0x1d
    80003f32:	e7290913          	addi	s2,s2,-398 # 80020da0 <log>
    80003f36:	01892583          	lw	a1,24(s2)
    80003f3a:	02892503          	lw	a0,40(s2)
    80003f3e:	fffff097          	auipc	ra,0xfffff
    80003f42:	fe6080e7          	jalr	-26(ra) # 80002f24 <bread>
    80003f46:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f48:	02c92683          	lw	a3,44(s2)
    80003f4c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f4e:	02d05863          	blez	a3,80003f7e <write_head+0x5c>
    80003f52:	0001d797          	auipc	a5,0x1d
    80003f56:	e7e78793          	addi	a5,a5,-386 # 80020dd0 <log+0x30>
    80003f5a:	05c50713          	addi	a4,a0,92
    80003f5e:	36fd                	addiw	a3,a3,-1
    80003f60:	02069613          	slli	a2,a3,0x20
    80003f64:	01e65693          	srli	a3,a2,0x1e
    80003f68:	0001d617          	auipc	a2,0x1d
    80003f6c:	e6c60613          	addi	a2,a2,-404 # 80020dd4 <log+0x34>
    80003f70:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f72:	4390                	lw	a2,0(a5)
    80003f74:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f76:	0791                	addi	a5,a5,4
    80003f78:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003f7a:	fed79ce3          	bne	a5,a3,80003f72 <write_head+0x50>
  }
  bwrite(buf);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	fffff097          	auipc	ra,0xfffff
    80003f84:	096080e7          	jalr	150(ra) # 80003016 <bwrite>
  brelse(buf);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	fffff097          	auipc	ra,0xfffff
    80003f8e:	0ca080e7          	jalr	202(ra) # 80003054 <brelse>
}
    80003f92:	60e2                	ld	ra,24(sp)
    80003f94:	6442                	ld	s0,16(sp)
    80003f96:	64a2                	ld	s1,8(sp)
    80003f98:	6902                	ld	s2,0(sp)
    80003f9a:	6105                	addi	sp,sp,32
    80003f9c:	8082                	ret

0000000080003f9e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f9e:	0001d797          	auipc	a5,0x1d
    80003fa2:	e2e7a783          	lw	a5,-466(a5) # 80020dcc <log+0x2c>
    80003fa6:	0af05d63          	blez	a5,80004060 <install_trans+0xc2>
{
    80003faa:	7139                	addi	sp,sp,-64
    80003fac:	fc06                	sd	ra,56(sp)
    80003fae:	f822                	sd	s0,48(sp)
    80003fb0:	f426                	sd	s1,40(sp)
    80003fb2:	f04a                	sd	s2,32(sp)
    80003fb4:	ec4e                	sd	s3,24(sp)
    80003fb6:	e852                	sd	s4,16(sp)
    80003fb8:	e456                	sd	s5,8(sp)
    80003fba:	e05a                	sd	s6,0(sp)
    80003fbc:	0080                	addi	s0,sp,64
    80003fbe:	8b2a                	mv	s6,a0
    80003fc0:	0001da97          	auipc	s5,0x1d
    80003fc4:	e10a8a93          	addi	s5,s5,-496 # 80020dd0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fc8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fca:	0001d997          	auipc	s3,0x1d
    80003fce:	dd698993          	addi	s3,s3,-554 # 80020da0 <log>
    80003fd2:	a00d                	j	80003ff4 <install_trans+0x56>
    brelse(lbuf);
    80003fd4:	854a                	mv	a0,s2
    80003fd6:	fffff097          	auipc	ra,0xfffff
    80003fda:	07e080e7          	jalr	126(ra) # 80003054 <brelse>
    brelse(dbuf);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	fffff097          	auipc	ra,0xfffff
    80003fe4:	074080e7          	jalr	116(ra) # 80003054 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fe8:	2a05                	addiw	s4,s4,1
    80003fea:	0a91                	addi	s5,s5,4
    80003fec:	02c9a783          	lw	a5,44(s3)
    80003ff0:	04fa5e63          	bge	s4,a5,8000404c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003ff4:	0189a583          	lw	a1,24(s3)
    80003ff8:	014585bb          	addw	a1,a1,s4
    80003ffc:	2585                	addiw	a1,a1,1
    80003ffe:	0289a503          	lw	a0,40(s3)
    80004002:	fffff097          	auipc	ra,0xfffff
    80004006:	f22080e7          	jalr	-222(ra) # 80002f24 <bread>
    8000400a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000400c:	000aa583          	lw	a1,0(s5)
    80004010:	0289a503          	lw	a0,40(s3)
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	f10080e7          	jalr	-240(ra) # 80002f24 <bread>
    8000401c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000401e:	40000613          	li	a2,1024
    80004022:	05890593          	addi	a1,s2,88
    80004026:	05850513          	addi	a0,a0,88
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	d04080e7          	jalr	-764(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    80004032:	8526                	mv	a0,s1
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	fe2080e7          	jalr	-30(ra) # 80003016 <bwrite>
    if(recovering == 0)
    8000403c:	f80b1ce3          	bnez	s6,80003fd4 <install_trans+0x36>
      bunpin(dbuf);
    80004040:	8526                	mv	a0,s1
    80004042:	fffff097          	auipc	ra,0xfffff
    80004046:	0ec080e7          	jalr	236(ra) # 8000312e <bunpin>
    8000404a:	b769                	j	80003fd4 <install_trans+0x36>
}
    8000404c:	70e2                	ld	ra,56(sp)
    8000404e:	7442                	ld	s0,48(sp)
    80004050:	74a2                	ld	s1,40(sp)
    80004052:	7902                	ld	s2,32(sp)
    80004054:	69e2                	ld	s3,24(sp)
    80004056:	6a42                	ld	s4,16(sp)
    80004058:	6aa2                	ld	s5,8(sp)
    8000405a:	6b02                	ld	s6,0(sp)
    8000405c:	6121                	addi	sp,sp,64
    8000405e:	8082                	ret
    80004060:	8082                	ret

0000000080004062 <initlog>:
{
    80004062:	7179                	addi	sp,sp,-48
    80004064:	f406                	sd	ra,40(sp)
    80004066:	f022                	sd	s0,32(sp)
    80004068:	ec26                	sd	s1,24(sp)
    8000406a:	e84a                	sd	s2,16(sp)
    8000406c:	e44e                	sd	s3,8(sp)
    8000406e:	1800                	addi	s0,sp,48
    80004070:	892a                	mv	s2,a0
    80004072:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004074:	0001d497          	auipc	s1,0x1d
    80004078:	d2c48493          	addi	s1,s1,-724 # 80020da0 <log>
    8000407c:	00004597          	auipc	a1,0x4
    80004080:	62c58593          	addi	a1,a1,1580 # 800086a8 <syscalls+0x1e0>
    80004084:	8526                	mv	a0,s1
    80004086:	ffffd097          	auipc	ra,0xffffd
    8000408a:	ac0080e7          	jalr	-1344(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    8000408e:	0149a583          	lw	a1,20(s3)
    80004092:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004094:	0109a783          	lw	a5,16(s3)
    80004098:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000409a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000409e:	854a                	mv	a0,s2
    800040a0:	fffff097          	auipc	ra,0xfffff
    800040a4:	e84080e7          	jalr	-380(ra) # 80002f24 <bread>
  log.lh.n = lh->n;
    800040a8:	4d34                	lw	a3,88(a0)
    800040aa:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040ac:	02d05663          	blez	a3,800040d8 <initlog+0x76>
    800040b0:	05c50793          	addi	a5,a0,92
    800040b4:	0001d717          	auipc	a4,0x1d
    800040b8:	d1c70713          	addi	a4,a4,-740 # 80020dd0 <log+0x30>
    800040bc:	36fd                	addiw	a3,a3,-1
    800040be:	02069613          	slli	a2,a3,0x20
    800040c2:	01e65693          	srli	a3,a2,0x1e
    800040c6:	06050613          	addi	a2,a0,96
    800040ca:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800040cc:	4390                	lw	a2,0(a5)
    800040ce:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040d0:	0791                	addi	a5,a5,4
    800040d2:	0711                	addi	a4,a4,4
    800040d4:	fed79ce3          	bne	a5,a3,800040cc <initlog+0x6a>
  brelse(buf);
    800040d8:	fffff097          	auipc	ra,0xfffff
    800040dc:	f7c080e7          	jalr	-132(ra) # 80003054 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800040e0:	4505                	li	a0,1
    800040e2:	00000097          	auipc	ra,0x0
    800040e6:	ebc080e7          	jalr	-324(ra) # 80003f9e <install_trans>
  log.lh.n = 0;
    800040ea:	0001d797          	auipc	a5,0x1d
    800040ee:	ce07a123          	sw	zero,-798(a5) # 80020dcc <log+0x2c>
  write_head(); // clear the log
    800040f2:	00000097          	auipc	ra,0x0
    800040f6:	e30080e7          	jalr	-464(ra) # 80003f22 <write_head>
}
    800040fa:	70a2                	ld	ra,40(sp)
    800040fc:	7402                	ld	s0,32(sp)
    800040fe:	64e2                	ld	s1,24(sp)
    80004100:	6942                	ld	s2,16(sp)
    80004102:	69a2                	ld	s3,8(sp)
    80004104:	6145                	addi	sp,sp,48
    80004106:	8082                	ret

0000000080004108 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004108:	1101                	addi	sp,sp,-32
    8000410a:	ec06                	sd	ra,24(sp)
    8000410c:	e822                	sd	s0,16(sp)
    8000410e:	e426                	sd	s1,8(sp)
    80004110:	e04a                	sd	s2,0(sp)
    80004112:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004114:	0001d517          	auipc	a0,0x1d
    80004118:	c8c50513          	addi	a0,a0,-884 # 80020da0 <log>
    8000411c:	ffffd097          	auipc	ra,0xffffd
    80004120:	aba080e7          	jalr	-1350(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    80004124:	0001d497          	auipc	s1,0x1d
    80004128:	c7c48493          	addi	s1,s1,-900 # 80020da0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000412c:	4979                	li	s2,30
    8000412e:	a039                	j	8000413c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004130:	85a6                	mv	a1,s1
    80004132:	8526                	mv	a0,s1
    80004134:	ffffe097          	auipc	ra,0xffffe
    80004138:	f7a080e7          	jalr	-134(ra) # 800020ae <sleep>
    if(log.committing){
    8000413c:	50dc                	lw	a5,36(s1)
    8000413e:	fbed                	bnez	a5,80004130 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004140:	5098                	lw	a4,32(s1)
    80004142:	2705                	addiw	a4,a4,1
    80004144:	0007069b          	sext.w	a3,a4
    80004148:	0027179b          	slliw	a5,a4,0x2
    8000414c:	9fb9                	addw	a5,a5,a4
    8000414e:	0017979b          	slliw	a5,a5,0x1
    80004152:	54d8                	lw	a4,44(s1)
    80004154:	9fb9                	addw	a5,a5,a4
    80004156:	00f95963          	bge	s2,a5,80004168 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000415a:	85a6                	mv	a1,s1
    8000415c:	8526                	mv	a0,s1
    8000415e:	ffffe097          	auipc	ra,0xffffe
    80004162:	f50080e7          	jalr	-176(ra) # 800020ae <sleep>
    80004166:	bfd9                	j	8000413c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004168:	0001d517          	auipc	a0,0x1d
    8000416c:	c3850513          	addi	a0,a0,-968 # 80020da0 <log>
    80004170:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004172:	ffffd097          	auipc	ra,0xffffd
    80004176:	b18080e7          	jalr	-1256(ra) # 80000c8a <release>
      break;
    }
  }
}
    8000417a:	60e2                	ld	ra,24(sp)
    8000417c:	6442                	ld	s0,16(sp)
    8000417e:	64a2                	ld	s1,8(sp)
    80004180:	6902                	ld	s2,0(sp)
    80004182:	6105                	addi	sp,sp,32
    80004184:	8082                	ret

0000000080004186 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004186:	7139                	addi	sp,sp,-64
    80004188:	fc06                	sd	ra,56(sp)
    8000418a:	f822                	sd	s0,48(sp)
    8000418c:	f426                	sd	s1,40(sp)
    8000418e:	f04a                	sd	s2,32(sp)
    80004190:	ec4e                	sd	s3,24(sp)
    80004192:	e852                	sd	s4,16(sp)
    80004194:	e456                	sd	s5,8(sp)
    80004196:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004198:	0001d497          	auipc	s1,0x1d
    8000419c:	c0848493          	addi	s1,s1,-1016 # 80020da0 <log>
    800041a0:	8526                	mv	a0,s1
    800041a2:	ffffd097          	auipc	ra,0xffffd
    800041a6:	a34080e7          	jalr	-1484(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    800041aa:	509c                	lw	a5,32(s1)
    800041ac:	37fd                	addiw	a5,a5,-1
    800041ae:	0007891b          	sext.w	s2,a5
    800041b2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041b4:	50dc                	lw	a5,36(s1)
    800041b6:	e7b9                	bnez	a5,80004204 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041b8:	04091e63          	bnez	s2,80004214 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041bc:	0001d497          	auipc	s1,0x1d
    800041c0:	be448493          	addi	s1,s1,-1052 # 80020da0 <log>
    800041c4:	4785                	li	a5,1
    800041c6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800041c8:	8526                	mv	a0,s1
    800041ca:	ffffd097          	auipc	ra,0xffffd
    800041ce:	ac0080e7          	jalr	-1344(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041d2:	54dc                	lw	a5,44(s1)
    800041d4:	06f04763          	bgtz	a5,80004242 <end_op+0xbc>
    acquire(&log.lock);
    800041d8:	0001d497          	auipc	s1,0x1d
    800041dc:	bc848493          	addi	s1,s1,-1080 # 80020da0 <log>
    800041e0:	8526                	mv	a0,s1
    800041e2:	ffffd097          	auipc	ra,0xffffd
    800041e6:	9f4080e7          	jalr	-1548(ra) # 80000bd6 <acquire>
    log.committing = 0;
    800041ea:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800041ee:	8526                	mv	a0,s1
    800041f0:	ffffe097          	auipc	ra,0xffffe
    800041f4:	f30080e7          	jalr	-208(ra) # 80002120 <wakeup>
    release(&log.lock);
    800041f8:	8526                	mv	a0,s1
    800041fa:	ffffd097          	auipc	ra,0xffffd
    800041fe:	a90080e7          	jalr	-1392(ra) # 80000c8a <release>
}
    80004202:	a03d                	j	80004230 <end_op+0xaa>
    panic("log.committing");
    80004204:	00004517          	auipc	a0,0x4
    80004208:	4ac50513          	addi	a0,a0,1196 # 800086b0 <syscalls+0x1e8>
    8000420c:	ffffc097          	auipc	ra,0xffffc
    80004210:	334080e7          	jalr	820(ra) # 80000540 <panic>
    wakeup(&log);
    80004214:	0001d497          	auipc	s1,0x1d
    80004218:	b8c48493          	addi	s1,s1,-1140 # 80020da0 <log>
    8000421c:	8526                	mv	a0,s1
    8000421e:	ffffe097          	auipc	ra,0xffffe
    80004222:	f02080e7          	jalr	-254(ra) # 80002120 <wakeup>
  release(&log.lock);
    80004226:	8526                	mv	a0,s1
    80004228:	ffffd097          	auipc	ra,0xffffd
    8000422c:	a62080e7          	jalr	-1438(ra) # 80000c8a <release>
}
    80004230:	70e2                	ld	ra,56(sp)
    80004232:	7442                	ld	s0,48(sp)
    80004234:	74a2                	ld	s1,40(sp)
    80004236:	7902                	ld	s2,32(sp)
    80004238:	69e2                	ld	s3,24(sp)
    8000423a:	6a42                	ld	s4,16(sp)
    8000423c:	6aa2                	ld	s5,8(sp)
    8000423e:	6121                	addi	sp,sp,64
    80004240:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004242:	0001da97          	auipc	s5,0x1d
    80004246:	b8ea8a93          	addi	s5,s5,-1138 # 80020dd0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000424a:	0001da17          	auipc	s4,0x1d
    8000424e:	b56a0a13          	addi	s4,s4,-1194 # 80020da0 <log>
    80004252:	018a2583          	lw	a1,24(s4)
    80004256:	012585bb          	addw	a1,a1,s2
    8000425a:	2585                	addiw	a1,a1,1
    8000425c:	028a2503          	lw	a0,40(s4)
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	cc4080e7          	jalr	-828(ra) # 80002f24 <bread>
    80004268:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000426a:	000aa583          	lw	a1,0(s5)
    8000426e:	028a2503          	lw	a0,40(s4)
    80004272:	fffff097          	auipc	ra,0xfffff
    80004276:	cb2080e7          	jalr	-846(ra) # 80002f24 <bread>
    8000427a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000427c:	40000613          	li	a2,1024
    80004280:	05850593          	addi	a1,a0,88
    80004284:	05848513          	addi	a0,s1,88
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	aa6080e7          	jalr	-1370(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    80004290:	8526                	mv	a0,s1
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	d84080e7          	jalr	-636(ra) # 80003016 <bwrite>
    brelse(from);
    8000429a:	854e                	mv	a0,s3
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	db8080e7          	jalr	-584(ra) # 80003054 <brelse>
    brelse(to);
    800042a4:	8526                	mv	a0,s1
    800042a6:	fffff097          	auipc	ra,0xfffff
    800042aa:	dae080e7          	jalr	-594(ra) # 80003054 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042ae:	2905                	addiw	s2,s2,1
    800042b0:	0a91                	addi	s5,s5,4
    800042b2:	02ca2783          	lw	a5,44(s4)
    800042b6:	f8f94ee3          	blt	s2,a5,80004252 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042ba:	00000097          	auipc	ra,0x0
    800042be:	c68080e7          	jalr	-920(ra) # 80003f22 <write_head>
    install_trans(0); // Now install writes to home locations
    800042c2:	4501                	li	a0,0
    800042c4:	00000097          	auipc	ra,0x0
    800042c8:	cda080e7          	jalr	-806(ra) # 80003f9e <install_trans>
    log.lh.n = 0;
    800042cc:	0001d797          	auipc	a5,0x1d
    800042d0:	b007a023          	sw	zero,-1280(a5) # 80020dcc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800042d4:	00000097          	auipc	ra,0x0
    800042d8:	c4e080e7          	jalr	-946(ra) # 80003f22 <write_head>
    800042dc:	bdf5                	j	800041d8 <end_op+0x52>

00000000800042de <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042de:	1101                	addi	sp,sp,-32
    800042e0:	ec06                	sd	ra,24(sp)
    800042e2:	e822                	sd	s0,16(sp)
    800042e4:	e426                	sd	s1,8(sp)
    800042e6:	e04a                	sd	s2,0(sp)
    800042e8:	1000                	addi	s0,sp,32
    800042ea:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800042ec:	0001d917          	auipc	s2,0x1d
    800042f0:	ab490913          	addi	s2,s2,-1356 # 80020da0 <log>
    800042f4:	854a                	mv	a0,s2
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	8e0080e7          	jalr	-1824(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800042fe:	02c92603          	lw	a2,44(s2)
    80004302:	47f5                	li	a5,29
    80004304:	06c7c563          	blt	a5,a2,8000436e <log_write+0x90>
    80004308:	0001d797          	auipc	a5,0x1d
    8000430c:	ab47a783          	lw	a5,-1356(a5) # 80020dbc <log+0x1c>
    80004310:	37fd                	addiw	a5,a5,-1
    80004312:	04f65e63          	bge	a2,a5,8000436e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004316:	0001d797          	auipc	a5,0x1d
    8000431a:	aaa7a783          	lw	a5,-1366(a5) # 80020dc0 <log+0x20>
    8000431e:	06f05063          	blez	a5,8000437e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004322:	4781                	li	a5,0
    80004324:	06c05563          	blez	a2,8000438e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004328:	44cc                	lw	a1,12(s1)
    8000432a:	0001d717          	auipc	a4,0x1d
    8000432e:	aa670713          	addi	a4,a4,-1370 # 80020dd0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004332:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004334:	4314                	lw	a3,0(a4)
    80004336:	04b68c63          	beq	a3,a1,8000438e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000433a:	2785                	addiw	a5,a5,1
    8000433c:	0711                	addi	a4,a4,4
    8000433e:	fef61be3          	bne	a2,a5,80004334 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004342:	0621                	addi	a2,a2,8
    80004344:	060a                	slli	a2,a2,0x2
    80004346:	0001d797          	auipc	a5,0x1d
    8000434a:	a5a78793          	addi	a5,a5,-1446 # 80020da0 <log>
    8000434e:	97b2                	add	a5,a5,a2
    80004350:	44d8                	lw	a4,12(s1)
    80004352:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004354:	8526                	mv	a0,s1
    80004356:	fffff097          	auipc	ra,0xfffff
    8000435a:	d9c080e7          	jalr	-612(ra) # 800030f2 <bpin>
    log.lh.n++;
    8000435e:	0001d717          	auipc	a4,0x1d
    80004362:	a4270713          	addi	a4,a4,-1470 # 80020da0 <log>
    80004366:	575c                	lw	a5,44(a4)
    80004368:	2785                	addiw	a5,a5,1
    8000436a:	d75c                	sw	a5,44(a4)
    8000436c:	a82d                	j	800043a6 <log_write+0xc8>
    panic("too big a transaction");
    8000436e:	00004517          	auipc	a0,0x4
    80004372:	35250513          	addi	a0,a0,850 # 800086c0 <syscalls+0x1f8>
    80004376:	ffffc097          	auipc	ra,0xffffc
    8000437a:	1ca080e7          	jalr	458(ra) # 80000540 <panic>
    panic("log_write outside of trans");
    8000437e:	00004517          	auipc	a0,0x4
    80004382:	35a50513          	addi	a0,a0,858 # 800086d8 <syscalls+0x210>
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	1ba080e7          	jalr	442(ra) # 80000540 <panic>
  log.lh.block[i] = b->blockno;
    8000438e:	00878693          	addi	a3,a5,8
    80004392:	068a                	slli	a3,a3,0x2
    80004394:	0001d717          	auipc	a4,0x1d
    80004398:	a0c70713          	addi	a4,a4,-1524 # 80020da0 <log>
    8000439c:	9736                	add	a4,a4,a3
    8000439e:	44d4                	lw	a3,12(s1)
    800043a0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800043a2:	faf609e3          	beq	a2,a5,80004354 <log_write+0x76>
  }
  release(&log.lock);
    800043a6:	0001d517          	auipc	a0,0x1d
    800043aa:	9fa50513          	addi	a0,a0,-1542 # 80020da0 <log>
    800043ae:	ffffd097          	auipc	ra,0xffffd
    800043b2:	8dc080e7          	jalr	-1828(ra) # 80000c8a <release>
}
    800043b6:	60e2                	ld	ra,24(sp)
    800043b8:	6442                	ld	s0,16(sp)
    800043ba:	64a2                	ld	s1,8(sp)
    800043bc:	6902                	ld	s2,0(sp)
    800043be:	6105                	addi	sp,sp,32
    800043c0:	8082                	ret

00000000800043c2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043c2:	1101                	addi	sp,sp,-32
    800043c4:	ec06                	sd	ra,24(sp)
    800043c6:	e822                	sd	s0,16(sp)
    800043c8:	e426                	sd	s1,8(sp)
    800043ca:	e04a                	sd	s2,0(sp)
    800043cc:	1000                	addi	s0,sp,32
    800043ce:	84aa                	mv	s1,a0
    800043d0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043d2:	00004597          	auipc	a1,0x4
    800043d6:	32658593          	addi	a1,a1,806 # 800086f8 <syscalls+0x230>
    800043da:	0521                	addi	a0,a0,8
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	76a080e7          	jalr	1898(ra) # 80000b46 <initlock>
  lk->name = name;
    800043e4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800043e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043ec:	0204a423          	sw	zero,40(s1)
}
    800043f0:	60e2                	ld	ra,24(sp)
    800043f2:	6442                	ld	s0,16(sp)
    800043f4:	64a2                	ld	s1,8(sp)
    800043f6:	6902                	ld	s2,0(sp)
    800043f8:	6105                	addi	sp,sp,32
    800043fa:	8082                	ret

00000000800043fc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800043fc:	1101                	addi	sp,sp,-32
    800043fe:	ec06                	sd	ra,24(sp)
    80004400:	e822                	sd	s0,16(sp)
    80004402:	e426                	sd	s1,8(sp)
    80004404:	e04a                	sd	s2,0(sp)
    80004406:	1000                	addi	s0,sp,32
    80004408:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000440a:	00850913          	addi	s2,a0,8
    8000440e:	854a                	mv	a0,s2
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	7c6080e7          	jalr	1990(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    80004418:	409c                	lw	a5,0(s1)
    8000441a:	cb89                	beqz	a5,8000442c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000441c:	85ca                	mv	a1,s2
    8000441e:	8526                	mv	a0,s1
    80004420:	ffffe097          	auipc	ra,0xffffe
    80004424:	c8e080e7          	jalr	-882(ra) # 800020ae <sleep>
  while (lk->locked) {
    80004428:	409c                	lw	a5,0(s1)
    8000442a:	fbed                	bnez	a5,8000441c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000442c:	4785                	li	a5,1
    8000442e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004430:	ffffd097          	auipc	ra,0xffffd
    80004434:	58e080e7          	jalr	1422(ra) # 800019be <myproc>
    80004438:	591c                	lw	a5,48(a0)
    8000443a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000443c:	854a                	mv	a0,s2
    8000443e:	ffffd097          	auipc	ra,0xffffd
    80004442:	84c080e7          	jalr	-1972(ra) # 80000c8a <release>
}
    80004446:	60e2                	ld	ra,24(sp)
    80004448:	6442                	ld	s0,16(sp)
    8000444a:	64a2                	ld	s1,8(sp)
    8000444c:	6902                	ld	s2,0(sp)
    8000444e:	6105                	addi	sp,sp,32
    80004450:	8082                	ret

0000000080004452 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004452:	1101                	addi	sp,sp,-32
    80004454:	ec06                	sd	ra,24(sp)
    80004456:	e822                	sd	s0,16(sp)
    80004458:	e426                	sd	s1,8(sp)
    8000445a:	e04a                	sd	s2,0(sp)
    8000445c:	1000                	addi	s0,sp,32
    8000445e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004460:	00850913          	addi	s2,a0,8
    80004464:	854a                	mv	a0,s2
    80004466:	ffffc097          	auipc	ra,0xffffc
    8000446a:	770080e7          	jalr	1904(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    8000446e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004472:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004476:	8526                	mv	a0,s1
    80004478:	ffffe097          	auipc	ra,0xffffe
    8000447c:	ca8080e7          	jalr	-856(ra) # 80002120 <wakeup>
  release(&lk->lk);
    80004480:	854a                	mv	a0,s2
    80004482:	ffffd097          	auipc	ra,0xffffd
    80004486:	808080e7          	jalr	-2040(ra) # 80000c8a <release>
}
    8000448a:	60e2                	ld	ra,24(sp)
    8000448c:	6442                	ld	s0,16(sp)
    8000448e:	64a2                	ld	s1,8(sp)
    80004490:	6902                	ld	s2,0(sp)
    80004492:	6105                	addi	sp,sp,32
    80004494:	8082                	ret

0000000080004496 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004496:	7179                	addi	sp,sp,-48
    80004498:	f406                	sd	ra,40(sp)
    8000449a:	f022                	sd	s0,32(sp)
    8000449c:	ec26                	sd	s1,24(sp)
    8000449e:	e84a                	sd	s2,16(sp)
    800044a0:	e44e                	sd	s3,8(sp)
    800044a2:	1800                	addi	s0,sp,48
    800044a4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044a6:	00850913          	addi	s2,a0,8
    800044aa:	854a                	mv	a0,s2
    800044ac:	ffffc097          	auipc	ra,0xffffc
    800044b0:	72a080e7          	jalr	1834(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044b4:	409c                	lw	a5,0(s1)
    800044b6:	ef99                	bnez	a5,800044d4 <holdingsleep+0x3e>
    800044b8:	4481                	li	s1,0
  release(&lk->lk);
    800044ba:	854a                	mv	a0,s2
    800044bc:	ffffc097          	auipc	ra,0xffffc
    800044c0:	7ce080e7          	jalr	1998(ra) # 80000c8a <release>
  return r;
}
    800044c4:	8526                	mv	a0,s1
    800044c6:	70a2                	ld	ra,40(sp)
    800044c8:	7402                	ld	s0,32(sp)
    800044ca:	64e2                	ld	s1,24(sp)
    800044cc:	6942                	ld	s2,16(sp)
    800044ce:	69a2                	ld	s3,8(sp)
    800044d0:	6145                	addi	sp,sp,48
    800044d2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044d4:	0284a983          	lw	s3,40(s1)
    800044d8:	ffffd097          	auipc	ra,0xffffd
    800044dc:	4e6080e7          	jalr	1254(ra) # 800019be <myproc>
    800044e0:	5904                	lw	s1,48(a0)
    800044e2:	413484b3          	sub	s1,s1,s3
    800044e6:	0014b493          	seqz	s1,s1
    800044ea:	bfc1                	j	800044ba <holdingsleep+0x24>

00000000800044ec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800044ec:	1141                	addi	sp,sp,-16
    800044ee:	e406                	sd	ra,8(sp)
    800044f0:	e022                	sd	s0,0(sp)
    800044f2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800044f4:	00004597          	auipc	a1,0x4
    800044f8:	21458593          	addi	a1,a1,532 # 80008708 <syscalls+0x240>
    800044fc:	0001d517          	auipc	a0,0x1d
    80004500:	9ec50513          	addi	a0,a0,-1556 # 80020ee8 <ftable>
    80004504:	ffffc097          	auipc	ra,0xffffc
    80004508:	642080e7          	jalr	1602(ra) # 80000b46 <initlock>
}
    8000450c:	60a2                	ld	ra,8(sp)
    8000450e:	6402                	ld	s0,0(sp)
    80004510:	0141                	addi	sp,sp,16
    80004512:	8082                	ret

0000000080004514 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004514:	1101                	addi	sp,sp,-32
    80004516:	ec06                	sd	ra,24(sp)
    80004518:	e822                	sd	s0,16(sp)
    8000451a:	e426                	sd	s1,8(sp)
    8000451c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000451e:	0001d517          	auipc	a0,0x1d
    80004522:	9ca50513          	addi	a0,a0,-1590 # 80020ee8 <ftable>
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	6b0080e7          	jalr	1712(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000452e:	0001d497          	auipc	s1,0x1d
    80004532:	9d248493          	addi	s1,s1,-1582 # 80020f00 <ftable+0x18>
    80004536:	0001e717          	auipc	a4,0x1e
    8000453a:	96a70713          	addi	a4,a4,-1686 # 80021ea0 <disk>
    if(f->ref == 0){
    8000453e:	40dc                	lw	a5,4(s1)
    80004540:	cf99                	beqz	a5,8000455e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004542:	02848493          	addi	s1,s1,40
    80004546:	fee49ce3          	bne	s1,a4,8000453e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000454a:	0001d517          	auipc	a0,0x1d
    8000454e:	99e50513          	addi	a0,a0,-1634 # 80020ee8 <ftable>
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	738080e7          	jalr	1848(ra) # 80000c8a <release>
  return 0;
    8000455a:	4481                	li	s1,0
    8000455c:	a819                	j	80004572 <filealloc+0x5e>
      f->ref = 1;
    8000455e:	4785                	li	a5,1
    80004560:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004562:	0001d517          	auipc	a0,0x1d
    80004566:	98650513          	addi	a0,a0,-1658 # 80020ee8 <ftable>
    8000456a:	ffffc097          	auipc	ra,0xffffc
    8000456e:	720080e7          	jalr	1824(ra) # 80000c8a <release>
}
    80004572:	8526                	mv	a0,s1
    80004574:	60e2                	ld	ra,24(sp)
    80004576:	6442                	ld	s0,16(sp)
    80004578:	64a2                	ld	s1,8(sp)
    8000457a:	6105                	addi	sp,sp,32
    8000457c:	8082                	ret

000000008000457e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000457e:	1101                	addi	sp,sp,-32
    80004580:	ec06                	sd	ra,24(sp)
    80004582:	e822                	sd	s0,16(sp)
    80004584:	e426                	sd	s1,8(sp)
    80004586:	1000                	addi	s0,sp,32
    80004588:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000458a:	0001d517          	auipc	a0,0x1d
    8000458e:	95e50513          	addi	a0,a0,-1698 # 80020ee8 <ftable>
    80004592:	ffffc097          	auipc	ra,0xffffc
    80004596:	644080e7          	jalr	1604(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    8000459a:	40dc                	lw	a5,4(s1)
    8000459c:	02f05263          	blez	a5,800045c0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045a0:	2785                	addiw	a5,a5,1
    800045a2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045a4:	0001d517          	auipc	a0,0x1d
    800045a8:	94450513          	addi	a0,a0,-1724 # 80020ee8 <ftable>
    800045ac:	ffffc097          	auipc	ra,0xffffc
    800045b0:	6de080e7          	jalr	1758(ra) # 80000c8a <release>
  return f;
}
    800045b4:	8526                	mv	a0,s1
    800045b6:	60e2                	ld	ra,24(sp)
    800045b8:	6442                	ld	s0,16(sp)
    800045ba:	64a2                	ld	s1,8(sp)
    800045bc:	6105                	addi	sp,sp,32
    800045be:	8082                	ret
    panic("filedup");
    800045c0:	00004517          	auipc	a0,0x4
    800045c4:	15050513          	addi	a0,a0,336 # 80008710 <syscalls+0x248>
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	f78080e7          	jalr	-136(ra) # 80000540 <panic>

00000000800045d0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045d0:	7139                	addi	sp,sp,-64
    800045d2:	fc06                	sd	ra,56(sp)
    800045d4:	f822                	sd	s0,48(sp)
    800045d6:	f426                	sd	s1,40(sp)
    800045d8:	f04a                	sd	s2,32(sp)
    800045da:	ec4e                	sd	s3,24(sp)
    800045dc:	e852                	sd	s4,16(sp)
    800045de:	e456                	sd	s5,8(sp)
    800045e0:	0080                	addi	s0,sp,64
    800045e2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800045e4:	0001d517          	auipc	a0,0x1d
    800045e8:	90450513          	addi	a0,a0,-1788 # 80020ee8 <ftable>
    800045ec:	ffffc097          	auipc	ra,0xffffc
    800045f0:	5ea080e7          	jalr	1514(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    800045f4:	40dc                	lw	a5,4(s1)
    800045f6:	06f05163          	blez	a5,80004658 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800045fa:	37fd                	addiw	a5,a5,-1
    800045fc:	0007871b          	sext.w	a4,a5
    80004600:	c0dc                	sw	a5,4(s1)
    80004602:	06e04363          	bgtz	a4,80004668 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004606:	0004a903          	lw	s2,0(s1)
    8000460a:	0094ca83          	lbu	s5,9(s1)
    8000460e:	0104ba03          	ld	s4,16(s1)
    80004612:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004616:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000461a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000461e:	0001d517          	auipc	a0,0x1d
    80004622:	8ca50513          	addi	a0,a0,-1846 # 80020ee8 <ftable>
    80004626:	ffffc097          	auipc	ra,0xffffc
    8000462a:	664080e7          	jalr	1636(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    8000462e:	4785                	li	a5,1
    80004630:	04f90d63          	beq	s2,a5,8000468a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004634:	3979                	addiw	s2,s2,-2
    80004636:	4785                	li	a5,1
    80004638:	0527e063          	bltu	a5,s2,80004678 <fileclose+0xa8>
    begin_op();
    8000463c:	00000097          	auipc	ra,0x0
    80004640:	acc080e7          	jalr	-1332(ra) # 80004108 <begin_op>
    iput(ff.ip);
    80004644:	854e                	mv	a0,s3
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	2b0080e7          	jalr	688(ra) # 800038f6 <iput>
    end_op();
    8000464e:	00000097          	auipc	ra,0x0
    80004652:	b38080e7          	jalr	-1224(ra) # 80004186 <end_op>
    80004656:	a00d                	j	80004678 <fileclose+0xa8>
    panic("fileclose");
    80004658:	00004517          	auipc	a0,0x4
    8000465c:	0c050513          	addi	a0,a0,192 # 80008718 <syscalls+0x250>
    80004660:	ffffc097          	auipc	ra,0xffffc
    80004664:	ee0080e7          	jalr	-288(ra) # 80000540 <panic>
    release(&ftable.lock);
    80004668:	0001d517          	auipc	a0,0x1d
    8000466c:	88050513          	addi	a0,a0,-1920 # 80020ee8 <ftable>
    80004670:	ffffc097          	auipc	ra,0xffffc
    80004674:	61a080e7          	jalr	1562(ra) # 80000c8a <release>
  }
}
    80004678:	70e2                	ld	ra,56(sp)
    8000467a:	7442                	ld	s0,48(sp)
    8000467c:	74a2                	ld	s1,40(sp)
    8000467e:	7902                	ld	s2,32(sp)
    80004680:	69e2                	ld	s3,24(sp)
    80004682:	6a42                	ld	s4,16(sp)
    80004684:	6aa2                	ld	s5,8(sp)
    80004686:	6121                	addi	sp,sp,64
    80004688:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000468a:	85d6                	mv	a1,s5
    8000468c:	8552                	mv	a0,s4
    8000468e:	00000097          	auipc	ra,0x0
    80004692:	34c080e7          	jalr	844(ra) # 800049da <pipeclose>
    80004696:	b7cd                	j	80004678 <fileclose+0xa8>

0000000080004698 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004698:	715d                	addi	sp,sp,-80
    8000469a:	e486                	sd	ra,72(sp)
    8000469c:	e0a2                	sd	s0,64(sp)
    8000469e:	fc26                	sd	s1,56(sp)
    800046a0:	f84a                	sd	s2,48(sp)
    800046a2:	f44e                	sd	s3,40(sp)
    800046a4:	0880                	addi	s0,sp,80
    800046a6:	84aa                	mv	s1,a0
    800046a8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046aa:	ffffd097          	auipc	ra,0xffffd
    800046ae:	314080e7          	jalr	788(ra) # 800019be <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046b2:	409c                	lw	a5,0(s1)
    800046b4:	37f9                	addiw	a5,a5,-2
    800046b6:	4705                	li	a4,1
    800046b8:	04f76763          	bltu	a4,a5,80004706 <filestat+0x6e>
    800046bc:	892a                	mv	s2,a0
    ilock(f->ip);
    800046be:	6c88                	ld	a0,24(s1)
    800046c0:	fffff097          	auipc	ra,0xfffff
    800046c4:	07c080e7          	jalr	124(ra) # 8000373c <ilock>
    stati(f->ip, &st);
    800046c8:	fb840593          	addi	a1,s0,-72
    800046cc:	6c88                	ld	a0,24(s1)
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	2f8080e7          	jalr	760(ra) # 800039c6 <stati>
    iunlock(f->ip);
    800046d6:	6c88                	ld	a0,24(s1)
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	126080e7          	jalr	294(ra) # 800037fe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046e0:	46e1                	li	a3,24
    800046e2:	fb840613          	addi	a2,s0,-72
    800046e6:	85ce                	mv	a1,s3
    800046e8:	05893503          	ld	a0,88(s2)
    800046ec:	ffffd097          	auipc	ra,0xffffd
    800046f0:	f80080e7          	jalr	-128(ra) # 8000166c <copyout>
    800046f4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800046f8:	60a6                	ld	ra,72(sp)
    800046fa:	6406                	ld	s0,64(sp)
    800046fc:	74e2                	ld	s1,56(sp)
    800046fe:	7942                	ld	s2,48(sp)
    80004700:	79a2                	ld	s3,40(sp)
    80004702:	6161                	addi	sp,sp,80
    80004704:	8082                	ret
  return -1;
    80004706:	557d                	li	a0,-1
    80004708:	bfc5                	j	800046f8 <filestat+0x60>

000000008000470a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000470a:	7179                	addi	sp,sp,-48
    8000470c:	f406                	sd	ra,40(sp)
    8000470e:	f022                	sd	s0,32(sp)
    80004710:	ec26                	sd	s1,24(sp)
    80004712:	e84a                	sd	s2,16(sp)
    80004714:	e44e                	sd	s3,8(sp)
    80004716:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004718:	00854783          	lbu	a5,8(a0)
    8000471c:	c3d5                	beqz	a5,800047c0 <fileread+0xb6>
    8000471e:	84aa                	mv	s1,a0
    80004720:	89ae                	mv	s3,a1
    80004722:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004724:	411c                	lw	a5,0(a0)
    80004726:	4705                	li	a4,1
    80004728:	04e78963          	beq	a5,a4,8000477a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000472c:	470d                	li	a4,3
    8000472e:	04e78d63          	beq	a5,a4,80004788 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004732:	4709                	li	a4,2
    80004734:	06e79e63          	bne	a5,a4,800047b0 <fileread+0xa6>
    ilock(f->ip);
    80004738:	6d08                	ld	a0,24(a0)
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	002080e7          	jalr	2(ra) # 8000373c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004742:	874a                	mv	a4,s2
    80004744:	5094                	lw	a3,32(s1)
    80004746:	864e                	mv	a2,s3
    80004748:	4585                	li	a1,1
    8000474a:	6c88                	ld	a0,24(s1)
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	2a4080e7          	jalr	676(ra) # 800039f0 <readi>
    80004754:	892a                	mv	s2,a0
    80004756:	00a05563          	blez	a0,80004760 <fileread+0x56>
      f->off += r;
    8000475a:	509c                	lw	a5,32(s1)
    8000475c:	9fa9                	addw	a5,a5,a0
    8000475e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004760:	6c88                	ld	a0,24(s1)
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	09c080e7          	jalr	156(ra) # 800037fe <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000476a:	854a                	mv	a0,s2
    8000476c:	70a2                	ld	ra,40(sp)
    8000476e:	7402                	ld	s0,32(sp)
    80004770:	64e2                	ld	s1,24(sp)
    80004772:	6942                	ld	s2,16(sp)
    80004774:	69a2                	ld	s3,8(sp)
    80004776:	6145                	addi	sp,sp,48
    80004778:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000477a:	6908                	ld	a0,16(a0)
    8000477c:	00000097          	auipc	ra,0x0
    80004780:	3c6080e7          	jalr	966(ra) # 80004b42 <piperead>
    80004784:	892a                	mv	s2,a0
    80004786:	b7d5                	j	8000476a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004788:	02451783          	lh	a5,36(a0)
    8000478c:	03079693          	slli	a3,a5,0x30
    80004790:	92c1                	srli	a3,a3,0x30
    80004792:	4725                	li	a4,9
    80004794:	02d76863          	bltu	a4,a3,800047c4 <fileread+0xba>
    80004798:	0792                	slli	a5,a5,0x4
    8000479a:	0001c717          	auipc	a4,0x1c
    8000479e:	6ae70713          	addi	a4,a4,1710 # 80020e48 <devsw>
    800047a2:	97ba                	add	a5,a5,a4
    800047a4:	639c                	ld	a5,0(a5)
    800047a6:	c38d                	beqz	a5,800047c8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047a8:	4505                	li	a0,1
    800047aa:	9782                	jalr	a5
    800047ac:	892a                	mv	s2,a0
    800047ae:	bf75                	j	8000476a <fileread+0x60>
    panic("fileread");
    800047b0:	00004517          	auipc	a0,0x4
    800047b4:	f7850513          	addi	a0,a0,-136 # 80008728 <syscalls+0x260>
    800047b8:	ffffc097          	auipc	ra,0xffffc
    800047bc:	d88080e7          	jalr	-632(ra) # 80000540 <panic>
    return -1;
    800047c0:	597d                	li	s2,-1
    800047c2:	b765                	j	8000476a <fileread+0x60>
      return -1;
    800047c4:	597d                	li	s2,-1
    800047c6:	b755                	j	8000476a <fileread+0x60>
    800047c8:	597d                	li	s2,-1
    800047ca:	b745                	j	8000476a <fileread+0x60>

00000000800047cc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800047cc:	715d                	addi	sp,sp,-80
    800047ce:	e486                	sd	ra,72(sp)
    800047d0:	e0a2                	sd	s0,64(sp)
    800047d2:	fc26                	sd	s1,56(sp)
    800047d4:	f84a                	sd	s2,48(sp)
    800047d6:	f44e                	sd	s3,40(sp)
    800047d8:	f052                	sd	s4,32(sp)
    800047da:	ec56                	sd	s5,24(sp)
    800047dc:	e85a                	sd	s6,16(sp)
    800047de:	e45e                	sd	s7,8(sp)
    800047e0:	e062                	sd	s8,0(sp)
    800047e2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800047e4:	00954783          	lbu	a5,9(a0)
    800047e8:	10078663          	beqz	a5,800048f4 <filewrite+0x128>
    800047ec:	892a                	mv	s2,a0
    800047ee:	8b2e                	mv	s6,a1
    800047f0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800047f2:	411c                	lw	a5,0(a0)
    800047f4:	4705                	li	a4,1
    800047f6:	02e78263          	beq	a5,a4,8000481a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047fa:	470d                	li	a4,3
    800047fc:	02e78663          	beq	a5,a4,80004828 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004800:	4709                	li	a4,2
    80004802:	0ee79163          	bne	a5,a4,800048e4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004806:	0ac05d63          	blez	a2,800048c0 <filewrite+0xf4>
    int i = 0;
    8000480a:	4981                	li	s3,0
    8000480c:	6b85                	lui	s7,0x1
    8000480e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004812:	6c05                	lui	s8,0x1
    80004814:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004818:	a861                	j	800048b0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    8000481a:	6908                	ld	a0,16(a0)
    8000481c:	00000097          	auipc	ra,0x0
    80004820:	22e080e7          	jalr	558(ra) # 80004a4a <pipewrite>
    80004824:	8a2a                	mv	s4,a0
    80004826:	a045                	j	800048c6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004828:	02451783          	lh	a5,36(a0)
    8000482c:	03079693          	slli	a3,a5,0x30
    80004830:	92c1                	srli	a3,a3,0x30
    80004832:	4725                	li	a4,9
    80004834:	0cd76263          	bltu	a4,a3,800048f8 <filewrite+0x12c>
    80004838:	0792                	slli	a5,a5,0x4
    8000483a:	0001c717          	auipc	a4,0x1c
    8000483e:	60e70713          	addi	a4,a4,1550 # 80020e48 <devsw>
    80004842:	97ba                	add	a5,a5,a4
    80004844:	679c                	ld	a5,8(a5)
    80004846:	cbdd                	beqz	a5,800048fc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004848:	4505                	li	a0,1
    8000484a:	9782                	jalr	a5
    8000484c:	8a2a                	mv	s4,a0
    8000484e:	a8a5                	j	800048c6 <filewrite+0xfa>
    80004850:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004854:	00000097          	auipc	ra,0x0
    80004858:	8b4080e7          	jalr	-1868(ra) # 80004108 <begin_op>
      ilock(f->ip);
    8000485c:	01893503          	ld	a0,24(s2)
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	edc080e7          	jalr	-292(ra) # 8000373c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004868:	8756                	mv	a4,s5
    8000486a:	02092683          	lw	a3,32(s2)
    8000486e:	01698633          	add	a2,s3,s6
    80004872:	4585                	li	a1,1
    80004874:	01893503          	ld	a0,24(s2)
    80004878:	fffff097          	auipc	ra,0xfffff
    8000487c:	270080e7          	jalr	624(ra) # 80003ae8 <writei>
    80004880:	84aa                	mv	s1,a0
    80004882:	00a05763          	blez	a0,80004890 <filewrite+0xc4>
        f->off += r;
    80004886:	02092783          	lw	a5,32(s2)
    8000488a:	9fa9                	addw	a5,a5,a0
    8000488c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004890:	01893503          	ld	a0,24(s2)
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	f6a080e7          	jalr	-150(ra) # 800037fe <iunlock>
      end_op();
    8000489c:	00000097          	auipc	ra,0x0
    800048a0:	8ea080e7          	jalr	-1814(ra) # 80004186 <end_op>

      if(r != n1){
    800048a4:	009a9f63          	bne	s5,s1,800048c2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800048a8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048ac:	0149db63          	bge	s3,s4,800048c2 <filewrite+0xf6>
      int n1 = n - i;
    800048b0:	413a04bb          	subw	s1,s4,s3
    800048b4:	0004879b          	sext.w	a5,s1
    800048b8:	f8fbdce3          	bge	s7,a5,80004850 <filewrite+0x84>
    800048bc:	84e2                	mv	s1,s8
    800048be:	bf49                	j	80004850 <filewrite+0x84>
    int i = 0;
    800048c0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800048c2:	013a1f63          	bne	s4,s3,800048e0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048c6:	8552                	mv	a0,s4
    800048c8:	60a6                	ld	ra,72(sp)
    800048ca:	6406                	ld	s0,64(sp)
    800048cc:	74e2                	ld	s1,56(sp)
    800048ce:	7942                	ld	s2,48(sp)
    800048d0:	79a2                	ld	s3,40(sp)
    800048d2:	7a02                	ld	s4,32(sp)
    800048d4:	6ae2                	ld	s5,24(sp)
    800048d6:	6b42                	ld	s6,16(sp)
    800048d8:	6ba2                	ld	s7,8(sp)
    800048da:	6c02                	ld	s8,0(sp)
    800048dc:	6161                	addi	sp,sp,80
    800048de:	8082                	ret
    ret = (i == n ? n : -1);
    800048e0:	5a7d                	li	s4,-1
    800048e2:	b7d5                	j	800048c6 <filewrite+0xfa>
    panic("filewrite");
    800048e4:	00004517          	auipc	a0,0x4
    800048e8:	e5450513          	addi	a0,a0,-428 # 80008738 <syscalls+0x270>
    800048ec:	ffffc097          	auipc	ra,0xffffc
    800048f0:	c54080e7          	jalr	-940(ra) # 80000540 <panic>
    return -1;
    800048f4:	5a7d                	li	s4,-1
    800048f6:	bfc1                	j	800048c6 <filewrite+0xfa>
      return -1;
    800048f8:	5a7d                	li	s4,-1
    800048fa:	b7f1                	j	800048c6 <filewrite+0xfa>
    800048fc:	5a7d                	li	s4,-1
    800048fe:	b7e1                	j	800048c6 <filewrite+0xfa>

0000000080004900 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004900:	7179                	addi	sp,sp,-48
    80004902:	f406                	sd	ra,40(sp)
    80004904:	f022                	sd	s0,32(sp)
    80004906:	ec26                	sd	s1,24(sp)
    80004908:	e84a                	sd	s2,16(sp)
    8000490a:	e44e                	sd	s3,8(sp)
    8000490c:	e052                	sd	s4,0(sp)
    8000490e:	1800                	addi	s0,sp,48
    80004910:	84aa                	mv	s1,a0
    80004912:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004914:	0005b023          	sd	zero,0(a1)
    80004918:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000491c:	00000097          	auipc	ra,0x0
    80004920:	bf8080e7          	jalr	-1032(ra) # 80004514 <filealloc>
    80004924:	e088                	sd	a0,0(s1)
    80004926:	c551                	beqz	a0,800049b2 <pipealloc+0xb2>
    80004928:	00000097          	auipc	ra,0x0
    8000492c:	bec080e7          	jalr	-1044(ra) # 80004514 <filealloc>
    80004930:	00aa3023          	sd	a0,0(s4)
    80004934:	c92d                	beqz	a0,800049a6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004936:	ffffc097          	auipc	ra,0xffffc
    8000493a:	1b0080e7          	jalr	432(ra) # 80000ae6 <kalloc>
    8000493e:	892a                	mv	s2,a0
    80004940:	c125                	beqz	a0,800049a0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004942:	4985                	li	s3,1
    80004944:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004948:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000494c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004950:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004954:	00004597          	auipc	a1,0x4
    80004958:	df458593          	addi	a1,a1,-524 # 80008748 <syscalls+0x280>
    8000495c:	ffffc097          	auipc	ra,0xffffc
    80004960:	1ea080e7          	jalr	490(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    80004964:	609c                	ld	a5,0(s1)
    80004966:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000496a:	609c                	ld	a5,0(s1)
    8000496c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004970:	609c                	ld	a5,0(s1)
    80004972:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004976:	609c                	ld	a5,0(s1)
    80004978:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000497c:	000a3783          	ld	a5,0(s4)
    80004980:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004984:	000a3783          	ld	a5,0(s4)
    80004988:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000498c:	000a3783          	ld	a5,0(s4)
    80004990:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004994:	000a3783          	ld	a5,0(s4)
    80004998:	0127b823          	sd	s2,16(a5)
  return 0;
    8000499c:	4501                	li	a0,0
    8000499e:	a025                	j	800049c6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049a0:	6088                	ld	a0,0(s1)
    800049a2:	e501                	bnez	a0,800049aa <pipealloc+0xaa>
    800049a4:	a039                	j	800049b2 <pipealloc+0xb2>
    800049a6:	6088                	ld	a0,0(s1)
    800049a8:	c51d                	beqz	a0,800049d6 <pipealloc+0xd6>
    fileclose(*f0);
    800049aa:	00000097          	auipc	ra,0x0
    800049ae:	c26080e7          	jalr	-986(ra) # 800045d0 <fileclose>
  if(*f1)
    800049b2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049b6:	557d                	li	a0,-1
  if(*f1)
    800049b8:	c799                	beqz	a5,800049c6 <pipealloc+0xc6>
    fileclose(*f1);
    800049ba:	853e                	mv	a0,a5
    800049bc:	00000097          	auipc	ra,0x0
    800049c0:	c14080e7          	jalr	-1004(ra) # 800045d0 <fileclose>
  return -1;
    800049c4:	557d                	li	a0,-1
}
    800049c6:	70a2                	ld	ra,40(sp)
    800049c8:	7402                	ld	s0,32(sp)
    800049ca:	64e2                	ld	s1,24(sp)
    800049cc:	6942                	ld	s2,16(sp)
    800049ce:	69a2                	ld	s3,8(sp)
    800049d0:	6a02                	ld	s4,0(sp)
    800049d2:	6145                	addi	sp,sp,48
    800049d4:	8082                	ret
  return -1;
    800049d6:	557d                	li	a0,-1
    800049d8:	b7fd                	j	800049c6 <pipealloc+0xc6>

00000000800049da <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049da:	1101                	addi	sp,sp,-32
    800049dc:	ec06                	sd	ra,24(sp)
    800049de:	e822                	sd	s0,16(sp)
    800049e0:	e426                	sd	s1,8(sp)
    800049e2:	e04a                	sd	s2,0(sp)
    800049e4:	1000                	addi	s0,sp,32
    800049e6:	84aa                	mv	s1,a0
    800049e8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800049ea:	ffffc097          	auipc	ra,0xffffc
    800049ee:	1ec080e7          	jalr	492(ra) # 80000bd6 <acquire>
  if(writable){
    800049f2:	02090d63          	beqz	s2,80004a2c <pipeclose+0x52>
    pi->writeopen = 0;
    800049f6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800049fa:	21848513          	addi	a0,s1,536
    800049fe:	ffffd097          	auipc	ra,0xffffd
    80004a02:	722080e7          	jalr	1826(ra) # 80002120 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a06:	2204b783          	ld	a5,544(s1)
    80004a0a:	eb95                	bnez	a5,80004a3e <pipeclose+0x64>
    release(&pi->lock);
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	ffffc097          	auipc	ra,0xffffc
    80004a12:	27c080e7          	jalr	636(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffc097          	auipc	ra,0xffffc
    80004a1c:	fd0080e7          	jalr	-48(ra) # 800009e8 <kfree>
  } else
    release(&pi->lock);
}
    80004a20:	60e2                	ld	ra,24(sp)
    80004a22:	6442                	ld	s0,16(sp)
    80004a24:	64a2                	ld	s1,8(sp)
    80004a26:	6902                	ld	s2,0(sp)
    80004a28:	6105                	addi	sp,sp,32
    80004a2a:	8082                	ret
    pi->readopen = 0;
    80004a2c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a30:	21c48513          	addi	a0,s1,540
    80004a34:	ffffd097          	auipc	ra,0xffffd
    80004a38:	6ec080e7          	jalr	1772(ra) # 80002120 <wakeup>
    80004a3c:	b7e9                	j	80004a06 <pipeclose+0x2c>
    release(&pi->lock);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffc097          	auipc	ra,0xffffc
    80004a44:	24a080e7          	jalr	586(ra) # 80000c8a <release>
}
    80004a48:	bfe1                	j	80004a20 <pipeclose+0x46>

0000000080004a4a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a4a:	711d                	addi	sp,sp,-96
    80004a4c:	ec86                	sd	ra,88(sp)
    80004a4e:	e8a2                	sd	s0,80(sp)
    80004a50:	e4a6                	sd	s1,72(sp)
    80004a52:	e0ca                	sd	s2,64(sp)
    80004a54:	fc4e                	sd	s3,56(sp)
    80004a56:	f852                	sd	s4,48(sp)
    80004a58:	f456                	sd	s5,40(sp)
    80004a5a:	f05a                	sd	s6,32(sp)
    80004a5c:	ec5e                	sd	s7,24(sp)
    80004a5e:	e862                	sd	s8,16(sp)
    80004a60:	1080                	addi	s0,sp,96
    80004a62:	84aa                	mv	s1,a0
    80004a64:	8aae                	mv	s5,a1
    80004a66:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004a68:	ffffd097          	auipc	ra,0xffffd
    80004a6c:	f56080e7          	jalr	-170(ra) # 800019be <myproc>
    80004a70:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffc097          	auipc	ra,0xffffc
    80004a78:	162080e7          	jalr	354(ra) # 80000bd6 <acquire>
  while(i < n){
    80004a7c:	0b405663          	blez	s4,80004b28 <pipewrite+0xde>
  int i = 0;
    80004a80:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a82:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004a84:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a88:	21c48b93          	addi	s7,s1,540
    80004a8c:	a089                	j	80004ace <pipewrite+0x84>
      release(&pi->lock);
    80004a8e:	8526                	mv	a0,s1
    80004a90:	ffffc097          	auipc	ra,0xffffc
    80004a94:	1fa080e7          	jalr	506(ra) # 80000c8a <release>
      return -1;
    80004a98:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004a9a:	854a                	mv	a0,s2
    80004a9c:	60e6                	ld	ra,88(sp)
    80004a9e:	6446                	ld	s0,80(sp)
    80004aa0:	64a6                	ld	s1,72(sp)
    80004aa2:	6906                	ld	s2,64(sp)
    80004aa4:	79e2                	ld	s3,56(sp)
    80004aa6:	7a42                	ld	s4,48(sp)
    80004aa8:	7aa2                	ld	s5,40(sp)
    80004aaa:	7b02                	ld	s6,32(sp)
    80004aac:	6be2                	ld	s7,24(sp)
    80004aae:	6c42                	ld	s8,16(sp)
    80004ab0:	6125                	addi	sp,sp,96
    80004ab2:	8082                	ret
      wakeup(&pi->nread);
    80004ab4:	8562                	mv	a0,s8
    80004ab6:	ffffd097          	auipc	ra,0xffffd
    80004aba:	66a080e7          	jalr	1642(ra) # 80002120 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004abe:	85a6                	mv	a1,s1
    80004ac0:	855e                	mv	a0,s7
    80004ac2:	ffffd097          	auipc	ra,0xffffd
    80004ac6:	5ec080e7          	jalr	1516(ra) # 800020ae <sleep>
  while(i < n){
    80004aca:	07495063          	bge	s2,s4,80004b2a <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004ace:	2204a783          	lw	a5,544(s1)
    80004ad2:	dfd5                	beqz	a5,80004a8e <pipewrite+0x44>
    80004ad4:	854e                	mv	a0,s3
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	88e080e7          	jalr	-1906(ra) # 80002364 <killed>
    80004ade:	f945                	bnez	a0,80004a8e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004ae0:	2184a783          	lw	a5,536(s1)
    80004ae4:	21c4a703          	lw	a4,540(s1)
    80004ae8:	2007879b          	addiw	a5,a5,512
    80004aec:	fcf704e3          	beq	a4,a5,80004ab4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004af0:	4685                	li	a3,1
    80004af2:	01590633          	add	a2,s2,s5
    80004af6:	faf40593          	addi	a1,s0,-81
    80004afa:	0589b503          	ld	a0,88(s3)
    80004afe:	ffffd097          	auipc	ra,0xffffd
    80004b02:	bfa080e7          	jalr	-1030(ra) # 800016f8 <copyin>
    80004b06:	03650263          	beq	a0,s6,80004b2a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b0a:	21c4a783          	lw	a5,540(s1)
    80004b0e:	0017871b          	addiw	a4,a5,1
    80004b12:	20e4ae23          	sw	a4,540(s1)
    80004b16:	1ff7f793          	andi	a5,a5,511
    80004b1a:	97a6                	add	a5,a5,s1
    80004b1c:	faf44703          	lbu	a4,-81(s0)
    80004b20:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b24:	2905                	addiw	s2,s2,1
    80004b26:	b755                	j	80004aca <pipewrite+0x80>
  int i = 0;
    80004b28:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b2a:	21848513          	addi	a0,s1,536
    80004b2e:	ffffd097          	auipc	ra,0xffffd
    80004b32:	5f2080e7          	jalr	1522(ra) # 80002120 <wakeup>
  release(&pi->lock);
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffc097          	auipc	ra,0xffffc
    80004b3c:	152080e7          	jalr	338(ra) # 80000c8a <release>
  return i;
    80004b40:	bfa9                	j	80004a9a <pipewrite+0x50>

0000000080004b42 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b42:	715d                	addi	sp,sp,-80
    80004b44:	e486                	sd	ra,72(sp)
    80004b46:	e0a2                	sd	s0,64(sp)
    80004b48:	fc26                	sd	s1,56(sp)
    80004b4a:	f84a                	sd	s2,48(sp)
    80004b4c:	f44e                	sd	s3,40(sp)
    80004b4e:	f052                	sd	s4,32(sp)
    80004b50:	ec56                	sd	s5,24(sp)
    80004b52:	e85a                	sd	s6,16(sp)
    80004b54:	0880                	addi	s0,sp,80
    80004b56:	84aa                	mv	s1,a0
    80004b58:	892e                	mv	s2,a1
    80004b5a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b5c:	ffffd097          	auipc	ra,0xffffd
    80004b60:	e62080e7          	jalr	-414(ra) # 800019be <myproc>
    80004b64:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b66:	8526                	mv	a0,s1
    80004b68:	ffffc097          	auipc	ra,0xffffc
    80004b6c:	06e080e7          	jalr	110(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b70:	2184a703          	lw	a4,536(s1)
    80004b74:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b78:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b7c:	02f71763          	bne	a4,a5,80004baa <piperead+0x68>
    80004b80:	2244a783          	lw	a5,548(s1)
    80004b84:	c39d                	beqz	a5,80004baa <piperead+0x68>
    if(killed(pr)){
    80004b86:	8552                	mv	a0,s4
    80004b88:	ffffd097          	auipc	ra,0xffffd
    80004b8c:	7dc080e7          	jalr	2012(ra) # 80002364 <killed>
    80004b90:	e949                	bnez	a0,80004c22 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b92:	85a6                	mv	a1,s1
    80004b94:	854e                	mv	a0,s3
    80004b96:	ffffd097          	auipc	ra,0xffffd
    80004b9a:	518080e7          	jalr	1304(ra) # 800020ae <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b9e:	2184a703          	lw	a4,536(s1)
    80004ba2:	21c4a783          	lw	a5,540(s1)
    80004ba6:	fcf70de3          	beq	a4,a5,80004b80 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004baa:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bac:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bae:	05505463          	blez	s5,80004bf6 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004bb2:	2184a783          	lw	a5,536(s1)
    80004bb6:	21c4a703          	lw	a4,540(s1)
    80004bba:	02f70e63          	beq	a4,a5,80004bf6 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004bbe:	0017871b          	addiw	a4,a5,1
    80004bc2:	20e4ac23          	sw	a4,536(s1)
    80004bc6:	1ff7f793          	andi	a5,a5,511
    80004bca:	97a6                	add	a5,a5,s1
    80004bcc:	0187c783          	lbu	a5,24(a5)
    80004bd0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bd4:	4685                	li	a3,1
    80004bd6:	fbf40613          	addi	a2,s0,-65
    80004bda:	85ca                	mv	a1,s2
    80004bdc:	058a3503          	ld	a0,88(s4)
    80004be0:	ffffd097          	auipc	ra,0xffffd
    80004be4:	a8c080e7          	jalr	-1396(ra) # 8000166c <copyout>
    80004be8:	01650763          	beq	a0,s6,80004bf6 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bec:	2985                	addiw	s3,s3,1
    80004bee:	0905                	addi	s2,s2,1
    80004bf0:	fd3a91e3          	bne	s5,s3,80004bb2 <piperead+0x70>
    80004bf4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004bf6:	21c48513          	addi	a0,s1,540
    80004bfa:	ffffd097          	auipc	ra,0xffffd
    80004bfe:	526080e7          	jalr	1318(ra) # 80002120 <wakeup>
  release(&pi->lock);
    80004c02:	8526                	mv	a0,s1
    80004c04:	ffffc097          	auipc	ra,0xffffc
    80004c08:	086080e7          	jalr	134(ra) # 80000c8a <release>
  return i;
}
    80004c0c:	854e                	mv	a0,s3
    80004c0e:	60a6                	ld	ra,72(sp)
    80004c10:	6406                	ld	s0,64(sp)
    80004c12:	74e2                	ld	s1,56(sp)
    80004c14:	7942                	ld	s2,48(sp)
    80004c16:	79a2                	ld	s3,40(sp)
    80004c18:	7a02                	ld	s4,32(sp)
    80004c1a:	6ae2                	ld	s5,24(sp)
    80004c1c:	6b42                	ld	s6,16(sp)
    80004c1e:	6161                	addi	sp,sp,80
    80004c20:	8082                	ret
      release(&pi->lock);
    80004c22:	8526                	mv	a0,s1
    80004c24:	ffffc097          	auipc	ra,0xffffc
    80004c28:	066080e7          	jalr	102(ra) # 80000c8a <release>
      return -1;
    80004c2c:	59fd                	li	s3,-1
    80004c2e:	bff9                	j	80004c0c <piperead+0xca>

0000000080004c30 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004c30:	1141                	addi	sp,sp,-16
    80004c32:	e422                	sd	s0,8(sp)
    80004c34:	0800                	addi	s0,sp,16
    80004c36:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004c38:	8905                	andi	a0,a0,1
    80004c3a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004c3c:	8b89                	andi	a5,a5,2
    80004c3e:	c399                	beqz	a5,80004c44 <flags2perm+0x14>
      perm |= PTE_W;
    80004c40:	00456513          	ori	a0,a0,4
    return perm;
}
    80004c44:	6422                	ld	s0,8(sp)
    80004c46:	0141                	addi	sp,sp,16
    80004c48:	8082                	ret

0000000080004c4a <exec>:

int
exec(char *path, char **argv)
{
    80004c4a:	de010113          	addi	sp,sp,-544
    80004c4e:	20113c23          	sd	ra,536(sp)
    80004c52:	20813823          	sd	s0,528(sp)
    80004c56:	20913423          	sd	s1,520(sp)
    80004c5a:	21213023          	sd	s2,512(sp)
    80004c5e:	ffce                	sd	s3,504(sp)
    80004c60:	fbd2                	sd	s4,496(sp)
    80004c62:	f7d6                	sd	s5,488(sp)
    80004c64:	f3da                	sd	s6,480(sp)
    80004c66:	efde                	sd	s7,472(sp)
    80004c68:	ebe2                	sd	s8,464(sp)
    80004c6a:	e7e6                	sd	s9,456(sp)
    80004c6c:	e3ea                	sd	s10,448(sp)
    80004c6e:	ff6e                	sd	s11,440(sp)
    80004c70:	1400                	addi	s0,sp,544
    80004c72:	892a                	mv	s2,a0
    80004c74:	dea43423          	sd	a0,-536(s0)
    80004c78:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c7c:	ffffd097          	auipc	ra,0xffffd
    80004c80:	d42080e7          	jalr	-702(ra) # 800019be <myproc>
    80004c84:	84aa                	mv	s1,a0

  begin_op();
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	482080e7          	jalr	1154(ra) # 80004108 <begin_op>

  if((ip = namei(path)) == 0){
    80004c8e:	854a                	mv	a0,s2
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	258080e7          	jalr	600(ra) # 80003ee8 <namei>
    80004c98:	c93d                	beqz	a0,80004d0e <exec+0xc4>
    80004c9a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	aa0080e7          	jalr	-1376(ra) # 8000373c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004ca4:	04000713          	li	a4,64
    80004ca8:	4681                	li	a3,0
    80004caa:	e5040613          	addi	a2,s0,-432
    80004cae:	4581                	li	a1,0
    80004cb0:	8556                	mv	a0,s5
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	d3e080e7          	jalr	-706(ra) # 800039f0 <readi>
    80004cba:	04000793          	li	a5,64
    80004cbe:	00f51a63          	bne	a0,a5,80004cd2 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004cc2:	e5042703          	lw	a4,-432(s0)
    80004cc6:	464c47b7          	lui	a5,0x464c4
    80004cca:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004cce:	04f70663          	beq	a4,a5,80004d1a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004cd2:	8556                	mv	a0,s5
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	cca080e7          	jalr	-822(ra) # 8000399e <iunlockput>
    end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	4aa080e7          	jalr	1194(ra) # 80004186 <end_op>
  }
  return -1;
    80004ce4:	557d                	li	a0,-1
}
    80004ce6:	21813083          	ld	ra,536(sp)
    80004cea:	21013403          	ld	s0,528(sp)
    80004cee:	20813483          	ld	s1,520(sp)
    80004cf2:	20013903          	ld	s2,512(sp)
    80004cf6:	79fe                	ld	s3,504(sp)
    80004cf8:	7a5e                	ld	s4,496(sp)
    80004cfa:	7abe                	ld	s5,488(sp)
    80004cfc:	7b1e                	ld	s6,480(sp)
    80004cfe:	6bfe                	ld	s7,472(sp)
    80004d00:	6c5e                	ld	s8,464(sp)
    80004d02:	6cbe                	ld	s9,456(sp)
    80004d04:	6d1e                	ld	s10,448(sp)
    80004d06:	7dfa                	ld	s11,440(sp)
    80004d08:	22010113          	addi	sp,sp,544
    80004d0c:	8082                	ret
    end_op();
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	478080e7          	jalr	1144(ra) # 80004186 <end_op>
    return -1;
    80004d16:	557d                	li	a0,-1
    80004d18:	b7f9                	j	80004ce6 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d1a:	8526                	mv	a0,s1
    80004d1c:	ffffd097          	auipc	ra,0xffffd
    80004d20:	d66080e7          	jalr	-666(ra) # 80001a82 <proc_pagetable>
    80004d24:	8b2a                	mv	s6,a0
    80004d26:	d555                	beqz	a0,80004cd2 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d28:	e7042783          	lw	a5,-400(s0)
    80004d2c:	e8845703          	lhu	a4,-376(s0)
    80004d30:	c735                	beqz	a4,80004d9c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d32:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d34:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004d38:	6a05                	lui	s4,0x1
    80004d3a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004d3e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004d42:	6d85                	lui	s11,0x1
    80004d44:	7d7d                	lui	s10,0xfffff
    80004d46:	ac3d                	j	80004f84 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004d48:	00004517          	auipc	a0,0x4
    80004d4c:	a0850513          	addi	a0,a0,-1528 # 80008750 <syscalls+0x288>
    80004d50:	ffffb097          	auipc	ra,0xffffb
    80004d54:	7f0080e7          	jalr	2032(ra) # 80000540 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d58:	874a                	mv	a4,s2
    80004d5a:	009c86bb          	addw	a3,s9,s1
    80004d5e:	4581                	li	a1,0
    80004d60:	8556                	mv	a0,s5
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	c8e080e7          	jalr	-882(ra) # 800039f0 <readi>
    80004d6a:	2501                	sext.w	a0,a0
    80004d6c:	1aa91963          	bne	s2,a0,80004f1e <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    80004d70:	009d84bb          	addw	s1,s11,s1
    80004d74:	013d09bb          	addw	s3,s10,s3
    80004d78:	1f74f663          	bgeu	s1,s7,80004f64 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004d7c:	02049593          	slli	a1,s1,0x20
    80004d80:	9181                	srli	a1,a1,0x20
    80004d82:	95e2                	add	a1,a1,s8
    80004d84:	855a                	mv	a0,s6
    80004d86:	ffffc097          	auipc	ra,0xffffc
    80004d8a:	2d6080e7          	jalr	726(ra) # 8000105c <walkaddr>
    80004d8e:	862a                	mv	a2,a0
    if(pa == 0)
    80004d90:	dd45                	beqz	a0,80004d48 <exec+0xfe>
      n = PGSIZE;
    80004d92:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004d94:	fd49f2e3          	bgeu	s3,s4,80004d58 <exec+0x10e>
      n = sz - i;
    80004d98:	894e                	mv	s2,s3
    80004d9a:	bf7d                	j	80004d58 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d9c:	4901                	li	s2,0
  iunlockput(ip);
    80004d9e:	8556                	mv	a0,s5
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	bfe080e7          	jalr	-1026(ra) # 8000399e <iunlockput>
  end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	3de080e7          	jalr	990(ra) # 80004186 <end_op>
  p = myproc();
    80004db0:	ffffd097          	auipc	ra,0xffffd
    80004db4:	c0e080e7          	jalr	-1010(ra) # 800019be <myproc>
    80004db8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004dba:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004dbe:	6785                	lui	a5,0x1
    80004dc0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004dc2:	97ca                	add	a5,a5,s2
    80004dc4:	777d                	lui	a4,0xfffff
    80004dc6:	8ff9                	and	a5,a5,a4
    80004dc8:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004dcc:	4691                	li	a3,4
    80004dce:	6609                	lui	a2,0x2
    80004dd0:	963e                	add	a2,a2,a5
    80004dd2:	85be                	mv	a1,a5
    80004dd4:	855a                	mv	a0,s6
    80004dd6:	ffffc097          	auipc	ra,0xffffc
    80004dda:	63a080e7          	jalr	1594(ra) # 80001410 <uvmalloc>
    80004dde:	8c2a                	mv	s8,a0
  ip = 0;
    80004de0:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004de2:	12050e63          	beqz	a0,80004f1e <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004de6:	75f9                	lui	a1,0xffffe
    80004de8:	95aa                	add	a1,a1,a0
    80004dea:	855a                	mv	a0,s6
    80004dec:	ffffd097          	auipc	ra,0xffffd
    80004df0:	84e080e7          	jalr	-1970(ra) # 8000163a <uvmclear>
  stackbase = sp - PGSIZE;
    80004df4:	7afd                	lui	s5,0xfffff
    80004df6:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004df8:	df043783          	ld	a5,-528(s0)
    80004dfc:	6388                	ld	a0,0(a5)
    80004dfe:	c925                	beqz	a0,80004e6e <exec+0x224>
    80004e00:	e9040993          	addi	s3,s0,-368
    80004e04:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004e08:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e0a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e0c:	ffffc097          	auipc	ra,0xffffc
    80004e10:	042080e7          	jalr	66(ra) # 80000e4e <strlen>
    80004e14:	0015079b          	addiw	a5,a0,1
    80004e18:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e1c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004e20:	13596663          	bltu	s2,s5,80004f4c <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e24:	df043d83          	ld	s11,-528(s0)
    80004e28:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004e2c:	8552                	mv	a0,s4
    80004e2e:	ffffc097          	auipc	ra,0xffffc
    80004e32:	020080e7          	jalr	32(ra) # 80000e4e <strlen>
    80004e36:	0015069b          	addiw	a3,a0,1
    80004e3a:	8652                	mv	a2,s4
    80004e3c:	85ca                	mv	a1,s2
    80004e3e:	855a                	mv	a0,s6
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	82c080e7          	jalr	-2004(ra) # 8000166c <copyout>
    80004e48:	10054663          	bltz	a0,80004f54 <exec+0x30a>
    ustack[argc] = sp;
    80004e4c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e50:	0485                	addi	s1,s1,1
    80004e52:	008d8793          	addi	a5,s11,8
    80004e56:	def43823          	sd	a5,-528(s0)
    80004e5a:	008db503          	ld	a0,8(s11)
    80004e5e:	c911                	beqz	a0,80004e72 <exec+0x228>
    if(argc >= MAXARG)
    80004e60:	09a1                	addi	s3,s3,8
    80004e62:	fb3c95e3          	bne	s9,s3,80004e0c <exec+0x1c2>
  sz = sz1;
    80004e66:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e6a:	4a81                	li	s5,0
    80004e6c:	a84d                	j	80004f1e <exec+0x2d4>
  sp = sz;
    80004e6e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e70:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e72:	00349793          	slli	a5,s1,0x3
    80004e76:	f9078793          	addi	a5,a5,-112
    80004e7a:	97a2                	add	a5,a5,s0
    80004e7c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004e80:	00148693          	addi	a3,s1,1
    80004e84:	068e                	slli	a3,a3,0x3
    80004e86:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004e8a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004e8e:	01597663          	bgeu	s2,s5,80004e9a <exec+0x250>
  sz = sz1;
    80004e92:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e96:	4a81                	li	s5,0
    80004e98:	a059                	j	80004f1e <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e9a:	e9040613          	addi	a2,s0,-368
    80004e9e:	85ca                	mv	a1,s2
    80004ea0:	855a                	mv	a0,s6
    80004ea2:	ffffc097          	auipc	ra,0xffffc
    80004ea6:	7ca080e7          	jalr	1994(ra) # 8000166c <copyout>
    80004eaa:	0a054963          	bltz	a0,80004f5c <exec+0x312>
  p->trapframe->a1 = sp;
    80004eae:	060bb783          	ld	a5,96(s7)
    80004eb2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004eb6:	de843783          	ld	a5,-536(s0)
    80004eba:	0007c703          	lbu	a4,0(a5)
    80004ebe:	cf11                	beqz	a4,80004eda <exec+0x290>
    80004ec0:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004ec2:	02f00693          	li	a3,47
    80004ec6:	a039                	j	80004ed4 <exec+0x28a>
      last = s+1;
    80004ec8:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004ecc:	0785                	addi	a5,a5,1
    80004ece:	fff7c703          	lbu	a4,-1(a5)
    80004ed2:	c701                	beqz	a4,80004eda <exec+0x290>
    if(*s == '/')
    80004ed4:	fed71ce3          	bne	a4,a3,80004ecc <exec+0x282>
    80004ed8:	bfc5                	j	80004ec8 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004eda:	4641                	li	a2,16
    80004edc:	de843583          	ld	a1,-536(s0)
    80004ee0:	160b8513          	addi	a0,s7,352
    80004ee4:	ffffc097          	auipc	ra,0xffffc
    80004ee8:	f38080e7          	jalr	-200(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    80004eec:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    80004ef0:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    80004ef4:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004ef8:	060bb783          	ld	a5,96(s7)
    80004efc:	e6843703          	ld	a4,-408(s0)
    80004f00:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f02:	060bb783          	ld	a5,96(s7)
    80004f06:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f0a:	85ea                	mv	a1,s10
    80004f0c:	ffffd097          	auipc	ra,0xffffd
    80004f10:	c12080e7          	jalr	-1006(ra) # 80001b1e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f14:	0004851b          	sext.w	a0,s1
    80004f18:	b3f9                	j	80004ce6 <exec+0x9c>
    80004f1a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004f1e:	df843583          	ld	a1,-520(s0)
    80004f22:	855a                	mv	a0,s6
    80004f24:	ffffd097          	auipc	ra,0xffffd
    80004f28:	bfa080e7          	jalr	-1030(ra) # 80001b1e <proc_freepagetable>
  if(ip){
    80004f2c:	da0a93e3          	bnez	s5,80004cd2 <exec+0x88>
  return -1;
    80004f30:	557d                	li	a0,-1
    80004f32:	bb55                	j	80004ce6 <exec+0x9c>
    80004f34:	df243c23          	sd	s2,-520(s0)
    80004f38:	b7dd                	j	80004f1e <exec+0x2d4>
    80004f3a:	df243c23          	sd	s2,-520(s0)
    80004f3e:	b7c5                	j	80004f1e <exec+0x2d4>
    80004f40:	df243c23          	sd	s2,-520(s0)
    80004f44:	bfe9                	j	80004f1e <exec+0x2d4>
    80004f46:	df243c23          	sd	s2,-520(s0)
    80004f4a:	bfd1                	j	80004f1e <exec+0x2d4>
  sz = sz1;
    80004f4c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f50:	4a81                	li	s5,0
    80004f52:	b7f1                	j	80004f1e <exec+0x2d4>
  sz = sz1;
    80004f54:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f58:	4a81                	li	s5,0
    80004f5a:	b7d1                	j	80004f1e <exec+0x2d4>
  sz = sz1;
    80004f5c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f60:	4a81                	li	s5,0
    80004f62:	bf75                	j	80004f1e <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004f64:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f68:	e0843783          	ld	a5,-504(s0)
    80004f6c:	0017869b          	addiw	a3,a5,1
    80004f70:	e0d43423          	sd	a3,-504(s0)
    80004f74:	e0043783          	ld	a5,-512(s0)
    80004f78:	0387879b          	addiw	a5,a5,56
    80004f7c:	e8845703          	lhu	a4,-376(s0)
    80004f80:	e0e6dfe3          	bge	a3,a4,80004d9e <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f84:	2781                	sext.w	a5,a5
    80004f86:	e0f43023          	sd	a5,-512(s0)
    80004f8a:	03800713          	li	a4,56
    80004f8e:	86be                	mv	a3,a5
    80004f90:	e1840613          	addi	a2,s0,-488
    80004f94:	4581                	li	a1,0
    80004f96:	8556                	mv	a0,s5
    80004f98:	fffff097          	auipc	ra,0xfffff
    80004f9c:	a58080e7          	jalr	-1448(ra) # 800039f0 <readi>
    80004fa0:	03800793          	li	a5,56
    80004fa4:	f6f51be3          	bne	a0,a5,80004f1a <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80004fa8:	e1842783          	lw	a5,-488(s0)
    80004fac:	4705                	li	a4,1
    80004fae:	fae79de3          	bne	a5,a4,80004f68 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    80004fb2:	e4043483          	ld	s1,-448(s0)
    80004fb6:	e3843783          	ld	a5,-456(s0)
    80004fba:	f6f4ede3          	bltu	s1,a5,80004f34 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004fbe:	e2843783          	ld	a5,-472(s0)
    80004fc2:	94be                	add	s1,s1,a5
    80004fc4:	f6f4ebe3          	bltu	s1,a5,80004f3a <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80004fc8:	de043703          	ld	a4,-544(s0)
    80004fcc:	8ff9                	and	a5,a5,a4
    80004fce:	fbad                	bnez	a5,80004f40 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004fd0:	e1c42503          	lw	a0,-484(s0)
    80004fd4:	00000097          	auipc	ra,0x0
    80004fd8:	c5c080e7          	jalr	-932(ra) # 80004c30 <flags2perm>
    80004fdc:	86aa                	mv	a3,a0
    80004fde:	8626                	mv	a2,s1
    80004fe0:	85ca                	mv	a1,s2
    80004fe2:	855a                	mv	a0,s6
    80004fe4:	ffffc097          	auipc	ra,0xffffc
    80004fe8:	42c080e7          	jalr	1068(ra) # 80001410 <uvmalloc>
    80004fec:	dea43c23          	sd	a0,-520(s0)
    80004ff0:	d939                	beqz	a0,80004f46 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ff2:	e2843c03          	ld	s8,-472(s0)
    80004ff6:	e2042c83          	lw	s9,-480(s0)
    80004ffa:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ffe:	f60b83e3          	beqz	s7,80004f64 <exec+0x31a>
    80005002:	89de                	mv	s3,s7
    80005004:	4481                	li	s1,0
    80005006:	bb9d                	j	80004d7c <exec+0x132>

0000000080005008 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005008:	7179                	addi	sp,sp,-48
    8000500a:	f406                	sd	ra,40(sp)
    8000500c:	f022                	sd	s0,32(sp)
    8000500e:	ec26                	sd	s1,24(sp)
    80005010:	e84a                	sd	s2,16(sp)
    80005012:	1800                	addi	s0,sp,48
    80005014:	892e                	mv	s2,a1
    80005016:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005018:	fdc40593          	addi	a1,s0,-36
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	b88080e7          	jalr	-1144(ra) # 80002ba4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005024:	fdc42703          	lw	a4,-36(s0)
    80005028:	47bd                	li	a5,15
    8000502a:	02e7eb63          	bltu	a5,a4,80005060 <argfd+0x58>
    8000502e:	ffffd097          	auipc	ra,0xffffd
    80005032:	990080e7          	jalr	-1648(ra) # 800019be <myproc>
    80005036:	fdc42703          	lw	a4,-36(s0)
    8000503a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd03a>
    8000503e:	078e                	slli	a5,a5,0x3
    80005040:	953e                	add	a0,a0,a5
    80005042:	651c                	ld	a5,8(a0)
    80005044:	c385                	beqz	a5,80005064 <argfd+0x5c>
    return -1;
  if(pfd)
    80005046:	00090463          	beqz	s2,8000504e <argfd+0x46>
    *pfd = fd;
    8000504a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000504e:	4501                	li	a0,0
  if(pf)
    80005050:	c091                	beqz	s1,80005054 <argfd+0x4c>
    *pf = f;
    80005052:	e09c                	sd	a5,0(s1)
}
    80005054:	70a2                	ld	ra,40(sp)
    80005056:	7402                	ld	s0,32(sp)
    80005058:	64e2                	ld	s1,24(sp)
    8000505a:	6942                	ld	s2,16(sp)
    8000505c:	6145                	addi	sp,sp,48
    8000505e:	8082                	ret
    return -1;
    80005060:	557d                	li	a0,-1
    80005062:	bfcd                	j	80005054 <argfd+0x4c>
    80005064:	557d                	li	a0,-1
    80005066:	b7fd                	j	80005054 <argfd+0x4c>

0000000080005068 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005068:	1101                	addi	sp,sp,-32
    8000506a:	ec06                	sd	ra,24(sp)
    8000506c:	e822                	sd	s0,16(sp)
    8000506e:	e426                	sd	s1,8(sp)
    80005070:	1000                	addi	s0,sp,32
    80005072:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005074:	ffffd097          	auipc	ra,0xffffd
    80005078:	94a080e7          	jalr	-1718(ra) # 800019be <myproc>
    8000507c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000507e:	0d850793          	addi	a5,a0,216
    80005082:	4501                	li	a0,0
    80005084:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005086:	6398                	ld	a4,0(a5)
    80005088:	cb19                	beqz	a4,8000509e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000508a:	2505                	addiw	a0,a0,1
    8000508c:	07a1                	addi	a5,a5,8
    8000508e:	fed51ce3          	bne	a0,a3,80005086 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005092:	557d                	li	a0,-1
}
    80005094:	60e2                	ld	ra,24(sp)
    80005096:	6442                	ld	s0,16(sp)
    80005098:	64a2                	ld	s1,8(sp)
    8000509a:	6105                	addi	sp,sp,32
    8000509c:	8082                	ret
      p->ofile[fd] = f;
    8000509e:	01a50793          	addi	a5,a0,26
    800050a2:	078e                	slli	a5,a5,0x3
    800050a4:	963e                	add	a2,a2,a5
    800050a6:	e604                	sd	s1,8(a2)
      return fd;
    800050a8:	b7f5                	j	80005094 <fdalloc+0x2c>

00000000800050aa <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800050aa:	715d                	addi	sp,sp,-80
    800050ac:	e486                	sd	ra,72(sp)
    800050ae:	e0a2                	sd	s0,64(sp)
    800050b0:	fc26                	sd	s1,56(sp)
    800050b2:	f84a                	sd	s2,48(sp)
    800050b4:	f44e                	sd	s3,40(sp)
    800050b6:	f052                	sd	s4,32(sp)
    800050b8:	ec56                	sd	s5,24(sp)
    800050ba:	e85a                	sd	s6,16(sp)
    800050bc:	0880                	addi	s0,sp,80
    800050be:	8b2e                	mv	s6,a1
    800050c0:	89b2                	mv	s3,a2
    800050c2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050c4:	fb040593          	addi	a1,s0,-80
    800050c8:	fffff097          	auipc	ra,0xfffff
    800050cc:	e3e080e7          	jalr	-450(ra) # 80003f06 <nameiparent>
    800050d0:	84aa                	mv	s1,a0
    800050d2:	14050f63          	beqz	a0,80005230 <create+0x186>
    return 0;

  ilock(dp);
    800050d6:	ffffe097          	auipc	ra,0xffffe
    800050da:	666080e7          	jalr	1638(ra) # 8000373c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800050de:	4601                	li	a2,0
    800050e0:	fb040593          	addi	a1,s0,-80
    800050e4:	8526                	mv	a0,s1
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	b3a080e7          	jalr	-1222(ra) # 80003c20 <dirlookup>
    800050ee:	8aaa                	mv	s5,a0
    800050f0:	c931                	beqz	a0,80005144 <create+0x9a>
    iunlockput(dp);
    800050f2:	8526                	mv	a0,s1
    800050f4:	fffff097          	auipc	ra,0xfffff
    800050f8:	8aa080e7          	jalr	-1878(ra) # 8000399e <iunlockput>
    ilock(ip);
    800050fc:	8556                	mv	a0,s5
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	63e080e7          	jalr	1598(ra) # 8000373c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005106:	000b059b          	sext.w	a1,s6
    8000510a:	4789                	li	a5,2
    8000510c:	02f59563          	bne	a1,a5,80005136 <create+0x8c>
    80005110:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd064>
    80005114:	37f9                	addiw	a5,a5,-2
    80005116:	17c2                	slli	a5,a5,0x30
    80005118:	93c1                	srli	a5,a5,0x30
    8000511a:	4705                	li	a4,1
    8000511c:	00f76d63          	bltu	a4,a5,80005136 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005120:	8556                	mv	a0,s5
    80005122:	60a6                	ld	ra,72(sp)
    80005124:	6406                	ld	s0,64(sp)
    80005126:	74e2                	ld	s1,56(sp)
    80005128:	7942                	ld	s2,48(sp)
    8000512a:	79a2                	ld	s3,40(sp)
    8000512c:	7a02                	ld	s4,32(sp)
    8000512e:	6ae2                	ld	s5,24(sp)
    80005130:	6b42                	ld	s6,16(sp)
    80005132:	6161                	addi	sp,sp,80
    80005134:	8082                	ret
    iunlockput(ip);
    80005136:	8556                	mv	a0,s5
    80005138:	fffff097          	auipc	ra,0xfffff
    8000513c:	866080e7          	jalr	-1946(ra) # 8000399e <iunlockput>
    return 0;
    80005140:	4a81                	li	s5,0
    80005142:	bff9                	j	80005120 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005144:	85da                	mv	a1,s6
    80005146:	4088                	lw	a0,0(s1)
    80005148:	ffffe097          	auipc	ra,0xffffe
    8000514c:	456080e7          	jalr	1110(ra) # 8000359e <ialloc>
    80005150:	8a2a                	mv	s4,a0
    80005152:	c539                	beqz	a0,800051a0 <create+0xf6>
  ilock(ip);
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	5e8080e7          	jalr	1512(ra) # 8000373c <ilock>
  ip->major = major;
    8000515c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005160:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005164:	4905                	li	s2,1
    80005166:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000516a:	8552                	mv	a0,s4
    8000516c:	ffffe097          	auipc	ra,0xffffe
    80005170:	504080e7          	jalr	1284(ra) # 80003670 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005174:	000b059b          	sext.w	a1,s6
    80005178:	03258b63          	beq	a1,s2,800051ae <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    8000517c:	004a2603          	lw	a2,4(s4)
    80005180:	fb040593          	addi	a1,s0,-80
    80005184:	8526                	mv	a0,s1
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	cb0080e7          	jalr	-848(ra) # 80003e36 <dirlink>
    8000518e:	06054f63          	bltz	a0,8000520c <create+0x162>
  iunlockput(dp);
    80005192:	8526                	mv	a0,s1
    80005194:	fffff097          	auipc	ra,0xfffff
    80005198:	80a080e7          	jalr	-2038(ra) # 8000399e <iunlockput>
  return ip;
    8000519c:	8ad2                	mv	s5,s4
    8000519e:	b749                	j	80005120 <create+0x76>
    iunlockput(dp);
    800051a0:	8526                	mv	a0,s1
    800051a2:	ffffe097          	auipc	ra,0xffffe
    800051a6:	7fc080e7          	jalr	2044(ra) # 8000399e <iunlockput>
    return 0;
    800051aa:	8ad2                	mv	s5,s4
    800051ac:	bf95                	j	80005120 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051ae:	004a2603          	lw	a2,4(s4)
    800051b2:	00003597          	auipc	a1,0x3
    800051b6:	5be58593          	addi	a1,a1,1470 # 80008770 <syscalls+0x2a8>
    800051ba:	8552                	mv	a0,s4
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	c7a080e7          	jalr	-902(ra) # 80003e36 <dirlink>
    800051c4:	04054463          	bltz	a0,8000520c <create+0x162>
    800051c8:	40d0                	lw	a2,4(s1)
    800051ca:	00003597          	auipc	a1,0x3
    800051ce:	5ae58593          	addi	a1,a1,1454 # 80008778 <syscalls+0x2b0>
    800051d2:	8552                	mv	a0,s4
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	c62080e7          	jalr	-926(ra) # 80003e36 <dirlink>
    800051dc:	02054863          	bltz	a0,8000520c <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800051e0:	004a2603          	lw	a2,4(s4)
    800051e4:	fb040593          	addi	a1,s0,-80
    800051e8:	8526                	mv	a0,s1
    800051ea:	fffff097          	auipc	ra,0xfffff
    800051ee:	c4c080e7          	jalr	-948(ra) # 80003e36 <dirlink>
    800051f2:	00054d63          	bltz	a0,8000520c <create+0x162>
    dp->nlink++;  // for ".."
    800051f6:	04a4d783          	lhu	a5,74(s1)
    800051fa:	2785                	addiw	a5,a5,1
    800051fc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005200:	8526                	mv	a0,s1
    80005202:	ffffe097          	auipc	ra,0xffffe
    80005206:	46e080e7          	jalr	1134(ra) # 80003670 <iupdate>
    8000520a:	b761                	j	80005192 <create+0xe8>
  ip->nlink = 0;
    8000520c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005210:	8552                	mv	a0,s4
    80005212:	ffffe097          	auipc	ra,0xffffe
    80005216:	45e080e7          	jalr	1118(ra) # 80003670 <iupdate>
  iunlockput(ip);
    8000521a:	8552                	mv	a0,s4
    8000521c:	ffffe097          	auipc	ra,0xffffe
    80005220:	782080e7          	jalr	1922(ra) # 8000399e <iunlockput>
  iunlockput(dp);
    80005224:	8526                	mv	a0,s1
    80005226:	ffffe097          	auipc	ra,0xffffe
    8000522a:	778080e7          	jalr	1912(ra) # 8000399e <iunlockput>
  return 0;
    8000522e:	bdcd                	j	80005120 <create+0x76>
    return 0;
    80005230:	8aaa                	mv	s5,a0
    80005232:	b5fd                	j	80005120 <create+0x76>

0000000080005234 <sys_dup>:
{
    80005234:	7179                	addi	sp,sp,-48
    80005236:	f406                	sd	ra,40(sp)
    80005238:	f022                	sd	s0,32(sp)
    8000523a:	ec26                	sd	s1,24(sp)
    8000523c:	e84a                	sd	s2,16(sp)
    8000523e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005240:	fd840613          	addi	a2,s0,-40
    80005244:	4581                	li	a1,0
    80005246:	4501                	li	a0,0
    80005248:	00000097          	auipc	ra,0x0
    8000524c:	dc0080e7          	jalr	-576(ra) # 80005008 <argfd>
    return -1;
    80005250:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005252:	02054363          	bltz	a0,80005278 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005256:	fd843903          	ld	s2,-40(s0)
    8000525a:	854a                	mv	a0,s2
    8000525c:	00000097          	auipc	ra,0x0
    80005260:	e0c080e7          	jalr	-500(ra) # 80005068 <fdalloc>
    80005264:	84aa                	mv	s1,a0
    return -1;
    80005266:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005268:	00054863          	bltz	a0,80005278 <sys_dup+0x44>
  filedup(f);
    8000526c:	854a                	mv	a0,s2
    8000526e:	fffff097          	auipc	ra,0xfffff
    80005272:	310080e7          	jalr	784(ra) # 8000457e <filedup>
  return fd;
    80005276:	87a6                	mv	a5,s1
}
    80005278:	853e                	mv	a0,a5
    8000527a:	70a2                	ld	ra,40(sp)
    8000527c:	7402                	ld	s0,32(sp)
    8000527e:	64e2                	ld	s1,24(sp)
    80005280:	6942                	ld	s2,16(sp)
    80005282:	6145                	addi	sp,sp,48
    80005284:	8082                	ret

0000000080005286 <sys_read>:
{
    80005286:	7179                	addi	sp,sp,-48
    80005288:	f406                	sd	ra,40(sp)
    8000528a:	f022                	sd	s0,32(sp)
    8000528c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000528e:	fd840593          	addi	a1,s0,-40
    80005292:	4505                	li	a0,1
    80005294:	ffffe097          	auipc	ra,0xffffe
    80005298:	930080e7          	jalr	-1744(ra) # 80002bc4 <argaddr>
  argint(2, &n);
    8000529c:	fe440593          	addi	a1,s0,-28
    800052a0:	4509                	li	a0,2
    800052a2:	ffffe097          	auipc	ra,0xffffe
    800052a6:	902080e7          	jalr	-1790(ra) # 80002ba4 <argint>
  if(argfd(0, 0, &f) < 0)
    800052aa:	fe840613          	addi	a2,s0,-24
    800052ae:	4581                	li	a1,0
    800052b0:	4501                	li	a0,0
    800052b2:	00000097          	auipc	ra,0x0
    800052b6:	d56080e7          	jalr	-682(ra) # 80005008 <argfd>
    800052ba:	87aa                	mv	a5,a0
    return -1;
    800052bc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800052be:	0007cc63          	bltz	a5,800052d6 <sys_read+0x50>
  return fileread(f, p, n);
    800052c2:	fe442603          	lw	a2,-28(s0)
    800052c6:	fd843583          	ld	a1,-40(s0)
    800052ca:	fe843503          	ld	a0,-24(s0)
    800052ce:	fffff097          	auipc	ra,0xfffff
    800052d2:	43c080e7          	jalr	1084(ra) # 8000470a <fileread>
}
    800052d6:	70a2                	ld	ra,40(sp)
    800052d8:	7402                	ld	s0,32(sp)
    800052da:	6145                	addi	sp,sp,48
    800052dc:	8082                	ret

00000000800052de <sys_write>:
{
    800052de:	7179                	addi	sp,sp,-48
    800052e0:	f406                	sd	ra,40(sp)
    800052e2:	f022                	sd	s0,32(sp)
    800052e4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800052e6:	fd840593          	addi	a1,s0,-40
    800052ea:	4505                	li	a0,1
    800052ec:	ffffe097          	auipc	ra,0xffffe
    800052f0:	8d8080e7          	jalr	-1832(ra) # 80002bc4 <argaddr>
  argint(2, &n);
    800052f4:	fe440593          	addi	a1,s0,-28
    800052f8:	4509                	li	a0,2
    800052fa:	ffffe097          	auipc	ra,0xffffe
    800052fe:	8aa080e7          	jalr	-1878(ra) # 80002ba4 <argint>
  if(argfd(0, 0, &f) < 0)
    80005302:	fe840613          	addi	a2,s0,-24
    80005306:	4581                	li	a1,0
    80005308:	4501                	li	a0,0
    8000530a:	00000097          	auipc	ra,0x0
    8000530e:	cfe080e7          	jalr	-770(ra) # 80005008 <argfd>
    80005312:	87aa                	mv	a5,a0
    return -1;
    80005314:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005316:	0007cc63          	bltz	a5,8000532e <sys_write+0x50>
  return filewrite(f, p, n);
    8000531a:	fe442603          	lw	a2,-28(s0)
    8000531e:	fd843583          	ld	a1,-40(s0)
    80005322:	fe843503          	ld	a0,-24(s0)
    80005326:	fffff097          	auipc	ra,0xfffff
    8000532a:	4a6080e7          	jalr	1190(ra) # 800047cc <filewrite>
}
    8000532e:	70a2                	ld	ra,40(sp)
    80005330:	7402                	ld	s0,32(sp)
    80005332:	6145                	addi	sp,sp,48
    80005334:	8082                	ret

0000000080005336 <sys_close>:
{
    80005336:	1101                	addi	sp,sp,-32
    80005338:	ec06                	sd	ra,24(sp)
    8000533a:	e822                	sd	s0,16(sp)
    8000533c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000533e:	fe040613          	addi	a2,s0,-32
    80005342:	fec40593          	addi	a1,s0,-20
    80005346:	4501                	li	a0,0
    80005348:	00000097          	auipc	ra,0x0
    8000534c:	cc0080e7          	jalr	-832(ra) # 80005008 <argfd>
    return -1;
    80005350:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005352:	02054463          	bltz	a0,8000537a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005356:	ffffc097          	auipc	ra,0xffffc
    8000535a:	668080e7          	jalr	1640(ra) # 800019be <myproc>
    8000535e:	fec42783          	lw	a5,-20(s0)
    80005362:	07e9                	addi	a5,a5,26
    80005364:	078e                	slli	a5,a5,0x3
    80005366:	953e                	add	a0,a0,a5
    80005368:	00053423          	sd	zero,8(a0)
  fileclose(f);
    8000536c:	fe043503          	ld	a0,-32(s0)
    80005370:	fffff097          	auipc	ra,0xfffff
    80005374:	260080e7          	jalr	608(ra) # 800045d0 <fileclose>
  return 0;
    80005378:	4781                	li	a5,0
}
    8000537a:	853e                	mv	a0,a5
    8000537c:	60e2                	ld	ra,24(sp)
    8000537e:	6442                	ld	s0,16(sp)
    80005380:	6105                	addi	sp,sp,32
    80005382:	8082                	ret

0000000080005384 <sys_fstat>:
{
    80005384:	1101                	addi	sp,sp,-32
    80005386:	ec06                	sd	ra,24(sp)
    80005388:	e822                	sd	s0,16(sp)
    8000538a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000538c:	fe040593          	addi	a1,s0,-32
    80005390:	4505                	li	a0,1
    80005392:	ffffe097          	auipc	ra,0xffffe
    80005396:	832080e7          	jalr	-1998(ra) # 80002bc4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000539a:	fe840613          	addi	a2,s0,-24
    8000539e:	4581                	li	a1,0
    800053a0:	4501                	li	a0,0
    800053a2:	00000097          	auipc	ra,0x0
    800053a6:	c66080e7          	jalr	-922(ra) # 80005008 <argfd>
    800053aa:	87aa                	mv	a5,a0
    return -1;
    800053ac:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053ae:	0007ca63          	bltz	a5,800053c2 <sys_fstat+0x3e>
  return filestat(f, st);
    800053b2:	fe043583          	ld	a1,-32(s0)
    800053b6:	fe843503          	ld	a0,-24(s0)
    800053ba:	fffff097          	auipc	ra,0xfffff
    800053be:	2de080e7          	jalr	734(ra) # 80004698 <filestat>
}
    800053c2:	60e2                	ld	ra,24(sp)
    800053c4:	6442                	ld	s0,16(sp)
    800053c6:	6105                	addi	sp,sp,32
    800053c8:	8082                	ret

00000000800053ca <sys_link>:
{
    800053ca:	7169                	addi	sp,sp,-304
    800053cc:	f606                	sd	ra,296(sp)
    800053ce:	f222                	sd	s0,288(sp)
    800053d0:	ee26                	sd	s1,280(sp)
    800053d2:	ea4a                	sd	s2,272(sp)
    800053d4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053d6:	08000613          	li	a2,128
    800053da:	ed040593          	addi	a1,s0,-304
    800053de:	4501                	li	a0,0
    800053e0:	ffffe097          	auipc	ra,0xffffe
    800053e4:	804080e7          	jalr	-2044(ra) # 80002be4 <argstr>
    return -1;
    800053e8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053ea:	10054e63          	bltz	a0,80005506 <sys_link+0x13c>
    800053ee:	08000613          	li	a2,128
    800053f2:	f5040593          	addi	a1,s0,-176
    800053f6:	4505                	li	a0,1
    800053f8:	ffffd097          	auipc	ra,0xffffd
    800053fc:	7ec080e7          	jalr	2028(ra) # 80002be4 <argstr>
    return -1;
    80005400:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005402:	10054263          	bltz	a0,80005506 <sys_link+0x13c>
  begin_op();
    80005406:	fffff097          	auipc	ra,0xfffff
    8000540a:	d02080e7          	jalr	-766(ra) # 80004108 <begin_op>
  if((ip = namei(old)) == 0){
    8000540e:	ed040513          	addi	a0,s0,-304
    80005412:	fffff097          	auipc	ra,0xfffff
    80005416:	ad6080e7          	jalr	-1322(ra) # 80003ee8 <namei>
    8000541a:	84aa                	mv	s1,a0
    8000541c:	c551                	beqz	a0,800054a8 <sys_link+0xde>
  ilock(ip);
    8000541e:	ffffe097          	auipc	ra,0xffffe
    80005422:	31e080e7          	jalr	798(ra) # 8000373c <ilock>
  if(ip->type == T_DIR){
    80005426:	04449703          	lh	a4,68(s1)
    8000542a:	4785                	li	a5,1
    8000542c:	08f70463          	beq	a4,a5,800054b4 <sys_link+0xea>
  ip->nlink++;
    80005430:	04a4d783          	lhu	a5,74(s1)
    80005434:	2785                	addiw	a5,a5,1
    80005436:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000543a:	8526                	mv	a0,s1
    8000543c:	ffffe097          	auipc	ra,0xffffe
    80005440:	234080e7          	jalr	564(ra) # 80003670 <iupdate>
  iunlock(ip);
    80005444:	8526                	mv	a0,s1
    80005446:	ffffe097          	auipc	ra,0xffffe
    8000544a:	3b8080e7          	jalr	952(ra) # 800037fe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000544e:	fd040593          	addi	a1,s0,-48
    80005452:	f5040513          	addi	a0,s0,-176
    80005456:	fffff097          	auipc	ra,0xfffff
    8000545a:	ab0080e7          	jalr	-1360(ra) # 80003f06 <nameiparent>
    8000545e:	892a                	mv	s2,a0
    80005460:	c935                	beqz	a0,800054d4 <sys_link+0x10a>
  ilock(dp);
    80005462:	ffffe097          	auipc	ra,0xffffe
    80005466:	2da080e7          	jalr	730(ra) # 8000373c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000546a:	00092703          	lw	a4,0(s2)
    8000546e:	409c                	lw	a5,0(s1)
    80005470:	04f71d63          	bne	a4,a5,800054ca <sys_link+0x100>
    80005474:	40d0                	lw	a2,4(s1)
    80005476:	fd040593          	addi	a1,s0,-48
    8000547a:	854a                	mv	a0,s2
    8000547c:	fffff097          	auipc	ra,0xfffff
    80005480:	9ba080e7          	jalr	-1606(ra) # 80003e36 <dirlink>
    80005484:	04054363          	bltz	a0,800054ca <sys_link+0x100>
  iunlockput(dp);
    80005488:	854a                	mv	a0,s2
    8000548a:	ffffe097          	auipc	ra,0xffffe
    8000548e:	514080e7          	jalr	1300(ra) # 8000399e <iunlockput>
  iput(ip);
    80005492:	8526                	mv	a0,s1
    80005494:	ffffe097          	auipc	ra,0xffffe
    80005498:	462080e7          	jalr	1122(ra) # 800038f6 <iput>
  end_op();
    8000549c:	fffff097          	auipc	ra,0xfffff
    800054a0:	cea080e7          	jalr	-790(ra) # 80004186 <end_op>
  return 0;
    800054a4:	4781                	li	a5,0
    800054a6:	a085                	j	80005506 <sys_link+0x13c>
    end_op();
    800054a8:	fffff097          	auipc	ra,0xfffff
    800054ac:	cde080e7          	jalr	-802(ra) # 80004186 <end_op>
    return -1;
    800054b0:	57fd                	li	a5,-1
    800054b2:	a891                	j	80005506 <sys_link+0x13c>
    iunlockput(ip);
    800054b4:	8526                	mv	a0,s1
    800054b6:	ffffe097          	auipc	ra,0xffffe
    800054ba:	4e8080e7          	jalr	1256(ra) # 8000399e <iunlockput>
    end_op();
    800054be:	fffff097          	auipc	ra,0xfffff
    800054c2:	cc8080e7          	jalr	-824(ra) # 80004186 <end_op>
    return -1;
    800054c6:	57fd                	li	a5,-1
    800054c8:	a83d                	j	80005506 <sys_link+0x13c>
    iunlockput(dp);
    800054ca:	854a                	mv	a0,s2
    800054cc:	ffffe097          	auipc	ra,0xffffe
    800054d0:	4d2080e7          	jalr	1234(ra) # 8000399e <iunlockput>
  ilock(ip);
    800054d4:	8526                	mv	a0,s1
    800054d6:	ffffe097          	auipc	ra,0xffffe
    800054da:	266080e7          	jalr	614(ra) # 8000373c <ilock>
  ip->nlink--;
    800054de:	04a4d783          	lhu	a5,74(s1)
    800054e2:	37fd                	addiw	a5,a5,-1
    800054e4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054e8:	8526                	mv	a0,s1
    800054ea:	ffffe097          	auipc	ra,0xffffe
    800054ee:	186080e7          	jalr	390(ra) # 80003670 <iupdate>
  iunlockput(ip);
    800054f2:	8526                	mv	a0,s1
    800054f4:	ffffe097          	auipc	ra,0xffffe
    800054f8:	4aa080e7          	jalr	1194(ra) # 8000399e <iunlockput>
  end_op();
    800054fc:	fffff097          	auipc	ra,0xfffff
    80005500:	c8a080e7          	jalr	-886(ra) # 80004186 <end_op>
  return -1;
    80005504:	57fd                	li	a5,-1
}
    80005506:	853e                	mv	a0,a5
    80005508:	70b2                	ld	ra,296(sp)
    8000550a:	7412                	ld	s0,288(sp)
    8000550c:	64f2                	ld	s1,280(sp)
    8000550e:	6952                	ld	s2,272(sp)
    80005510:	6155                	addi	sp,sp,304
    80005512:	8082                	ret

0000000080005514 <sys_unlink>:
{
    80005514:	7151                	addi	sp,sp,-240
    80005516:	f586                	sd	ra,232(sp)
    80005518:	f1a2                	sd	s0,224(sp)
    8000551a:	eda6                	sd	s1,216(sp)
    8000551c:	e9ca                	sd	s2,208(sp)
    8000551e:	e5ce                	sd	s3,200(sp)
    80005520:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005522:	08000613          	li	a2,128
    80005526:	f3040593          	addi	a1,s0,-208
    8000552a:	4501                	li	a0,0
    8000552c:	ffffd097          	auipc	ra,0xffffd
    80005530:	6b8080e7          	jalr	1720(ra) # 80002be4 <argstr>
    80005534:	18054163          	bltz	a0,800056b6 <sys_unlink+0x1a2>
  begin_op();
    80005538:	fffff097          	auipc	ra,0xfffff
    8000553c:	bd0080e7          	jalr	-1072(ra) # 80004108 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005540:	fb040593          	addi	a1,s0,-80
    80005544:	f3040513          	addi	a0,s0,-208
    80005548:	fffff097          	auipc	ra,0xfffff
    8000554c:	9be080e7          	jalr	-1602(ra) # 80003f06 <nameiparent>
    80005550:	84aa                	mv	s1,a0
    80005552:	c979                	beqz	a0,80005628 <sys_unlink+0x114>
  ilock(dp);
    80005554:	ffffe097          	auipc	ra,0xffffe
    80005558:	1e8080e7          	jalr	488(ra) # 8000373c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000555c:	00003597          	auipc	a1,0x3
    80005560:	21458593          	addi	a1,a1,532 # 80008770 <syscalls+0x2a8>
    80005564:	fb040513          	addi	a0,s0,-80
    80005568:	ffffe097          	auipc	ra,0xffffe
    8000556c:	69e080e7          	jalr	1694(ra) # 80003c06 <namecmp>
    80005570:	14050a63          	beqz	a0,800056c4 <sys_unlink+0x1b0>
    80005574:	00003597          	auipc	a1,0x3
    80005578:	20458593          	addi	a1,a1,516 # 80008778 <syscalls+0x2b0>
    8000557c:	fb040513          	addi	a0,s0,-80
    80005580:	ffffe097          	auipc	ra,0xffffe
    80005584:	686080e7          	jalr	1670(ra) # 80003c06 <namecmp>
    80005588:	12050e63          	beqz	a0,800056c4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000558c:	f2c40613          	addi	a2,s0,-212
    80005590:	fb040593          	addi	a1,s0,-80
    80005594:	8526                	mv	a0,s1
    80005596:	ffffe097          	auipc	ra,0xffffe
    8000559a:	68a080e7          	jalr	1674(ra) # 80003c20 <dirlookup>
    8000559e:	892a                	mv	s2,a0
    800055a0:	12050263          	beqz	a0,800056c4 <sys_unlink+0x1b0>
  ilock(ip);
    800055a4:	ffffe097          	auipc	ra,0xffffe
    800055a8:	198080e7          	jalr	408(ra) # 8000373c <ilock>
  if(ip->nlink < 1)
    800055ac:	04a91783          	lh	a5,74(s2)
    800055b0:	08f05263          	blez	a5,80005634 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055b4:	04491703          	lh	a4,68(s2)
    800055b8:	4785                	li	a5,1
    800055ba:	08f70563          	beq	a4,a5,80005644 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055be:	4641                	li	a2,16
    800055c0:	4581                	li	a1,0
    800055c2:	fc040513          	addi	a0,s0,-64
    800055c6:	ffffb097          	auipc	ra,0xffffb
    800055ca:	70c080e7          	jalr	1804(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055ce:	4741                	li	a4,16
    800055d0:	f2c42683          	lw	a3,-212(s0)
    800055d4:	fc040613          	addi	a2,s0,-64
    800055d8:	4581                	li	a1,0
    800055da:	8526                	mv	a0,s1
    800055dc:	ffffe097          	auipc	ra,0xffffe
    800055e0:	50c080e7          	jalr	1292(ra) # 80003ae8 <writei>
    800055e4:	47c1                	li	a5,16
    800055e6:	0af51563          	bne	a0,a5,80005690 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800055ea:	04491703          	lh	a4,68(s2)
    800055ee:	4785                	li	a5,1
    800055f0:	0af70863          	beq	a4,a5,800056a0 <sys_unlink+0x18c>
  iunlockput(dp);
    800055f4:	8526                	mv	a0,s1
    800055f6:	ffffe097          	auipc	ra,0xffffe
    800055fa:	3a8080e7          	jalr	936(ra) # 8000399e <iunlockput>
  ip->nlink--;
    800055fe:	04a95783          	lhu	a5,74(s2)
    80005602:	37fd                	addiw	a5,a5,-1
    80005604:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005608:	854a                	mv	a0,s2
    8000560a:	ffffe097          	auipc	ra,0xffffe
    8000560e:	066080e7          	jalr	102(ra) # 80003670 <iupdate>
  iunlockput(ip);
    80005612:	854a                	mv	a0,s2
    80005614:	ffffe097          	auipc	ra,0xffffe
    80005618:	38a080e7          	jalr	906(ra) # 8000399e <iunlockput>
  end_op();
    8000561c:	fffff097          	auipc	ra,0xfffff
    80005620:	b6a080e7          	jalr	-1174(ra) # 80004186 <end_op>
  return 0;
    80005624:	4501                	li	a0,0
    80005626:	a84d                	j	800056d8 <sys_unlink+0x1c4>
    end_op();
    80005628:	fffff097          	auipc	ra,0xfffff
    8000562c:	b5e080e7          	jalr	-1186(ra) # 80004186 <end_op>
    return -1;
    80005630:	557d                	li	a0,-1
    80005632:	a05d                	j	800056d8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005634:	00003517          	auipc	a0,0x3
    80005638:	14c50513          	addi	a0,a0,332 # 80008780 <syscalls+0x2b8>
    8000563c:	ffffb097          	auipc	ra,0xffffb
    80005640:	f04080e7          	jalr	-252(ra) # 80000540 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005644:	04c92703          	lw	a4,76(s2)
    80005648:	02000793          	li	a5,32
    8000564c:	f6e7f9e3          	bgeu	a5,a4,800055be <sys_unlink+0xaa>
    80005650:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005654:	4741                	li	a4,16
    80005656:	86ce                	mv	a3,s3
    80005658:	f1840613          	addi	a2,s0,-232
    8000565c:	4581                	li	a1,0
    8000565e:	854a                	mv	a0,s2
    80005660:	ffffe097          	auipc	ra,0xffffe
    80005664:	390080e7          	jalr	912(ra) # 800039f0 <readi>
    80005668:	47c1                	li	a5,16
    8000566a:	00f51b63          	bne	a0,a5,80005680 <sys_unlink+0x16c>
    if(de.inum != 0)
    8000566e:	f1845783          	lhu	a5,-232(s0)
    80005672:	e7a1                	bnez	a5,800056ba <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005674:	29c1                	addiw	s3,s3,16
    80005676:	04c92783          	lw	a5,76(s2)
    8000567a:	fcf9ede3          	bltu	s3,a5,80005654 <sys_unlink+0x140>
    8000567e:	b781                	j	800055be <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005680:	00003517          	auipc	a0,0x3
    80005684:	11850513          	addi	a0,a0,280 # 80008798 <syscalls+0x2d0>
    80005688:	ffffb097          	auipc	ra,0xffffb
    8000568c:	eb8080e7          	jalr	-328(ra) # 80000540 <panic>
    panic("unlink: writei");
    80005690:	00003517          	auipc	a0,0x3
    80005694:	12050513          	addi	a0,a0,288 # 800087b0 <syscalls+0x2e8>
    80005698:	ffffb097          	auipc	ra,0xffffb
    8000569c:	ea8080e7          	jalr	-344(ra) # 80000540 <panic>
    dp->nlink--;
    800056a0:	04a4d783          	lhu	a5,74(s1)
    800056a4:	37fd                	addiw	a5,a5,-1
    800056a6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800056aa:	8526                	mv	a0,s1
    800056ac:	ffffe097          	auipc	ra,0xffffe
    800056b0:	fc4080e7          	jalr	-60(ra) # 80003670 <iupdate>
    800056b4:	b781                	j	800055f4 <sys_unlink+0xe0>
    return -1;
    800056b6:	557d                	li	a0,-1
    800056b8:	a005                	j	800056d8 <sys_unlink+0x1c4>
    iunlockput(ip);
    800056ba:	854a                	mv	a0,s2
    800056bc:	ffffe097          	auipc	ra,0xffffe
    800056c0:	2e2080e7          	jalr	738(ra) # 8000399e <iunlockput>
  iunlockput(dp);
    800056c4:	8526                	mv	a0,s1
    800056c6:	ffffe097          	auipc	ra,0xffffe
    800056ca:	2d8080e7          	jalr	728(ra) # 8000399e <iunlockput>
  end_op();
    800056ce:	fffff097          	auipc	ra,0xfffff
    800056d2:	ab8080e7          	jalr	-1352(ra) # 80004186 <end_op>
  return -1;
    800056d6:	557d                	li	a0,-1
}
    800056d8:	70ae                	ld	ra,232(sp)
    800056da:	740e                	ld	s0,224(sp)
    800056dc:	64ee                	ld	s1,216(sp)
    800056de:	694e                	ld	s2,208(sp)
    800056e0:	69ae                	ld	s3,200(sp)
    800056e2:	616d                	addi	sp,sp,240
    800056e4:	8082                	ret

00000000800056e6 <sys_open>:

uint64
sys_open(void)
{
    800056e6:	7131                	addi	sp,sp,-192
    800056e8:	fd06                	sd	ra,184(sp)
    800056ea:	f922                	sd	s0,176(sp)
    800056ec:	f526                	sd	s1,168(sp)
    800056ee:	f14a                	sd	s2,160(sp)
    800056f0:	ed4e                	sd	s3,152(sp)
    800056f2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800056f4:	f4c40593          	addi	a1,s0,-180
    800056f8:	4505                	li	a0,1
    800056fa:	ffffd097          	auipc	ra,0xffffd
    800056fe:	4aa080e7          	jalr	1194(ra) # 80002ba4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005702:	08000613          	li	a2,128
    80005706:	f5040593          	addi	a1,s0,-176
    8000570a:	4501                	li	a0,0
    8000570c:	ffffd097          	auipc	ra,0xffffd
    80005710:	4d8080e7          	jalr	1240(ra) # 80002be4 <argstr>
    80005714:	87aa                	mv	a5,a0
    return -1;
    80005716:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005718:	0a07c963          	bltz	a5,800057ca <sys_open+0xe4>

  begin_op();
    8000571c:	fffff097          	auipc	ra,0xfffff
    80005720:	9ec080e7          	jalr	-1556(ra) # 80004108 <begin_op>

  if(omode & O_CREATE){
    80005724:	f4c42783          	lw	a5,-180(s0)
    80005728:	2007f793          	andi	a5,a5,512
    8000572c:	cfc5                	beqz	a5,800057e4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    8000572e:	4681                	li	a3,0
    80005730:	4601                	li	a2,0
    80005732:	4589                	li	a1,2
    80005734:	f5040513          	addi	a0,s0,-176
    80005738:	00000097          	auipc	ra,0x0
    8000573c:	972080e7          	jalr	-1678(ra) # 800050aa <create>
    80005740:	84aa                	mv	s1,a0
    if(ip == 0){
    80005742:	c959                	beqz	a0,800057d8 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005744:	04449703          	lh	a4,68(s1)
    80005748:	478d                	li	a5,3
    8000574a:	00f71763          	bne	a4,a5,80005758 <sys_open+0x72>
    8000574e:	0464d703          	lhu	a4,70(s1)
    80005752:	47a5                	li	a5,9
    80005754:	0ce7ed63          	bltu	a5,a4,8000582e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005758:	fffff097          	auipc	ra,0xfffff
    8000575c:	dbc080e7          	jalr	-580(ra) # 80004514 <filealloc>
    80005760:	89aa                	mv	s3,a0
    80005762:	10050363          	beqz	a0,80005868 <sys_open+0x182>
    80005766:	00000097          	auipc	ra,0x0
    8000576a:	902080e7          	jalr	-1790(ra) # 80005068 <fdalloc>
    8000576e:	892a                	mv	s2,a0
    80005770:	0e054763          	bltz	a0,8000585e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005774:	04449703          	lh	a4,68(s1)
    80005778:	478d                	li	a5,3
    8000577a:	0cf70563          	beq	a4,a5,80005844 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000577e:	4789                	li	a5,2
    80005780:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005784:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005788:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000578c:	f4c42783          	lw	a5,-180(s0)
    80005790:	0017c713          	xori	a4,a5,1
    80005794:	8b05                	andi	a4,a4,1
    80005796:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000579a:	0037f713          	andi	a4,a5,3
    8000579e:	00e03733          	snez	a4,a4
    800057a2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800057a6:	4007f793          	andi	a5,a5,1024
    800057aa:	c791                	beqz	a5,800057b6 <sys_open+0xd0>
    800057ac:	04449703          	lh	a4,68(s1)
    800057b0:	4789                	li	a5,2
    800057b2:	0af70063          	beq	a4,a5,80005852 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800057b6:	8526                	mv	a0,s1
    800057b8:	ffffe097          	auipc	ra,0xffffe
    800057bc:	046080e7          	jalr	70(ra) # 800037fe <iunlock>
  end_op();
    800057c0:	fffff097          	auipc	ra,0xfffff
    800057c4:	9c6080e7          	jalr	-1594(ra) # 80004186 <end_op>

  return fd;
    800057c8:	854a                	mv	a0,s2
}
    800057ca:	70ea                	ld	ra,184(sp)
    800057cc:	744a                	ld	s0,176(sp)
    800057ce:	74aa                	ld	s1,168(sp)
    800057d0:	790a                	ld	s2,160(sp)
    800057d2:	69ea                	ld	s3,152(sp)
    800057d4:	6129                	addi	sp,sp,192
    800057d6:	8082                	ret
      end_op();
    800057d8:	fffff097          	auipc	ra,0xfffff
    800057dc:	9ae080e7          	jalr	-1618(ra) # 80004186 <end_op>
      return -1;
    800057e0:	557d                	li	a0,-1
    800057e2:	b7e5                	j	800057ca <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800057e4:	f5040513          	addi	a0,s0,-176
    800057e8:	ffffe097          	auipc	ra,0xffffe
    800057ec:	700080e7          	jalr	1792(ra) # 80003ee8 <namei>
    800057f0:	84aa                	mv	s1,a0
    800057f2:	c905                	beqz	a0,80005822 <sys_open+0x13c>
    ilock(ip);
    800057f4:	ffffe097          	auipc	ra,0xffffe
    800057f8:	f48080e7          	jalr	-184(ra) # 8000373c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800057fc:	04449703          	lh	a4,68(s1)
    80005800:	4785                	li	a5,1
    80005802:	f4f711e3          	bne	a4,a5,80005744 <sys_open+0x5e>
    80005806:	f4c42783          	lw	a5,-180(s0)
    8000580a:	d7b9                	beqz	a5,80005758 <sys_open+0x72>
      iunlockput(ip);
    8000580c:	8526                	mv	a0,s1
    8000580e:	ffffe097          	auipc	ra,0xffffe
    80005812:	190080e7          	jalr	400(ra) # 8000399e <iunlockput>
      end_op();
    80005816:	fffff097          	auipc	ra,0xfffff
    8000581a:	970080e7          	jalr	-1680(ra) # 80004186 <end_op>
      return -1;
    8000581e:	557d                	li	a0,-1
    80005820:	b76d                	j	800057ca <sys_open+0xe4>
      end_op();
    80005822:	fffff097          	auipc	ra,0xfffff
    80005826:	964080e7          	jalr	-1692(ra) # 80004186 <end_op>
      return -1;
    8000582a:	557d                	li	a0,-1
    8000582c:	bf79                	j	800057ca <sys_open+0xe4>
    iunlockput(ip);
    8000582e:	8526                	mv	a0,s1
    80005830:	ffffe097          	auipc	ra,0xffffe
    80005834:	16e080e7          	jalr	366(ra) # 8000399e <iunlockput>
    end_op();
    80005838:	fffff097          	auipc	ra,0xfffff
    8000583c:	94e080e7          	jalr	-1714(ra) # 80004186 <end_op>
    return -1;
    80005840:	557d                	li	a0,-1
    80005842:	b761                	j	800057ca <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005844:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005848:	04649783          	lh	a5,70(s1)
    8000584c:	02f99223          	sh	a5,36(s3)
    80005850:	bf25                	j	80005788 <sys_open+0xa2>
    itrunc(ip);
    80005852:	8526                	mv	a0,s1
    80005854:	ffffe097          	auipc	ra,0xffffe
    80005858:	ff6080e7          	jalr	-10(ra) # 8000384a <itrunc>
    8000585c:	bfa9                	j	800057b6 <sys_open+0xd0>
      fileclose(f);
    8000585e:	854e                	mv	a0,s3
    80005860:	fffff097          	auipc	ra,0xfffff
    80005864:	d70080e7          	jalr	-656(ra) # 800045d0 <fileclose>
    iunlockput(ip);
    80005868:	8526                	mv	a0,s1
    8000586a:	ffffe097          	auipc	ra,0xffffe
    8000586e:	134080e7          	jalr	308(ra) # 8000399e <iunlockput>
    end_op();
    80005872:	fffff097          	auipc	ra,0xfffff
    80005876:	914080e7          	jalr	-1772(ra) # 80004186 <end_op>
    return -1;
    8000587a:	557d                	li	a0,-1
    8000587c:	b7b9                	j	800057ca <sys_open+0xe4>

000000008000587e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000587e:	7175                	addi	sp,sp,-144
    80005880:	e506                	sd	ra,136(sp)
    80005882:	e122                	sd	s0,128(sp)
    80005884:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005886:	fffff097          	auipc	ra,0xfffff
    8000588a:	882080e7          	jalr	-1918(ra) # 80004108 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000588e:	08000613          	li	a2,128
    80005892:	f7040593          	addi	a1,s0,-144
    80005896:	4501                	li	a0,0
    80005898:	ffffd097          	auipc	ra,0xffffd
    8000589c:	34c080e7          	jalr	844(ra) # 80002be4 <argstr>
    800058a0:	02054963          	bltz	a0,800058d2 <sys_mkdir+0x54>
    800058a4:	4681                	li	a3,0
    800058a6:	4601                	li	a2,0
    800058a8:	4585                	li	a1,1
    800058aa:	f7040513          	addi	a0,s0,-144
    800058ae:	fffff097          	auipc	ra,0xfffff
    800058b2:	7fc080e7          	jalr	2044(ra) # 800050aa <create>
    800058b6:	cd11                	beqz	a0,800058d2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058b8:	ffffe097          	auipc	ra,0xffffe
    800058bc:	0e6080e7          	jalr	230(ra) # 8000399e <iunlockput>
  end_op();
    800058c0:	fffff097          	auipc	ra,0xfffff
    800058c4:	8c6080e7          	jalr	-1850(ra) # 80004186 <end_op>
  return 0;
    800058c8:	4501                	li	a0,0
}
    800058ca:	60aa                	ld	ra,136(sp)
    800058cc:	640a                	ld	s0,128(sp)
    800058ce:	6149                	addi	sp,sp,144
    800058d0:	8082                	ret
    end_op();
    800058d2:	fffff097          	auipc	ra,0xfffff
    800058d6:	8b4080e7          	jalr	-1868(ra) # 80004186 <end_op>
    return -1;
    800058da:	557d                	li	a0,-1
    800058dc:	b7fd                	j	800058ca <sys_mkdir+0x4c>

00000000800058de <sys_mknod>:

uint64
sys_mknod(void)
{
    800058de:	7135                	addi	sp,sp,-160
    800058e0:	ed06                	sd	ra,152(sp)
    800058e2:	e922                	sd	s0,144(sp)
    800058e4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800058e6:	fffff097          	auipc	ra,0xfffff
    800058ea:	822080e7          	jalr	-2014(ra) # 80004108 <begin_op>
  argint(1, &major);
    800058ee:	f6c40593          	addi	a1,s0,-148
    800058f2:	4505                	li	a0,1
    800058f4:	ffffd097          	auipc	ra,0xffffd
    800058f8:	2b0080e7          	jalr	688(ra) # 80002ba4 <argint>
  argint(2, &minor);
    800058fc:	f6840593          	addi	a1,s0,-152
    80005900:	4509                	li	a0,2
    80005902:	ffffd097          	auipc	ra,0xffffd
    80005906:	2a2080e7          	jalr	674(ra) # 80002ba4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000590a:	08000613          	li	a2,128
    8000590e:	f7040593          	addi	a1,s0,-144
    80005912:	4501                	li	a0,0
    80005914:	ffffd097          	auipc	ra,0xffffd
    80005918:	2d0080e7          	jalr	720(ra) # 80002be4 <argstr>
    8000591c:	02054b63          	bltz	a0,80005952 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005920:	f6841683          	lh	a3,-152(s0)
    80005924:	f6c41603          	lh	a2,-148(s0)
    80005928:	458d                	li	a1,3
    8000592a:	f7040513          	addi	a0,s0,-144
    8000592e:	fffff097          	auipc	ra,0xfffff
    80005932:	77c080e7          	jalr	1916(ra) # 800050aa <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005936:	cd11                	beqz	a0,80005952 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005938:	ffffe097          	auipc	ra,0xffffe
    8000593c:	066080e7          	jalr	102(ra) # 8000399e <iunlockput>
  end_op();
    80005940:	fffff097          	auipc	ra,0xfffff
    80005944:	846080e7          	jalr	-1978(ra) # 80004186 <end_op>
  return 0;
    80005948:	4501                	li	a0,0
}
    8000594a:	60ea                	ld	ra,152(sp)
    8000594c:	644a                	ld	s0,144(sp)
    8000594e:	610d                	addi	sp,sp,160
    80005950:	8082                	ret
    end_op();
    80005952:	fffff097          	auipc	ra,0xfffff
    80005956:	834080e7          	jalr	-1996(ra) # 80004186 <end_op>
    return -1;
    8000595a:	557d                	li	a0,-1
    8000595c:	b7fd                	j	8000594a <sys_mknod+0x6c>

000000008000595e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000595e:	7135                	addi	sp,sp,-160
    80005960:	ed06                	sd	ra,152(sp)
    80005962:	e922                	sd	s0,144(sp)
    80005964:	e526                	sd	s1,136(sp)
    80005966:	e14a                	sd	s2,128(sp)
    80005968:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	054080e7          	jalr	84(ra) # 800019be <myproc>
    80005972:	892a                	mv	s2,a0
  
  begin_op();
    80005974:	ffffe097          	auipc	ra,0xffffe
    80005978:	794080e7          	jalr	1940(ra) # 80004108 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000597c:	08000613          	li	a2,128
    80005980:	f6040593          	addi	a1,s0,-160
    80005984:	4501                	li	a0,0
    80005986:	ffffd097          	auipc	ra,0xffffd
    8000598a:	25e080e7          	jalr	606(ra) # 80002be4 <argstr>
    8000598e:	04054b63          	bltz	a0,800059e4 <sys_chdir+0x86>
    80005992:	f6040513          	addi	a0,s0,-160
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	552080e7          	jalr	1362(ra) # 80003ee8 <namei>
    8000599e:	84aa                	mv	s1,a0
    800059a0:	c131                	beqz	a0,800059e4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800059a2:	ffffe097          	auipc	ra,0xffffe
    800059a6:	d9a080e7          	jalr	-614(ra) # 8000373c <ilock>
  if(ip->type != T_DIR){
    800059aa:	04449703          	lh	a4,68(s1)
    800059ae:	4785                	li	a5,1
    800059b0:	04f71063          	bne	a4,a5,800059f0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059b4:	8526                	mv	a0,s1
    800059b6:	ffffe097          	auipc	ra,0xffffe
    800059ba:	e48080e7          	jalr	-440(ra) # 800037fe <iunlock>
  iput(p->cwd);
    800059be:	15893503          	ld	a0,344(s2)
    800059c2:	ffffe097          	auipc	ra,0xffffe
    800059c6:	f34080e7          	jalr	-204(ra) # 800038f6 <iput>
  end_op();
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	7bc080e7          	jalr	1980(ra) # 80004186 <end_op>
  p->cwd = ip;
    800059d2:	14993c23          	sd	s1,344(s2)
  return 0;
    800059d6:	4501                	li	a0,0
}
    800059d8:	60ea                	ld	ra,152(sp)
    800059da:	644a                	ld	s0,144(sp)
    800059dc:	64aa                	ld	s1,136(sp)
    800059de:	690a                	ld	s2,128(sp)
    800059e0:	610d                	addi	sp,sp,160
    800059e2:	8082                	ret
    end_op();
    800059e4:	ffffe097          	auipc	ra,0xffffe
    800059e8:	7a2080e7          	jalr	1954(ra) # 80004186 <end_op>
    return -1;
    800059ec:	557d                	li	a0,-1
    800059ee:	b7ed                	j	800059d8 <sys_chdir+0x7a>
    iunlockput(ip);
    800059f0:	8526                	mv	a0,s1
    800059f2:	ffffe097          	auipc	ra,0xffffe
    800059f6:	fac080e7          	jalr	-84(ra) # 8000399e <iunlockput>
    end_op();
    800059fa:	ffffe097          	auipc	ra,0xffffe
    800059fe:	78c080e7          	jalr	1932(ra) # 80004186 <end_op>
    return -1;
    80005a02:	557d                	li	a0,-1
    80005a04:	bfd1                	j	800059d8 <sys_chdir+0x7a>

0000000080005a06 <sys_exec>:

uint64
sys_exec(void)
{
    80005a06:	7145                	addi	sp,sp,-464
    80005a08:	e786                	sd	ra,456(sp)
    80005a0a:	e3a2                	sd	s0,448(sp)
    80005a0c:	ff26                	sd	s1,440(sp)
    80005a0e:	fb4a                	sd	s2,432(sp)
    80005a10:	f74e                	sd	s3,424(sp)
    80005a12:	f352                	sd	s4,416(sp)
    80005a14:	ef56                	sd	s5,408(sp)
    80005a16:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005a18:	e3840593          	addi	a1,s0,-456
    80005a1c:	4505                	li	a0,1
    80005a1e:	ffffd097          	auipc	ra,0xffffd
    80005a22:	1a6080e7          	jalr	422(ra) # 80002bc4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005a26:	08000613          	li	a2,128
    80005a2a:	f4040593          	addi	a1,s0,-192
    80005a2e:	4501                	li	a0,0
    80005a30:	ffffd097          	auipc	ra,0xffffd
    80005a34:	1b4080e7          	jalr	436(ra) # 80002be4 <argstr>
    80005a38:	87aa                	mv	a5,a0
    return -1;
    80005a3a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005a3c:	0c07c363          	bltz	a5,80005b02 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005a40:	10000613          	li	a2,256
    80005a44:	4581                	li	a1,0
    80005a46:	e4040513          	addi	a0,s0,-448
    80005a4a:	ffffb097          	auipc	ra,0xffffb
    80005a4e:	288080e7          	jalr	648(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a52:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005a56:	89a6                	mv	s3,s1
    80005a58:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a5a:	02000a13          	li	s4,32
    80005a5e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a62:	00391513          	slli	a0,s2,0x3
    80005a66:	e3040593          	addi	a1,s0,-464
    80005a6a:	e3843783          	ld	a5,-456(s0)
    80005a6e:	953e                	add	a0,a0,a5
    80005a70:	ffffd097          	auipc	ra,0xffffd
    80005a74:	096080e7          	jalr	150(ra) # 80002b06 <fetchaddr>
    80005a78:	02054a63          	bltz	a0,80005aac <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005a7c:	e3043783          	ld	a5,-464(s0)
    80005a80:	c3b9                	beqz	a5,80005ac6 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a82:	ffffb097          	auipc	ra,0xffffb
    80005a86:	064080e7          	jalr	100(ra) # 80000ae6 <kalloc>
    80005a8a:	85aa                	mv	a1,a0
    80005a8c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a90:	cd11                	beqz	a0,80005aac <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a92:	6605                	lui	a2,0x1
    80005a94:	e3043503          	ld	a0,-464(s0)
    80005a98:	ffffd097          	auipc	ra,0xffffd
    80005a9c:	0c0080e7          	jalr	192(ra) # 80002b58 <fetchstr>
    80005aa0:	00054663          	bltz	a0,80005aac <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005aa4:	0905                	addi	s2,s2,1
    80005aa6:	09a1                	addi	s3,s3,8
    80005aa8:	fb491be3          	bne	s2,s4,80005a5e <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aac:	f4040913          	addi	s2,s0,-192
    80005ab0:	6088                	ld	a0,0(s1)
    80005ab2:	c539                	beqz	a0,80005b00 <sys_exec+0xfa>
    kfree(argv[i]);
    80005ab4:	ffffb097          	auipc	ra,0xffffb
    80005ab8:	f34080e7          	jalr	-204(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005abc:	04a1                	addi	s1,s1,8
    80005abe:	ff2499e3          	bne	s1,s2,80005ab0 <sys_exec+0xaa>
  return -1;
    80005ac2:	557d                	li	a0,-1
    80005ac4:	a83d                	j	80005b02 <sys_exec+0xfc>
      argv[i] = 0;
    80005ac6:	0a8e                	slli	s5,s5,0x3
    80005ac8:	fc0a8793          	addi	a5,s5,-64
    80005acc:	00878ab3          	add	s5,a5,s0
    80005ad0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005ad4:	e4040593          	addi	a1,s0,-448
    80005ad8:	f4040513          	addi	a0,s0,-192
    80005adc:	fffff097          	auipc	ra,0xfffff
    80005ae0:	16e080e7          	jalr	366(ra) # 80004c4a <exec>
    80005ae4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ae6:	f4040993          	addi	s3,s0,-192
    80005aea:	6088                	ld	a0,0(s1)
    80005aec:	c901                	beqz	a0,80005afc <sys_exec+0xf6>
    kfree(argv[i]);
    80005aee:	ffffb097          	auipc	ra,0xffffb
    80005af2:	efa080e7          	jalr	-262(ra) # 800009e8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005af6:	04a1                	addi	s1,s1,8
    80005af8:	ff3499e3          	bne	s1,s3,80005aea <sys_exec+0xe4>
  return ret;
    80005afc:	854a                	mv	a0,s2
    80005afe:	a011                	j	80005b02 <sys_exec+0xfc>
  return -1;
    80005b00:	557d                	li	a0,-1
}
    80005b02:	60be                	ld	ra,456(sp)
    80005b04:	641e                	ld	s0,448(sp)
    80005b06:	74fa                	ld	s1,440(sp)
    80005b08:	795a                	ld	s2,432(sp)
    80005b0a:	79ba                	ld	s3,424(sp)
    80005b0c:	7a1a                	ld	s4,416(sp)
    80005b0e:	6afa                	ld	s5,408(sp)
    80005b10:	6179                	addi	sp,sp,464
    80005b12:	8082                	ret

0000000080005b14 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b14:	7139                	addi	sp,sp,-64
    80005b16:	fc06                	sd	ra,56(sp)
    80005b18:	f822                	sd	s0,48(sp)
    80005b1a:	f426                	sd	s1,40(sp)
    80005b1c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b1e:	ffffc097          	auipc	ra,0xffffc
    80005b22:	ea0080e7          	jalr	-352(ra) # 800019be <myproc>
    80005b26:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005b28:	fd840593          	addi	a1,s0,-40
    80005b2c:	4501                	li	a0,0
    80005b2e:	ffffd097          	auipc	ra,0xffffd
    80005b32:	096080e7          	jalr	150(ra) # 80002bc4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005b36:	fc840593          	addi	a1,s0,-56
    80005b3a:	fd040513          	addi	a0,s0,-48
    80005b3e:	fffff097          	auipc	ra,0xfffff
    80005b42:	dc2080e7          	jalr	-574(ra) # 80004900 <pipealloc>
    return -1;
    80005b46:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b48:	0c054463          	bltz	a0,80005c10 <sys_pipe+0xfc>
  fd0 = -1;
    80005b4c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b50:	fd043503          	ld	a0,-48(s0)
    80005b54:	fffff097          	auipc	ra,0xfffff
    80005b58:	514080e7          	jalr	1300(ra) # 80005068 <fdalloc>
    80005b5c:	fca42223          	sw	a0,-60(s0)
    80005b60:	08054b63          	bltz	a0,80005bf6 <sys_pipe+0xe2>
    80005b64:	fc843503          	ld	a0,-56(s0)
    80005b68:	fffff097          	auipc	ra,0xfffff
    80005b6c:	500080e7          	jalr	1280(ra) # 80005068 <fdalloc>
    80005b70:	fca42023          	sw	a0,-64(s0)
    80005b74:	06054863          	bltz	a0,80005be4 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b78:	4691                	li	a3,4
    80005b7a:	fc440613          	addi	a2,s0,-60
    80005b7e:	fd843583          	ld	a1,-40(s0)
    80005b82:	6ca8                	ld	a0,88(s1)
    80005b84:	ffffc097          	auipc	ra,0xffffc
    80005b88:	ae8080e7          	jalr	-1304(ra) # 8000166c <copyout>
    80005b8c:	02054063          	bltz	a0,80005bac <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b90:	4691                	li	a3,4
    80005b92:	fc040613          	addi	a2,s0,-64
    80005b96:	fd843583          	ld	a1,-40(s0)
    80005b9a:	0591                	addi	a1,a1,4
    80005b9c:	6ca8                	ld	a0,88(s1)
    80005b9e:	ffffc097          	auipc	ra,0xffffc
    80005ba2:	ace080e7          	jalr	-1330(ra) # 8000166c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005ba6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ba8:	06055463          	bgez	a0,80005c10 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005bac:	fc442783          	lw	a5,-60(s0)
    80005bb0:	07e9                	addi	a5,a5,26
    80005bb2:	078e                	slli	a5,a5,0x3
    80005bb4:	97a6                	add	a5,a5,s1
    80005bb6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005bba:	fc042783          	lw	a5,-64(s0)
    80005bbe:	07e9                	addi	a5,a5,26
    80005bc0:	078e                	slli	a5,a5,0x3
    80005bc2:	94be                	add	s1,s1,a5
    80005bc4:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005bc8:	fd043503          	ld	a0,-48(s0)
    80005bcc:	fffff097          	auipc	ra,0xfffff
    80005bd0:	a04080e7          	jalr	-1532(ra) # 800045d0 <fileclose>
    fileclose(wf);
    80005bd4:	fc843503          	ld	a0,-56(s0)
    80005bd8:	fffff097          	auipc	ra,0xfffff
    80005bdc:	9f8080e7          	jalr	-1544(ra) # 800045d0 <fileclose>
    return -1;
    80005be0:	57fd                	li	a5,-1
    80005be2:	a03d                	j	80005c10 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005be4:	fc442783          	lw	a5,-60(s0)
    80005be8:	0007c763          	bltz	a5,80005bf6 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005bec:	07e9                	addi	a5,a5,26
    80005bee:	078e                	slli	a5,a5,0x3
    80005bf0:	97a6                	add	a5,a5,s1
    80005bf2:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005bf6:	fd043503          	ld	a0,-48(s0)
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	9d6080e7          	jalr	-1578(ra) # 800045d0 <fileclose>
    fileclose(wf);
    80005c02:	fc843503          	ld	a0,-56(s0)
    80005c06:	fffff097          	auipc	ra,0xfffff
    80005c0a:	9ca080e7          	jalr	-1590(ra) # 800045d0 <fileclose>
    return -1;
    80005c0e:	57fd                	li	a5,-1
}
    80005c10:	853e                	mv	a0,a5
    80005c12:	70e2                	ld	ra,56(sp)
    80005c14:	7442                	ld	s0,48(sp)
    80005c16:	74a2                	ld	s1,40(sp)
    80005c18:	6121                	addi	sp,sp,64
    80005c1a:	8082                	ret
    80005c1c:	0000                	unimp
	...

0000000080005c20 <kernelvec>:
    80005c20:	7111                	addi	sp,sp,-256
    80005c22:	e006                	sd	ra,0(sp)
    80005c24:	e40a                	sd	sp,8(sp)
    80005c26:	e80e                	sd	gp,16(sp)
    80005c28:	ec12                	sd	tp,24(sp)
    80005c2a:	f016                	sd	t0,32(sp)
    80005c2c:	f41a                	sd	t1,40(sp)
    80005c2e:	f81e                	sd	t2,48(sp)
    80005c30:	fc22                	sd	s0,56(sp)
    80005c32:	e0a6                	sd	s1,64(sp)
    80005c34:	e4aa                	sd	a0,72(sp)
    80005c36:	e8ae                	sd	a1,80(sp)
    80005c38:	ecb2                	sd	a2,88(sp)
    80005c3a:	f0b6                	sd	a3,96(sp)
    80005c3c:	f4ba                	sd	a4,104(sp)
    80005c3e:	f8be                	sd	a5,112(sp)
    80005c40:	fcc2                	sd	a6,120(sp)
    80005c42:	e146                	sd	a7,128(sp)
    80005c44:	e54a                	sd	s2,136(sp)
    80005c46:	e94e                	sd	s3,144(sp)
    80005c48:	ed52                	sd	s4,152(sp)
    80005c4a:	f156                	sd	s5,160(sp)
    80005c4c:	f55a                	sd	s6,168(sp)
    80005c4e:	f95e                	sd	s7,176(sp)
    80005c50:	fd62                	sd	s8,184(sp)
    80005c52:	e1e6                	sd	s9,192(sp)
    80005c54:	e5ea                	sd	s10,200(sp)
    80005c56:	e9ee                	sd	s11,208(sp)
    80005c58:	edf2                	sd	t3,216(sp)
    80005c5a:	f1f6                	sd	t4,224(sp)
    80005c5c:	f5fa                	sd	t5,232(sp)
    80005c5e:	f9fe                	sd	t6,240(sp)
    80005c60:	d73fc0ef          	jal	ra,800029d2 <kerneltrap>
    80005c64:	6082                	ld	ra,0(sp)
    80005c66:	6122                	ld	sp,8(sp)
    80005c68:	61c2                	ld	gp,16(sp)
    80005c6a:	7282                	ld	t0,32(sp)
    80005c6c:	7322                	ld	t1,40(sp)
    80005c6e:	73c2                	ld	t2,48(sp)
    80005c70:	7462                	ld	s0,56(sp)
    80005c72:	6486                	ld	s1,64(sp)
    80005c74:	6526                	ld	a0,72(sp)
    80005c76:	65c6                	ld	a1,80(sp)
    80005c78:	6666                	ld	a2,88(sp)
    80005c7a:	7686                	ld	a3,96(sp)
    80005c7c:	7726                	ld	a4,104(sp)
    80005c7e:	77c6                	ld	a5,112(sp)
    80005c80:	7866                	ld	a6,120(sp)
    80005c82:	688a                	ld	a7,128(sp)
    80005c84:	692a                	ld	s2,136(sp)
    80005c86:	69ca                	ld	s3,144(sp)
    80005c88:	6a6a                	ld	s4,152(sp)
    80005c8a:	7a8a                	ld	s5,160(sp)
    80005c8c:	7b2a                	ld	s6,168(sp)
    80005c8e:	7bca                	ld	s7,176(sp)
    80005c90:	7c6a                	ld	s8,184(sp)
    80005c92:	6c8e                	ld	s9,192(sp)
    80005c94:	6d2e                	ld	s10,200(sp)
    80005c96:	6dce                	ld	s11,208(sp)
    80005c98:	6e6e                	ld	t3,216(sp)
    80005c9a:	7e8e                	ld	t4,224(sp)
    80005c9c:	7f2e                	ld	t5,232(sp)
    80005c9e:	7fce                	ld	t6,240(sp)
    80005ca0:	6111                	addi	sp,sp,256
    80005ca2:	10200073          	sret
    80005ca6:	00000013          	nop
    80005caa:	00000013          	nop
    80005cae:	0001                	nop

0000000080005cb0 <timervec>:
    80005cb0:	34051573          	csrrw	a0,mscratch,a0
    80005cb4:	e10c                	sd	a1,0(a0)
    80005cb6:	e510                	sd	a2,8(a0)
    80005cb8:	e914                	sd	a3,16(a0)
    80005cba:	6d0c                	ld	a1,24(a0)
    80005cbc:	7110                	ld	a2,32(a0)
    80005cbe:	6194                	ld	a3,0(a1)
    80005cc0:	96b2                	add	a3,a3,a2
    80005cc2:	e194                	sd	a3,0(a1)
    80005cc4:	4589                	li	a1,2
    80005cc6:	14459073          	csrw	sip,a1
    80005cca:	6914                	ld	a3,16(a0)
    80005ccc:	6510                	ld	a2,8(a0)
    80005cce:	610c                	ld	a1,0(a0)
    80005cd0:	34051573          	csrrw	a0,mscratch,a0
    80005cd4:	30200073          	mret
	...

0000000080005cda <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005cda:	1141                	addi	sp,sp,-16
    80005cdc:	e422                	sd	s0,8(sp)
    80005cde:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005ce0:	0c0007b7          	lui	a5,0xc000
    80005ce4:	4705                	li	a4,1
    80005ce6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005ce8:	c3d8                	sw	a4,4(a5)
}
    80005cea:	6422                	ld	s0,8(sp)
    80005cec:	0141                	addi	sp,sp,16
    80005cee:	8082                	ret

0000000080005cf0 <plicinithart>:

void
plicinithart(void)
{
    80005cf0:	1141                	addi	sp,sp,-16
    80005cf2:	e406                	sd	ra,8(sp)
    80005cf4:	e022                	sd	s0,0(sp)
    80005cf6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005cf8:	ffffc097          	auipc	ra,0xffffc
    80005cfc:	c9a080e7          	jalr	-870(ra) # 80001992 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005d00:	0085171b          	slliw	a4,a0,0x8
    80005d04:	0c0027b7          	lui	a5,0xc002
    80005d08:	97ba                	add	a5,a5,a4
    80005d0a:	40200713          	li	a4,1026
    80005d0e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005d12:	00d5151b          	slliw	a0,a0,0xd
    80005d16:	0c2017b7          	lui	a5,0xc201
    80005d1a:	97aa                	add	a5,a5,a0
    80005d1c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005d20:	60a2                	ld	ra,8(sp)
    80005d22:	6402                	ld	s0,0(sp)
    80005d24:	0141                	addi	sp,sp,16
    80005d26:	8082                	ret

0000000080005d28 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005d28:	1141                	addi	sp,sp,-16
    80005d2a:	e406                	sd	ra,8(sp)
    80005d2c:	e022                	sd	s0,0(sp)
    80005d2e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d30:	ffffc097          	auipc	ra,0xffffc
    80005d34:	c62080e7          	jalr	-926(ra) # 80001992 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d38:	00d5151b          	slliw	a0,a0,0xd
    80005d3c:	0c2017b7          	lui	a5,0xc201
    80005d40:	97aa                	add	a5,a5,a0
  return irq;
}
    80005d42:	43c8                	lw	a0,4(a5)
    80005d44:	60a2                	ld	ra,8(sp)
    80005d46:	6402                	ld	s0,0(sp)
    80005d48:	0141                	addi	sp,sp,16
    80005d4a:	8082                	ret

0000000080005d4c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005d4c:	1101                	addi	sp,sp,-32
    80005d4e:	ec06                	sd	ra,24(sp)
    80005d50:	e822                	sd	s0,16(sp)
    80005d52:	e426                	sd	s1,8(sp)
    80005d54:	1000                	addi	s0,sp,32
    80005d56:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d58:	ffffc097          	auipc	ra,0xffffc
    80005d5c:	c3a080e7          	jalr	-966(ra) # 80001992 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d60:	00d5151b          	slliw	a0,a0,0xd
    80005d64:	0c2017b7          	lui	a5,0xc201
    80005d68:	97aa                	add	a5,a5,a0
    80005d6a:	c3c4                	sw	s1,4(a5)
}
    80005d6c:	60e2                	ld	ra,24(sp)
    80005d6e:	6442                	ld	s0,16(sp)
    80005d70:	64a2                	ld	s1,8(sp)
    80005d72:	6105                	addi	sp,sp,32
    80005d74:	8082                	ret

0000000080005d76 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005d76:	1141                	addi	sp,sp,-16
    80005d78:	e406                	sd	ra,8(sp)
    80005d7a:	e022                	sd	s0,0(sp)
    80005d7c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d7e:	479d                	li	a5,7
    80005d80:	04a7cc63          	blt	a5,a0,80005dd8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005d84:	0001c797          	auipc	a5,0x1c
    80005d88:	11c78793          	addi	a5,a5,284 # 80021ea0 <disk>
    80005d8c:	97aa                	add	a5,a5,a0
    80005d8e:	0187c783          	lbu	a5,24(a5)
    80005d92:	ebb9                	bnez	a5,80005de8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005d94:	00451693          	slli	a3,a0,0x4
    80005d98:	0001c797          	auipc	a5,0x1c
    80005d9c:	10878793          	addi	a5,a5,264 # 80021ea0 <disk>
    80005da0:	6398                	ld	a4,0(a5)
    80005da2:	9736                	add	a4,a4,a3
    80005da4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005da8:	6398                	ld	a4,0(a5)
    80005daa:	9736                	add	a4,a4,a3
    80005dac:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005db0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005db4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005db8:	97aa                	add	a5,a5,a0
    80005dba:	4705                	li	a4,1
    80005dbc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005dc0:	0001c517          	auipc	a0,0x1c
    80005dc4:	0f850513          	addi	a0,a0,248 # 80021eb8 <disk+0x18>
    80005dc8:	ffffc097          	auipc	ra,0xffffc
    80005dcc:	358080e7          	jalr	856(ra) # 80002120 <wakeup>
}
    80005dd0:	60a2                	ld	ra,8(sp)
    80005dd2:	6402                	ld	s0,0(sp)
    80005dd4:	0141                	addi	sp,sp,16
    80005dd6:	8082                	ret
    panic("free_desc 1");
    80005dd8:	00003517          	auipc	a0,0x3
    80005ddc:	9e850513          	addi	a0,a0,-1560 # 800087c0 <syscalls+0x2f8>
    80005de0:	ffffa097          	auipc	ra,0xffffa
    80005de4:	760080e7          	jalr	1888(ra) # 80000540 <panic>
    panic("free_desc 2");
    80005de8:	00003517          	auipc	a0,0x3
    80005dec:	9e850513          	addi	a0,a0,-1560 # 800087d0 <syscalls+0x308>
    80005df0:	ffffa097          	auipc	ra,0xffffa
    80005df4:	750080e7          	jalr	1872(ra) # 80000540 <panic>

0000000080005df8 <virtio_disk_init>:
{
    80005df8:	1101                	addi	sp,sp,-32
    80005dfa:	ec06                	sd	ra,24(sp)
    80005dfc:	e822                	sd	s0,16(sp)
    80005dfe:	e426                	sd	s1,8(sp)
    80005e00:	e04a                	sd	s2,0(sp)
    80005e02:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005e04:	00003597          	auipc	a1,0x3
    80005e08:	9dc58593          	addi	a1,a1,-1572 # 800087e0 <syscalls+0x318>
    80005e0c:	0001c517          	auipc	a0,0x1c
    80005e10:	1bc50513          	addi	a0,a0,444 # 80021fc8 <disk+0x128>
    80005e14:	ffffb097          	auipc	ra,0xffffb
    80005e18:	d32080e7          	jalr	-718(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e1c:	100017b7          	lui	a5,0x10001
    80005e20:	4398                	lw	a4,0(a5)
    80005e22:	2701                	sext.w	a4,a4
    80005e24:	747277b7          	lui	a5,0x74727
    80005e28:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e2c:	14f71b63          	bne	a4,a5,80005f82 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005e30:	100017b7          	lui	a5,0x10001
    80005e34:	43dc                	lw	a5,4(a5)
    80005e36:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e38:	4709                	li	a4,2
    80005e3a:	14e79463          	bne	a5,a4,80005f82 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e3e:	100017b7          	lui	a5,0x10001
    80005e42:	479c                	lw	a5,8(a5)
    80005e44:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005e46:	12e79e63          	bne	a5,a4,80005f82 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e4a:	100017b7          	lui	a5,0x10001
    80005e4e:	47d8                	lw	a4,12(a5)
    80005e50:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e52:	554d47b7          	lui	a5,0x554d4
    80005e56:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e5a:	12f71463          	bne	a4,a5,80005f82 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e5e:	100017b7          	lui	a5,0x10001
    80005e62:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e66:	4705                	li	a4,1
    80005e68:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e6a:	470d                	li	a4,3
    80005e6c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e6e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e70:	c7ffe6b7          	lui	a3,0xc7ffe
    80005e74:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc77f>
    80005e78:	8f75                	and	a4,a4,a3
    80005e7a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e7c:	472d                	li	a4,11
    80005e7e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005e80:	5bbc                	lw	a5,112(a5)
    80005e82:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005e86:	8ba1                	andi	a5,a5,8
    80005e88:	10078563          	beqz	a5,80005f92 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e8c:	100017b7          	lui	a5,0x10001
    80005e90:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005e94:	43fc                	lw	a5,68(a5)
    80005e96:	2781                	sext.w	a5,a5
    80005e98:	10079563          	bnez	a5,80005fa2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e9c:	100017b7          	lui	a5,0x10001
    80005ea0:	5bdc                	lw	a5,52(a5)
    80005ea2:	2781                	sext.w	a5,a5
  if(max == 0)
    80005ea4:	10078763          	beqz	a5,80005fb2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005ea8:	471d                	li	a4,7
    80005eaa:	10f77c63          	bgeu	a4,a5,80005fc2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005eae:	ffffb097          	auipc	ra,0xffffb
    80005eb2:	c38080e7          	jalr	-968(ra) # 80000ae6 <kalloc>
    80005eb6:	0001c497          	auipc	s1,0x1c
    80005eba:	fea48493          	addi	s1,s1,-22 # 80021ea0 <disk>
    80005ebe:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005ec0:	ffffb097          	auipc	ra,0xffffb
    80005ec4:	c26080e7          	jalr	-986(ra) # 80000ae6 <kalloc>
    80005ec8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005eca:	ffffb097          	auipc	ra,0xffffb
    80005ece:	c1c080e7          	jalr	-996(ra) # 80000ae6 <kalloc>
    80005ed2:	87aa                	mv	a5,a0
    80005ed4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005ed6:	6088                	ld	a0,0(s1)
    80005ed8:	cd6d                	beqz	a0,80005fd2 <virtio_disk_init+0x1da>
    80005eda:	0001c717          	auipc	a4,0x1c
    80005ede:	fce73703          	ld	a4,-50(a4) # 80021ea8 <disk+0x8>
    80005ee2:	cb65                	beqz	a4,80005fd2 <virtio_disk_init+0x1da>
    80005ee4:	c7fd                	beqz	a5,80005fd2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005ee6:	6605                	lui	a2,0x1
    80005ee8:	4581                	li	a1,0
    80005eea:	ffffb097          	auipc	ra,0xffffb
    80005eee:	de8080e7          	jalr	-536(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005ef2:	0001c497          	auipc	s1,0x1c
    80005ef6:	fae48493          	addi	s1,s1,-82 # 80021ea0 <disk>
    80005efa:	6605                	lui	a2,0x1
    80005efc:	4581                	li	a1,0
    80005efe:	6488                	ld	a0,8(s1)
    80005f00:	ffffb097          	auipc	ra,0xffffb
    80005f04:	dd2080e7          	jalr	-558(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    80005f08:	6605                	lui	a2,0x1
    80005f0a:	4581                	li	a1,0
    80005f0c:	6888                	ld	a0,16(s1)
    80005f0e:	ffffb097          	auipc	ra,0xffffb
    80005f12:	dc4080e7          	jalr	-572(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005f16:	100017b7          	lui	a5,0x10001
    80005f1a:	4721                	li	a4,8
    80005f1c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005f1e:	4098                	lw	a4,0(s1)
    80005f20:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005f24:	40d8                	lw	a4,4(s1)
    80005f26:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005f2a:	6498                	ld	a4,8(s1)
    80005f2c:	0007069b          	sext.w	a3,a4
    80005f30:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005f34:	9701                	srai	a4,a4,0x20
    80005f36:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005f3a:	6898                	ld	a4,16(s1)
    80005f3c:	0007069b          	sext.w	a3,a4
    80005f40:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005f44:	9701                	srai	a4,a4,0x20
    80005f46:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005f4a:	4705                	li	a4,1
    80005f4c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005f4e:	00e48c23          	sb	a4,24(s1)
    80005f52:	00e48ca3          	sb	a4,25(s1)
    80005f56:	00e48d23          	sb	a4,26(s1)
    80005f5a:	00e48da3          	sb	a4,27(s1)
    80005f5e:	00e48e23          	sb	a4,28(s1)
    80005f62:	00e48ea3          	sb	a4,29(s1)
    80005f66:	00e48f23          	sb	a4,30(s1)
    80005f6a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005f6e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f72:	0727a823          	sw	s2,112(a5)
}
    80005f76:	60e2                	ld	ra,24(sp)
    80005f78:	6442                	ld	s0,16(sp)
    80005f7a:	64a2                	ld	s1,8(sp)
    80005f7c:	6902                	ld	s2,0(sp)
    80005f7e:	6105                	addi	sp,sp,32
    80005f80:	8082                	ret
    panic("could not find virtio disk");
    80005f82:	00003517          	auipc	a0,0x3
    80005f86:	86e50513          	addi	a0,a0,-1938 # 800087f0 <syscalls+0x328>
    80005f8a:	ffffa097          	auipc	ra,0xffffa
    80005f8e:	5b6080e7          	jalr	1462(ra) # 80000540 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005f92:	00003517          	auipc	a0,0x3
    80005f96:	87e50513          	addi	a0,a0,-1922 # 80008810 <syscalls+0x348>
    80005f9a:	ffffa097          	auipc	ra,0xffffa
    80005f9e:	5a6080e7          	jalr	1446(ra) # 80000540 <panic>
    panic("virtio disk should not be ready");
    80005fa2:	00003517          	auipc	a0,0x3
    80005fa6:	88e50513          	addi	a0,a0,-1906 # 80008830 <syscalls+0x368>
    80005faa:	ffffa097          	auipc	ra,0xffffa
    80005fae:	596080e7          	jalr	1430(ra) # 80000540 <panic>
    panic("virtio disk has no queue 0");
    80005fb2:	00003517          	auipc	a0,0x3
    80005fb6:	89e50513          	addi	a0,a0,-1890 # 80008850 <syscalls+0x388>
    80005fba:	ffffa097          	auipc	ra,0xffffa
    80005fbe:	586080e7          	jalr	1414(ra) # 80000540 <panic>
    panic("virtio disk max queue too short");
    80005fc2:	00003517          	auipc	a0,0x3
    80005fc6:	8ae50513          	addi	a0,a0,-1874 # 80008870 <syscalls+0x3a8>
    80005fca:	ffffa097          	auipc	ra,0xffffa
    80005fce:	576080e7          	jalr	1398(ra) # 80000540 <panic>
    panic("virtio disk kalloc");
    80005fd2:	00003517          	auipc	a0,0x3
    80005fd6:	8be50513          	addi	a0,a0,-1858 # 80008890 <syscalls+0x3c8>
    80005fda:	ffffa097          	auipc	ra,0xffffa
    80005fde:	566080e7          	jalr	1382(ra) # 80000540 <panic>

0000000080005fe2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005fe2:	7119                	addi	sp,sp,-128
    80005fe4:	fc86                	sd	ra,120(sp)
    80005fe6:	f8a2                	sd	s0,112(sp)
    80005fe8:	f4a6                	sd	s1,104(sp)
    80005fea:	f0ca                	sd	s2,96(sp)
    80005fec:	ecce                	sd	s3,88(sp)
    80005fee:	e8d2                	sd	s4,80(sp)
    80005ff0:	e4d6                	sd	s5,72(sp)
    80005ff2:	e0da                	sd	s6,64(sp)
    80005ff4:	fc5e                	sd	s7,56(sp)
    80005ff6:	f862                	sd	s8,48(sp)
    80005ff8:	f466                	sd	s9,40(sp)
    80005ffa:	f06a                	sd	s10,32(sp)
    80005ffc:	ec6e                	sd	s11,24(sp)
    80005ffe:	0100                	addi	s0,sp,128
    80006000:	8aaa                	mv	s5,a0
    80006002:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006004:	00c52d03          	lw	s10,12(a0)
    80006008:	001d1d1b          	slliw	s10,s10,0x1
    8000600c:	1d02                	slli	s10,s10,0x20
    8000600e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006012:	0001c517          	auipc	a0,0x1c
    80006016:	fb650513          	addi	a0,a0,-74 # 80021fc8 <disk+0x128>
    8000601a:	ffffb097          	auipc	ra,0xffffb
    8000601e:	bbc080e7          	jalr	-1092(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    80006022:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006024:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006026:	0001cb97          	auipc	s7,0x1c
    8000602a:	e7ab8b93          	addi	s7,s7,-390 # 80021ea0 <disk>
  for(int i = 0; i < 3; i++){
    8000602e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006030:	0001cc97          	auipc	s9,0x1c
    80006034:	f98c8c93          	addi	s9,s9,-104 # 80021fc8 <disk+0x128>
    80006038:	a08d                	j	8000609a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000603a:	00fb8733          	add	a4,s7,a5
    8000603e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006042:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006044:	0207c563          	bltz	a5,8000606e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80006048:	2905                	addiw	s2,s2,1
    8000604a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000604c:	05690c63          	beq	s2,s6,800060a4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006050:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006052:	0001c717          	auipc	a4,0x1c
    80006056:	e4e70713          	addi	a4,a4,-434 # 80021ea0 <disk>
    8000605a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000605c:	01874683          	lbu	a3,24(a4)
    80006060:	fee9                	bnez	a3,8000603a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80006062:	2785                	addiw	a5,a5,1
    80006064:	0705                	addi	a4,a4,1
    80006066:	fe979be3          	bne	a5,s1,8000605c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000606a:	57fd                	li	a5,-1
    8000606c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000606e:	01205d63          	blez	s2,80006088 <virtio_disk_rw+0xa6>
    80006072:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006074:	000a2503          	lw	a0,0(s4)
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	cfe080e7          	jalr	-770(ra) # 80005d76 <free_desc>
      for(int j = 0; j < i; j++)
    80006080:	2d85                	addiw	s11,s11,1
    80006082:	0a11                	addi	s4,s4,4
    80006084:	ff2d98e3          	bne	s11,s2,80006074 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006088:	85e6                	mv	a1,s9
    8000608a:	0001c517          	auipc	a0,0x1c
    8000608e:	e2e50513          	addi	a0,a0,-466 # 80021eb8 <disk+0x18>
    80006092:	ffffc097          	auipc	ra,0xffffc
    80006096:	01c080e7          	jalr	28(ra) # 800020ae <sleep>
  for(int i = 0; i < 3; i++){
    8000609a:	f8040a13          	addi	s4,s0,-128
{
    8000609e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800060a0:	894e                	mv	s2,s3
    800060a2:	b77d                	j	80006050 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800060a4:	f8042503          	lw	a0,-128(s0)
    800060a8:	00a50713          	addi	a4,a0,10
    800060ac:	0712                	slli	a4,a4,0x4

  if(write)
    800060ae:	0001c797          	auipc	a5,0x1c
    800060b2:	df278793          	addi	a5,a5,-526 # 80021ea0 <disk>
    800060b6:	00e786b3          	add	a3,a5,a4
    800060ba:	01803633          	snez	a2,s8
    800060be:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800060c0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800060c4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800060c8:	f6070613          	addi	a2,a4,-160
    800060cc:	6394                	ld	a3,0(a5)
    800060ce:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800060d0:	00870593          	addi	a1,a4,8
    800060d4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800060d6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800060d8:	0007b803          	ld	a6,0(a5)
    800060dc:	9642                	add	a2,a2,a6
    800060de:	46c1                	li	a3,16
    800060e0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800060e2:	4585                	li	a1,1
    800060e4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800060e8:	f8442683          	lw	a3,-124(s0)
    800060ec:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800060f0:	0692                	slli	a3,a3,0x4
    800060f2:	9836                	add	a6,a6,a3
    800060f4:	058a8613          	addi	a2,s5,88
    800060f8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800060fc:	0007b803          	ld	a6,0(a5)
    80006100:	96c2                	add	a3,a3,a6
    80006102:	40000613          	li	a2,1024
    80006106:	c690                	sw	a2,8(a3)
  if(write)
    80006108:	001c3613          	seqz	a2,s8
    8000610c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006110:	00166613          	ori	a2,a2,1
    80006114:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006118:	f8842603          	lw	a2,-120(s0)
    8000611c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006120:	00250693          	addi	a3,a0,2
    80006124:	0692                	slli	a3,a3,0x4
    80006126:	96be                	add	a3,a3,a5
    80006128:	58fd                	li	a7,-1
    8000612a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000612e:	0612                	slli	a2,a2,0x4
    80006130:	9832                	add	a6,a6,a2
    80006132:	f9070713          	addi	a4,a4,-112
    80006136:	973e                	add	a4,a4,a5
    80006138:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000613c:	6398                	ld	a4,0(a5)
    8000613e:	9732                	add	a4,a4,a2
    80006140:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006142:	4609                	li	a2,2
    80006144:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80006148:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000614c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006150:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006154:	6794                	ld	a3,8(a5)
    80006156:	0026d703          	lhu	a4,2(a3)
    8000615a:	8b1d                	andi	a4,a4,7
    8000615c:	0706                	slli	a4,a4,0x1
    8000615e:	96ba                	add	a3,a3,a4
    80006160:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006164:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006168:	6798                	ld	a4,8(a5)
    8000616a:	00275783          	lhu	a5,2(a4)
    8000616e:	2785                	addiw	a5,a5,1
    80006170:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006174:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006178:	100017b7          	lui	a5,0x10001
    8000617c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006180:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80006184:	0001c917          	auipc	s2,0x1c
    80006188:	e4490913          	addi	s2,s2,-444 # 80021fc8 <disk+0x128>
  while(b->disk == 1) {
    8000618c:	4485                	li	s1,1
    8000618e:	00b79c63          	bne	a5,a1,800061a6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006192:	85ca                	mv	a1,s2
    80006194:	8556                	mv	a0,s5
    80006196:	ffffc097          	auipc	ra,0xffffc
    8000619a:	f18080e7          	jalr	-232(ra) # 800020ae <sleep>
  while(b->disk == 1) {
    8000619e:	004aa783          	lw	a5,4(s5)
    800061a2:	fe9788e3          	beq	a5,s1,80006192 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800061a6:	f8042903          	lw	s2,-128(s0)
    800061aa:	00290713          	addi	a4,s2,2
    800061ae:	0712                	slli	a4,a4,0x4
    800061b0:	0001c797          	auipc	a5,0x1c
    800061b4:	cf078793          	addi	a5,a5,-784 # 80021ea0 <disk>
    800061b8:	97ba                	add	a5,a5,a4
    800061ba:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800061be:	0001c997          	auipc	s3,0x1c
    800061c2:	ce298993          	addi	s3,s3,-798 # 80021ea0 <disk>
    800061c6:	00491713          	slli	a4,s2,0x4
    800061ca:	0009b783          	ld	a5,0(s3)
    800061ce:	97ba                	add	a5,a5,a4
    800061d0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800061d4:	854a                	mv	a0,s2
    800061d6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800061da:	00000097          	auipc	ra,0x0
    800061de:	b9c080e7          	jalr	-1124(ra) # 80005d76 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800061e2:	8885                	andi	s1,s1,1
    800061e4:	f0ed                	bnez	s1,800061c6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800061e6:	0001c517          	auipc	a0,0x1c
    800061ea:	de250513          	addi	a0,a0,-542 # 80021fc8 <disk+0x128>
    800061ee:	ffffb097          	auipc	ra,0xffffb
    800061f2:	a9c080e7          	jalr	-1380(ra) # 80000c8a <release>
}
    800061f6:	70e6                	ld	ra,120(sp)
    800061f8:	7446                	ld	s0,112(sp)
    800061fa:	74a6                	ld	s1,104(sp)
    800061fc:	7906                	ld	s2,96(sp)
    800061fe:	69e6                	ld	s3,88(sp)
    80006200:	6a46                	ld	s4,80(sp)
    80006202:	6aa6                	ld	s5,72(sp)
    80006204:	6b06                	ld	s6,64(sp)
    80006206:	7be2                	ld	s7,56(sp)
    80006208:	7c42                	ld	s8,48(sp)
    8000620a:	7ca2                	ld	s9,40(sp)
    8000620c:	7d02                	ld	s10,32(sp)
    8000620e:	6de2                	ld	s11,24(sp)
    80006210:	6109                	addi	sp,sp,128
    80006212:	8082                	ret

0000000080006214 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006214:	1101                	addi	sp,sp,-32
    80006216:	ec06                	sd	ra,24(sp)
    80006218:	e822                	sd	s0,16(sp)
    8000621a:	e426                	sd	s1,8(sp)
    8000621c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000621e:	0001c497          	auipc	s1,0x1c
    80006222:	c8248493          	addi	s1,s1,-894 # 80021ea0 <disk>
    80006226:	0001c517          	auipc	a0,0x1c
    8000622a:	da250513          	addi	a0,a0,-606 # 80021fc8 <disk+0x128>
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	9a8080e7          	jalr	-1624(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006236:	10001737          	lui	a4,0x10001
    8000623a:	533c                	lw	a5,96(a4)
    8000623c:	8b8d                	andi	a5,a5,3
    8000623e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006240:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006244:	689c                	ld	a5,16(s1)
    80006246:	0204d703          	lhu	a4,32(s1)
    8000624a:	0027d783          	lhu	a5,2(a5)
    8000624e:	04f70863          	beq	a4,a5,8000629e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006252:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006256:	6898                	ld	a4,16(s1)
    80006258:	0204d783          	lhu	a5,32(s1)
    8000625c:	8b9d                	andi	a5,a5,7
    8000625e:	078e                	slli	a5,a5,0x3
    80006260:	97ba                	add	a5,a5,a4
    80006262:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006264:	00278713          	addi	a4,a5,2
    80006268:	0712                	slli	a4,a4,0x4
    8000626a:	9726                	add	a4,a4,s1
    8000626c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006270:	e721                	bnez	a4,800062b8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006272:	0789                	addi	a5,a5,2
    80006274:	0792                	slli	a5,a5,0x4
    80006276:	97a6                	add	a5,a5,s1
    80006278:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000627a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000627e:	ffffc097          	auipc	ra,0xffffc
    80006282:	ea2080e7          	jalr	-350(ra) # 80002120 <wakeup>

    disk.used_idx += 1;
    80006286:	0204d783          	lhu	a5,32(s1)
    8000628a:	2785                	addiw	a5,a5,1
    8000628c:	17c2                	slli	a5,a5,0x30
    8000628e:	93c1                	srli	a5,a5,0x30
    80006290:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006294:	6898                	ld	a4,16(s1)
    80006296:	00275703          	lhu	a4,2(a4)
    8000629a:	faf71ce3          	bne	a4,a5,80006252 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000629e:	0001c517          	auipc	a0,0x1c
    800062a2:	d2a50513          	addi	a0,a0,-726 # 80021fc8 <disk+0x128>
    800062a6:	ffffb097          	auipc	ra,0xffffb
    800062aa:	9e4080e7          	jalr	-1564(ra) # 80000c8a <release>
}
    800062ae:	60e2                	ld	ra,24(sp)
    800062b0:	6442                	ld	s0,16(sp)
    800062b2:	64a2                	ld	s1,8(sp)
    800062b4:	6105                	addi	sp,sp,32
    800062b6:	8082                	ret
      panic("virtio_disk_intr status");
    800062b8:	00002517          	auipc	a0,0x2
    800062bc:	5f050513          	addi	a0,a0,1520 # 800088a8 <syscalls+0x3e0>
    800062c0:	ffffa097          	auipc	ra,0xffffa
    800062c4:	280080e7          	jalr	640(ra) # 80000540 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
