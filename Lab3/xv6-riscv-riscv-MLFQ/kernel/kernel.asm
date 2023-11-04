
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	93013103          	ld	sp,-1744(sp) # 80008930 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
    80000022:	f14027f3          	csrr	a5,mhartid
    80000026:	0007859b          	sext.w	a1,a5
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	94070713          	addi	a4,a4,-1728 # 80008990 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
    8000005a:	ef1c                	sd	a5,24(a4)
    8000005c:	f310                	sd	a2,32(a4)
    8000005e:	34071073          	csrw	mscratch,a4
    80000062:	00006797          	auipc	a5,0x6
    80000066:	d0e78793          	addi	a5,a5,-754 # 80005d70 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
    8000006e:	300027f3          	csrr	a5,mstatus
    80000072:	0087e793          	ori	a5,a5,8
    80000076:	30079073          	csrw	mstatus,a5
    8000007a:	304027f3          	csrr	a5,mie
    8000007e:	0807e793          	ori	a5,a5,128
    80000082:	30479073          	csrw	mie,a5
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
    80000094:	300027f3          	csrr	a5,mstatus
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc7ff>
    8000009e:	8ff9                	and	a5,a5,a4
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
    800000a8:	30079073          	csrw	mstatus,a5
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dcc78793          	addi	a5,a5,-564 # 80000e78 <main>
    800000b4:	34179073          	csrw	mepc,a5
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
    800000c6:	30379073          	csrw	mideleg,a5
    800000ca:	104027f3          	csrr	a5,sie
    800000ce:	2227e793          	ori	a5,a5,546
    800000d2:	10479073          	csrw	sie,a5
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
    800000ec:	f14027f3          	csrr	a5,mhartid
    800000f0:	2781                	sext.w	a5,a5
    800000f2:	823e                	mv	tp,a5
    800000f4:	30200073          	mret
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	4b4080e7          	jalr	1204(ra) # 800025de <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	784080e7          	jalr	1924(ra) # 800008be <uartputc>
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
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
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
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
    80000186:	00060b1b          	sext.w	s6,a2
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	94650513          	addi	a0,a0,-1722 # 80010ad0 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	93648493          	addi	s1,s1,-1738 # 80010ad0 <cons>
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	9c690913          	addi	s2,s2,-1594 # 80010b68 <cons+0x98>
    800001aa:	4b91                	li	s7,4
    800001ac:	5c7d                	li	s8,-1
    800001ae:	4ca9                	li	s9,10
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
    800001c0:	00001097          	auipc	ra,0x1
    800001c4:	7fe080e7          	jalr	2046(ra) # 800019be <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	260080e7          	jalr	608(ra) # 80002428 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	f9c080e7          	jalr	-100(ra) # 80002172 <sleep>
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	376080e7          	jalr	886(ra) # 80002588 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    8000021e:	0a05                	addi	s4,s4,1
    80000220:	39fd                	addiw	s3,s3,-1
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	8aa50513          	addi	a0,a0,-1878 # 80010ad0 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	89450513          	addi	a0,a0,-1900 # 80010ad0 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	a46080e7          	jalr	-1466(ra) # 80000c8a <release>
    8000024c:	557d                	li	a0,-1
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
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
    80000272:	00011717          	auipc	a4,0x11
    80000276:	8ef72b23          	sw	a5,-1802(a4) # 80010b68 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	560080e7          	jalr	1376(ra) # 800007ec <uartputc_sync>
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
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
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
    800002cc:	00011517          	auipc	a0,0x11
    800002d0:	80450513          	addi	a0,a0,-2044 # 80010ad0 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	902080e7          	jalr	-1790(ra) # 80000bd6 <acquire>
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	342080e7          	jalr	834(ra) # 80002634 <procdump>
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	7d650513          	addi	a0,a0,2006 # 80010ad0 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	988080e7          	jalr	-1656(ra) # 80000c8a <release>
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	7b270713          	addi	a4,a4,1970 # 80010ad0 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	78878793          	addi	a5,a5,1928 # 80010ad0 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7f27a783          	lw	a5,2034(a5) # 80010b68 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	74670713          	addi	a4,a4,1862 # 80010ad0 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	73648493          	addi	s1,s1,1846 # 80010ad0 <cons>
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
    800003b8:	0af4a023          	sw	a5,160(s1)
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	6fa70713          	addi	a4,a4,1786 # 80010ad0 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	78f72223          	sw	a5,1924(a4) # 80010b70 <cons+0xa0>
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
    80000412:	00010797          	auipc	a5,0x10
    80000416:	6be78793          	addi	a5,a5,1726 # 80010ad0 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	72c7ab23          	sw	a2,1846(a5) # 80010b6c <cons+0x9c>
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	72a50513          	addi	a0,a0,1834 # 80010b68 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	d9e080e7          	jalr	-610(ra) # 800021e4 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	67050513          	addi	a0,a0,1648 # 80010ad0 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32c080e7          	jalr	812(ra) # 8000079c <uartinit>
    80000478:	00021797          	auipc	a5,0x21
    8000047c:	9f078793          	addi	a5,a5,-1552 # 80020e68 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7670713          	addi	a4,a4,-906 # 80000100 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054763          	bltz	a0,80000538 <printint+0x9c>
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48
    800004b6:	4701                	li	a4,0
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
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>
    800004e6:	00088c63          	beqz	a7,800004fe <printint+0x62>
    800004ea:	fe070793          	addi	a5,a4,-32
    800004ee:	00878733          	add	a4,a5,s0
    800004f2:	02d00793          	li	a5,45
    800004f6:	fef70823          	sb	a5,-16(a4)
    800004fa:	0028071b          	addiw	a4,a6,2
    800004fe:	02e05763          	blez	a4,8000052c <printint+0x90>
    80000502:	fd040793          	addi	a5,s0,-48
    80000506:	00e784b3          	add	s1,a5,a4
    8000050a:	fff78913          	addi	s2,a5,-1
    8000050e:	993a                	add	s2,s2,a4
    80000510:	377d                	addiw	a4,a4,-1
    80000512:	1702                	slli	a4,a4,0x20
    80000514:	9301                	srli	a4,a4,0x20
    80000516:	40e90933          	sub	s2,s2,a4
    8000051a:	fff4c503          	lbu	a0,-1(s1)
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	d5e080e7          	jalr	-674(ra) # 8000027c <consputc>
    80000526:	14fd                	addi	s1,s1,-1
    80000528:	ff2499e3          	bne	s1,s2,8000051a <printint+0x7e>
    8000052c:	70a2                	ld	ra,40(sp)
    8000052e:	7402                	ld	s0,32(sp)
    80000530:	64e2                	ld	s1,24(sp)
    80000532:	6942                	ld	s2,16(sp)
    80000534:	6145                	addi	sp,sp,48
    80000536:	8082                	ret
    80000538:	40a0053b          	negw	a0,a0
    8000053c:	4885                	li	a7,1
    8000053e:	bf95                	j	800004b2 <printint+0x16>

0000000080000540 <panic>:
    80000540:	1101                	addi	sp,sp,-32
    80000542:	ec06                	sd	ra,24(sp)
    80000544:	e822                	sd	s0,16(sp)
    80000546:	e426                	sd	s1,8(sp)
    80000548:	1000                	addi	s0,sp,32
    8000054a:	84aa                	mv	s1,a0
    8000054c:	00010797          	auipc	a5,0x10
    80000550:	6407a223          	sw	zero,1604(a5) # 80010b90 <pr+0x18>
    80000554:	00008517          	auipc	a0,0x8
    80000558:	ac450513          	addi	a0,a0,-1340 # 80008018 <etext+0x18>
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	02e080e7          	jalr	46(ra) # 8000058a <printf>
    80000564:	8526                	mv	a0,s1
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	024080e7          	jalr	36(ra) # 8000058a <printf>
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	b5a50513          	addi	a0,a0,-1190 # 800080c8 <digits+0x88>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	014080e7          	jalr	20(ra) # 8000058a <printf>
    8000057e:	4785                	li	a5,1
    80000580:	00008717          	auipc	a4,0x8
    80000584:	3cf72823          	sw	a5,976(a4) # 80008950 <panicked>
    80000588:	a001                	j	80000588 <panic+0x48>

000000008000058a <printf>:
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
    800005bc:	00010d97          	auipc	s11,0x10
    800005c0:	5d4dad83          	lw	s11,1492(s11) # 80010b90 <pr+0x18>
    800005c4:	020d9b63          	bnez	s11,800005fa <printf+0x70>
    800005c8:	040a0263          	beqz	s4,8000060c <printf+0x82>
    800005cc:	00840793          	addi	a5,s0,8
    800005d0:	f8f43423          	sd	a5,-120(s0)
    800005d4:	000a4503          	lbu	a0,0(s4)
    800005d8:	14050f63          	beqz	a0,80000736 <printf+0x1ac>
    800005dc:	4981                	li	s3,0
    800005de:	02500a93          	li	s5,37
    800005e2:	07000b93          	li	s7,112
    800005e6:	4d41                	li	s10,16
    800005e8:	00008b17          	auipc	s6,0x8
    800005ec:	a58b0b13          	addi	s6,s6,-1448 # 80008040 <digits>
    800005f0:	07300c93          	li	s9,115
    800005f4:	06400c13          	li	s8,100
    800005f8:	a82d                	j	80000632 <printf+0xa8>
    800005fa:	00010517          	auipc	a0,0x10
    800005fe:	57e50513          	addi	a0,a0,1406 # 80010b78 <pr>
    80000602:	00000097          	auipc	ra,0x0
    80000606:	5d4080e7          	jalr	1492(ra) # 80000bd6 <acquire>
    8000060a:	bf7d                	j	800005c8 <printf+0x3e>
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a1c50513          	addi	a0,a0,-1508 # 80008028 <etext+0x28>
    80000614:	00000097          	auipc	ra,0x0
    80000618:	f2c080e7          	jalr	-212(ra) # 80000540 <panic>
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	c60080e7          	jalr	-928(ra) # 8000027c <consputc>
    80000624:	2985                	addiw	s3,s3,1
    80000626:	013a07b3          	add	a5,s4,s3
    8000062a:	0007c503          	lbu	a0,0(a5)
    8000062e:	10050463          	beqz	a0,80000736 <printf+0x1ac>
    80000632:	ff5515e3          	bne	a0,s5,8000061c <printf+0x92>
    80000636:	2985                	addiw	s3,s3,1
    80000638:	013a07b3          	add	a5,s4,s3
    8000063c:	0007c783          	lbu	a5,0(a5)
    80000640:	0007849b          	sext.w	s1,a5
    80000644:	cbed                	beqz	a5,80000736 <printf+0x1ac>
    80000646:	05778a63          	beq	a5,s7,8000069a <printf+0x110>
    8000064a:	02fbf663          	bgeu	s7,a5,80000676 <printf+0xec>
    8000064e:	09978863          	beq	a5,s9,800006de <printf+0x154>
    80000652:	07800713          	li	a4,120
    80000656:	0ce79563          	bne	a5,a4,80000720 <printf+0x196>
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4605                	li	a2,1
    80000668:	85ea                	mv	a1,s10
    8000066a:	4388                	lw	a0,0(a5)
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	e30080e7          	jalr	-464(ra) # 8000049c <printint>
    80000674:	bf45                	j	80000624 <printf+0x9a>
    80000676:	09578f63          	beq	a5,s5,80000714 <printf+0x18a>
    8000067a:	0b879363          	bne	a5,s8,80000720 <printf+0x196>
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4605                	li	a2,1
    8000068c:	45a9                	li	a1,10
    8000068e:	4388                	lw	a0,0(a5)
    80000690:	00000097          	auipc	ra,0x0
    80000694:	e0c080e7          	jalr	-500(ra) # 8000049c <printint>
    80000698:	b771                	j	80000624 <printf+0x9a>
    8000069a:	f8843783          	ld	a5,-120(s0)
    8000069e:	00878713          	addi	a4,a5,8
    800006a2:	f8e43423          	sd	a4,-120(s0)
    800006a6:	0007b903          	ld	s2,0(a5)
    800006aa:	03000513          	li	a0,48
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	bce080e7          	jalr	-1074(ra) # 8000027c <consputc>
    800006b6:	07800513          	li	a0,120
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	bc2080e7          	jalr	-1086(ra) # 8000027c <consputc>
    800006c2:	84ea                	mv	s1,s10
    800006c4:	03c95793          	srli	a5,s2,0x3c
    800006c8:	97da                	add	a5,a5,s6
    800006ca:	0007c503          	lbu	a0,0(a5)
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	bae080e7          	jalr	-1106(ra) # 8000027c <consputc>
    800006d6:	0912                	slli	s2,s2,0x4
    800006d8:	34fd                	addiw	s1,s1,-1
    800006da:	f4ed                	bnez	s1,800006c4 <printf+0x13a>
    800006dc:	b7a1                	j	80000624 <printf+0x9a>
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	6384                	ld	s1,0(a5)
    800006ec:	cc89                	beqz	s1,80000706 <printf+0x17c>
    800006ee:	0004c503          	lbu	a0,0(s1)
    800006f2:	d90d                	beqz	a0,80000624 <printf+0x9a>
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	b88080e7          	jalr	-1144(ra) # 8000027c <consputc>
    800006fc:	0485                	addi	s1,s1,1
    800006fe:	0004c503          	lbu	a0,0(s1)
    80000702:	f96d                	bnez	a0,800006f4 <printf+0x16a>
    80000704:	b705                	j	80000624 <printf+0x9a>
    80000706:	00008497          	auipc	s1,0x8
    8000070a:	91a48493          	addi	s1,s1,-1766 # 80008020 <etext+0x20>
    8000070e:	02800513          	li	a0,40
    80000712:	b7cd                	j	800006f4 <printf+0x16a>
    80000714:	8556                	mv	a0,s5
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b66080e7          	jalr	-1178(ra) # 8000027c <consputc>
    8000071e:	b719                	j	80000624 <printf+0x9a>
    80000720:	8556                	mv	a0,s5
    80000722:	00000097          	auipc	ra,0x0
    80000726:	b5a080e7          	jalr	-1190(ra) # 8000027c <consputc>
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b50080e7          	jalr	-1200(ra) # 8000027c <consputc>
    80000734:	bdc5                	j	80000624 <printf+0x9a>
    80000736:	020d9163          	bnez	s11,80000758 <printf+0x1ce>
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
    80000758:	00010517          	auipc	a0,0x10
    8000075c:	42050513          	addi	a0,a0,1056 # 80010b78 <pr>
    80000760:	00000097          	auipc	ra,0x0
    80000764:	52a080e7          	jalr	1322(ra) # 80000c8a <release>
    80000768:	bfc9                	j	8000073a <printf+0x1b0>

000000008000076a <printfinit>:
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
    80000774:	00010497          	auipc	s1,0x10
    80000778:	40448493          	addi	s1,s1,1028 # 80010b78 <pr>
    8000077c:	00008597          	auipc	a1,0x8
    80000780:	8bc58593          	addi	a1,a1,-1860 # 80008038 <etext+0x38>
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	3c0080e7          	jalr	960(ra) # 80000b46 <initlock>
    8000078e:	4785                	li	a5,1
    80000790:	cc9c                	sw	a5,24(s1)
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret

000000008000079c <uartinit>:
    8000079c:	1141                	addi	sp,sp,-16
    8000079e:	e406                	sd	ra,8(sp)
    800007a0:	e022                	sd	s0,0(sp)
    800007a2:	0800                	addi	s0,sp,16
    800007a4:	100007b7          	lui	a5,0x10000
    800007a8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    800007ac:	f8000713          	li	a4,-128
    800007b0:	00e781a3          	sb	a4,3(a5)
    800007b4:	470d                	li	a4,3
    800007b6:	00e78023          	sb	a4,0(a5)
    800007ba:	000780a3          	sb	zero,1(a5)
    800007be:	00e781a3          	sb	a4,3(a5)
    800007c2:	469d                	li	a3,7
    800007c4:	00d78123          	sb	a3,2(a5)
    800007c8:	00e780a3          	sb	a4,1(a5)
    800007cc:	00008597          	auipc	a1,0x8
    800007d0:	88c58593          	addi	a1,a1,-1908 # 80008058 <digits+0x18>
    800007d4:	00010517          	auipc	a0,0x10
    800007d8:	3c450513          	addi	a0,a0,964 # 80010b98 <uart_tx_lock>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	36a080e7          	jalr	874(ra) # 80000b46 <initlock>
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uartputc_sync>:
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    800007f6:	84aa                	mv	s1,a0
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	392080e7          	jalr	914(ra) # 80000b8a <push_off>
    80000800:	00008797          	auipc	a5,0x8
    80000804:	1507a783          	lw	a5,336(a5) # 80008950 <panicked>
    80000808:	10000737          	lui	a4,0x10000
    8000080c:	c391                	beqz	a5,80000810 <uartputc_sync+0x24>
    8000080e:	a001                	j	8000080e <uartputc_sync+0x22>
    80000810:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dfe5                	beqz	a5,80000810 <uartputc_sync+0x24>
    8000081a:	0ff4f513          	zext.b	a0,s1
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	404080e7          	jalr	1028(ra) # 80000c2a <pop_off>
    8000082e:	60e2                	ld	ra,24(sp)
    80000830:	6442                	ld	s0,16(sp)
    80000832:	64a2                	ld	s1,8(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <uartstart>:
    80000838:	00008797          	auipc	a5,0x8
    8000083c:	1207b783          	ld	a5,288(a5) # 80008958 <uart_tx_r>
    80000840:	00008717          	auipc	a4,0x8
    80000844:	12073703          	ld	a4,288(a4) # 80008960 <uart_tx_w>
    80000848:	06f70a63          	beq	a4,a5,800008bc <uartstart+0x84>
    8000084c:	7139                	addi	sp,sp,-64
    8000084e:	fc06                	sd	ra,56(sp)
    80000850:	f822                	sd	s0,48(sp)
    80000852:	f426                	sd	s1,40(sp)
    80000854:	f04a                	sd	s2,32(sp)
    80000856:	ec4e                	sd	s3,24(sp)
    80000858:	e852                	sd	s4,16(sp)
    8000085a:	e456                	sd	s5,8(sp)
    8000085c:	0080                	addi	s0,sp,64
    8000085e:	10000937          	lui	s2,0x10000
    80000862:	00010a17          	auipc	s4,0x10
    80000866:	336a0a13          	addi	s4,s4,822 # 80010b98 <uart_tx_lock>
    8000086a:	00008497          	auipc	s1,0x8
    8000086e:	0ee48493          	addi	s1,s1,238 # 80008958 <uart_tx_r>
    80000872:	00008997          	auipc	s3,0x8
    80000876:	0ee98993          	addi	s3,s3,238 # 80008960 <uart_tx_w>
    8000087a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087e:	02077713          	andi	a4,a4,32
    80000882:	c705                	beqz	a4,800008aa <uartstart+0x72>
    80000884:	01f7f713          	andi	a4,a5,31
    80000888:	9752                	add	a4,a4,s4
    8000088a:	01874a83          	lbu	s5,24(a4)
    8000088e:	0785                	addi	a5,a5,1
    80000890:	e09c                	sd	a5,0(s1)
    80000892:	8526                	mv	a0,s1
    80000894:	00002097          	auipc	ra,0x2
    80000898:	950080e7          	jalr	-1712(ra) # 800021e4 <wakeup>
    8000089c:	01590023          	sb	s5,0(s2)
    800008a0:	609c                	ld	a5,0(s1)
    800008a2:	0009b703          	ld	a4,0(s3)
    800008a6:	fcf71ae3          	bne	a4,a5,8000087a <uartstart+0x42>
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
    800008be:	7179                	addi	sp,sp,-48
    800008c0:	f406                	sd	ra,40(sp)
    800008c2:	f022                	sd	s0,32(sp)
    800008c4:	ec26                	sd	s1,24(sp)
    800008c6:	e84a                	sd	s2,16(sp)
    800008c8:	e44e                	sd	s3,8(sp)
    800008ca:	e052                	sd	s4,0(sp)
    800008cc:	1800                	addi	s0,sp,48
    800008ce:	8a2a                	mv	s4,a0
    800008d0:	00010517          	auipc	a0,0x10
    800008d4:	2c850513          	addi	a0,a0,712 # 80010b98 <uart_tx_lock>
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	2fe080e7          	jalr	766(ra) # 80000bd6 <acquire>
    800008e0:	00008797          	auipc	a5,0x8
    800008e4:	0707a783          	lw	a5,112(a5) # 80008950 <panicked>
    800008e8:	e7c9                	bnez	a5,80000972 <uartputc+0xb4>
    800008ea:	00008717          	auipc	a4,0x8
    800008ee:	07673703          	ld	a4,118(a4) # 80008960 <uart_tx_w>
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	0667b783          	ld	a5,102(a5) # 80008958 <uart_tx_r>
    800008fa:	02078793          	addi	a5,a5,32
    800008fe:	00010997          	auipc	s3,0x10
    80000902:	29a98993          	addi	s3,s3,666 # 80010b98 <uart_tx_lock>
    80000906:	00008497          	auipc	s1,0x8
    8000090a:	05248493          	addi	s1,s1,82 # 80008958 <uart_tx_r>
    8000090e:	00008917          	auipc	s2,0x8
    80000912:	05290913          	addi	s2,s2,82 # 80008960 <uart_tx_w>
    80000916:	00e79f63          	bne	a5,a4,80000934 <uartputc+0x76>
    8000091a:	85ce                	mv	a1,s3
    8000091c:	8526                	mv	a0,s1
    8000091e:	00002097          	auipc	ra,0x2
    80000922:	854080e7          	jalr	-1964(ra) # 80002172 <sleep>
    80000926:	00093703          	ld	a4,0(s2)
    8000092a:	609c                	ld	a5,0(s1)
    8000092c:	02078793          	addi	a5,a5,32
    80000930:	fee785e3          	beq	a5,a4,8000091a <uartputc+0x5c>
    80000934:	00010497          	auipc	s1,0x10
    80000938:	26448493          	addi	s1,s1,612 # 80010b98 <uart_tx_lock>
    8000093c:	01f77793          	andi	a5,a4,31
    80000940:	97a6                	add	a5,a5,s1
    80000942:	01478c23          	sb	s4,24(a5)
    80000946:	0705                	addi	a4,a4,1
    80000948:	00008797          	auipc	a5,0x8
    8000094c:	00e7bc23          	sd	a4,24(a5) # 80008960 <uart_tx_w>
    80000950:	00000097          	auipc	ra,0x0
    80000954:	ee8080e7          	jalr	-280(ra) # 80000838 <uartstart>
    80000958:	8526                	mv	a0,s1
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	330080e7          	jalr	816(ra) # 80000c8a <release>
    80000962:	70a2                	ld	ra,40(sp)
    80000964:	7402                	ld	s0,32(sp)
    80000966:	64e2                	ld	s1,24(sp)
    80000968:	6942                	ld	s2,16(sp)
    8000096a:	69a2                	ld	s3,8(sp)
    8000096c:	6a02                	ld	s4,0(sp)
    8000096e:	6145                	addi	sp,sp,48
    80000970:	8082                	ret
    80000972:	a001                	j	80000972 <uartputc+0xb4>

0000000080000974 <uartgetc>:
    80000974:	1141                	addi	sp,sp,-16
    80000976:	e422                	sd	s0,8(sp)
    80000978:	0800                	addi	s0,sp,16
    8000097a:	100007b7          	lui	a5,0x10000
    8000097e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000982:	8b85                	andi	a5,a5,1
    80000984:	cb81                	beqz	a5,80000994 <uartgetc+0x20>
    80000986:	100007b7          	lui	a5,0x10000
    8000098a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098e:	6422                	ld	s0,8(sp)
    80000990:	0141                	addi	sp,sp,16
    80000992:	8082                	ret
    80000994:	557d                	li	a0,-1
    80000996:	bfe5                	j	8000098e <uartgetc+0x1a>

0000000080000998 <uartintr>:
    80000998:	1101                	addi	sp,sp,-32
    8000099a:	ec06                	sd	ra,24(sp)
    8000099c:	e822                	sd	s0,16(sp)
    8000099e:	e426                	sd	s1,8(sp)
    800009a0:	1000                	addi	s0,sp,32
    800009a2:	54fd                	li	s1,-1
    800009a4:	a029                	j	800009ae <uartintr+0x16>
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	918080e7          	jalr	-1768(ra) # 800002be <consoleintr>
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	fc6080e7          	jalr	-58(ra) # 80000974 <uartgetc>
    800009b6:	fe9518e3          	bne	a0,s1,800009a6 <uartintr+0xe>
    800009ba:	00010497          	auipc	s1,0x10
    800009be:	1de48493          	addi	s1,s1,478 # 80010b98 <uart_tx_lock>
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	212080e7          	jalr	530(ra) # 80000bd6 <acquire>
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	e6c080e7          	jalr	-404(ra) # 80000838 <uartstart>
    800009d4:	8526                	mv	a0,s1
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	2b4080e7          	jalr	692(ra) # 80000c8a <release>
    800009de:	60e2                	ld	ra,24(sp)
    800009e0:	6442                	ld	s0,16(sp)
    800009e2:	64a2                	ld	s1,8(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret

00000000800009e8 <kfree>:
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	e04a                	sd	s2,0(sp)
    800009f2:	1000                	addi	s0,sp,32
    800009f4:	03451793          	slli	a5,a0,0x34
    800009f8:	ebb9                	bnez	a5,80000a4e <kfree+0x66>
    800009fa:	84aa                	mv	s1,a0
    800009fc:	00021797          	auipc	a5,0x21
    80000a00:	60478793          	addi	a5,a5,1540 # 80022000 <end>
    80000a04:	04f56563          	bltu	a0,a5,80000a4e <kfree+0x66>
    80000a08:	47c5                	li	a5,17
    80000a0a:	07ee                	slli	a5,a5,0x1b
    80000a0c:	04f57163          	bgeu	a0,a5,80000a4e <kfree+0x66>
    80000a10:	6605                	lui	a2,0x1
    80000a12:	4585                	li	a1,1
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	2be080e7          	jalr	702(ra) # 80000cd2 <memset>
    80000a1c:	00010917          	auipc	s2,0x10
    80000a20:	1b490913          	addi	s2,s2,436 # 80010bd0 <kmem>
    80000a24:	854a                	mv	a0,s2
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	1b0080e7          	jalr	432(ra) # 80000bd6 <acquire>
    80000a2e:	01893783          	ld	a5,24(s2)
    80000a32:	e09c                	sd	a5,0(s1)
    80000a34:	00993c23          	sd	s1,24(s2)
    80000a38:	854a                	mv	a0,s2
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	250080e7          	jalr	592(ra) # 80000c8a <release>
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6902                	ld	s2,0(sp)
    80000a4a:	6105                	addi	sp,sp,32
    80000a4c:	8082                	ret
    80000a4e:	00007517          	auipc	a0,0x7
    80000a52:	61250513          	addi	a0,a0,1554 # 80008060 <digits+0x20>
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	aea080e7          	jalr	-1302(ra) # 80000540 <panic>

0000000080000a5e <freerange>:
    80000a5e:	7179                	addi	sp,sp,-48
    80000a60:	f406                	sd	ra,40(sp)
    80000a62:	f022                	sd	s0,32(sp)
    80000a64:	ec26                	sd	s1,24(sp)
    80000a66:	e84a                	sd	s2,16(sp)
    80000a68:	e44e                	sd	s3,8(sp)
    80000a6a:	e052                	sd	s4,0(sp)
    80000a6c:	1800                	addi	s0,sp,48
    80000a6e:	6785                	lui	a5,0x1
    80000a70:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a74:	00e504b3          	add	s1,a0,a4
    80000a78:	777d                	lui	a4,0xfffff
    80000a7a:	8cf9                	and	s1,s1,a4
    80000a7c:	94be                	add	s1,s1,a5
    80000a7e:	0095ee63          	bltu	a1,s1,80000a9a <freerange+0x3c>
    80000a82:	892e                	mv	s2,a1
    80000a84:	7a7d                	lui	s4,0xfffff
    80000a86:	6985                	lui	s3,0x1
    80000a88:	01448533          	add	a0,s1,s4
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	f5c080e7          	jalr	-164(ra) # 800009e8 <kfree>
    80000a94:	94ce                	add	s1,s1,s3
    80000a96:	fe9979e3          	bgeu	s2,s1,80000a88 <freerange+0x2a>
    80000a9a:	70a2                	ld	ra,40(sp)
    80000a9c:	7402                	ld	s0,32(sp)
    80000a9e:	64e2                	ld	s1,24(sp)
    80000aa0:	6942                	ld	s2,16(sp)
    80000aa2:	69a2                	ld	s3,8(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	6145                	addi	sp,sp,48
    80000aa8:	8082                	ret

0000000080000aaa <kinit>:
    80000aaa:	1141                	addi	sp,sp,-16
    80000aac:	e406                	sd	ra,8(sp)
    80000aae:	e022                	sd	s0,0(sp)
    80000ab0:	0800                	addi	s0,sp,16
    80000ab2:	00007597          	auipc	a1,0x7
    80000ab6:	5b658593          	addi	a1,a1,1462 # 80008068 <digits+0x28>
    80000aba:	00010517          	auipc	a0,0x10
    80000abe:	11650513          	addi	a0,a0,278 # 80010bd0 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00021517          	auipc	a0,0x21
    80000ad2:	53250513          	addi	a0,a0,1330 # 80022000 <end>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f88080e7          	jalr	-120(ra) # 80000a5e <freerange>
    80000ade:	60a2                	ld	ra,8(sp)
    80000ae0:	6402                	ld	s0,0(sp)
    80000ae2:	0141                	addi	sp,sp,16
    80000ae4:	8082                	ret

0000000080000ae6 <kalloc>:
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
    80000af0:	00010497          	auipc	s1,0x10
    80000af4:	0e048493          	addi	s1,s1,224 # 80010bd0 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	0dc080e7          	jalr	220(ra) # 80000bd6 <acquire>
    80000b02:	6c84                	ld	s1,24(s1)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	0c850513          	addi	a0,a0,200 # 80010bd0 <kmem>
    80000b10:	ed1c                	sd	a5,24(a0)
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	178080e7          	jalr	376(ra) # 80000c8a <release>
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	4595                	li	a1,5
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1b2080e7          	jalr	434(ra) # 80000cd2 <memset>
    80000b28:	8526                	mv	a0,s1
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	addi	sp,sp,32
    80000b32:	8082                	ret
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	09c50513          	addi	a0,a0,156 # 80010bd0 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	14e080e7          	jalr	334(ra) # 80000c8a <release>
    80000b44:	b7d5                	j	80000b28 <kalloc+0x42>

0000000080000b46 <initlock>:
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e422                	sd	s0,8(sp)
    80000b4a:	0800                	addi	s0,sp,16
    80000b4c:	e50c                	sd	a1,8(a0)
    80000b4e:	00052023          	sw	zero,0(a0)
    80000b52:	00053823          	sd	zero,16(a0)
    80000b56:	6422                	ld	s0,8(sp)
    80000b58:	0141                	addi	sp,sp,16
    80000b5a:	8082                	ret

0000000080000b5c <holding>:
    80000b5c:	411c                	lw	a5,0(a0)
    80000b5e:	e399                	bnez	a5,80000b64 <holding+0x8>
    80000b60:	4501                	li	a0,0
    80000b62:	8082                	ret
    80000b64:	1101                	addi	sp,sp,-32
    80000b66:	ec06                	sd	ra,24(sp)
    80000b68:	e822                	sd	s0,16(sp)
    80000b6a:	e426                	sd	s1,8(sp)
    80000b6c:	1000                	addi	s0,sp,32
    80000b6e:	6904                	ld	s1,16(a0)
    80000b70:	00001097          	auipc	ra,0x1
    80000b74:	e32080e7          	jalr	-462(ra) # 800019a2 <mycpu>
    80000b78:	40a48533          	sub	a0,s1,a0
    80000b7c:	00153513          	seqz	a0,a0
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret

0000000080000b8a <push_off>:
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
    80000b94:	100024f3          	csrr	s1,sstatus
    80000b98:	100027f3          	csrr	a5,sstatus
    80000b9c:	9bf5                	andi	a5,a5,-3
    80000b9e:	10079073          	csrw	sstatus,a5
    80000ba2:	00001097          	auipc	ra,0x1
    80000ba6:	e00080e7          	jalr	-512(ra) # 800019a2 <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cf89                	beqz	a5,80000bc6 <push_off+0x3c>
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	df4080e7          	jalr	-524(ra) # 800019a2 <mycpu>
    80000bb6:	5d3c                	lw	a5,120(a0)
    80000bb8:	2785                	addiw	a5,a5,1
    80000bba:	dd3c                	sw	a5,120(a0)
    80000bbc:	60e2                	ld	ra,24(sp)
    80000bbe:	6442                	ld	s0,16(sp)
    80000bc0:	64a2                	ld	s1,8(sp)
    80000bc2:	6105                	addi	sp,sp,32
    80000bc4:	8082                	ret
    80000bc6:	00001097          	auipc	ra,0x1
    80000bca:	ddc080e7          	jalr	-548(ra) # 800019a2 <mycpu>
    80000bce:	8085                	srli	s1,s1,0x1
    80000bd0:	8885                	andi	s1,s1,1
    80000bd2:	dd64                	sw	s1,124(a0)
    80000bd4:	bfe9                	j	80000bae <push_off+0x24>

0000000080000bd6 <acquire>:
    80000bd6:	1101                	addi	sp,sp,-32
    80000bd8:	ec06                	sd	ra,24(sp)
    80000bda:	e822                	sd	s0,16(sp)
    80000bdc:	e426                	sd	s1,8(sp)
    80000bde:	1000                	addi	s0,sp,32
    80000be0:	84aa                	mv	s1,a0
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	fa8080e7          	jalr	-88(ra) # 80000b8a <push_off>
    80000bea:	8526                	mv	a0,s1
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	f70080e7          	jalr	-144(ra) # 80000b5c <holding>
    80000bf4:	4705                	li	a4,1
    80000bf6:	e115                	bnez	a0,80000c1a <acquire+0x44>
    80000bf8:	87ba                	mv	a5,a4
    80000bfa:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfe:	2781                	sext.w	a5,a5
    80000c00:	ffe5                	bnez	a5,80000bf8 <acquire+0x22>
    80000c02:	0ff0000f          	fence
    80000c06:	00001097          	auipc	ra,0x1
    80000c0a:	d9c080e7          	jalr	-612(ra) # 800019a2 <mycpu>
    80000c0e:	e888                	sd	a0,16(s1)
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    80000c1a:	00007517          	auipc	a0,0x7
    80000c1e:	45650513          	addi	a0,a0,1110 # 80008070 <digits+0x30>
    80000c22:	00000097          	auipc	ra,0x0
    80000c26:	91e080e7          	jalr	-1762(ra) # 80000540 <panic>

0000000080000c2a <pop_off>:
    80000c2a:	1141                	addi	sp,sp,-16
    80000c2c:	e406                	sd	ra,8(sp)
    80000c2e:	e022                	sd	s0,0(sp)
    80000c30:	0800                	addi	s0,sp,16
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	d70080e7          	jalr	-656(ra) # 800019a2 <mycpu>
    80000c3a:	100027f3          	csrr	a5,sstatus
    80000c3e:	8b89                	andi	a5,a5,2
    80000c40:	e78d                	bnez	a5,80000c6a <pop_off+0x40>
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	02f05b63          	blez	a5,80000c7a <pop_off+0x50>
    80000c48:	37fd                	addiw	a5,a5,-1
    80000c4a:	0007871b          	sext.w	a4,a5
    80000c4e:	dd3c                	sw	a5,120(a0)
    80000c50:	eb09                	bnez	a4,80000c62 <pop_off+0x38>
    80000c52:	5d7c                	lw	a5,124(a0)
    80000c54:	c799                	beqz	a5,80000c62 <pop_off+0x38>
    80000c56:	100027f3          	csrr	a5,sstatus
    80000c5a:	0027e793          	ori	a5,a5,2
    80000c5e:	10079073          	csrw	sstatus,a5
    80000c62:	60a2                	ld	ra,8(sp)
    80000c64:	6402                	ld	s0,0(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret
    80000c6a:	00007517          	auipc	a0,0x7
    80000c6e:	40e50513          	addi	a0,a0,1038 # 80008078 <digits+0x38>
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8ce080e7          	jalr	-1842(ra) # 80000540 <panic>
    80000c7a:	00007517          	auipc	a0,0x7
    80000c7e:	41650513          	addi	a0,a0,1046 # 80008090 <digits+0x50>
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	8be080e7          	jalr	-1858(ra) # 80000540 <panic>

0000000080000c8a <release>:
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	ec6080e7          	jalr	-314(ra) # 80000b5c <holding>
    80000c9e:	c115                	beqz	a0,80000cc2 <release+0x38>
    80000ca0:	0004b823          	sd	zero,16(s1)
    80000ca4:	0ff0000f          	fence
    80000ca8:	0f50000f          	fence	iorw,ow
    80000cac:	0804a02f          	amoswap.w	zero,zero,(s1)
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	f7a080e7          	jalr	-134(ra) # 80000c2a <pop_off>
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	3d650513          	addi	a0,a0,982 # 80008098 <digits+0x58>
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	876080e7          	jalr	-1930(ra) # 80000540 <panic>

0000000080000cd2 <memset>:
    80000cd2:	1141                	addi	sp,sp,-16
    80000cd4:	e422                	sd	s0,8(sp)
    80000cd6:	0800                	addi	s0,sp,16
    80000cd8:	ca19                	beqz	a2,80000cee <memset+0x1c>
    80000cda:	87aa                	mv	a5,a0
    80000cdc:	1602                	slli	a2,a2,0x20
    80000cde:	9201                	srli	a2,a2,0x20
    80000ce0:	00a60733          	add	a4,a2,a0
    80000ce4:	00b78023          	sb	a1,0(a5)
    80000ce8:	0785                	addi	a5,a5,1
    80000cea:	fee79de3          	bne	a5,a4,80000ce4 <memset+0x12>
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e422                	sd	s0,8(sp)
    80000cf8:	0800                	addi	s0,sp,16
    80000cfa:	ca05                	beqz	a2,80000d2a <memcmp+0x36>
    80000cfc:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d00:	1682                	slli	a3,a3,0x20
    80000d02:	9281                	srli	a3,a3,0x20
    80000d04:	0685                	addi	a3,a3,1
    80000d06:	96aa                	add	a3,a3,a0
    80000d08:	00054783          	lbu	a5,0(a0)
    80000d0c:	0005c703          	lbu	a4,0(a1)
    80000d10:	00e79863          	bne	a5,a4,80000d20 <memcmp+0x2c>
    80000d14:	0505                	addi	a0,a0,1
    80000d16:	0585                	addi	a1,a1,1
    80000d18:	fed518e3          	bne	a0,a3,80000d08 <memcmp+0x14>
    80000d1c:	4501                	li	a0,0
    80000d1e:	a019                	j	80000d24 <memcmp+0x30>
    80000d20:	40e7853b          	subw	a0,a5,a4
    80000d24:	6422                	ld	s0,8(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
    80000d2a:	4501                	li	a0,0
    80000d2c:	bfe5                	j	80000d24 <memcmp+0x30>

0000000080000d2e <memmove>:
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
    80000d34:	c205                	beqz	a2,80000d54 <memmove+0x26>
    80000d36:	02a5e263          	bltu	a1,a0,80000d5a <memmove+0x2c>
    80000d3a:	1602                	slli	a2,a2,0x20
    80000d3c:	9201                	srli	a2,a2,0x20
    80000d3e:	00c587b3          	add	a5,a1,a2
    80000d42:	872a                	mv	a4,a0
    80000d44:	0585                	addi	a1,a1,1
    80000d46:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd001>
    80000d48:	fff5c683          	lbu	a3,-1(a1)
    80000d4c:	fed70fa3          	sb	a3,-1(a4)
    80000d50:	fef59ae3          	bne	a1,a5,80000d44 <memmove+0x16>
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
    80000d5a:	02061693          	slli	a3,a2,0x20
    80000d5e:	9281                	srli	a3,a3,0x20
    80000d60:	00d58733          	add	a4,a1,a3
    80000d64:	fce57be3          	bgeu	a0,a4,80000d3a <memmove+0xc>
    80000d68:	96aa                	add	a3,a3,a0
    80000d6a:	fff6079b          	addiw	a5,a2,-1
    80000d6e:	1782                	slli	a5,a5,0x20
    80000d70:	9381                	srli	a5,a5,0x20
    80000d72:	fff7c793          	not	a5,a5
    80000d76:	97ba                	add	a5,a5,a4
    80000d78:	177d                	addi	a4,a4,-1
    80000d7a:	16fd                	addi	a3,a3,-1
    80000d7c:	00074603          	lbu	a2,0(a4)
    80000d80:	00c68023          	sb	a2,0(a3)
    80000d84:	fee79ae3          	bne	a5,a4,80000d78 <memmove+0x4a>
    80000d88:	b7f1                	j	80000d54 <memmove+0x26>

0000000080000d8a <memcpy>:
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	f9c080e7          	jalr	-100(ra) # 80000d2e <memmove>
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
    80000dc0:	4501                	li	a0,0
    80000dc2:	a809                	j	80000dd4 <strncmp+0x32>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a039                	j	80000dd4 <strncmp+0x32>
    80000dc8:	ca09                	beqz	a2,80000dda <strncmp+0x38>
    80000dca:	00054503          	lbu	a0,0(a0)
    80000dce:	0005c783          	lbu	a5,0(a1)
    80000dd2:	9d1d                	subw	a0,a0,a5
    80000dd4:	6422                	ld	s0,8(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret
    80000dda:	4501                	li	a0,0
    80000ddc:	bfe5                	j	80000dd4 <strncmp+0x32>

0000000080000dde <strncpy>:
    80000dde:	1141                	addi	sp,sp,-16
    80000de0:	e422                	sd	s0,8(sp)
    80000de2:	0800                	addi	s0,sp,16
    80000de4:	872a                	mv	a4,a0
    80000de6:	8832                	mv	a6,a2
    80000de8:	367d                	addiw	a2,a2,-1
    80000dea:	01005963          	blez	a6,80000dfc <strncpy+0x1e>
    80000dee:	0705                	addi	a4,a4,1
    80000df0:	0005c783          	lbu	a5,0(a1)
    80000df4:	fef70fa3          	sb	a5,-1(a4)
    80000df8:	0585                	addi	a1,a1,1
    80000dfa:	f7f5                	bnez	a5,80000de6 <strncpy+0x8>
    80000dfc:	86ba                	mv	a3,a4
    80000dfe:	00c05c63          	blez	a2,80000e16 <strncpy+0x38>
    80000e02:	0685                	addi	a3,a3,1
    80000e04:	fe068fa3          	sb	zero,-1(a3)
    80000e08:	40d707bb          	subw	a5,a4,a3
    80000e0c:	37fd                	addiw	a5,a5,-1
    80000e0e:	010787bb          	addw	a5,a5,a6
    80000e12:	fef048e3          	bgtz	a5,80000e02 <strncpy+0x24>
    80000e16:	6422                	ld	s0,8(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret

0000000080000e1c <safestrcpy>:
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
    80000e22:	02c05363          	blez	a2,80000e48 <safestrcpy+0x2c>
    80000e26:	fff6069b          	addiw	a3,a2,-1
    80000e2a:	1682                	slli	a3,a3,0x20
    80000e2c:	9281                	srli	a3,a3,0x20
    80000e2e:	96ae                	add	a3,a3,a1
    80000e30:	87aa                	mv	a5,a0
    80000e32:	00d58963          	beq	a1,a3,80000e44 <safestrcpy+0x28>
    80000e36:	0585                	addi	a1,a1,1
    80000e38:	0785                	addi	a5,a5,1
    80000e3a:	fff5c703          	lbu	a4,-1(a1)
    80000e3e:	fee78fa3          	sb	a4,-1(a5)
    80000e42:	fb65                	bnez	a4,80000e32 <safestrcpy+0x16>
    80000e44:	00078023          	sb	zero,0(a5)
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strlen>:
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
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
    80000e6e:	6422                	ld	s0,8(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret
    80000e74:	4501                	li	a0,0
    80000e76:	bfe5                	j	80000e6e <strlen+0x20>

0000000080000e78 <main>:
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e406                	sd	ra,8(sp)
    80000e7c:	e022                	sd	s0,0(sp)
    80000e7e:	0800                	addi	s0,sp,16
    80000e80:	00001097          	auipc	ra,0x1
    80000e84:	b12080e7          	jalr	-1262(ra) # 80001992 <cpuid>
    80000e88:	00008717          	auipc	a4,0x8
    80000e8c:	ae070713          	addi	a4,a4,-1312 # 80008968 <started>
    80000e90:	c139                	beqz	a0,80000ed6 <main+0x5e>
    80000e92:	431c                	lw	a5,0(a4)
    80000e94:	2781                	sext.w	a5,a5
    80000e96:	dff5                	beqz	a5,80000e92 <main+0x1a>
    80000e98:	0ff0000f          	fence
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	af6080e7          	jalr	-1290(ra) # 80001992 <cpuid>
    80000ea4:	85aa                	mv	a1,a0
    80000ea6:	00007517          	auipc	a0,0x7
    80000eaa:	21250513          	addi	a0,a0,530 # 800080b8 <digits+0x78>
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	6dc080e7          	jalr	1756(ra) # 8000058a <printf>
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	0d8080e7          	jalr	216(ra) # 80000f8e <kvminithart>
    80000ebe:	00002097          	auipc	ra,0x2
    80000ec2:	932080e7          	jalr	-1742(ra) # 800027f0 <trapinithart>
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	eea080e7          	jalr	-278(ra) # 80005db0 <plicinithart>
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	ff2080e7          	jalr	-14(ra) # 80001ec0 <scheduler>
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	57a080e7          	jalr	1402(ra) # 80000450 <consoleinit>
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	88c080e7          	jalr	-1908(ra) # 8000076a <printfinit>
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	1e250513          	addi	a0,a0,482 # 800080c8 <digits+0x88>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	69c080e7          	jalr	1692(ra) # 8000058a <printf>
    80000ef6:	00007517          	auipc	a0,0x7
    80000efa:	1aa50513          	addi	a0,a0,426 # 800080a0 <digits+0x60>
    80000efe:	fffff097          	auipc	ra,0xfffff
    80000f02:	68c080e7          	jalr	1676(ra) # 8000058a <printf>
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	1c250513          	addi	a0,a0,450 # 800080c8 <digits+0x88>
    80000f0e:	fffff097          	auipc	ra,0xfffff
    80000f12:	67c080e7          	jalr	1660(ra) # 8000058a <printf>
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	b94080e7          	jalr	-1132(ra) # 80000aaa <kinit>
    80000f1e:	00000097          	auipc	ra,0x0
    80000f22:	326080e7          	jalr	806(ra) # 80001244 <kvminit>
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	068080e7          	jalr	104(ra) # 80000f8e <kvminithart>
    80000f2e:	00001097          	auipc	ra,0x1
    80000f32:	99e080e7          	jalr	-1634(ra) # 800018cc <procinit>
    80000f36:	00002097          	auipc	ra,0x2
    80000f3a:	892080e7          	jalr	-1902(ra) # 800027c8 <trapinit>
    80000f3e:	00002097          	auipc	ra,0x2
    80000f42:	8b2080e7          	jalr	-1870(ra) # 800027f0 <trapinithart>
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	e54080e7          	jalr	-428(ra) # 80005d9a <plicinit>
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	e62080e7          	jalr	-414(ra) # 80005db0 <plicinithart>
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	004080e7          	jalr	4(ra) # 80002f5a <binit>
    80000f5e:	00002097          	auipc	ra,0x2
    80000f62:	6a4080e7          	jalr	1700(ra) # 80003602 <iinit>
    80000f66:	00003097          	auipc	ra,0x3
    80000f6a:	64a080e7          	jalr	1610(ra) # 800045b0 <fileinit>
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	f4a080e7          	jalr	-182(ra) # 80005eb8 <virtio_disk_init>
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	d2c080e7          	jalr	-724(ra) # 80001ca2 <userinit>
    80000f7e:	0ff0000f          	fence
    80000f82:	4785                	li	a5,1
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	9ef72223          	sw	a5,-1564(a4) # 80008968 <started>
    80000f8c:	b789                	j	80000ece <main+0x56>

0000000080000f8e <kvminithart>:
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e422                	sd	s0,8(sp)
    80000f92:	0800                	addi	s0,sp,16
    80000f94:	12000073          	sfence.vma
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	9d87b783          	ld	a5,-1576(a5) # 80008970 <kernel_pagetable>
    80000fa0:	83b1                	srli	a5,a5,0xc
    80000fa2:	577d                	li	a4,-1
    80000fa4:	177e                	slli	a4,a4,0x3f
    80000fa6:	8fd9                	or	a5,a5,a4
    80000fa8:	18079073          	csrw	satp,a5
    80000fac:	12000073          	sfence.vma
    80000fb0:	6422                	ld	s0,8(sp)
    80000fb2:	0141                	addi	sp,sp,16
    80000fb4:	8082                	ret

0000000080000fb6 <walk>:
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
    80000fd0:	57fd                	li	a5,-1
    80000fd2:	83e9                	srli	a5,a5,0x1a
    80000fd4:	4a79                	li	s4,30
    80000fd6:	4b31                	li	s6,12
    80000fd8:	04b7f263          	bgeu	a5,a1,8000101c <walk+0x66>
    80000fdc:	00007517          	auipc	a0,0x7
    80000fe0:	0f450513          	addi	a0,a0,244 # 800080d0 <digits+0x90>
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	55c080e7          	jalr	1372(ra) # 80000540 <panic>
    80000fec:	060a8663          	beqz	s5,80001058 <walk+0xa2>
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	af6080e7          	jalr	-1290(ra) # 80000ae6 <kalloc>
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	c529                	beqz	a0,80001044 <walk+0x8e>
    80000ffc:	6605                	lui	a2,0x1
    80000ffe:	4581                	li	a1,0
    80001000:	00000097          	auipc	ra,0x0
    80001004:	cd2080e7          	jalr	-814(ra) # 80000cd2 <memset>
    80001008:	00c4d793          	srli	a5,s1,0xc
    8000100c:	07aa                	slli	a5,a5,0xa
    8000100e:	0017e793          	ori	a5,a5,1
    80001012:	00f93023          	sd	a5,0(s2)
    80001016:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcff7>
    80001018:	036a0063          	beq	s4,s6,80001038 <walk+0x82>
    8000101c:	0149d933          	srl	s2,s3,s4
    80001020:	1ff97913          	andi	s2,s2,511
    80001024:	090e                	slli	s2,s2,0x3
    80001026:	9926                	add	s2,s2,s1
    80001028:	00093483          	ld	s1,0(s2)
    8000102c:	0014f793          	andi	a5,s1,1
    80001030:	dfd5                	beqz	a5,80000fec <walk+0x36>
    80001032:	80a9                	srli	s1,s1,0xa
    80001034:	04b2                	slli	s1,s1,0xc
    80001036:	b7c5                	j	80001016 <walk+0x60>
    80001038:	00c9d513          	srli	a0,s3,0xc
    8000103c:	1ff57513          	andi	a0,a0,511
    80001040:	050e                	slli	a0,a0,0x3
    80001042:	9526                	add	a0,a0,s1
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
    80001058:	4501                	li	a0,0
    8000105a:	b7ed                	j	80001044 <walk+0x8e>

000000008000105c <walkaddr>:
    8000105c:	57fd                	li	a5,-1
    8000105e:	83e9                	srli	a5,a5,0x1a
    80001060:	00b7f463          	bgeu	a5,a1,80001068 <walkaddr+0xc>
    80001064:	4501                	li	a0,0
    80001066:	8082                	ret
    80001068:	1141                	addi	sp,sp,-16
    8000106a:	e406                	sd	ra,8(sp)
    8000106c:	e022                	sd	s0,0(sp)
    8000106e:	0800                	addi	s0,sp,16
    80001070:	4601                	li	a2,0
    80001072:	00000097          	auipc	ra,0x0
    80001076:	f44080e7          	jalr	-188(ra) # 80000fb6 <walk>
    8000107a:	c105                	beqz	a0,8000109a <walkaddr+0x3e>
    8000107c:	611c                	ld	a5,0(a0)
    8000107e:	0117f693          	andi	a3,a5,17
    80001082:	4745                	li	a4,17
    80001084:	4501                	li	a0,0
    80001086:	00e68663          	beq	a3,a4,80001092 <walkaddr+0x36>
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	addi	sp,sp,16
    80001090:	8082                	ret
    80001092:	83a9                	srli	a5,a5,0xa
    80001094:	00c79513          	slli	a0,a5,0xc
    80001098:	bfcd                	j	8000108a <walkaddr+0x2e>
    8000109a:	4501                	li	a0,0
    8000109c:	b7fd                	j	8000108a <walkaddr+0x2e>

000000008000109e <mappages>:
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
    800010b4:	c639                	beqz	a2,80001102 <mappages+0x64>
    800010b6:	8aaa                	mv	s5,a0
    800010b8:	8b3a                	mv	s6,a4
    800010ba:	777d                	lui	a4,0xfffff
    800010bc:	00e5f7b3          	and	a5,a1,a4
    800010c0:	fff58993          	addi	s3,a1,-1
    800010c4:	99b2                	add	s3,s3,a2
    800010c6:	00e9f9b3          	and	s3,s3,a4
    800010ca:	893e                	mv	s2,a5
    800010cc:	40f68a33          	sub	s4,a3,a5
    800010d0:	6b85                	lui	s7,0x1
    800010d2:	012a04b3          	add	s1,s4,s2
    800010d6:	4605                	li	a2,1
    800010d8:	85ca                	mv	a1,s2
    800010da:	8556                	mv	a0,s5
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	eda080e7          	jalr	-294(ra) # 80000fb6 <walk>
    800010e4:	cd1d                	beqz	a0,80001122 <mappages+0x84>
    800010e6:	611c                	ld	a5,0(a0)
    800010e8:	8b85                	andi	a5,a5,1
    800010ea:	e785                	bnez	a5,80001112 <mappages+0x74>
    800010ec:	80b1                	srli	s1,s1,0xc
    800010ee:	04aa                	slli	s1,s1,0xa
    800010f0:	0164e4b3          	or	s1,s1,s6
    800010f4:	0014e493          	ori	s1,s1,1
    800010f8:	e104                	sd	s1,0(a0)
    800010fa:	05390063          	beq	s2,s3,8000113a <mappages+0x9c>
    800010fe:	995e                	add	s2,s2,s7
    80001100:	bfc9                	j	800010d2 <mappages+0x34>
    80001102:	00007517          	auipc	a0,0x7
    80001106:	fd650513          	addi	a0,a0,-42 # 800080d8 <digits+0x98>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	436080e7          	jalr	1078(ra) # 80000540 <panic>
    80001112:	00007517          	auipc	a0,0x7
    80001116:	fd650513          	addi	a0,a0,-42 # 800080e8 <digits+0xa8>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	426080e7          	jalr	1062(ra) # 80000540 <panic>
    80001122:	557d                	li	a0,-1
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
    8000113a:	4501                	li	a0,0
    8000113c:	b7e5                	j	80001124 <mappages+0x86>

000000008000113e <kvmmap>:
    8000113e:	1141                	addi	sp,sp,-16
    80001140:	e406                	sd	ra,8(sp)
    80001142:	e022                	sd	s0,0(sp)
    80001144:	0800                	addi	s0,sp,16
    80001146:	87b6                	mv	a5,a3
    80001148:	86b2                	mv	a3,a2
    8000114a:	863e                	mv	a2,a5
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f52080e7          	jalr	-174(ra) # 8000109e <mappages>
    80001154:	e509                	bnez	a0,8000115e <kvmmap+0x20>
    80001156:	60a2                	ld	ra,8(sp)
    80001158:	6402                	ld	s0,0(sp)
    8000115a:	0141                	addi	sp,sp,16
    8000115c:	8082                	ret
    8000115e:	00007517          	auipc	a0,0x7
    80001162:	f9a50513          	addi	a0,a0,-102 # 800080f8 <digits+0xb8>
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3da080e7          	jalr	986(ra) # 80000540 <panic>

000000008000116e <kvmmake>:
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	e04a                	sd	s2,0(sp)
    80001178:	1000                	addi	s0,sp,32
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	96c080e7          	jalr	-1684(ra) # 80000ae6 <kalloc>
    80001182:	84aa                	mv	s1,a0
    80001184:	6605                	lui	a2,0x1
    80001186:	4581                	li	a1,0
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	b4a080e7          	jalr	-1206(ra) # 80000cd2 <memset>
    80001190:	4719                	li	a4,6
    80001192:	6685                	lui	a3,0x1
    80001194:	10000637          	lui	a2,0x10000
    80001198:	100005b7          	lui	a1,0x10000
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	fa0080e7          	jalr	-96(ra) # 8000113e <kvmmap>
    800011a6:	4719                	li	a4,6
    800011a8:	6685                	lui	a3,0x1
    800011aa:	10001637          	lui	a2,0x10001
    800011ae:	100015b7          	lui	a1,0x10001
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f8a080e7          	jalr	-118(ra) # 8000113e <kvmmap>
    800011bc:	4719                	li	a4,6
    800011be:	004006b7          	lui	a3,0x400
    800011c2:	0c000637          	lui	a2,0xc000
    800011c6:	0c0005b7          	lui	a1,0xc000
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f72080e7          	jalr	-142(ra) # 8000113e <kvmmap>
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
    800011f6:	4719                	li	a4,6
    800011f8:	46c5                	li	a3,17
    800011fa:	06ee                	slli	a3,a3,0x1b
    800011fc:	412686b3          	sub	a3,a3,s2
    80001200:	864a                	mv	a2,s2
    80001202:	85ca                	mv	a1,s2
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	f38080e7          	jalr	-200(ra) # 8000113e <kvmmap>
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
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	608080e7          	jalr	1544(ra) # 80001836 <proc_mapstacks>
    80001236:	8526                	mv	a0,s1
    80001238:	60e2                	ld	ra,24(sp)
    8000123a:	6442                	ld	s0,16(sp)
    8000123c:	64a2                	ld	s1,8(sp)
    8000123e:	6902                	ld	s2,0(sp)
    80001240:	6105                	addi	sp,sp,32
    80001242:	8082                	ret

0000000080001244 <kvminit>:
    80001244:	1141                	addi	sp,sp,-16
    80001246:	e406                	sd	ra,8(sp)
    80001248:	e022                	sd	s0,0(sp)
    8000124a:	0800                	addi	s0,sp,16
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f22080e7          	jalr	-222(ra) # 8000116e <kvmmake>
    80001254:	00007797          	auipc	a5,0x7
    80001258:	70a7be23          	sd	a0,1820(a5) # 80008970 <kernel_pagetable>
    8000125c:	60a2                	ld	ra,8(sp)
    8000125e:	6402                	ld	s0,0(sp)
    80001260:	0141                	addi	sp,sp,16
    80001262:	8082                	ret

0000000080001264 <uvmunmap>:
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
    8000127a:	03459793          	slli	a5,a1,0x34
    8000127e:	e795                	bnez	a5,800012aa <uvmunmap+0x46>
    80001280:	8a2a                	mv	s4,a0
    80001282:	892e                	mv	s2,a1
    80001284:	8ab6                	mv	s5,a3
    80001286:	0632                	slli	a2,a2,0xc
    80001288:	00b609b3          	add	s3,a2,a1
    8000128c:	4b85                	li	s7,1
    8000128e:	6b05                	lui	s6,0x1
    80001290:	0735e263          	bltu	a1,s3,800012f4 <uvmunmap+0x90>
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
    800012aa:	00007517          	auipc	a0,0x7
    800012ae:	e5650513          	addi	a0,a0,-426 # 80008100 <digits+0xc0>
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	28e080e7          	jalr	654(ra) # 80000540 <panic>
    800012ba:	00007517          	auipc	a0,0x7
    800012be:	e5e50513          	addi	a0,a0,-418 # 80008118 <digits+0xd8>
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	27e080e7          	jalr	638(ra) # 80000540 <panic>
    800012ca:	00007517          	auipc	a0,0x7
    800012ce:	e5e50513          	addi	a0,a0,-418 # 80008128 <digits+0xe8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	26e080e7          	jalr	622(ra) # 80000540 <panic>
    800012da:	00007517          	auipc	a0,0x7
    800012de:	e6650513          	addi	a0,a0,-410 # 80008140 <digits+0x100>
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	25e080e7          	jalr	606(ra) # 80000540 <panic>
    800012ea:	0004b023          	sd	zero,0(s1)
    800012ee:	995a                	add	s2,s2,s6
    800012f0:	fb3972e3          	bgeu	s2,s3,80001294 <uvmunmap+0x30>
    800012f4:	4601                	li	a2,0
    800012f6:	85ca                	mv	a1,s2
    800012f8:	8552                	mv	a0,s4
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	cbc080e7          	jalr	-836(ra) # 80000fb6 <walk>
    80001302:	84aa                	mv	s1,a0
    80001304:	d95d                	beqz	a0,800012ba <uvmunmap+0x56>
    80001306:	6108                	ld	a0,0(a0)
    80001308:	00157793          	andi	a5,a0,1
    8000130c:	dfdd                	beqz	a5,800012ca <uvmunmap+0x66>
    8000130e:	3ff57793          	andi	a5,a0,1023
    80001312:	fd7784e3          	beq	a5,s7,800012da <uvmunmap+0x76>
    80001316:	fc0a8ae3          	beqz	s5,800012ea <uvmunmap+0x86>
    8000131a:	8129                	srli	a0,a0,0xa
    8000131c:	0532                	slli	a0,a0,0xc
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	6ca080e7          	jalr	1738(ra) # 800009e8 <kfree>
    80001326:	b7d1                	j	800012ea <uvmunmap+0x86>

0000000080001328 <uvmcreate>:
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	e426                	sd	s1,8(sp)
    80001330:	1000                	addi	s0,sp,32
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	7b4080e7          	jalr	1972(ra) # 80000ae6 <kalloc>
    8000133a:	84aa                	mv	s1,a0
    8000133c:	c519                	beqz	a0,8000134a <uvmcreate+0x22>
    8000133e:	6605                	lui	a2,0x1
    80001340:	4581                	li	a1,0
    80001342:	00000097          	auipc	ra,0x0
    80001346:	990080e7          	jalr	-1648(ra) # 80000cd2 <memset>
    8000134a:	8526                	mv	a0,s1
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret

0000000080001356 <uvmfirst>:
    80001356:	7179                	addi	sp,sp,-48
    80001358:	f406                	sd	ra,40(sp)
    8000135a:	f022                	sd	s0,32(sp)
    8000135c:	ec26                	sd	s1,24(sp)
    8000135e:	e84a                	sd	s2,16(sp)
    80001360:	e44e                	sd	s3,8(sp)
    80001362:	e052                	sd	s4,0(sp)
    80001364:	1800                	addi	s0,sp,48
    80001366:	6785                	lui	a5,0x1
    80001368:	04f67863          	bgeu	a2,a5,800013b8 <uvmfirst+0x62>
    8000136c:	8a2a                	mv	s4,a0
    8000136e:	89ae                	mv	s3,a1
    80001370:	84b2                	mv	s1,a2
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	774080e7          	jalr	1908(ra) # 80000ae6 <kalloc>
    8000137a:	892a                	mv	s2,a0
    8000137c:	6605                	lui	a2,0x1
    8000137e:	4581                	li	a1,0
    80001380:	00000097          	auipc	ra,0x0
    80001384:	952080e7          	jalr	-1710(ra) # 80000cd2 <memset>
    80001388:	4779                	li	a4,30
    8000138a:	86ca                	mv	a3,s2
    8000138c:	6605                	lui	a2,0x1
    8000138e:	4581                	li	a1,0
    80001390:	8552                	mv	a0,s4
    80001392:	00000097          	auipc	ra,0x0
    80001396:	d0c080e7          	jalr	-756(ra) # 8000109e <mappages>
    8000139a:	8626                	mv	a2,s1
    8000139c:	85ce                	mv	a1,s3
    8000139e:	854a                	mv	a0,s2
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	98e080e7          	jalr	-1650(ra) # 80000d2e <memmove>
    800013a8:	70a2                	ld	ra,40(sp)
    800013aa:	7402                	ld	s0,32(sp)
    800013ac:	64e2                	ld	s1,24(sp)
    800013ae:	6942                	ld	s2,16(sp)
    800013b0:	69a2                	ld	s3,8(sp)
    800013b2:	6a02                	ld	s4,0(sp)
    800013b4:	6145                	addi	sp,sp,48
    800013b6:	8082                	ret
    800013b8:	00007517          	auipc	a0,0x7
    800013bc:	da050513          	addi	a0,a0,-608 # 80008158 <digits+0x118>
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	180080e7          	jalr	384(ra) # 80000540 <panic>

00000000800013c8 <uvmdealloc>:
    800013c8:	1101                	addi	sp,sp,-32
    800013ca:	ec06                	sd	ra,24(sp)
    800013cc:	e822                	sd	s0,16(sp)
    800013ce:	e426                	sd	s1,8(sp)
    800013d0:	1000                	addi	s0,sp,32
    800013d2:	84ae                	mv	s1,a1
    800013d4:	00b67d63          	bgeu	a2,a1,800013ee <uvmdealloc+0x26>
    800013d8:	84b2                	mv	s1,a2
    800013da:	6785                	lui	a5,0x1
    800013dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013de:	00f60733          	add	a4,a2,a5
    800013e2:	76fd                	lui	a3,0xfffff
    800013e4:	8f75                	and	a4,a4,a3
    800013e6:	97ae                	add	a5,a5,a1
    800013e8:	8ff5                	and	a5,a5,a3
    800013ea:	00f76863          	bltu	a4,a5,800013fa <uvmdealloc+0x32>
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret
    800013fa:	8f99                	sub	a5,a5,a4
    800013fc:	83b1                	srli	a5,a5,0xc
    800013fe:	4685                	li	a3,1
    80001400:	0007861b          	sext.w	a2,a5
    80001404:	85ba                	mv	a1,a4
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	e5e080e7          	jalr	-418(ra) # 80001264 <uvmunmap>
    8000140e:	b7c5                	j	800013ee <uvmdealloc+0x26>

0000000080001410 <uvmalloc>:
    80001410:	0ab66563          	bltu	a2,a1,800014ba <uvmalloc+0xaa>
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
    8000142c:	6785                	lui	a5,0x1
    8000142e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001430:	95be                	add	a1,a1,a5
    80001432:	77fd                	lui	a5,0xfffff
    80001434:	00f5f9b3          	and	s3,a1,a5
    80001438:	08c9f363          	bgeu	s3,a2,800014be <uvmalloc+0xae>
    8000143c:	894e                	mv	s2,s3
    8000143e:	0126eb13          	ori	s6,a3,18
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	6a4080e7          	jalr	1700(ra) # 80000ae6 <kalloc>
    8000144a:	84aa                	mv	s1,a0
    8000144c:	c51d                	beqz	a0,8000147a <uvmalloc+0x6a>
    8000144e:	6605                	lui	a2,0x1
    80001450:	4581                	li	a1,0
    80001452:	00000097          	auipc	ra,0x0
    80001456:	880080e7          	jalr	-1920(ra) # 80000cd2 <memset>
    8000145a:	875a                	mv	a4,s6
    8000145c:	86a6                	mv	a3,s1
    8000145e:	6605                	lui	a2,0x1
    80001460:	85ca                	mv	a1,s2
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	c3a080e7          	jalr	-966(ra) # 8000109e <mappages>
    8000146c:	e90d                	bnez	a0,8000149e <uvmalloc+0x8e>
    8000146e:	6785                	lui	a5,0x1
    80001470:	993e                	add	s2,s2,a5
    80001472:	fd4968e3          	bltu	s2,s4,80001442 <uvmalloc+0x32>
    80001476:	8552                	mv	a0,s4
    80001478:	a809                	j	8000148a <uvmalloc+0x7a>
    8000147a:	864e                	mv	a2,s3
    8000147c:	85ca                	mv	a1,s2
    8000147e:	8556                	mv	a0,s5
    80001480:	00000097          	auipc	ra,0x0
    80001484:	f48080e7          	jalr	-184(ra) # 800013c8 <uvmdealloc>
    80001488:	4501                	li	a0,0
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
    8000149e:	8526                	mv	a0,s1
    800014a0:	fffff097          	auipc	ra,0xfffff
    800014a4:	548080e7          	jalr	1352(ra) # 800009e8 <kfree>
    800014a8:	864e                	mv	a2,s3
    800014aa:	85ca                	mv	a1,s2
    800014ac:	8556                	mv	a0,s5
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	f1a080e7          	jalr	-230(ra) # 800013c8 <uvmdealloc>
    800014b6:	4501                	li	a0,0
    800014b8:	bfc9                	j	8000148a <uvmalloc+0x7a>
    800014ba:	852e                	mv	a0,a1
    800014bc:	8082                	ret
    800014be:	8532                	mv	a0,a2
    800014c0:	b7e9                	j	8000148a <uvmalloc+0x7a>

00000000800014c2 <freewalk>:
    800014c2:	7179                	addi	sp,sp,-48
    800014c4:	f406                	sd	ra,40(sp)
    800014c6:	f022                	sd	s0,32(sp)
    800014c8:	ec26                	sd	s1,24(sp)
    800014ca:	e84a                	sd	s2,16(sp)
    800014cc:	e44e                	sd	s3,8(sp)
    800014ce:	e052                	sd	s4,0(sp)
    800014d0:	1800                	addi	s0,sp,48
    800014d2:	8a2a                	mv	s4,a0
    800014d4:	84aa                	mv	s1,a0
    800014d6:	6905                	lui	s2,0x1
    800014d8:	992a                	add	s2,s2,a0
    800014da:	4985                	li	s3,1
    800014dc:	a829                	j	800014f6 <freewalk+0x34>
    800014de:	83a9                	srli	a5,a5,0xa
    800014e0:	00c79513          	slli	a0,a5,0xc
    800014e4:	00000097          	auipc	ra,0x0
    800014e8:	fde080e7          	jalr	-34(ra) # 800014c2 <freewalk>
    800014ec:	0004b023          	sd	zero,0(s1)
    800014f0:	04a1                	addi	s1,s1,8
    800014f2:	03248163          	beq	s1,s2,80001514 <freewalk+0x52>
    800014f6:	609c                	ld	a5,0(s1)
    800014f8:	00f7f713          	andi	a4,a5,15
    800014fc:	ff3701e3          	beq	a4,s3,800014de <freewalk+0x1c>
    80001500:	8b85                	andi	a5,a5,1
    80001502:	d7fd                	beqz	a5,800014f0 <freewalk+0x2e>
    80001504:	00007517          	auipc	a0,0x7
    80001508:	c7450513          	addi	a0,a0,-908 # 80008178 <digits+0x138>
    8000150c:	fffff097          	auipc	ra,0xfffff
    80001510:	034080e7          	jalr	52(ra) # 80000540 <panic>
    80001514:	8552                	mv	a0,s4
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	4d2080e7          	jalr	1234(ra) # 800009e8 <kfree>
    8000151e:	70a2                	ld	ra,40(sp)
    80001520:	7402                	ld	s0,32(sp)
    80001522:	64e2                	ld	s1,24(sp)
    80001524:	6942                	ld	s2,16(sp)
    80001526:	69a2                	ld	s3,8(sp)
    80001528:	6a02                	ld	s4,0(sp)
    8000152a:	6145                	addi	sp,sp,48
    8000152c:	8082                	ret

000000008000152e <uvmfree>:
    8000152e:	1101                	addi	sp,sp,-32
    80001530:	ec06                	sd	ra,24(sp)
    80001532:	e822                	sd	s0,16(sp)
    80001534:	e426                	sd	s1,8(sp)
    80001536:	1000                	addi	s0,sp,32
    80001538:	84aa                	mv	s1,a0
    8000153a:	e999                	bnez	a1,80001550 <uvmfree+0x22>
    8000153c:	8526                	mv	a0,s1
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	f84080e7          	jalr	-124(ra) # 800014c2 <freewalk>
    80001546:	60e2                	ld	ra,24(sp)
    80001548:	6442                	ld	s0,16(sp)
    8000154a:	64a2                	ld	s1,8(sp)
    8000154c:	6105                	addi	sp,sp,32
    8000154e:	8082                	ret
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
    80001568:	c679                	beqz	a2,80001636 <uvmcopy+0xce>
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
    80001586:	4981                	li	s3,0
    80001588:	4601                	li	a2,0
    8000158a:	85ce                	mv	a1,s3
    8000158c:	855a                	mv	a0,s6
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	a28080e7          	jalr	-1496(ra) # 80000fb6 <walk>
    80001596:	c531                	beqz	a0,800015e2 <uvmcopy+0x7a>
    80001598:	6118                	ld	a4,0(a0)
    8000159a:	00177793          	andi	a5,a4,1
    8000159e:	cbb1                	beqz	a5,800015f2 <uvmcopy+0x8a>
    800015a0:	00a75593          	srli	a1,a4,0xa
    800015a4:	00c59b93          	slli	s7,a1,0xc
    800015a8:	3ff77493          	andi	s1,a4,1023
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	53a080e7          	jalr	1338(ra) # 80000ae6 <kalloc>
    800015b4:	892a                	mv	s2,a0
    800015b6:	c939                	beqz	a0,8000160c <uvmcopy+0xa4>
    800015b8:	6605                	lui	a2,0x1
    800015ba:	85de                	mv	a1,s7
    800015bc:	fffff097          	auipc	ra,0xfffff
    800015c0:	772080e7          	jalr	1906(ra) # 80000d2e <memmove>
    800015c4:	8726                	mv	a4,s1
    800015c6:	86ca                	mv	a3,s2
    800015c8:	6605                	lui	a2,0x1
    800015ca:	85ce                	mv	a1,s3
    800015cc:	8556                	mv	a0,s5
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	ad0080e7          	jalr	-1328(ra) # 8000109e <mappages>
    800015d6:	e515                	bnez	a0,80001602 <uvmcopy+0x9a>
    800015d8:	6785                	lui	a5,0x1
    800015da:	99be                	add	s3,s3,a5
    800015dc:	fb49e6e3          	bltu	s3,s4,80001588 <uvmcopy+0x20>
    800015e0:	a081                	j	80001620 <uvmcopy+0xb8>
    800015e2:	00007517          	auipc	a0,0x7
    800015e6:	ba650513          	addi	a0,a0,-1114 # 80008188 <digits+0x148>
    800015ea:	fffff097          	auipc	ra,0xfffff
    800015ee:	f56080e7          	jalr	-170(ra) # 80000540 <panic>
    800015f2:	00007517          	auipc	a0,0x7
    800015f6:	bb650513          	addi	a0,a0,-1098 # 800081a8 <digits+0x168>
    800015fa:	fffff097          	auipc	ra,0xfffff
    800015fe:	f46080e7          	jalr	-186(ra) # 80000540 <panic>
    80001602:	854a                	mv	a0,s2
    80001604:	fffff097          	auipc	ra,0xfffff
    80001608:	3e4080e7          	jalr	996(ra) # 800009e8 <kfree>
    8000160c:	4685                	li	a3,1
    8000160e:	00c9d613          	srli	a2,s3,0xc
    80001612:	4581                	li	a1,0
    80001614:	8556                	mv	a0,s5
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	c4e080e7          	jalr	-946(ra) # 80001264 <uvmunmap>
    8000161e:	557d                	li	a0,-1
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
    80001636:	4501                	li	a0,0
    80001638:	8082                	ret

000000008000163a <uvmclear>:
    8000163a:	1141                	addi	sp,sp,-16
    8000163c:	e406                	sd	ra,8(sp)
    8000163e:	e022                	sd	s0,0(sp)
    80001640:	0800                	addi	s0,sp,16
    80001642:	4601                	li	a2,0
    80001644:	00000097          	auipc	ra,0x0
    80001648:	972080e7          	jalr	-1678(ra) # 80000fb6 <walk>
    8000164c:	c901                	beqz	a0,8000165c <uvmclear+0x22>
    8000164e:	611c                	ld	a5,0(a0)
    80001650:	9bbd                	andi	a5,a5,-17
    80001652:	e11c                	sd	a5,0(a0)
    80001654:	60a2                	ld	ra,8(sp)
    80001656:	6402                	ld	s0,0(sp)
    80001658:	0141                	addi	sp,sp,16
    8000165a:	8082                	ret
    8000165c:	00007517          	auipc	a0,0x7
    80001660:	b6c50513          	addi	a0,a0,-1172 # 800081c8 <digits+0x188>
    80001664:	fffff097          	auipc	ra,0xfffff
    80001668:	edc080e7          	jalr	-292(ra) # 80000540 <panic>

000000008000166c <copyout>:
    8000166c:	c6bd                	beqz	a3,800016da <copyout+0x6e>
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
    8000168e:	7bfd                	lui	s7,0xfffff
    80001690:	6a85                	lui	s5,0x1
    80001692:	a015                	j	800016b6 <copyout+0x4a>
    80001694:	9562                	add	a0,a0,s8
    80001696:	0004861b          	sext.w	a2,s1
    8000169a:	85d2                	mv	a1,s4
    8000169c:	41250533          	sub	a0,a0,s2
    800016a0:	fffff097          	auipc	ra,0xfffff
    800016a4:	68e080e7          	jalr	1678(ra) # 80000d2e <memmove>
    800016a8:	409989b3          	sub	s3,s3,s1
    800016ac:	9a26                	add	s4,s4,s1
    800016ae:	01590c33          	add	s8,s2,s5
    800016b2:	02098263          	beqz	s3,800016d6 <copyout+0x6a>
    800016b6:	017c7933          	and	s2,s8,s7
    800016ba:	85ca                	mv	a1,s2
    800016bc:	855a                	mv	a0,s6
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	99e080e7          	jalr	-1634(ra) # 8000105c <walkaddr>
    800016c6:	cd01                	beqz	a0,800016de <copyout+0x72>
    800016c8:	418904b3          	sub	s1,s2,s8
    800016cc:	94d6                	add	s1,s1,s5
    800016ce:	fc99f3e3          	bgeu	s3,s1,80001694 <copyout+0x28>
    800016d2:	84ce                	mv	s1,s3
    800016d4:	b7c1                	j	80001694 <copyout+0x28>
    800016d6:	4501                	li	a0,0
    800016d8:	a021                	j	800016e0 <copyout+0x74>
    800016da:	4501                	li	a0,0
    800016dc:	8082                	ret
    800016de:	557d                	li	a0,-1
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
    800016f8:	caa5                	beqz	a3,80001768 <copyin+0x70>
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
    8000171a:	7bfd                	lui	s7,0xfffff
    8000171c:	6a85                	lui	s5,0x1
    8000171e:	a01d                	j	80001744 <copyin+0x4c>
    80001720:	018505b3          	add	a1,a0,s8
    80001724:	0004861b          	sext.w	a2,s1
    80001728:	412585b3          	sub	a1,a1,s2
    8000172c:	8552                	mv	a0,s4
    8000172e:	fffff097          	auipc	ra,0xfffff
    80001732:	600080e7          	jalr	1536(ra) # 80000d2e <memmove>
    80001736:	409989b3          	sub	s3,s3,s1
    8000173a:	9a26                	add	s4,s4,s1
    8000173c:	01590c33          	add	s8,s2,s5
    80001740:	02098263          	beqz	s3,80001764 <copyin+0x6c>
    80001744:	017c7933          	and	s2,s8,s7
    80001748:	85ca                	mv	a1,s2
    8000174a:	855a                	mv	a0,s6
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	910080e7          	jalr	-1776(ra) # 8000105c <walkaddr>
    80001754:	cd01                	beqz	a0,8000176c <copyin+0x74>
    80001756:	418904b3          	sub	s1,s2,s8
    8000175a:	94d6                	add	s1,s1,s5
    8000175c:	fc99f2e3          	bgeu	s3,s1,80001720 <copyin+0x28>
    80001760:	84ce                	mv	s1,s3
    80001762:	bf7d                	j	80001720 <copyin+0x28>
    80001764:	4501                	li	a0,0
    80001766:	a021                	j	8000176e <copyin+0x76>
    80001768:	4501                	li	a0,0
    8000176a:	8082                	ret
    8000176c:	557d                	li	a0,-1
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
    80001786:	c2dd                	beqz	a3,8000182c <copyinstr+0xa6>
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
    800017a6:	7afd                	lui	s5,0xfffff
    800017a8:	6985                	lui	s3,0x1
    800017aa:	a02d                	j	800017d4 <copyinstr+0x4e>
    800017ac:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017b0:	4785                	li	a5,1
    800017b2:	37fd                	addiw	a5,a5,-1
    800017b4:	0007851b          	sext.w	a0,a5
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
    800017ce:	01390bb3          	add	s7,s2,s3
    800017d2:	c8a9                	beqz	s1,80001824 <copyinstr+0x9e>
    800017d4:	015bf933          	and	s2,s7,s5
    800017d8:	85ca                	mv	a1,s2
    800017da:	8552                	mv	a0,s4
    800017dc:	00000097          	auipc	ra,0x0
    800017e0:	880080e7          	jalr	-1920(ra) # 8000105c <walkaddr>
    800017e4:	c131                	beqz	a0,80001828 <copyinstr+0xa2>
    800017e6:	417906b3          	sub	a3,s2,s7
    800017ea:	96ce                	add	a3,a3,s3
    800017ec:	00d4f363          	bgeu	s1,a3,800017f2 <copyinstr+0x6c>
    800017f0:	86a6                	mv	a3,s1
    800017f2:	955e                	add	a0,a0,s7
    800017f4:	41250533          	sub	a0,a0,s2
    800017f8:	daf9                	beqz	a3,800017ce <copyinstr+0x48>
    800017fa:	87da                	mv	a5,s6
    800017fc:	41650633          	sub	a2,a0,s6
    80001800:	fff48593          	addi	a1,s1,-1
    80001804:	95da                	add	a1,a1,s6
    80001806:	96da                	add	a3,a3,s6
    80001808:	00f60733          	add	a4,a2,a5
    8000180c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd000>
    80001810:	df51                	beqz	a4,800017ac <copyinstr+0x26>
    80001812:	00e78023          	sb	a4,0(a5)
    80001816:	40f584b3          	sub	s1,a1,a5
    8000181a:	0785                	addi	a5,a5,1
    8000181c:	fed796e3          	bne	a5,a3,80001808 <copyinstr+0x82>
    80001820:	8b3e                	mv	s6,a5
    80001822:	b775                	j	800017ce <copyinstr+0x48>
    80001824:	4781                	li	a5,0
    80001826:	b771                	j	800017b2 <copyinstr+0x2c>
    80001828:	557d                	li	a0,-1
    8000182a:	b779                	j	800017b8 <copyinstr+0x32>
    8000182c:	4781                	li	a5,0
    8000182e:	37fd                	addiw	a5,a5,-1
    80001830:	0007851b          	sext.w	a0,a5
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
    80001850:	7d448493          	addi	s1,s1,2004 # 80011020 <proc>
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
    8000186a:	3baa0a13          	addi	s4,s4,954 # 80016c20 <tickslock>
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
    800018ee:	30650513          	addi	a0,a0,774 # 80010bf0 <pid_lock>
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	254080e7          	jalr	596(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018fa:	00007597          	auipc	a1,0x7
    800018fe:	8ee58593          	addi	a1,a1,-1810 # 800081e8 <digits+0x1a8>
    80001902:	0000f517          	auipc	a0,0xf
    80001906:	30650513          	addi	a0,a0,774 # 80010c08 <wait_lock>
    8000190a:	fffff097          	auipc	ra,0xfffff
    8000190e:	23c080e7          	jalr	572(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001912:	0000f497          	auipc	s1,0xf
    80001916:	70e48493          	addi	s1,s1,1806 # 80011020 <proc>
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
    8000193a:	2ea98993          	addi	s3,s3,746 # 80016c20 <tickslock>
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
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
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
    800019b2:	27250513          	addi	a0,a0,626 # 80010c20 <cpus>
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
    800019da:	21a70713          	addi	a4,a4,538 # 80010bf0 <pid_lock>
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
    80001a12:	ed27a783          	lw	a5,-302(a5) # 800088e0 <first.1>
    80001a16:	eb89                	bnez	a5,80001a28 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a18:	00001097          	auipc	ra,0x1
    80001a1c:	df0080e7          	jalr	-528(ra) # 80002808 <usertrapret>
}
    80001a20:	60a2                	ld	ra,8(sp)
    80001a22:	6402                	ld	s0,0(sp)
    80001a24:	0141                	addi	sp,sp,16
    80001a26:	8082                	ret
    first = 0;
    80001a28:	00007797          	auipc	a5,0x7
    80001a2c:	ea07ac23          	sw	zero,-328(a5) # 800088e0 <first.1>
    fsinit(ROOTDEV);
    80001a30:	4505                	li	a0,1
    80001a32:	00002097          	auipc	ra,0x2
    80001a36:	b50080e7          	jalr	-1200(ra) # 80003582 <fsinit>
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
    80001a4c:	1a890913          	addi	s2,s2,424 # 80010bf0 <pid_lock>
    80001a50:	854a                	mv	a0,s2
    80001a52:	fffff097          	auipc	ra,0xfffff
    80001a56:	184080e7          	jalr	388(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a5a:	00007797          	auipc	a5,0x7
    80001a5e:	e8a78793          	addi	a5,a5,-374 # 800088e4 <nextpid>
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
    80001be4:	44048493          	addi	s1,s1,1088 # 80011020 <proc>
    80001be8:	00015917          	auipc	s2,0x15
    80001bec:	03890913          	addi	s2,s2,56 # 80016c20 <tickslock>
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
    80001cba:	cca7b123          	sd	a0,-830(a5) # 80008978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001cbe:	03400613          	li	a2,52
    80001cc2:	00007597          	auipc	a1,0x7
    80001cc6:	c2e58593          	addi	a1,a1,-978 # 800088f0 <initcode>
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
    80001d04:	2ac080e7          	jalr	684(ra) # 80003fac <namei>
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
    80001e30:	00003097          	auipc	ra,0x3
    80001e34:	812080e7          	jalr	-2030(ra) # 80004642 <filedup>
    80001e38:	00a93023          	sd	a0,0(s2)
    80001e3c:	b7e5                	j	80001e24 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e3e:	158ab503          	ld	a0,344(s5)
    80001e42:	00002097          	auipc	ra,0x2
    80001e46:	980080e7          	jalr	-1664(ra) # 800037c2 <idup>
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
    80001e72:	d9a48493          	addi	s1,s1,-614 # 80010c08 <wait_lock>
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
    80001ec0:	711d                	addi	sp,sp,-96
    80001ec2:	ec86                	sd	ra,88(sp)
    80001ec4:	e8a2                	sd	s0,80(sp)
    80001ec6:	e4a6                	sd	s1,72(sp)
    80001ec8:	e0ca                	sd	s2,64(sp)
    80001eca:	fc4e                	sd	s3,56(sp)
    80001ecc:	f852                	sd	s4,48(sp)
    80001ece:	f456                	sd	s5,40(sp)
    80001ed0:	f05a                	sd	s6,32(sp)
    80001ed2:	ec5e                	sd	s7,24(sp)
    80001ed4:	e862                	sd	s8,16(sp)
    80001ed6:	e466                	sd	s9,8(sp)
    80001ed8:	e06a                	sd	s10,0(sp)
    80001eda:	1080                	addi	s0,sp,96
    80001edc:	8792                	mv	a5,tp
  int id = r_tp();
    80001ede:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ee0:	00779b93          	slli	s7,a5,0x7
    80001ee4:	0000f717          	auipc	a4,0xf
    80001ee8:	d0c70713          	addi	a4,a4,-756 # 80010bf0 <pid_lock>
    80001eec:	975e                	add	a4,a4,s7
    80001eee:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ef2:	0000f717          	auipc	a4,0xf
    80001ef6:	d3670713          	addi	a4,a4,-714 # 80010c28 <cpus+0x8>
    80001efa:	9bba                	add	s7,s7,a4
  uint64 ticks_track = 1000;
    80001efc:	3e800a13          	li	s4,1000
    if (ticks >= ticks_track)
    80001f00:	00007a97          	auipc	s5,0x7
    80001f04:	a80a8a93          	addi	s5,s5,-1408 # 80008980 <ticks>
      for (p_aux = proc ; p_aux < &proc[NPROC]; p_aux++)
    80001f08:	00015917          	auipc	s2,0x15
    80001f0c:	d1890913          	addi	s2,s2,-744 # 80016c20 <tickslock>
        c->proc = p;
    80001f10:	079e                	slli	a5,a5,0x7
    80001f12:	0000fb17          	auipc	s6,0xf
    80001f16:	cdeb0b13          	addi	s6,s6,-802 # 80010bf0 <pid_lock>
    80001f1a:	9b3e                	add	s6,s6,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f20:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f24:	10079073          	csrw	sstatus,a5
    acquire(&tickslock);
    80001f28:	00015517          	auipc	a0,0x15
    80001f2c:	cf850513          	addi	a0,a0,-776 # 80016c20 <tickslock>
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	ca6080e7          	jalr	-858(ra) # 80000bd6 <acquire>
    if (ticks >= ticks_track)
    80001f38:	000ae783          	lwu	a5,0(s5)
    80001f3c:	0547f763          	bgeu	a5,s4,80001f8a <scheduler+0xca>
    release(&tickslock);
    80001f40:	00015517          	auipc	a0,0x15
    80001f44:	ce050513          	addi	a0,a0,-800 # 80016c20 <tickslock>
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	d42080e7          	jalr	-702(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f50:	0000f497          	auipc	s1,0xf
    80001f54:	0d048493          	addi	s1,s1,208 # 80011020 <proc>
      if (p->state == RUNNABLE)
    80001f58:	498d                	li	s3,3
        p->state = RUNNING;
    80001f5a:	4c91                	li	s9,4
        acquire(&tickslock);
    80001f5c:	00015c17          	auipc	s8,0x15
    80001f60:	cc4c0c13          	addi	s8,s8,-828 # 80016c20 <tickslock>
      acquire(&p->lock);
    80001f64:	8d26                	mv	s10,s1
    80001f66:	8526                	mv	a0,s1
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	c6e080e7          	jalr	-914(ra) # 80000bd6 <acquire>
      if (p->state == RUNNABLE)
    80001f70:	4c9c                	lw	a5,24(s1)
    80001f72:	07378263          	beq	a5,s3,80001fd6 <scheduler+0x116>
      release(&p->lock);
    80001f76:	8526                	mv	a0,s1
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	d12080e7          	jalr	-750(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f80:	17048493          	addi	s1,s1,368
    80001f84:	f924fce3          	bgeu	s1,s2,80001f1c <scheduler+0x5c>
    80001f88:	bff1                	j	80001f64 <scheduler+0xa4>
      ticks_track += 1000;
    80001f8a:	3e8a0a13          	addi	s4,s4,1000
      for (p_aux = proc ; p_aux < &proc[NPROC]; p_aux++)
    80001f8e:	0000f497          	auipc	s1,0xf
    80001f92:	09248493          	addi	s1,s1,146 # 80011020 <proc>
          if (p_aux->state == RUNNABLE)
    80001f96:	498d                	li	s3,3
            p_aux->priority = NPRIO -1;
    80001f98:	4c89                	li	s9,2
            printf("priority boost \n");
    80001f9a:	00006c17          	auipc	s8,0x6
    80001f9e:	27ec0c13          	addi	s8,s8,638 # 80008218 <digits+0x1d8>
    80001fa2:	a811                	j	80001fb6 <scheduler+0xf6>
          release(&p_aux->lock);
    80001fa4:	8526                	mv	a0,s1
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	ce4080e7          	jalr	-796(ra) # 80000c8a <release>
      for (p_aux = proc ; p_aux < &proc[NPROC]; p_aux++)
    80001fae:	17048493          	addi	s1,s1,368
    80001fb2:	f92487e3          	beq	s1,s2,80001f40 <scheduler+0x80>
          acquire(&p_aux->lock);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	c1e080e7          	jalr	-994(ra) # 80000bd6 <acquire>
          if (p_aux->state == RUNNABLE)
    80001fc0:	4c9c                	lw	a5,24(s1)
    80001fc2:	ff3791e3          	bne	a5,s3,80001fa4 <scheduler+0xe4>
            p_aux->priority = NPRIO -1;
    80001fc6:	0394aa23          	sw	s9,52(s1)
            printf("priority boost \n");
    80001fca:	8562                	mv	a0,s8
    80001fcc:	ffffe097          	auipc	ra,0xffffe
    80001fd0:	5be080e7          	jalr	1470(ra) # 8000058a <printf>
    80001fd4:	bfc1                	j	80001fa4 <scheduler+0xe4>
        for (p_aux = proc; p_aux < &proc[NPROC]; p_aux++)
    80001fd6:	0000f797          	auipc	a5,0xf
    80001fda:	04a78793          	addi	a5,a5,74 # 80011020 <proc>
    80001fde:	a031                	j	80001fea <scheduler+0x12a>
    80001fe0:	84be                	mv	s1,a5
    80001fe2:	17078793          	addi	a5,a5,368
    80001fe6:	03278163          	beq	a5,s2,80002008 <scheduler+0x148>
          if(p_aux->state == RUNNABLE){
    80001fea:	4f98                	lw	a4,24(a5)
    80001fec:	ff371be3          	bne	a4,s3,80001fe2 <scheduler+0x122>
            if (first->priority < p_aux->priority){
    80001ff0:	58d4                	lw	a3,52(s1)
    80001ff2:	5bd8                	lw	a4,52(a5)
    80001ff4:	fee6c6e3          	blt	a3,a4,80001fe0 <scheduler+0x120>
            else if ((first->priority == p_aux->priority) && (first->times_executed > p_aux->times_executed))
    80001ff8:	fee695e3          	bne	a3,a4,80001fe2 <scheduler+0x122>
    80001ffc:	5c94                	lw	a3,56(s1)
    80001ffe:	5f98                	lw	a4,56(a5)
    80002000:	fed751e3          	bge	a4,a3,80001fe2 <scheduler+0x122>
    80002004:	84be                	mv	s1,a5
    80002006:	bff1                	j	80001fe2 <scheduler+0x122>
        release(&p->lock);
    80002008:	856a                	mv	a0,s10
    8000200a:	fffff097          	auipc	ra,0xfffff
    8000200e:	c80080e7          	jalr	-896(ra) # 80000c8a <release>
        acquire(&p->lock);
    80002012:	8526                	mv	a0,s1
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	bc2080e7          	jalr	-1086(ra) # 80000bd6 <acquire>
        p->state = RUNNING;
    8000201c:	0194ac23          	sw	s9,24(s1)
        c->proc = p;
    80002020:	029b3823          	sd	s1,48(s6)
        p->times_executed ++;
    80002024:	5c9c                	lw	a5,56(s1)
    80002026:	2785                	addiw	a5,a5,1
    80002028:	dc9c                	sw	a5,56(s1)
        acquire(&tickslock);
    8000202a:	8562                	mv	a0,s8
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	baa080e7          	jalr	-1110(ra) # 80000bd6 <acquire>
        p->last_executed = ticks;
    80002034:	000aa783          	lw	a5,0(s5)
    80002038:	dcdc                	sw	a5,60(s1)
        release(&tickslock);
    8000203a:	8562                	mv	a0,s8
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	c4e080e7          	jalr	-946(ra) # 80000c8a <release>
        swtch(&c->context, &p->context);
    80002044:	06848593          	addi	a1,s1,104
    80002048:	855e                	mv	a0,s7
    8000204a:	00000097          	auipc	ra,0x0
    8000204e:	714080e7          	jalr	1812(ra) # 8000275e <swtch>
        c->proc = 0;
    80002052:	020b3823          	sd	zero,48(s6)
    80002056:	b705                	j	80001f76 <scheduler+0xb6>

0000000080002058 <sched>:
{
    80002058:	7179                	addi	sp,sp,-48
    8000205a:	f406                	sd	ra,40(sp)
    8000205c:	f022                	sd	s0,32(sp)
    8000205e:	ec26                	sd	s1,24(sp)
    80002060:	e84a                	sd	s2,16(sp)
    80002062:	e44e                	sd	s3,8(sp)
    80002064:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	958080e7          	jalr	-1704(ra) # 800019be <myproc>
    8000206e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	aec080e7          	jalr	-1300(ra) # 80000b5c <holding>
    80002078:	c93d                	beqz	a0,800020ee <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000207a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000207c:	2781                	sext.w	a5,a5
    8000207e:	079e                	slli	a5,a5,0x7
    80002080:	0000f717          	auipc	a4,0xf
    80002084:	b7070713          	addi	a4,a4,-1168 # 80010bf0 <pid_lock>
    80002088:	97ba                	add	a5,a5,a4
    8000208a:	0a87a703          	lw	a4,168(a5)
    8000208e:	4785                	li	a5,1
    80002090:	06f71763          	bne	a4,a5,800020fe <sched+0xa6>
  if(p->state == RUNNING)
    80002094:	4c98                	lw	a4,24(s1)
    80002096:	4791                	li	a5,4
    80002098:	06f70b63          	beq	a4,a5,8000210e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000209c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020a0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020a2:	efb5                	bnez	a5,8000211e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020a4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020a6:	0000f917          	auipc	s2,0xf
    800020aa:	b4a90913          	addi	s2,s2,-1206 # 80010bf0 <pid_lock>
    800020ae:	2781                	sext.w	a5,a5
    800020b0:	079e                	slli	a5,a5,0x7
    800020b2:	97ca                	add	a5,a5,s2
    800020b4:	0ac7a983          	lw	s3,172(a5)
    800020b8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020ba:	2781                	sext.w	a5,a5
    800020bc:	079e                	slli	a5,a5,0x7
    800020be:	0000f597          	auipc	a1,0xf
    800020c2:	b6a58593          	addi	a1,a1,-1174 # 80010c28 <cpus+0x8>
    800020c6:	95be                	add	a1,a1,a5
    800020c8:	06848513          	addi	a0,s1,104
    800020cc:	00000097          	auipc	ra,0x0
    800020d0:	692080e7          	jalr	1682(ra) # 8000275e <swtch>
    800020d4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020d6:	2781                	sext.w	a5,a5
    800020d8:	079e                	slli	a5,a5,0x7
    800020da:	993e                	add	s2,s2,a5
    800020dc:	0b392623          	sw	s3,172(s2)
}
    800020e0:	70a2                	ld	ra,40(sp)
    800020e2:	7402                	ld	s0,32(sp)
    800020e4:	64e2                	ld	s1,24(sp)
    800020e6:	6942                	ld	s2,16(sp)
    800020e8:	69a2                	ld	s3,8(sp)
    800020ea:	6145                	addi	sp,sp,48
    800020ec:	8082                	ret
    panic("sched p->lock");
    800020ee:	00006517          	auipc	a0,0x6
    800020f2:	14250513          	addi	a0,a0,322 # 80008230 <digits+0x1f0>
    800020f6:	ffffe097          	auipc	ra,0xffffe
    800020fa:	44a080e7          	jalr	1098(ra) # 80000540 <panic>
    panic("sched locks");
    800020fe:	00006517          	auipc	a0,0x6
    80002102:	14250513          	addi	a0,a0,322 # 80008240 <digits+0x200>
    80002106:	ffffe097          	auipc	ra,0xffffe
    8000210a:	43a080e7          	jalr	1082(ra) # 80000540 <panic>
    panic("sched running");
    8000210e:	00006517          	auipc	a0,0x6
    80002112:	14250513          	addi	a0,a0,322 # 80008250 <digits+0x210>
    80002116:	ffffe097          	auipc	ra,0xffffe
    8000211a:	42a080e7          	jalr	1066(ra) # 80000540 <panic>
    panic("sched interruptible");
    8000211e:	00006517          	auipc	a0,0x6
    80002122:	14250513          	addi	a0,a0,322 # 80008260 <digits+0x220>
    80002126:	ffffe097          	auipc	ra,0xffffe
    8000212a:	41a080e7          	jalr	1050(ra) # 80000540 <panic>

000000008000212e <yield>:
{
    8000212e:	1101                	addi	sp,sp,-32
    80002130:	ec06                	sd	ra,24(sp)
    80002132:	e822                	sd	s0,16(sp)
    80002134:	e426                	sd	s1,8(sp)
    80002136:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002138:	00000097          	auipc	ra,0x0
    8000213c:	886080e7          	jalr	-1914(ra) # 800019be <myproc>
    80002140:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	a94080e7          	jalr	-1388(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    8000214a:	478d                	li	a5,3
    8000214c:	cc9c                	sw	a5,24(s1)
  if (p->priority != 0)
    8000214e:	58dc                	lw	a5,52(s1)
    80002150:	c399                	beqz	a5,80002156 <yield+0x28>
    p->priority --;
    80002152:	37fd                	addiw	a5,a5,-1
    80002154:	d8dc                	sw	a5,52(s1)
  sched();
    80002156:	00000097          	auipc	ra,0x0
    8000215a:	f02080e7          	jalr	-254(ra) # 80002058 <sched>
  release(&p->lock);
    8000215e:	8526                	mv	a0,s1
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	b2a080e7          	jalr	-1238(ra) # 80000c8a <release>
}
    80002168:	60e2                	ld	ra,24(sp)
    8000216a:	6442                	ld	s0,16(sp)
    8000216c:	64a2                	ld	s1,8(sp)
    8000216e:	6105                	addi	sp,sp,32
    80002170:	8082                	ret

0000000080002172 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002172:	7179                	addi	sp,sp,-48
    80002174:	f406                	sd	ra,40(sp)
    80002176:	f022                	sd	s0,32(sp)
    80002178:	ec26                	sd	s1,24(sp)
    8000217a:	e84a                	sd	s2,16(sp)
    8000217c:	e44e                	sd	s3,8(sp)
    8000217e:	1800                	addi	s0,sp,48
    80002180:	89aa                	mv	s3,a0
    80002182:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002184:	00000097          	auipc	ra,0x0
    80002188:	83a080e7          	jalr	-1990(ra) # 800019be <myproc>
    8000218c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	a48080e7          	jalr	-1464(ra) # 80000bd6 <acquire>
  release(lk);
    80002196:	854a                	mv	a0,s2
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	af2080e7          	jalr	-1294(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    800021a0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800021a4:	4789                	li	a5,2
    800021a6:	cc9c                	sw	a5,24(s1)

  //Aumentar prioridad
  if (p->priority < NPRIO - 1)
    800021a8:	58dc                	lw	a5,52(s1)
    800021aa:	4705                	li	a4,1
    800021ac:	02f75963          	bge	a4,a5,800021de <sleep+0x6c>
  {
    p->priority ++;
  }

  sched();
    800021b0:	00000097          	auipc	ra,0x0
    800021b4:	ea8080e7          	jalr	-344(ra) # 80002058 <sched>

  // Tidy up.
  p->chan = 0;
    800021b8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	acc080e7          	jalr	-1332(ra) # 80000c8a <release>
  acquire(lk);
    800021c6:	854a                	mv	a0,s2
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	a0e080e7          	jalr	-1522(ra) # 80000bd6 <acquire>
}
    800021d0:	70a2                	ld	ra,40(sp)
    800021d2:	7402                	ld	s0,32(sp)
    800021d4:	64e2                	ld	s1,24(sp)
    800021d6:	6942                	ld	s2,16(sp)
    800021d8:	69a2                	ld	s3,8(sp)
    800021da:	6145                	addi	sp,sp,48
    800021dc:	8082                	ret
    p->priority ++;
    800021de:	2785                	addiw	a5,a5,1
    800021e0:	d8dc                	sw	a5,52(s1)
    800021e2:	b7f9                	j	800021b0 <sleep+0x3e>

00000000800021e4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800021e4:	7139                	addi	sp,sp,-64
    800021e6:	fc06                	sd	ra,56(sp)
    800021e8:	f822                	sd	s0,48(sp)
    800021ea:	f426                	sd	s1,40(sp)
    800021ec:	f04a                	sd	s2,32(sp)
    800021ee:	ec4e                	sd	s3,24(sp)
    800021f0:	e852                	sd	s4,16(sp)
    800021f2:	e456                	sd	s5,8(sp)
    800021f4:	0080                	addi	s0,sp,64
    800021f6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800021f8:	0000f497          	auipc	s1,0xf
    800021fc:	e2848493          	addi	s1,s1,-472 # 80011020 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002200:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002202:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002204:	00015917          	auipc	s2,0x15
    80002208:	a1c90913          	addi	s2,s2,-1508 # 80016c20 <tickslock>
    8000220c:	a811                	j	80002220 <wakeup+0x3c>
      }
      release(&p->lock);
    8000220e:	8526                	mv	a0,s1
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	a7a080e7          	jalr	-1414(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002218:	17048493          	addi	s1,s1,368
    8000221c:	03248663          	beq	s1,s2,80002248 <wakeup+0x64>
    if(p != myproc()){
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	79e080e7          	jalr	1950(ra) # 800019be <myproc>
    80002228:	fea488e3          	beq	s1,a0,80002218 <wakeup+0x34>
      acquire(&p->lock);
    8000222c:	8526                	mv	a0,s1
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	9a8080e7          	jalr	-1624(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002236:	4c9c                	lw	a5,24(s1)
    80002238:	fd379be3          	bne	a5,s3,8000220e <wakeup+0x2a>
    8000223c:	709c                	ld	a5,32(s1)
    8000223e:	fd4798e3          	bne	a5,s4,8000220e <wakeup+0x2a>
        p->state = RUNNABLE;
    80002242:	0154ac23          	sw	s5,24(s1)
    80002246:	b7e1                	j	8000220e <wakeup+0x2a>
    }
  }
}
    80002248:	70e2                	ld	ra,56(sp)
    8000224a:	7442                	ld	s0,48(sp)
    8000224c:	74a2                	ld	s1,40(sp)
    8000224e:	7902                	ld	s2,32(sp)
    80002250:	69e2                	ld	s3,24(sp)
    80002252:	6a42                	ld	s4,16(sp)
    80002254:	6aa2                	ld	s5,8(sp)
    80002256:	6121                	addi	sp,sp,64
    80002258:	8082                	ret

000000008000225a <reparent>:
{
    8000225a:	7179                	addi	sp,sp,-48
    8000225c:	f406                	sd	ra,40(sp)
    8000225e:	f022                	sd	s0,32(sp)
    80002260:	ec26                	sd	s1,24(sp)
    80002262:	e84a                	sd	s2,16(sp)
    80002264:	e44e                	sd	s3,8(sp)
    80002266:	e052                	sd	s4,0(sp)
    80002268:	1800                	addi	s0,sp,48
    8000226a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000226c:	0000f497          	auipc	s1,0xf
    80002270:	db448493          	addi	s1,s1,-588 # 80011020 <proc>
      pp->parent = initproc;
    80002274:	00006a17          	auipc	s4,0x6
    80002278:	704a0a13          	addi	s4,s4,1796 # 80008978 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000227c:	00015997          	auipc	s3,0x15
    80002280:	9a498993          	addi	s3,s3,-1628 # 80016c20 <tickslock>
    80002284:	a029                	j	8000228e <reparent+0x34>
    80002286:	17048493          	addi	s1,s1,368
    8000228a:	01348d63          	beq	s1,s3,800022a4 <reparent+0x4a>
    if(pp->parent == p){
    8000228e:	60bc                	ld	a5,64(s1)
    80002290:	ff279be3          	bne	a5,s2,80002286 <reparent+0x2c>
      pp->parent = initproc;
    80002294:	000a3503          	ld	a0,0(s4)
    80002298:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	f4a080e7          	jalr	-182(ra) # 800021e4 <wakeup>
    800022a2:	b7d5                	j	80002286 <reparent+0x2c>
}
    800022a4:	70a2                	ld	ra,40(sp)
    800022a6:	7402                	ld	s0,32(sp)
    800022a8:	64e2                	ld	s1,24(sp)
    800022aa:	6942                	ld	s2,16(sp)
    800022ac:	69a2                	ld	s3,8(sp)
    800022ae:	6a02                	ld	s4,0(sp)
    800022b0:	6145                	addi	sp,sp,48
    800022b2:	8082                	ret

00000000800022b4 <exit>:
{
    800022b4:	7179                	addi	sp,sp,-48
    800022b6:	f406                	sd	ra,40(sp)
    800022b8:	f022                	sd	s0,32(sp)
    800022ba:	ec26                	sd	s1,24(sp)
    800022bc:	e84a                	sd	s2,16(sp)
    800022be:	e44e                	sd	s3,8(sp)
    800022c0:	e052                	sd	s4,0(sp)
    800022c2:	1800                	addi	s0,sp,48
    800022c4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	6f8080e7          	jalr	1784(ra) # 800019be <myproc>
    800022ce:	89aa                	mv	s3,a0
  if(p == initproc)
    800022d0:	00006797          	auipc	a5,0x6
    800022d4:	6a87b783          	ld	a5,1704(a5) # 80008978 <initproc>
    800022d8:	0d850493          	addi	s1,a0,216
    800022dc:	15850913          	addi	s2,a0,344
    800022e0:	02a79363          	bne	a5,a0,80002306 <exit+0x52>
    panic("init exiting");
    800022e4:	00006517          	auipc	a0,0x6
    800022e8:	f9450513          	addi	a0,a0,-108 # 80008278 <digits+0x238>
    800022ec:	ffffe097          	auipc	ra,0xffffe
    800022f0:	254080e7          	jalr	596(ra) # 80000540 <panic>
      fileclose(f);
    800022f4:	00002097          	auipc	ra,0x2
    800022f8:	3a0080e7          	jalr	928(ra) # 80004694 <fileclose>
      p->ofile[fd] = 0;
    800022fc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002300:	04a1                	addi	s1,s1,8
    80002302:	01248563          	beq	s1,s2,8000230c <exit+0x58>
    if(p->ofile[fd]){
    80002306:	6088                	ld	a0,0(s1)
    80002308:	f575                	bnez	a0,800022f4 <exit+0x40>
    8000230a:	bfdd                	j	80002300 <exit+0x4c>
  begin_op();
    8000230c:	00002097          	auipc	ra,0x2
    80002310:	ec0080e7          	jalr	-320(ra) # 800041cc <begin_op>
  iput(p->cwd);
    80002314:	1589b503          	ld	a0,344(s3)
    80002318:	00001097          	auipc	ra,0x1
    8000231c:	6a2080e7          	jalr	1698(ra) # 800039ba <iput>
  end_op();
    80002320:	00002097          	auipc	ra,0x2
    80002324:	f2a080e7          	jalr	-214(ra) # 8000424a <end_op>
  p->cwd = 0;
    80002328:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000232c:	0000f497          	auipc	s1,0xf
    80002330:	8dc48493          	addi	s1,s1,-1828 # 80010c08 <wait_lock>
    80002334:	8526                	mv	a0,s1
    80002336:	fffff097          	auipc	ra,0xfffff
    8000233a:	8a0080e7          	jalr	-1888(ra) # 80000bd6 <acquire>
  reparent(p);
    8000233e:	854e                	mv	a0,s3
    80002340:	00000097          	auipc	ra,0x0
    80002344:	f1a080e7          	jalr	-230(ra) # 8000225a <reparent>
  wakeup(p->parent);
    80002348:	0409b503          	ld	a0,64(s3)
    8000234c:	00000097          	auipc	ra,0x0
    80002350:	e98080e7          	jalr	-360(ra) # 800021e4 <wakeup>
  acquire(&p->lock);
    80002354:	854e                	mv	a0,s3
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	880080e7          	jalr	-1920(ra) # 80000bd6 <acquire>
  p->xstate = status;
    8000235e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002362:	4795                	li	a5,5
    80002364:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002368:	8526                	mv	a0,s1
    8000236a:	fffff097          	auipc	ra,0xfffff
    8000236e:	920080e7          	jalr	-1760(ra) # 80000c8a <release>
  sched();
    80002372:	00000097          	auipc	ra,0x0
    80002376:	ce6080e7          	jalr	-794(ra) # 80002058 <sched>
  panic("zombie exit");
    8000237a:	00006517          	auipc	a0,0x6
    8000237e:	f0e50513          	addi	a0,a0,-242 # 80008288 <digits+0x248>
    80002382:	ffffe097          	auipc	ra,0xffffe
    80002386:	1be080e7          	jalr	446(ra) # 80000540 <panic>

000000008000238a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000238a:	7179                	addi	sp,sp,-48
    8000238c:	f406                	sd	ra,40(sp)
    8000238e:	f022                	sd	s0,32(sp)
    80002390:	ec26                	sd	s1,24(sp)
    80002392:	e84a                	sd	s2,16(sp)
    80002394:	e44e                	sd	s3,8(sp)
    80002396:	1800                	addi	s0,sp,48
    80002398:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000239a:	0000f497          	auipc	s1,0xf
    8000239e:	c8648493          	addi	s1,s1,-890 # 80011020 <proc>
    800023a2:	00015997          	auipc	s3,0x15
    800023a6:	87e98993          	addi	s3,s3,-1922 # 80016c20 <tickslock>
    acquire(&p->lock);
    800023aa:	8526                	mv	a0,s1
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	82a080e7          	jalr	-2006(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    800023b4:	589c                	lw	a5,48(s1)
    800023b6:	01278d63          	beq	a5,s2,800023d0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023ba:	8526                	mv	a0,s1
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	8ce080e7          	jalr	-1842(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023c4:	17048493          	addi	s1,s1,368
    800023c8:	ff3491e3          	bne	s1,s3,800023aa <kill+0x20>
  }
  return -1;
    800023cc:	557d                	li	a0,-1
    800023ce:	a829                	j	800023e8 <kill+0x5e>
      p->killed = 1;
    800023d0:	4785                	li	a5,1
    800023d2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800023d4:	4c98                	lw	a4,24(s1)
    800023d6:	4789                	li	a5,2
    800023d8:	00f70f63          	beq	a4,a5,800023f6 <kill+0x6c>
      release(&p->lock);
    800023dc:	8526                	mv	a0,s1
    800023de:	fffff097          	auipc	ra,0xfffff
    800023e2:	8ac080e7          	jalr	-1876(ra) # 80000c8a <release>
      return 0;
    800023e6:	4501                	li	a0,0
}
    800023e8:	70a2                	ld	ra,40(sp)
    800023ea:	7402                	ld	s0,32(sp)
    800023ec:	64e2                	ld	s1,24(sp)
    800023ee:	6942                	ld	s2,16(sp)
    800023f0:	69a2                	ld	s3,8(sp)
    800023f2:	6145                	addi	sp,sp,48
    800023f4:	8082                	ret
        p->state = RUNNABLE;
    800023f6:	478d                	li	a5,3
    800023f8:	cc9c                	sw	a5,24(s1)
    800023fa:	b7cd                	j	800023dc <kill+0x52>

00000000800023fc <setkilled>:

void
setkilled(struct proc *p)
{
    800023fc:	1101                	addi	sp,sp,-32
    800023fe:	ec06                	sd	ra,24(sp)
    80002400:	e822                	sd	s0,16(sp)
    80002402:	e426                	sd	s1,8(sp)
    80002404:	1000                	addi	s0,sp,32
    80002406:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002408:	ffffe097          	auipc	ra,0xffffe
    8000240c:	7ce080e7          	jalr	1998(ra) # 80000bd6 <acquire>
  p->killed = 1;
    80002410:	4785                	li	a5,1
    80002412:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002414:	8526                	mv	a0,s1
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	874080e7          	jalr	-1932(ra) # 80000c8a <release>
}
    8000241e:	60e2                	ld	ra,24(sp)
    80002420:	6442                	ld	s0,16(sp)
    80002422:	64a2                	ld	s1,8(sp)
    80002424:	6105                	addi	sp,sp,32
    80002426:	8082                	ret

0000000080002428 <killed>:

int
killed(struct proc *p)
{
    80002428:	1101                	addi	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	e426                	sd	s1,8(sp)
    80002430:	e04a                	sd	s2,0(sp)
    80002432:	1000                	addi	s0,sp,32
    80002434:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002436:	ffffe097          	auipc	ra,0xffffe
    8000243a:	7a0080e7          	jalr	1952(ra) # 80000bd6 <acquire>
  k = p->killed;
    8000243e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002442:	8526                	mv	a0,s1
    80002444:	fffff097          	auipc	ra,0xfffff
    80002448:	846080e7          	jalr	-1978(ra) # 80000c8a <release>
  return k;
}
    8000244c:	854a                	mv	a0,s2
    8000244e:	60e2                	ld	ra,24(sp)
    80002450:	6442                	ld	s0,16(sp)
    80002452:	64a2                	ld	s1,8(sp)
    80002454:	6902                	ld	s2,0(sp)
    80002456:	6105                	addi	sp,sp,32
    80002458:	8082                	ret

000000008000245a <wait>:
{
    8000245a:	715d                	addi	sp,sp,-80
    8000245c:	e486                	sd	ra,72(sp)
    8000245e:	e0a2                	sd	s0,64(sp)
    80002460:	fc26                	sd	s1,56(sp)
    80002462:	f84a                	sd	s2,48(sp)
    80002464:	f44e                	sd	s3,40(sp)
    80002466:	f052                	sd	s4,32(sp)
    80002468:	ec56                	sd	s5,24(sp)
    8000246a:	e85a                	sd	s6,16(sp)
    8000246c:	e45e                	sd	s7,8(sp)
    8000246e:	e062                	sd	s8,0(sp)
    80002470:	0880                	addi	s0,sp,80
    80002472:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002474:	fffff097          	auipc	ra,0xfffff
    80002478:	54a080e7          	jalr	1354(ra) # 800019be <myproc>
    8000247c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000247e:	0000e517          	auipc	a0,0xe
    80002482:	78a50513          	addi	a0,a0,1930 # 80010c08 <wait_lock>
    80002486:	ffffe097          	auipc	ra,0xffffe
    8000248a:	750080e7          	jalr	1872(ra) # 80000bd6 <acquire>
    havekids = 0;
    8000248e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002490:	4a15                	li	s4,5
        havekids = 1;
    80002492:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002494:	00014997          	auipc	s3,0x14
    80002498:	78c98993          	addi	s3,s3,1932 # 80016c20 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000249c:	0000ec17          	auipc	s8,0xe
    800024a0:	76cc0c13          	addi	s8,s8,1900 # 80010c08 <wait_lock>
    havekids = 0;
    800024a4:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024a6:	0000f497          	auipc	s1,0xf
    800024aa:	b7a48493          	addi	s1,s1,-1158 # 80011020 <proc>
    800024ae:	a0bd                	j	8000251c <wait+0xc2>
          pid = pp->pid;
    800024b0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800024b4:	000b0e63          	beqz	s6,800024d0 <wait+0x76>
    800024b8:	4691                	li	a3,4
    800024ba:	02c48613          	addi	a2,s1,44
    800024be:	85da                	mv	a1,s6
    800024c0:	05893503          	ld	a0,88(s2)
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	1a8080e7          	jalr	424(ra) # 8000166c <copyout>
    800024cc:	02054563          	bltz	a0,800024f6 <wait+0x9c>
          freeproc(pp);
    800024d0:	8526                	mv	a0,s1
    800024d2:	fffff097          	auipc	ra,0xfffff
    800024d6:	69e080e7          	jalr	1694(ra) # 80001b70 <freeproc>
          release(&pp->lock);
    800024da:	8526                	mv	a0,s1
    800024dc:	ffffe097          	auipc	ra,0xffffe
    800024e0:	7ae080e7          	jalr	1966(ra) # 80000c8a <release>
          release(&wait_lock);
    800024e4:	0000e517          	auipc	a0,0xe
    800024e8:	72450513          	addi	a0,a0,1828 # 80010c08 <wait_lock>
    800024ec:	ffffe097          	auipc	ra,0xffffe
    800024f0:	79e080e7          	jalr	1950(ra) # 80000c8a <release>
          return pid;
    800024f4:	a0b5                	j	80002560 <wait+0x106>
            release(&pp->lock);
    800024f6:	8526                	mv	a0,s1
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	792080e7          	jalr	1938(ra) # 80000c8a <release>
            release(&wait_lock);
    80002500:	0000e517          	auipc	a0,0xe
    80002504:	70850513          	addi	a0,a0,1800 # 80010c08 <wait_lock>
    80002508:	ffffe097          	auipc	ra,0xffffe
    8000250c:	782080e7          	jalr	1922(ra) # 80000c8a <release>
            return -1;
    80002510:	59fd                	li	s3,-1
    80002512:	a0b9                	j	80002560 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002514:	17048493          	addi	s1,s1,368
    80002518:	03348463          	beq	s1,s3,80002540 <wait+0xe6>
      if(pp->parent == p){
    8000251c:	60bc                	ld	a5,64(s1)
    8000251e:	ff279be3          	bne	a5,s2,80002514 <wait+0xba>
        acquire(&pp->lock);
    80002522:	8526                	mv	a0,s1
    80002524:	ffffe097          	auipc	ra,0xffffe
    80002528:	6b2080e7          	jalr	1714(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    8000252c:	4c9c                	lw	a5,24(s1)
    8000252e:	f94781e3          	beq	a5,s4,800024b0 <wait+0x56>
        release(&pp->lock);
    80002532:	8526                	mv	a0,s1
    80002534:	ffffe097          	auipc	ra,0xffffe
    80002538:	756080e7          	jalr	1878(ra) # 80000c8a <release>
        havekids = 1;
    8000253c:	8756                	mv	a4,s5
    8000253e:	bfd9                	j	80002514 <wait+0xba>
    if(!havekids || killed(p)){
    80002540:	c719                	beqz	a4,8000254e <wait+0xf4>
    80002542:	854a                	mv	a0,s2
    80002544:	00000097          	auipc	ra,0x0
    80002548:	ee4080e7          	jalr	-284(ra) # 80002428 <killed>
    8000254c:	c51d                	beqz	a0,8000257a <wait+0x120>
      release(&wait_lock);
    8000254e:	0000e517          	auipc	a0,0xe
    80002552:	6ba50513          	addi	a0,a0,1722 # 80010c08 <wait_lock>
    80002556:	ffffe097          	auipc	ra,0xffffe
    8000255a:	734080e7          	jalr	1844(ra) # 80000c8a <release>
      return -1;
    8000255e:	59fd                	li	s3,-1
}
    80002560:	854e                	mv	a0,s3
    80002562:	60a6                	ld	ra,72(sp)
    80002564:	6406                	ld	s0,64(sp)
    80002566:	74e2                	ld	s1,56(sp)
    80002568:	7942                	ld	s2,48(sp)
    8000256a:	79a2                	ld	s3,40(sp)
    8000256c:	7a02                	ld	s4,32(sp)
    8000256e:	6ae2                	ld	s5,24(sp)
    80002570:	6b42                	ld	s6,16(sp)
    80002572:	6ba2                	ld	s7,8(sp)
    80002574:	6c02                	ld	s8,0(sp)
    80002576:	6161                	addi	sp,sp,80
    80002578:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000257a:	85e2                	mv	a1,s8
    8000257c:	854a                	mv	a0,s2
    8000257e:	00000097          	auipc	ra,0x0
    80002582:	bf4080e7          	jalr	-1036(ra) # 80002172 <sleep>
    havekids = 0;
    80002586:	bf39                	j	800024a4 <wait+0x4a>

0000000080002588 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002588:	7179                	addi	sp,sp,-48
    8000258a:	f406                	sd	ra,40(sp)
    8000258c:	f022                	sd	s0,32(sp)
    8000258e:	ec26                	sd	s1,24(sp)
    80002590:	e84a                	sd	s2,16(sp)
    80002592:	e44e                	sd	s3,8(sp)
    80002594:	e052                	sd	s4,0(sp)
    80002596:	1800                	addi	s0,sp,48
    80002598:	84aa                	mv	s1,a0
    8000259a:	892e                	mv	s2,a1
    8000259c:	89b2                	mv	s3,a2
    8000259e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025a0:	fffff097          	auipc	ra,0xfffff
    800025a4:	41e080e7          	jalr	1054(ra) # 800019be <myproc>
  if(user_dst){
    800025a8:	c08d                	beqz	s1,800025ca <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800025aa:	86d2                	mv	a3,s4
    800025ac:	864e                	mv	a2,s3
    800025ae:	85ca                	mv	a1,s2
    800025b0:	6d28                	ld	a0,88(a0)
    800025b2:	fffff097          	auipc	ra,0xfffff
    800025b6:	0ba080e7          	jalr	186(ra) # 8000166c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800025ba:	70a2                	ld	ra,40(sp)
    800025bc:	7402                	ld	s0,32(sp)
    800025be:	64e2                	ld	s1,24(sp)
    800025c0:	6942                	ld	s2,16(sp)
    800025c2:	69a2                	ld	s3,8(sp)
    800025c4:	6a02                	ld	s4,0(sp)
    800025c6:	6145                	addi	sp,sp,48
    800025c8:	8082                	ret
    memmove((char *)dst, src, len);
    800025ca:	000a061b          	sext.w	a2,s4
    800025ce:	85ce                	mv	a1,s3
    800025d0:	854a                	mv	a0,s2
    800025d2:	ffffe097          	auipc	ra,0xffffe
    800025d6:	75c080e7          	jalr	1884(ra) # 80000d2e <memmove>
    return 0;
    800025da:	8526                	mv	a0,s1
    800025dc:	bff9                	j	800025ba <either_copyout+0x32>

00000000800025de <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800025de:	7179                	addi	sp,sp,-48
    800025e0:	f406                	sd	ra,40(sp)
    800025e2:	f022                	sd	s0,32(sp)
    800025e4:	ec26                	sd	s1,24(sp)
    800025e6:	e84a                	sd	s2,16(sp)
    800025e8:	e44e                	sd	s3,8(sp)
    800025ea:	e052                	sd	s4,0(sp)
    800025ec:	1800                	addi	s0,sp,48
    800025ee:	892a                	mv	s2,a0
    800025f0:	84ae                	mv	s1,a1
    800025f2:	89b2                	mv	s3,a2
    800025f4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025f6:	fffff097          	auipc	ra,0xfffff
    800025fa:	3c8080e7          	jalr	968(ra) # 800019be <myproc>
  if(user_src){
    800025fe:	c08d                	beqz	s1,80002620 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002600:	86d2                	mv	a3,s4
    80002602:	864e                	mv	a2,s3
    80002604:	85ca                	mv	a1,s2
    80002606:	6d28                	ld	a0,88(a0)
    80002608:	fffff097          	auipc	ra,0xfffff
    8000260c:	0f0080e7          	jalr	240(ra) # 800016f8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002610:	70a2                	ld	ra,40(sp)
    80002612:	7402                	ld	s0,32(sp)
    80002614:	64e2                	ld	s1,24(sp)
    80002616:	6942                	ld	s2,16(sp)
    80002618:	69a2                	ld	s3,8(sp)
    8000261a:	6a02                	ld	s4,0(sp)
    8000261c:	6145                	addi	sp,sp,48
    8000261e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002620:	000a061b          	sext.w	a2,s4
    80002624:	85ce                	mv	a1,s3
    80002626:	854a                	mv	a0,s2
    80002628:	ffffe097          	auipc	ra,0xffffe
    8000262c:	706080e7          	jalr	1798(ra) # 80000d2e <memmove>
    return 0;
    80002630:	8526                	mv	a0,s1
    80002632:	bff9                	j	80002610 <either_copyin+0x32>

0000000080002634 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002634:	715d                	addi	sp,sp,-80
    80002636:	e486                	sd	ra,72(sp)
    80002638:	e0a2                	sd	s0,64(sp)
    8000263a:	fc26                	sd	s1,56(sp)
    8000263c:	f84a                	sd	s2,48(sp)
    8000263e:	f44e                	sd	s3,40(sp)
    80002640:	f052                	sd	s4,32(sp)
    80002642:	ec56                	sd	s5,24(sp)
    80002644:	e85a                	sd	s6,16(sp)
    80002646:	e45e                	sd	s7,8(sp)
    80002648:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000264a:	00006517          	auipc	a0,0x6
    8000264e:	a7e50513          	addi	a0,a0,-1410 # 800080c8 <digits+0x88>
    80002652:	ffffe097          	auipc	ra,0xffffe
    80002656:	f38080e7          	jalr	-200(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000265a:	0000f497          	auipc	s1,0xf
    8000265e:	b2648493          	addi	s1,s1,-1242 # 80011180 <proc+0x160>
    80002662:	00014917          	auipc	s2,0x14
    80002666:	71e90913          	addi	s2,s2,1822 # 80016d80 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000266a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000266c:	00006997          	auipc	s3,0x6
    80002670:	c2c98993          	addi	s3,s3,-980 # 80008298 <digits+0x258>
    printf("%d %s %s Priority : 0, Times executed : %d, Last time executed : %d", p->pid, state, p->name,p->times_executed,p->last_executed);
    80002674:	00006a97          	auipc	s5,0x6
    80002678:	c2ca8a93          	addi	s5,s5,-980 # 800082a0 <digits+0x260>
    printf("\n");
    8000267c:	00006a17          	auipc	s4,0x6
    80002680:	a4ca0a13          	addi	s4,s4,-1460 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002684:	00006b97          	auipc	s7,0x6
    80002688:	cd4b8b93          	addi	s7,s7,-812 # 80008358 <states.0>
    8000268c:	a02d                	j	800026b6 <procdump+0x82>
    printf("%d %s %s Priority : 0, Times executed : %d, Last time executed : %d", p->pid, state, p->name,p->times_executed,p->last_executed);
    8000268e:	edc6a783          	lw	a5,-292(a3)
    80002692:	ed86a703          	lw	a4,-296(a3)
    80002696:	ed06a583          	lw	a1,-304(a3)
    8000269a:	8556                	mv	a0,s5
    8000269c:	ffffe097          	auipc	ra,0xffffe
    800026a0:	eee080e7          	jalr	-274(ra) # 8000058a <printf>
    printf("\n");
    800026a4:	8552                	mv	a0,s4
    800026a6:	ffffe097          	auipc	ra,0xffffe
    800026aa:	ee4080e7          	jalr	-284(ra) # 8000058a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026ae:	17048493          	addi	s1,s1,368
    800026b2:	03248263          	beq	s1,s2,800026d6 <procdump+0xa2>
    if(p->state == UNUSED)
    800026b6:	86a6                	mv	a3,s1
    800026b8:	eb84a783          	lw	a5,-328(s1)
    800026bc:	dbed                	beqz	a5,800026ae <procdump+0x7a>
      state = "???";
    800026be:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026c0:	fcfb67e3          	bltu	s6,a5,8000268e <procdump+0x5a>
    800026c4:	02079713          	slli	a4,a5,0x20
    800026c8:	01d75793          	srli	a5,a4,0x1d
    800026cc:	97de                	add	a5,a5,s7
    800026ce:	6390                	ld	a2,0(a5)
    800026d0:	fe5d                	bnez	a2,8000268e <procdump+0x5a>
      state = "???";
    800026d2:	864e                	mv	a2,s3
    800026d4:	bf6d                	j	8000268e <procdump+0x5a>
  }
}
    800026d6:	60a6                	ld	ra,72(sp)
    800026d8:	6406                	ld	s0,64(sp)
    800026da:	74e2                	ld	s1,56(sp)
    800026dc:	7942                	ld	s2,48(sp)
    800026de:	79a2                	ld	s3,40(sp)
    800026e0:	7a02                	ld	s4,32(sp)
    800026e2:	6ae2                	ld	s5,24(sp)
    800026e4:	6b42                	ld	s6,16(sp)
    800026e6:	6ba2                	ld	s7,8(sp)
    800026e8:	6161                	addi	sp,sp,80
    800026ea:	8082                	ret

00000000800026ec <pstat>:

//Implementacion pstat 
int pstat(int pid) {
    800026ec:	7179                	addi	sp,sp,-48
    800026ee:	f406                	sd	ra,40(sp)
    800026f0:	f022                	sd	s0,32(sp)
    800026f2:	ec26                	sd	s1,24(sp)
    800026f4:	e84a                	sd	s2,16(sp)
    800026f6:	e44e                	sd	s3,8(sp)
    800026f8:	1800                	addi	s0,sp,48
    800026fa:	892a                	mv	s2,a0
    struct proc *p;
    for(p = proc; p < &proc[NPROC]; p++) {
    800026fc:	0000f497          	auipc	s1,0xf
    80002700:	92448493          	addi	s1,s1,-1756 # 80011020 <proc>
    80002704:	00014997          	auipc	s3,0x14
    80002708:	51c98993          	addi	s3,s3,1308 # 80016c20 <tickslock>
      acquire(&p->lock);
    8000270c:	8526                	mv	a0,s1
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	4c8080e7          	jalr	1224(ra) # 80000bd6 <acquire>
      if(p->pid == pid) {
    80002716:	589c                	lw	a5,48(s1)
    80002718:	01278c63          	beq	a5,s2,80002730 <pstat+0x44>
        printf("Priority : 0, Times executed : %d, Last time executed : %d", p->times_executed,p->last_executed);
        release(&p->lock);
        break;
      }
      release(&p->lock);
    8000271c:	8526                	mv	a0,s1
    8000271e:	ffffe097          	auipc	ra,0xffffe
    80002722:	56c080e7          	jalr	1388(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002726:	17048493          	addi	s1,s1,368
    8000272a:	ff3491e3          	bne	s1,s3,8000270c <pstat+0x20>
    8000272e:	a005                	j	8000274e <pstat+0x62>
        printf("Priority : 0, Times executed : %d, Last time executed : %d", p->times_executed,p->last_executed);
    80002730:	5cd0                	lw	a2,60(s1)
    80002732:	5c8c                	lw	a1,56(s1)
    80002734:	00006517          	auipc	a0,0x6
    80002738:	bb450513          	addi	a0,a0,-1100 # 800082e8 <digits+0x2a8>
    8000273c:	ffffe097          	auipc	ra,0xffffe
    80002740:	e4e080e7          	jalr	-434(ra) # 8000058a <printf>
        release(&p->lock);
    80002744:	8526                	mv	a0,s1
    80002746:	ffffe097          	auipc	ra,0xffffe
    8000274a:	544080e7          	jalr	1348(ra) # 80000c8a <release>
    }
    return 0;
}
    8000274e:	4501                	li	a0,0
    80002750:	70a2                	ld	ra,40(sp)
    80002752:	7402                	ld	s0,32(sp)
    80002754:	64e2                	ld	s1,24(sp)
    80002756:	6942                	ld	s2,16(sp)
    80002758:	69a2                	ld	s3,8(sp)
    8000275a:	6145                	addi	sp,sp,48
    8000275c:	8082                	ret

000000008000275e <swtch>:
    8000275e:	00153023          	sd	ra,0(a0)
    80002762:	00253423          	sd	sp,8(a0)
    80002766:	e900                	sd	s0,16(a0)
    80002768:	ed04                	sd	s1,24(a0)
    8000276a:	03253023          	sd	s2,32(a0)
    8000276e:	03353423          	sd	s3,40(a0)
    80002772:	03453823          	sd	s4,48(a0)
    80002776:	03553c23          	sd	s5,56(a0)
    8000277a:	05653023          	sd	s6,64(a0)
    8000277e:	05753423          	sd	s7,72(a0)
    80002782:	05853823          	sd	s8,80(a0)
    80002786:	05953c23          	sd	s9,88(a0)
    8000278a:	07a53023          	sd	s10,96(a0)
    8000278e:	07b53423          	sd	s11,104(a0)
    80002792:	0005b083          	ld	ra,0(a1)
    80002796:	0085b103          	ld	sp,8(a1)
    8000279a:	6980                	ld	s0,16(a1)
    8000279c:	6d84                	ld	s1,24(a1)
    8000279e:	0205b903          	ld	s2,32(a1)
    800027a2:	0285b983          	ld	s3,40(a1)
    800027a6:	0305ba03          	ld	s4,48(a1)
    800027aa:	0385ba83          	ld	s5,56(a1)
    800027ae:	0405bb03          	ld	s6,64(a1)
    800027b2:	0485bb83          	ld	s7,72(a1)
    800027b6:	0505bc03          	ld	s8,80(a1)
    800027ba:	0585bc83          	ld	s9,88(a1)
    800027be:	0605bd03          	ld	s10,96(a1)
    800027c2:	0685bd83          	ld	s11,104(a1)
    800027c6:	8082                	ret

00000000800027c8 <trapinit>:
    800027c8:	1141                	addi	sp,sp,-16
    800027ca:	e406                	sd	ra,8(sp)
    800027cc:	e022                	sd	s0,0(sp)
    800027ce:	0800                	addi	s0,sp,16
    800027d0:	00006597          	auipc	a1,0x6
    800027d4:	bb858593          	addi	a1,a1,-1096 # 80008388 <states.0+0x30>
    800027d8:	00014517          	auipc	a0,0x14
    800027dc:	44850513          	addi	a0,a0,1096 # 80016c20 <tickslock>
    800027e0:	ffffe097          	auipc	ra,0xffffe
    800027e4:	366080e7          	jalr	870(ra) # 80000b46 <initlock>
    800027e8:	60a2                	ld	ra,8(sp)
    800027ea:	6402                	ld	s0,0(sp)
    800027ec:	0141                	addi	sp,sp,16
    800027ee:	8082                	ret

00000000800027f0 <trapinithart>:
    800027f0:	1141                	addi	sp,sp,-16
    800027f2:	e422                	sd	s0,8(sp)
    800027f4:	0800                	addi	s0,sp,16
    800027f6:	00003797          	auipc	a5,0x3
    800027fa:	4ea78793          	addi	a5,a5,1258 # 80005ce0 <kernelvec>
    800027fe:	10579073          	csrw	stvec,a5
    80002802:	6422                	ld	s0,8(sp)
    80002804:	0141                	addi	sp,sp,16
    80002806:	8082                	ret

0000000080002808 <usertrapret>:
    80002808:	1141                	addi	sp,sp,-16
    8000280a:	e406                	sd	ra,8(sp)
    8000280c:	e022                	sd	s0,0(sp)
    8000280e:	0800                	addi	s0,sp,16
    80002810:	fffff097          	auipc	ra,0xfffff
    80002814:	1ae080e7          	jalr	430(ra) # 800019be <myproc>
    80002818:	100027f3          	csrr	a5,sstatus
    8000281c:	9bf5                	andi	a5,a5,-3
    8000281e:	10079073          	csrw	sstatus,a5
    80002822:	00004697          	auipc	a3,0x4
    80002826:	7de68693          	addi	a3,a3,2014 # 80007000 <_trampoline>
    8000282a:	00004717          	auipc	a4,0x4
    8000282e:	7d670713          	addi	a4,a4,2006 # 80007000 <_trampoline>
    80002832:	8f15                	sub	a4,a4,a3
    80002834:	040007b7          	lui	a5,0x4000
    80002838:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000283a:	07b2                	slli	a5,a5,0xc
    8000283c:	973e                	add	a4,a4,a5
    8000283e:	10571073          	csrw	stvec,a4
    80002842:	7138                	ld	a4,96(a0)
    80002844:	18002673          	csrr	a2,satp
    80002848:	e310                	sd	a2,0(a4)
    8000284a:	7130                	ld	a2,96(a0)
    8000284c:	6538                	ld	a4,72(a0)
    8000284e:	6585                	lui	a1,0x1
    80002850:	972e                	add	a4,a4,a1
    80002852:	e618                	sd	a4,8(a2)
    80002854:	7138                	ld	a4,96(a0)
    80002856:	00000617          	auipc	a2,0x0
    8000285a:	13060613          	addi	a2,a2,304 # 80002986 <usertrap>
    8000285e:	eb10                	sd	a2,16(a4)
    80002860:	7138                	ld	a4,96(a0)
    80002862:	8612                	mv	a2,tp
    80002864:	f310                	sd	a2,32(a4)
    80002866:	10002773          	csrr	a4,sstatus
    8000286a:	eff77713          	andi	a4,a4,-257
    8000286e:	02076713          	ori	a4,a4,32
    80002872:	10071073          	csrw	sstatus,a4
    80002876:	7138                	ld	a4,96(a0)
    80002878:	6f18                	ld	a4,24(a4)
    8000287a:	14171073          	csrw	sepc,a4
    8000287e:	6d28                	ld	a0,88(a0)
    80002880:	8131                	srli	a0,a0,0xc
    80002882:	00005717          	auipc	a4,0x5
    80002886:	81a70713          	addi	a4,a4,-2022 # 8000709c <userret>
    8000288a:	8f15                	sub	a4,a4,a3
    8000288c:	97ba                	add	a5,a5,a4
    8000288e:	577d                	li	a4,-1
    80002890:	177e                	slli	a4,a4,0x3f
    80002892:	8d59                	or	a0,a0,a4
    80002894:	9782                	jalr	a5
    80002896:	60a2                	ld	ra,8(sp)
    80002898:	6402                	ld	s0,0(sp)
    8000289a:	0141                	addi	sp,sp,16
    8000289c:	8082                	ret

000000008000289e <clockintr>:
    8000289e:	1101                	addi	sp,sp,-32
    800028a0:	ec06                	sd	ra,24(sp)
    800028a2:	e822                	sd	s0,16(sp)
    800028a4:	e426                	sd	s1,8(sp)
    800028a6:	1000                	addi	s0,sp,32
    800028a8:	00014497          	auipc	s1,0x14
    800028ac:	37848493          	addi	s1,s1,888 # 80016c20 <tickslock>
    800028b0:	8526                	mv	a0,s1
    800028b2:	ffffe097          	auipc	ra,0xffffe
    800028b6:	324080e7          	jalr	804(ra) # 80000bd6 <acquire>
    800028ba:	00006517          	auipc	a0,0x6
    800028be:	0c650513          	addi	a0,a0,198 # 80008980 <ticks>
    800028c2:	411c                	lw	a5,0(a0)
    800028c4:	2785                	addiw	a5,a5,1
    800028c6:	c11c                	sw	a5,0(a0)
    800028c8:	00000097          	auipc	ra,0x0
    800028cc:	91c080e7          	jalr	-1764(ra) # 800021e4 <wakeup>
    800028d0:	8526                	mv	a0,s1
    800028d2:	ffffe097          	auipc	ra,0xffffe
    800028d6:	3b8080e7          	jalr	952(ra) # 80000c8a <release>
    800028da:	60e2                	ld	ra,24(sp)
    800028dc:	6442                	ld	s0,16(sp)
    800028de:	64a2                	ld	s1,8(sp)
    800028e0:	6105                	addi	sp,sp,32
    800028e2:	8082                	ret

00000000800028e4 <devintr>:
    800028e4:	1101                	addi	sp,sp,-32
    800028e6:	ec06                	sd	ra,24(sp)
    800028e8:	e822                	sd	s0,16(sp)
    800028ea:	e426                	sd	s1,8(sp)
    800028ec:	1000                	addi	s0,sp,32
    800028ee:	14202773          	csrr	a4,scause
    800028f2:	00074d63          	bltz	a4,8000290c <devintr+0x28>
    800028f6:	57fd                	li	a5,-1
    800028f8:	17fe                	slli	a5,a5,0x3f
    800028fa:	0785                	addi	a5,a5,1
    800028fc:	4501                	li	a0,0
    800028fe:	06f70363          	beq	a4,a5,80002964 <devintr+0x80>
    80002902:	60e2                	ld	ra,24(sp)
    80002904:	6442                	ld	s0,16(sp)
    80002906:	64a2                	ld	s1,8(sp)
    80002908:	6105                	addi	sp,sp,32
    8000290a:	8082                	ret
    8000290c:	0ff77793          	zext.b	a5,a4
    80002910:	46a5                	li	a3,9
    80002912:	fed792e3          	bne	a5,a3,800028f6 <devintr+0x12>
    80002916:	00003097          	auipc	ra,0x3
    8000291a:	4d2080e7          	jalr	1234(ra) # 80005de8 <plic_claim>
    8000291e:	84aa                	mv	s1,a0
    80002920:	47a9                	li	a5,10
    80002922:	02f50763          	beq	a0,a5,80002950 <devintr+0x6c>
    80002926:	4785                	li	a5,1
    80002928:	02f50963          	beq	a0,a5,8000295a <devintr+0x76>
    8000292c:	4505                	li	a0,1
    8000292e:	d8f1                	beqz	s1,80002902 <devintr+0x1e>
    80002930:	85a6                	mv	a1,s1
    80002932:	00006517          	auipc	a0,0x6
    80002936:	a5e50513          	addi	a0,a0,-1442 # 80008390 <states.0+0x38>
    8000293a:	ffffe097          	auipc	ra,0xffffe
    8000293e:	c50080e7          	jalr	-944(ra) # 8000058a <printf>
    80002942:	8526                	mv	a0,s1
    80002944:	00003097          	auipc	ra,0x3
    80002948:	4c8080e7          	jalr	1224(ra) # 80005e0c <plic_complete>
    8000294c:	4505                	li	a0,1
    8000294e:	bf55                	j	80002902 <devintr+0x1e>
    80002950:	ffffe097          	auipc	ra,0xffffe
    80002954:	048080e7          	jalr	72(ra) # 80000998 <uartintr>
    80002958:	b7ed                	j	80002942 <devintr+0x5e>
    8000295a:	00004097          	auipc	ra,0x4
    8000295e:	97a080e7          	jalr	-1670(ra) # 800062d4 <virtio_disk_intr>
    80002962:	b7c5                	j	80002942 <devintr+0x5e>
    80002964:	fffff097          	auipc	ra,0xfffff
    80002968:	02e080e7          	jalr	46(ra) # 80001992 <cpuid>
    8000296c:	c901                	beqz	a0,8000297c <devintr+0x98>
    8000296e:	144027f3          	csrr	a5,sip
    80002972:	9bf5                	andi	a5,a5,-3
    80002974:	14479073          	csrw	sip,a5
    80002978:	4509                	li	a0,2
    8000297a:	b761                	j	80002902 <devintr+0x1e>
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	f22080e7          	jalr	-222(ra) # 8000289e <clockintr>
    80002984:	b7ed                	j	8000296e <devintr+0x8a>

0000000080002986 <usertrap>:
    80002986:	1101                	addi	sp,sp,-32
    80002988:	ec06                	sd	ra,24(sp)
    8000298a:	e822                	sd	s0,16(sp)
    8000298c:	e426                	sd	s1,8(sp)
    8000298e:	e04a                	sd	s2,0(sp)
    80002990:	1000                	addi	s0,sp,32
    80002992:	100027f3          	csrr	a5,sstatus
    80002996:	1007f793          	andi	a5,a5,256
    8000299a:	e3b1                	bnez	a5,800029de <usertrap+0x58>
    8000299c:	00003797          	auipc	a5,0x3
    800029a0:	34478793          	addi	a5,a5,836 # 80005ce0 <kernelvec>
    800029a4:	10579073          	csrw	stvec,a5
    800029a8:	fffff097          	auipc	ra,0xfffff
    800029ac:	016080e7          	jalr	22(ra) # 800019be <myproc>
    800029b0:	84aa                	mv	s1,a0
    800029b2:	713c                	ld	a5,96(a0)
    800029b4:	14102773          	csrr	a4,sepc
    800029b8:	ef98                	sd	a4,24(a5)
    800029ba:	14202773          	csrr	a4,scause
    800029be:	47a1                	li	a5,8
    800029c0:	02f70763          	beq	a4,a5,800029ee <usertrap+0x68>
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	f20080e7          	jalr	-224(ra) # 800028e4 <devintr>
    800029cc:	892a                	mv	s2,a0
    800029ce:	c151                	beqz	a0,80002a52 <usertrap+0xcc>
    800029d0:	8526                	mv	a0,s1
    800029d2:	00000097          	auipc	ra,0x0
    800029d6:	a56080e7          	jalr	-1450(ra) # 80002428 <killed>
    800029da:	c929                	beqz	a0,80002a2c <usertrap+0xa6>
    800029dc:	a099                	j	80002a22 <usertrap+0x9c>
    800029de:	00006517          	auipc	a0,0x6
    800029e2:	9d250513          	addi	a0,a0,-1582 # 800083b0 <states.0+0x58>
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	b5a080e7          	jalr	-1190(ra) # 80000540 <panic>
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	a3a080e7          	jalr	-1478(ra) # 80002428 <killed>
    800029f6:	e921                	bnez	a0,80002a46 <usertrap+0xc0>
    800029f8:	70b8                	ld	a4,96(s1)
    800029fa:	6f1c                	ld	a5,24(a4)
    800029fc:	0791                	addi	a5,a5,4
    800029fe:	ef1c                	sd	a5,24(a4)
    80002a00:	100027f3          	csrr	a5,sstatus
    80002a04:	0027e793          	ori	a5,a5,2
    80002a08:	10079073          	csrw	sstatus,a5
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	2d4080e7          	jalr	724(ra) # 80002ce0 <syscall>
    80002a14:	8526                	mv	a0,s1
    80002a16:	00000097          	auipc	ra,0x0
    80002a1a:	a12080e7          	jalr	-1518(ra) # 80002428 <killed>
    80002a1e:	c911                	beqz	a0,80002a32 <usertrap+0xac>
    80002a20:	4901                	li	s2,0
    80002a22:	557d                	li	a0,-1
    80002a24:	00000097          	auipc	ra,0x0
    80002a28:	890080e7          	jalr	-1904(ra) # 800022b4 <exit>
    80002a2c:	4789                	li	a5,2
    80002a2e:	04f90f63          	beq	s2,a5,80002a8c <usertrap+0x106>
    80002a32:	00000097          	auipc	ra,0x0
    80002a36:	dd6080e7          	jalr	-554(ra) # 80002808 <usertrapret>
    80002a3a:	60e2                	ld	ra,24(sp)
    80002a3c:	6442                	ld	s0,16(sp)
    80002a3e:	64a2                	ld	s1,8(sp)
    80002a40:	6902                	ld	s2,0(sp)
    80002a42:	6105                	addi	sp,sp,32
    80002a44:	8082                	ret
    80002a46:	557d                	li	a0,-1
    80002a48:	00000097          	auipc	ra,0x0
    80002a4c:	86c080e7          	jalr	-1940(ra) # 800022b4 <exit>
    80002a50:	b765                	j	800029f8 <usertrap+0x72>
    80002a52:	142025f3          	csrr	a1,scause
    80002a56:	5890                	lw	a2,48(s1)
    80002a58:	00006517          	auipc	a0,0x6
    80002a5c:	97850513          	addi	a0,a0,-1672 # 800083d0 <states.0+0x78>
    80002a60:	ffffe097          	auipc	ra,0xffffe
    80002a64:	b2a080e7          	jalr	-1238(ra) # 8000058a <printf>
    80002a68:	141025f3          	csrr	a1,sepc
    80002a6c:	14302673          	csrr	a2,stval
    80002a70:	00006517          	auipc	a0,0x6
    80002a74:	99050513          	addi	a0,a0,-1648 # 80008400 <states.0+0xa8>
    80002a78:	ffffe097          	auipc	ra,0xffffe
    80002a7c:	b12080e7          	jalr	-1262(ra) # 8000058a <printf>
    80002a80:	8526                	mv	a0,s1
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	97a080e7          	jalr	-1670(ra) # 800023fc <setkilled>
    80002a8a:	b769                	j	80002a14 <usertrap+0x8e>
    80002a8c:	fffff097          	auipc	ra,0xfffff
    80002a90:	6a2080e7          	jalr	1698(ra) # 8000212e <yield>
    80002a94:	bf79                	j	80002a32 <usertrap+0xac>

0000000080002a96 <kerneltrap>:
    80002a96:	7179                	addi	sp,sp,-48
    80002a98:	f406                	sd	ra,40(sp)
    80002a9a:	f022                	sd	s0,32(sp)
    80002a9c:	ec26                	sd	s1,24(sp)
    80002a9e:	e84a                	sd	s2,16(sp)
    80002aa0:	e44e                	sd	s3,8(sp)
    80002aa2:	1800                	addi	s0,sp,48
    80002aa4:	14102973          	csrr	s2,sepc
    80002aa8:	100024f3          	csrr	s1,sstatus
    80002aac:	142029f3          	csrr	s3,scause
    80002ab0:	1004f793          	andi	a5,s1,256
    80002ab4:	cb85                	beqz	a5,80002ae4 <kerneltrap+0x4e>
    80002ab6:	100027f3          	csrr	a5,sstatus
    80002aba:	8b89                	andi	a5,a5,2
    80002abc:	ef85                	bnez	a5,80002af4 <kerneltrap+0x5e>
    80002abe:	00000097          	auipc	ra,0x0
    80002ac2:	e26080e7          	jalr	-474(ra) # 800028e4 <devintr>
    80002ac6:	cd1d                	beqz	a0,80002b04 <kerneltrap+0x6e>
    80002ac8:	4789                	li	a5,2
    80002aca:	06f50a63          	beq	a0,a5,80002b3e <kerneltrap+0xa8>
    80002ace:	14191073          	csrw	sepc,s2
    80002ad2:	10049073          	csrw	sstatus,s1
    80002ad6:	70a2                	ld	ra,40(sp)
    80002ad8:	7402                	ld	s0,32(sp)
    80002ada:	64e2                	ld	s1,24(sp)
    80002adc:	6942                	ld	s2,16(sp)
    80002ade:	69a2                	ld	s3,8(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	93c50513          	addi	a0,a0,-1732 # 80008420 <states.0+0xc8>
    80002aec:	ffffe097          	auipc	ra,0xffffe
    80002af0:	a54080e7          	jalr	-1452(ra) # 80000540 <panic>
    80002af4:	00006517          	auipc	a0,0x6
    80002af8:	95450513          	addi	a0,a0,-1708 # 80008448 <states.0+0xf0>
    80002afc:	ffffe097          	auipc	ra,0xffffe
    80002b00:	a44080e7          	jalr	-1468(ra) # 80000540 <panic>
    80002b04:	85ce                	mv	a1,s3
    80002b06:	00006517          	auipc	a0,0x6
    80002b0a:	96250513          	addi	a0,a0,-1694 # 80008468 <states.0+0x110>
    80002b0e:	ffffe097          	auipc	ra,0xffffe
    80002b12:	a7c080e7          	jalr	-1412(ra) # 8000058a <printf>
    80002b16:	141025f3          	csrr	a1,sepc
    80002b1a:	14302673          	csrr	a2,stval
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	95a50513          	addi	a0,a0,-1702 # 80008478 <states.0+0x120>
    80002b26:	ffffe097          	auipc	ra,0xffffe
    80002b2a:	a64080e7          	jalr	-1436(ra) # 8000058a <printf>
    80002b2e:	00006517          	auipc	a0,0x6
    80002b32:	96250513          	addi	a0,a0,-1694 # 80008490 <states.0+0x138>
    80002b36:	ffffe097          	auipc	ra,0xffffe
    80002b3a:	a0a080e7          	jalr	-1526(ra) # 80000540 <panic>
    80002b3e:	fffff097          	auipc	ra,0xfffff
    80002b42:	e80080e7          	jalr	-384(ra) # 800019be <myproc>
    80002b46:	d541                	beqz	a0,80002ace <kerneltrap+0x38>
    80002b48:	fffff097          	auipc	ra,0xfffff
    80002b4c:	e76080e7          	jalr	-394(ra) # 800019be <myproc>
    80002b50:	4d18                	lw	a4,24(a0)
    80002b52:	4791                	li	a5,4
    80002b54:	f6f71de3          	bne	a4,a5,80002ace <kerneltrap+0x38>
    80002b58:	fffff097          	auipc	ra,0xfffff
    80002b5c:	5d6080e7          	jalr	1494(ra) # 8000212e <yield>
    80002b60:	b7bd                	j	80002ace <kerneltrap+0x38>

0000000080002b62 <argraw>:
    80002b62:	1101                	addi	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	e426                	sd	s1,8(sp)
    80002b6a:	1000                	addi	s0,sp,32
    80002b6c:	84aa                	mv	s1,a0
    80002b6e:	fffff097          	auipc	ra,0xfffff
    80002b72:	e50080e7          	jalr	-432(ra) # 800019be <myproc>
    80002b76:	4795                	li	a5,5
    80002b78:	0497e163          	bltu	a5,s1,80002bba <argraw+0x58>
    80002b7c:	048a                	slli	s1,s1,0x2
    80002b7e:	00006717          	auipc	a4,0x6
    80002b82:	94a70713          	addi	a4,a4,-1718 # 800084c8 <states.0+0x170>
    80002b86:	94ba                	add	s1,s1,a4
    80002b88:	409c                	lw	a5,0(s1)
    80002b8a:	97ba                	add	a5,a5,a4
    80002b8c:	8782                	jr	a5
    80002b8e:	713c                	ld	a5,96(a0)
    80002b90:	7ba8                	ld	a0,112(a5)
    80002b92:	60e2                	ld	ra,24(sp)
    80002b94:	6442                	ld	s0,16(sp)
    80002b96:	64a2                	ld	s1,8(sp)
    80002b98:	6105                	addi	sp,sp,32
    80002b9a:	8082                	ret
    80002b9c:	713c                	ld	a5,96(a0)
    80002b9e:	7fa8                	ld	a0,120(a5)
    80002ba0:	bfcd                	j	80002b92 <argraw+0x30>
    80002ba2:	713c                	ld	a5,96(a0)
    80002ba4:	63c8                	ld	a0,128(a5)
    80002ba6:	b7f5                	j	80002b92 <argraw+0x30>
    80002ba8:	713c                	ld	a5,96(a0)
    80002baa:	67c8                	ld	a0,136(a5)
    80002bac:	b7dd                	j	80002b92 <argraw+0x30>
    80002bae:	713c                	ld	a5,96(a0)
    80002bb0:	6bc8                	ld	a0,144(a5)
    80002bb2:	b7c5                	j	80002b92 <argraw+0x30>
    80002bb4:	713c                	ld	a5,96(a0)
    80002bb6:	6fc8                	ld	a0,152(a5)
    80002bb8:	bfe9                	j	80002b92 <argraw+0x30>
    80002bba:	00006517          	auipc	a0,0x6
    80002bbe:	8e650513          	addi	a0,a0,-1818 # 800084a0 <states.0+0x148>
    80002bc2:	ffffe097          	auipc	ra,0xffffe
    80002bc6:	97e080e7          	jalr	-1666(ra) # 80000540 <panic>

0000000080002bca <fetchaddr>:
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	e426                	sd	s1,8(sp)
    80002bd2:	e04a                	sd	s2,0(sp)
    80002bd4:	1000                	addi	s0,sp,32
    80002bd6:	84aa                	mv	s1,a0
    80002bd8:	892e                	mv	s2,a1
    80002bda:	fffff097          	auipc	ra,0xfffff
    80002bde:	de4080e7          	jalr	-540(ra) # 800019be <myproc>
    80002be2:	693c                	ld	a5,80(a0)
    80002be4:	02f4f863          	bgeu	s1,a5,80002c14 <fetchaddr+0x4a>
    80002be8:	00848713          	addi	a4,s1,8
    80002bec:	02e7e663          	bltu	a5,a4,80002c18 <fetchaddr+0x4e>
    80002bf0:	46a1                	li	a3,8
    80002bf2:	8626                	mv	a2,s1
    80002bf4:	85ca                	mv	a1,s2
    80002bf6:	6d28                	ld	a0,88(a0)
    80002bf8:	fffff097          	auipc	ra,0xfffff
    80002bfc:	b00080e7          	jalr	-1280(ra) # 800016f8 <copyin>
    80002c00:	00a03533          	snez	a0,a0
    80002c04:	40a00533          	neg	a0,a0
    80002c08:	60e2                	ld	ra,24(sp)
    80002c0a:	6442                	ld	s0,16(sp)
    80002c0c:	64a2                	ld	s1,8(sp)
    80002c0e:	6902                	ld	s2,0(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret
    80002c14:	557d                	li	a0,-1
    80002c16:	bfcd                	j	80002c08 <fetchaddr+0x3e>
    80002c18:	557d                	li	a0,-1
    80002c1a:	b7fd                	j	80002c08 <fetchaddr+0x3e>

0000000080002c1c <fetchstr>:
    80002c1c:	7179                	addi	sp,sp,-48
    80002c1e:	f406                	sd	ra,40(sp)
    80002c20:	f022                	sd	s0,32(sp)
    80002c22:	ec26                	sd	s1,24(sp)
    80002c24:	e84a                	sd	s2,16(sp)
    80002c26:	e44e                	sd	s3,8(sp)
    80002c28:	1800                	addi	s0,sp,48
    80002c2a:	892a                	mv	s2,a0
    80002c2c:	84ae                	mv	s1,a1
    80002c2e:	89b2                	mv	s3,a2
    80002c30:	fffff097          	auipc	ra,0xfffff
    80002c34:	d8e080e7          	jalr	-626(ra) # 800019be <myproc>
    80002c38:	86ce                	mv	a3,s3
    80002c3a:	864a                	mv	a2,s2
    80002c3c:	85a6                	mv	a1,s1
    80002c3e:	6d28                	ld	a0,88(a0)
    80002c40:	fffff097          	auipc	ra,0xfffff
    80002c44:	b46080e7          	jalr	-1210(ra) # 80001786 <copyinstr>
    80002c48:	00054e63          	bltz	a0,80002c64 <fetchstr+0x48>
    80002c4c:	8526                	mv	a0,s1
    80002c4e:	ffffe097          	auipc	ra,0xffffe
    80002c52:	200080e7          	jalr	512(ra) # 80000e4e <strlen>
    80002c56:	70a2                	ld	ra,40(sp)
    80002c58:	7402                	ld	s0,32(sp)
    80002c5a:	64e2                	ld	s1,24(sp)
    80002c5c:	6942                	ld	s2,16(sp)
    80002c5e:	69a2                	ld	s3,8(sp)
    80002c60:	6145                	addi	sp,sp,48
    80002c62:	8082                	ret
    80002c64:	557d                	li	a0,-1
    80002c66:	bfc5                	j	80002c56 <fetchstr+0x3a>

0000000080002c68 <argint>:
    80002c68:	1101                	addi	sp,sp,-32
    80002c6a:	ec06                	sd	ra,24(sp)
    80002c6c:	e822                	sd	s0,16(sp)
    80002c6e:	e426                	sd	s1,8(sp)
    80002c70:	1000                	addi	s0,sp,32
    80002c72:	84ae                	mv	s1,a1
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	eee080e7          	jalr	-274(ra) # 80002b62 <argraw>
    80002c7c:	c088                	sw	a0,0(s1)
    80002c7e:	60e2                	ld	ra,24(sp)
    80002c80:	6442                	ld	s0,16(sp)
    80002c82:	64a2                	ld	s1,8(sp)
    80002c84:	6105                	addi	sp,sp,32
    80002c86:	8082                	ret

0000000080002c88 <argaddr>:
    80002c88:	1101                	addi	sp,sp,-32
    80002c8a:	ec06                	sd	ra,24(sp)
    80002c8c:	e822                	sd	s0,16(sp)
    80002c8e:	e426                	sd	s1,8(sp)
    80002c90:	1000                	addi	s0,sp,32
    80002c92:	84ae                	mv	s1,a1
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	ece080e7          	jalr	-306(ra) # 80002b62 <argraw>
    80002c9c:	e088                	sd	a0,0(s1)
    80002c9e:	60e2                	ld	ra,24(sp)
    80002ca0:	6442                	ld	s0,16(sp)
    80002ca2:	64a2                	ld	s1,8(sp)
    80002ca4:	6105                	addi	sp,sp,32
    80002ca6:	8082                	ret

0000000080002ca8 <argstr>:
    80002ca8:	7179                	addi	sp,sp,-48
    80002caa:	f406                	sd	ra,40(sp)
    80002cac:	f022                	sd	s0,32(sp)
    80002cae:	ec26                	sd	s1,24(sp)
    80002cb0:	e84a                	sd	s2,16(sp)
    80002cb2:	1800                	addi	s0,sp,48
    80002cb4:	84ae                	mv	s1,a1
    80002cb6:	8932                	mv	s2,a2
    80002cb8:	fd840593          	addi	a1,s0,-40
    80002cbc:	00000097          	auipc	ra,0x0
    80002cc0:	fcc080e7          	jalr	-52(ra) # 80002c88 <argaddr>
    80002cc4:	864a                	mv	a2,s2
    80002cc6:	85a6                	mv	a1,s1
    80002cc8:	fd843503          	ld	a0,-40(s0)
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	f50080e7          	jalr	-176(ra) # 80002c1c <fetchstr>
    80002cd4:	70a2                	ld	ra,40(sp)
    80002cd6:	7402                	ld	s0,32(sp)
    80002cd8:	64e2                	ld	s1,24(sp)
    80002cda:	6942                	ld	s2,16(sp)
    80002cdc:	6145                	addi	sp,sp,48
    80002cde:	8082                	ret

0000000080002ce0 <syscall>:
    80002ce0:	1101                	addi	sp,sp,-32
    80002ce2:	ec06                	sd	ra,24(sp)
    80002ce4:	e822                	sd	s0,16(sp)
    80002ce6:	e426                	sd	s1,8(sp)
    80002ce8:	e04a                	sd	s2,0(sp)
    80002cea:	1000                	addi	s0,sp,32
    80002cec:	fffff097          	auipc	ra,0xfffff
    80002cf0:	cd2080e7          	jalr	-814(ra) # 800019be <myproc>
    80002cf4:	84aa                	mv	s1,a0
    80002cf6:	06053903          	ld	s2,96(a0)
    80002cfa:	0a893783          	ld	a5,168(s2)
    80002cfe:	0007869b          	sext.w	a3,a5
    80002d02:	37fd                	addiw	a5,a5,-1
    80002d04:	4755                	li	a4,21
    80002d06:	00f76f63          	bltu	a4,a5,80002d24 <syscall+0x44>
    80002d0a:	00369713          	slli	a4,a3,0x3
    80002d0e:	00005797          	auipc	a5,0x5
    80002d12:	7d278793          	addi	a5,a5,2002 # 800084e0 <syscalls>
    80002d16:	97ba                	add	a5,a5,a4
    80002d18:	639c                	ld	a5,0(a5)
    80002d1a:	c789                	beqz	a5,80002d24 <syscall+0x44>
    80002d1c:	9782                	jalr	a5
    80002d1e:	06a93823          	sd	a0,112(s2)
    80002d22:	a839                	j	80002d40 <syscall+0x60>
    80002d24:	16048613          	addi	a2,s1,352
    80002d28:	588c                	lw	a1,48(s1)
    80002d2a:	00005517          	auipc	a0,0x5
    80002d2e:	77e50513          	addi	a0,a0,1918 # 800084a8 <states.0+0x150>
    80002d32:	ffffe097          	auipc	ra,0xffffe
    80002d36:	858080e7          	jalr	-1960(ra) # 8000058a <printf>
    80002d3a:	70bc                	ld	a5,96(s1)
    80002d3c:	577d                	li	a4,-1
    80002d3e:	fbb8                	sd	a4,112(a5)
    80002d40:	60e2                	ld	ra,24(sp)
    80002d42:	6442                	ld	s0,16(sp)
    80002d44:	64a2                	ld	s1,8(sp)
    80002d46:	6902                	ld	s2,0(sp)
    80002d48:	6105                	addi	sp,sp,32
    80002d4a:	8082                	ret

0000000080002d4c <sys_exit>:
    80002d4c:	1101                	addi	sp,sp,-32
    80002d4e:	ec06                	sd	ra,24(sp)
    80002d50:	e822                	sd	s0,16(sp)
    80002d52:	1000                	addi	s0,sp,32
    80002d54:	fec40593          	addi	a1,s0,-20
    80002d58:	4501                	li	a0,0
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	f0e080e7          	jalr	-242(ra) # 80002c68 <argint>
    80002d62:	fec42503          	lw	a0,-20(s0)
    80002d66:	fffff097          	auipc	ra,0xfffff
    80002d6a:	54e080e7          	jalr	1358(ra) # 800022b4 <exit>
    80002d6e:	4501                	li	a0,0
    80002d70:	60e2                	ld	ra,24(sp)
    80002d72:	6442                	ld	s0,16(sp)
    80002d74:	6105                	addi	sp,sp,32
    80002d76:	8082                	ret

0000000080002d78 <sys_getpid>:
    80002d78:	1141                	addi	sp,sp,-16
    80002d7a:	e406                	sd	ra,8(sp)
    80002d7c:	e022                	sd	s0,0(sp)
    80002d7e:	0800                	addi	s0,sp,16
    80002d80:	fffff097          	auipc	ra,0xfffff
    80002d84:	c3e080e7          	jalr	-962(ra) # 800019be <myproc>
    80002d88:	5908                	lw	a0,48(a0)
    80002d8a:	60a2                	ld	ra,8(sp)
    80002d8c:	6402                	ld	s0,0(sp)
    80002d8e:	0141                	addi	sp,sp,16
    80002d90:	8082                	ret

0000000080002d92 <sys_fork>:
    80002d92:	1141                	addi	sp,sp,-16
    80002d94:	e406                	sd	ra,8(sp)
    80002d96:	e022                	sd	s0,0(sp)
    80002d98:	0800                	addi	s0,sp,16
    80002d9a:	fffff097          	auipc	ra,0xfffff
    80002d9e:	fe6080e7          	jalr	-26(ra) # 80001d80 <fork>
    80002da2:	60a2                	ld	ra,8(sp)
    80002da4:	6402                	ld	s0,0(sp)
    80002da6:	0141                	addi	sp,sp,16
    80002da8:	8082                	ret

0000000080002daa <sys_wait>:
    80002daa:	1101                	addi	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	1000                	addi	s0,sp,32
    80002db2:	fe840593          	addi	a1,s0,-24
    80002db6:	4501                	li	a0,0
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	ed0080e7          	jalr	-304(ra) # 80002c88 <argaddr>
    80002dc0:	fe843503          	ld	a0,-24(s0)
    80002dc4:	fffff097          	auipc	ra,0xfffff
    80002dc8:	696080e7          	jalr	1686(ra) # 8000245a <wait>
    80002dcc:	60e2                	ld	ra,24(sp)
    80002dce:	6442                	ld	s0,16(sp)
    80002dd0:	6105                	addi	sp,sp,32
    80002dd2:	8082                	ret

0000000080002dd4 <sys_sbrk>:
    80002dd4:	7179                	addi	sp,sp,-48
    80002dd6:	f406                	sd	ra,40(sp)
    80002dd8:	f022                	sd	s0,32(sp)
    80002dda:	ec26                	sd	s1,24(sp)
    80002ddc:	1800                	addi	s0,sp,48
    80002dde:	fdc40593          	addi	a1,s0,-36
    80002de2:	4501                	li	a0,0
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	e84080e7          	jalr	-380(ra) # 80002c68 <argint>
    80002dec:	fffff097          	auipc	ra,0xfffff
    80002df0:	bd2080e7          	jalr	-1070(ra) # 800019be <myproc>
    80002df4:	6924                	ld	s1,80(a0)
    80002df6:	fdc42503          	lw	a0,-36(s0)
    80002dfa:	fffff097          	auipc	ra,0xfffff
    80002dfe:	f2a080e7          	jalr	-214(ra) # 80001d24 <growproc>
    80002e02:	00054863          	bltz	a0,80002e12 <sys_sbrk+0x3e>
    80002e06:	8526                	mv	a0,s1
    80002e08:	70a2                	ld	ra,40(sp)
    80002e0a:	7402                	ld	s0,32(sp)
    80002e0c:	64e2                	ld	s1,24(sp)
    80002e0e:	6145                	addi	sp,sp,48
    80002e10:	8082                	ret
    80002e12:	54fd                	li	s1,-1
    80002e14:	bfcd                	j	80002e06 <sys_sbrk+0x32>

0000000080002e16 <sys_sleep>:
    80002e16:	7139                	addi	sp,sp,-64
    80002e18:	fc06                	sd	ra,56(sp)
    80002e1a:	f822                	sd	s0,48(sp)
    80002e1c:	f426                	sd	s1,40(sp)
    80002e1e:	f04a                	sd	s2,32(sp)
    80002e20:	ec4e                	sd	s3,24(sp)
    80002e22:	0080                	addi	s0,sp,64
    80002e24:	fcc40593          	addi	a1,s0,-52
    80002e28:	4501                	li	a0,0
    80002e2a:	00000097          	auipc	ra,0x0
    80002e2e:	e3e080e7          	jalr	-450(ra) # 80002c68 <argint>
    80002e32:	00014517          	auipc	a0,0x14
    80002e36:	dee50513          	addi	a0,a0,-530 # 80016c20 <tickslock>
    80002e3a:	ffffe097          	auipc	ra,0xffffe
    80002e3e:	d9c080e7          	jalr	-612(ra) # 80000bd6 <acquire>
    80002e42:	00006917          	auipc	s2,0x6
    80002e46:	b3e92903          	lw	s2,-1218(s2) # 80008980 <ticks>
    80002e4a:	fcc42783          	lw	a5,-52(s0)
    80002e4e:	cf9d                	beqz	a5,80002e8c <sys_sleep+0x76>
    80002e50:	00014997          	auipc	s3,0x14
    80002e54:	dd098993          	addi	s3,s3,-560 # 80016c20 <tickslock>
    80002e58:	00006497          	auipc	s1,0x6
    80002e5c:	b2848493          	addi	s1,s1,-1240 # 80008980 <ticks>
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	b5e080e7          	jalr	-1186(ra) # 800019be <myproc>
    80002e68:	fffff097          	auipc	ra,0xfffff
    80002e6c:	5c0080e7          	jalr	1472(ra) # 80002428 <killed>
    80002e70:	ed15                	bnez	a0,80002eac <sys_sleep+0x96>
    80002e72:	85ce                	mv	a1,s3
    80002e74:	8526                	mv	a0,s1
    80002e76:	fffff097          	auipc	ra,0xfffff
    80002e7a:	2fc080e7          	jalr	764(ra) # 80002172 <sleep>
    80002e7e:	409c                	lw	a5,0(s1)
    80002e80:	412787bb          	subw	a5,a5,s2
    80002e84:	fcc42703          	lw	a4,-52(s0)
    80002e88:	fce7ece3          	bltu	a5,a4,80002e60 <sys_sleep+0x4a>
    80002e8c:	00014517          	auipc	a0,0x14
    80002e90:	d9450513          	addi	a0,a0,-620 # 80016c20 <tickslock>
    80002e94:	ffffe097          	auipc	ra,0xffffe
    80002e98:	df6080e7          	jalr	-522(ra) # 80000c8a <release>
    80002e9c:	4501                	li	a0,0
    80002e9e:	70e2                	ld	ra,56(sp)
    80002ea0:	7442                	ld	s0,48(sp)
    80002ea2:	74a2                	ld	s1,40(sp)
    80002ea4:	7902                	ld	s2,32(sp)
    80002ea6:	69e2                	ld	s3,24(sp)
    80002ea8:	6121                	addi	sp,sp,64
    80002eaa:	8082                	ret
    80002eac:	00014517          	auipc	a0,0x14
    80002eb0:	d7450513          	addi	a0,a0,-652 # 80016c20 <tickslock>
    80002eb4:	ffffe097          	auipc	ra,0xffffe
    80002eb8:	dd6080e7          	jalr	-554(ra) # 80000c8a <release>
    80002ebc:	557d                	li	a0,-1
    80002ebe:	b7c5                	j	80002e9e <sys_sleep+0x88>

0000000080002ec0 <sys_kill>:
    80002ec0:	1101                	addi	sp,sp,-32
    80002ec2:	ec06                	sd	ra,24(sp)
    80002ec4:	e822                	sd	s0,16(sp)
    80002ec6:	1000                	addi	s0,sp,32
    80002ec8:	fec40593          	addi	a1,s0,-20
    80002ecc:	4501                	li	a0,0
    80002ece:	00000097          	auipc	ra,0x0
    80002ed2:	d9a080e7          	jalr	-614(ra) # 80002c68 <argint>
    80002ed6:	fec42503          	lw	a0,-20(s0)
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	4b0080e7          	jalr	1200(ra) # 8000238a <kill>
    80002ee2:	60e2                	ld	ra,24(sp)
    80002ee4:	6442                	ld	s0,16(sp)
    80002ee6:	6105                	addi	sp,sp,32
    80002ee8:	8082                	ret

0000000080002eea <sys_uptime>:
    80002eea:	1101                	addi	sp,sp,-32
    80002eec:	ec06                	sd	ra,24(sp)
    80002eee:	e822                	sd	s0,16(sp)
    80002ef0:	e426                	sd	s1,8(sp)
    80002ef2:	1000                	addi	s0,sp,32
    80002ef4:	00014517          	auipc	a0,0x14
    80002ef8:	d2c50513          	addi	a0,a0,-724 # 80016c20 <tickslock>
    80002efc:	ffffe097          	auipc	ra,0xffffe
    80002f00:	cda080e7          	jalr	-806(ra) # 80000bd6 <acquire>
    80002f04:	00006497          	auipc	s1,0x6
    80002f08:	a7c4a483          	lw	s1,-1412(s1) # 80008980 <ticks>
    80002f0c:	00014517          	auipc	a0,0x14
    80002f10:	d1450513          	addi	a0,a0,-748 # 80016c20 <tickslock>
    80002f14:	ffffe097          	auipc	ra,0xffffe
    80002f18:	d76080e7          	jalr	-650(ra) # 80000c8a <release>
    80002f1c:	02049513          	slli	a0,s1,0x20
    80002f20:	9101                	srli	a0,a0,0x20
    80002f22:	60e2                	ld	ra,24(sp)
    80002f24:	6442                	ld	s0,16(sp)
    80002f26:	64a2                	ld	s1,8(sp)
    80002f28:	6105                	addi	sp,sp,32
    80002f2a:	8082                	ret

0000000080002f2c <sys_pstat>:
    80002f2c:	1101                	addi	sp,sp,-32
    80002f2e:	ec06                	sd	ra,24(sp)
    80002f30:	e822                	sd	s0,16(sp)
    80002f32:	1000                	addi	s0,sp,32
    80002f34:	fec40593          	addi	a1,s0,-20
    80002f38:	4501                	li	a0,0
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	d2e080e7          	jalr	-722(ra) # 80002c68 <argint>
    80002f42:	fec42503          	lw	a0,-20(s0)
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	7a6080e7          	jalr	1958(ra) # 800026ec <pstat>
    80002f4e:	fec42503          	lw	a0,-20(s0)
    80002f52:	60e2                	ld	ra,24(sp)
    80002f54:	6442                	ld	s0,16(sp)
    80002f56:	6105                	addi	sp,sp,32
    80002f58:	8082                	ret

0000000080002f5a <binit>:
    80002f5a:	7179                	addi	sp,sp,-48
    80002f5c:	f406                	sd	ra,40(sp)
    80002f5e:	f022                	sd	s0,32(sp)
    80002f60:	ec26                	sd	s1,24(sp)
    80002f62:	e84a                	sd	s2,16(sp)
    80002f64:	e44e                	sd	s3,8(sp)
    80002f66:	e052                	sd	s4,0(sp)
    80002f68:	1800                	addi	s0,sp,48
    80002f6a:	00005597          	auipc	a1,0x5
    80002f6e:	62e58593          	addi	a1,a1,1582 # 80008598 <syscalls+0xb8>
    80002f72:	00014517          	auipc	a0,0x14
    80002f76:	cc650513          	addi	a0,a0,-826 # 80016c38 <bcache>
    80002f7a:	ffffe097          	auipc	ra,0xffffe
    80002f7e:	bcc080e7          	jalr	-1076(ra) # 80000b46 <initlock>
    80002f82:	0001c797          	auipc	a5,0x1c
    80002f86:	cb678793          	addi	a5,a5,-842 # 8001ec38 <bcache+0x8000>
    80002f8a:	0001c717          	auipc	a4,0x1c
    80002f8e:	f1670713          	addi	a4,a4,-234 # 8001eea0 <bcache+0x8268>
    80002f92:	2ae7b823          	sd	a4,688(a5)
    80002f96:	2ae7bc23          	sd	a4,696(a5)
    80002f9a:	00014497          	auipc	s1,0x14
    80002f9e:	cb648493          	addi	s1,s1,-842 # 80016c50 <bcache+0x18>
    80002fa2:	893e                	mv	s2,a5
    80002fa4:	89ba                	mv	s3,a4
    80002fa6:	00005a17          	auipc	s4,0x5
    80002faa:	5faa0a13          	addi	s4,s4,1530 # 800085a0 <syscalls+0xc0>
    80002fae:	2b893783          	ld	a5,696(s2)
    80002fb2:	e8bc                	sd	a5,80(s1)
    80002fb4:	0534b423          	sd	s3,72(s1)
    80002fb8:	85d2                	mv	a1,s4
    80002fba:	01048513          	addi	a0,s1,16
    80002fbe:	00001097          	auipc	ra,0x1
    80002fc2:	4c8080e7          	jalr	1224(ra) # 80004486 <initsleeplock>
    80002fc6:	2b893783          	ld	a5,696(s2)
    80002fca:	e7a4                	sd	s1,72(a5)
    80002fcc:	2a993c23          	sd	s1,696(s2)
    80002fd0:	45848493          	addi	s1,s1,1112
    80002fd4:	fd349de3          	bne	s1,s3,80002fae <binit+0x54>
    80002fd8:	70a2                	ld	ra,40(sp)
    80002fda:	7402                	ld	s0,32(sp)
    80002fdc:	64e2                	ld	s1,24(sp)
    80002fde:	6942                	ld	s2,16(sp)
    80002fe0:	69a2                	ld	s3,8(sp)
    80002fe2:	6a02                	ld	s4,0(sp)
    80002fe4:	6145                	addi	sp,sp,48
    80002fe6:	8082                	ret

0000000080002fe8 <bread>:
    80002fe8:	7179                	addi	sp,sp,-48
    80002fea:	f406                	sd	ra,40(sp)
    80002fec:	f022                	sd	s0,32(sp)
    80002fee:	ec26                	sd	s1,24(sp)
    80002ff0:	e84a                	sd	s2,16(sp)
    80002ff2:	e44e                	sd	s3,8(sp)
    80002ff4:	1800                	addi	s0,sp,48
    80002ff6:	892a                	mv	s2,a0
    80002ff8:	89ae                	mv	s3,a1
    80002ffa:	00014517          	auipc	a0,0x14
    80002ffe:	c3e50513          	addi	a0,a0,-962 # 80016c38 <bcache>
    80003002:	ffffe097          	auipc	ra,0xffffe
    80003006:	bd4080e7          	jalr	-1068(ra) # 80000bd6 <acquire>
    8000300a:	0001c497          	auipc	s1,0x1c
    8000300e:	ee64b483          	ld	s1,-282(s1) # 8001eef0 <bcache+0x82b8>
    80003012:	0001c797          	auipc	a5,0x1c
    80003016:	e8e78793          	addi	a5,a5,-370 # 8001eea0 <bcache+0x8268>
    8000301a:	02f48f63          	beq	s1,a5,80003058 <bread+0x70>
    8000301e:	873e                	mv	a4,a5
    80003020:	a021                	j	80003028 <bread+0x40>
    80003022:	68a4                	ld	s1,80(s1)
    80003024:	02e48a63          	beq	s1,a4,80003058 <bread+0x70>
    80003028:	449c                	lw	a5,8(s1)
    8000302a:	ff279ce3          	bne	a5,s2,80003022 <bread+0x3a>
    8000302e:	44dc                	lw	a5,12(s1)
    80003030:	ff3799e3          	bne	a5,s3,80003022 <bread+0x3a>
    80003034:	40bc                	lw	a5,64(s1)
    80003036:	2785                	addiw	a5,a5,1
    80003038:	c0bc                	sw	a5,64(s1)
    8000303a:	00014517          	auipc	a0,0x14
    8000303e:	bfe50513          	addi	a0,a0,-1026 # 80016c38 <bcache>
    80003042:	ffffe097          	auipc	ra,0xffffe
    80003046:	c48080e7          	jalr	-952(ra) # 80000c8a <release>
    8000304a:	01048513          	addi	a0,s1,16
    8000304e:	00001097          	auipc	ra,0x1
    80003052:	472080e7          	jalr	1138(ra) # 800044c0 <acquiresleep>
    80003056:	a8b9                	j	800030b4 <bread+0xcc>
    80003058:	0001c497          	auipc	s1,0x1c
    8000305c:	e904b483          	ld	s1,-368(s1) # 8001eee8 <bcache+0x82b0>
    80003060:	0001c797          	auipc	a5,0x1c
    80003064:	e4078793          	addi	a5,a5,-448 # 8001eea0 <bcache+0x8268>
    80003068:	00f48863          	beq	s1,a5,80003078 <bread+0x90>
    8000306c:	873e                	mv	a4,a5
    8000306e:	40bc                	lw	a5,64(s1)
    80003070:	cf81                	beqz	a5,80003088 <bread+0xa0>
    80003072:	64a4                	ld	s1,72(s1)
    80003074:	fee49de3          	bne	s1,a4,8000306e <bread+0x86>
    80003078:	00005517          	auipc	a0,0x5
    8000307c:	53050513          	addi	a0,a0,1328 # 800085a8 <syscalls+0xc8>
    80003080:	ffffd097          	auipc	ra,0xffffd
    80003084:	4c0080e7          	jalr	1216(ra) # 80000540 <panic>
    80003088:	0124a423          	sw	s2,8(s1)
    8000308c:	0134a623          	sw	s3,12(s1)
    80003090:	0004a023          	sw	zero,0(s1)
    80003094:	4785                	li	a5,1
    80003096:	c0bc                	sw	a5,64(s1)
    80003098:	00014517          	auipc	a0,0x14
    8000309c:	ba050513          	addi	a0,a0,-1120 # 80016c38 <bcache>
    800030a0:	ffffe097          	auipc	ra,0xffffe
    800030a4:	bea080e7          	jalr	-1046(ra) # 80000c8a <release>
    800030a8:	01048513          	addi	a0,s1,16
    800030ac:	00001097          	auipc	ra,0x1
    800030b0:	414080e7          	jalr	1044(ra) # 800044c0 <acquiresleep>
    800030b4:	409c                	lw	a5,0(s1)
    800030b6:	cb89                	beqz	a5,800030c8 <bread+0xe0>
    800030b8:	8526                	mv	a0,s1
    800030ba:	70a2                	ld	ra,40(sp)
    800030bc:	7402                	ld	s0,32(sp)
    800030be:	64e2                	ld	s1,24(sp)
    800030c0:	6942                	ld	s2,16(sp)
    800030c2:	69a2                	ld	s3,8(sp)
    800030c4:	6145                	addi	sp,sp,48
    800030c6:	8082                	ret
    800030c8:	4581                	li	a1,0
    800030ca:	8526                	mv	a0,s1
    800030cc:	00003097          	auipc	ra,0x3
    800030d0:	fd6080e7          	jalr	-42(ra) # 800060a2 <virtio_disk_rw>
    800030d4:	4785                	li	a5,1
    800030d6:	c09c                	sw	a5,0(s1)
    800030d8:	b7c5                	j	800030b8 <bread+0xd0>

00000000800030da <bwrite>:
    800030da:	1101                	addi	sp,sp,-32
    800030dc:	ec06                	sd	ra,24(sp)
    800030de:	e822                	sd	s0,16(sp)
    800030e0:	e426                	sd	s1,8(sp)
    800030e2:	1000                	addi	s0,sp,32
    800030e4:	84aa                	mv	s1,a0
    800030e6:	0541                	addi	a0,a0,16
    800030e8:	00001097          	auipc	ra,0x1
    800030ec:	472080e7          	jalr	1138(ra) # 8000455a <holdingsleep>
    800030f0:	cd01                	beqz	a0,80003108 <bwrite+0x2e>
    800030f2:	4585                	li	a1,1
    800030f4:	8526                	mv	a0,s1
    800030f6:	00003097          	auipc	ra,0x3
    800030fa:	fac080e7          	jalr	-84(ra) # 800060a2 <virtio_disk_rw>
    800030fe:	60e2                	ld	ra,24(sp)
    80003100:	6442                	ld	s0,16(sp)
    80003102:	64a2                	ld	s1,8(sp)
    80003104:	6105                	addi	sp,sp,32
    80003106:	8082                	ret
    80003108:	00005517          	auipc	a0,0x5
    8000310c:	4b850513          	addi	a0,a0,1208 # 800085c0 <syscalls+0xe0>
    80003110:	ffffd097          	auipc	ra,0xffffd
    80003114:	430080e7          	jalr	1072(ra) # 80000540 <panic>

0000000080003118 <brelse>:
    80003118:	1101                	addi	sp,sp,-32
    8000311a:	ec06                	sd	ra,24(sp)
    8000311c:	e822                	sd	s0,16(sp)
    8000311e:	e426                	sd	s1,8(sp)
    80003120:	e04a                	sd	s2,0(sp)
    80003122:	1000                	addi	s0,sp,32
    80003124:	84aa                	mv	s1,a0
    80003126:	01050913          	addi	s2,a0,16
    8000312a:	854a                	mv	a0,s2
    8000312c:	00001097          	auipc	ra,0x1
    80003130:	42e080e7          	jalr	1070(ra) # 8000455a <holdingsleep>
    80003134:	c92d                	beqz	a0,800031a6 <brelse+0x8e>
    80003136:	854a                	mv	a0,s2
    80003138:	00001097          	auipc	ra,0x1
    8000313c:	3de080e7          	jalr	990(ra) # 80004516 <releasesleep>
    80003140:	00014517          	auipc	a0,0x14
    80003144:	af850513          	addi	a0,a0,-1288 # 80016c38 <bcache>
    80003148:	ffffe097          	auipc	ra,0xffffe
    8000314c:	a8e080e7          	jalr	-1394(ra) # 80000bd6 <acquire>
    80003150:	40bc                	lw	a5,64(s1)
    80003152:	37fd                	addiw	a5,a5,-1
    80003154:	0007871b          	sext.w	a4,a5
    80003158:	c0bc                	sw	a5,64(s1)
    8000315a:	eb05                	bnez	a4,8000318a <brelse+0x72>
    8000315c:	68bc                	ld	a5,80(s1)
    8000315e:	64b8                	ld	a4,72(s1)
    80003160:	e7b8                	sd	a4,72(a5)
    80003162:	64bc                	ld	a5,72(s1)
    80003164:	68b8                	ld	a4,80(s1)
    80003166:	ebb8                	sd	a4,80(a5)
    80003168:	0001c797          	auipc	a5,0x1c
    8000316c:	ad078793          	addi	a5,a5,-1328 # 8001ec38 <bcache+0x8000>
    80003170:	2b87b703          	ld	a4,696(a5)
    80003174:	e8b8                	sd	a4,80(s1)
    80003176:	0001c717          	auipc	a4,0x1c
    8000317a:	d2a70713          	addi	a4,a4,-726 # 8001eea0 <bcache+0x8268>
    8000317e:	e4b8                	sd	a4,72(s1)
    80003180:	2b87b703          	ld	a4,696(a5)
    80003184:	e724                	sd	s1,72(a4)
    80003186:	2a97bc23          	sd	s1,696(a5)
    8000318a:	00014517          	auipc	a0,0x14
    8000318e:	aae50513          	addi	a0,a0,-1362 # 80016c38 <bcache>
    80003192:	ffffe097          	auipc	ra,0xffffe
    80003196:	af8080e7          	jalr	-1288(ra) # 80000c8a <release>
    8000319a:	60e2                	ld	ra,24(sp)
    8000319c:	6442                	ld	s0,16(sp)
    8000319e:	64a2                	ld	s1,8(sp)
    800031a0:	6902                	ld	s2,0(sp)
    800031a2:	6105                	addi	sp,sp,32
    800031a4:	8082                	ret
    800031a6:	00005517          	auipc	a0,0x5
    800031aa:	42250513          	addi	a0,a0,1058 # 800085c8 <syscalls+0xe8>
    800031ae:	ffffd097          	auipc	ra,0xffffd
    800031b2:	392080e7          	jalr	914(ra) # 80000540 <panic>

00000000800031b6 <bpin>:
    800031b6:	1101                	addi	sp,sp,-32
    800031b8:	ec06                	sd	ra,24(sp)
    800031ba:	e822                	sd	s0,16(sp)
    800031bc:	e426                	sd	s1,8(sp)
    800031be:	1000                	addi	s0,sp,32
    800031c0:	84aa                	mv	s1,a0
    800031c2:	00014517          	auipc	a0,0x14
    800031c6:	a7650513          	addi	a0,a0,-1418 # 80016c38 <bcache>
    800031ca:	ffffe097          	auipc	ra,0xffffe
    800031ce:	a0c080e7          	jalr	-1524(ra) # 80000bd6 <acquire>
    800031d2:	40bc                	lw	a5,64(s1)
    800031d4:	2785                	addiw	a5,a5,1
    800031d6:	c0bc                	sw	a5,64(s1)
    800031d8:	00014517          	auipc	a0,0x14
    800031dc:	a6050513          	addi	a0,a0,-1440 # 80016c38 <bcache>
    800031e0:	ffffe097          	auipc	ra,0xffffe
    800031e4:	aaa080e7          	jalr	-1366(ra) # 80000c8a <release>
    800031e8:	60e2                	ld	ra,24(sp)
    800031ea:	6442                	ld	s0,16(sp)
    800031ec:	64a2                	ld	s1,8(sp)
    800031ee:	6105                	addi	sp,sp,32
    800031f0:	8082                	ret

00000000800031f2 <bunpin>:
    800031f2:	1101                	addi	sp,sp,-32
    800031f4:	ec06                	sd	ra,24(sp)
    800031f6:	e822                	sd	s0,16(sp)
    800031f8:	e426                	sd	s1,8(sp)
    800031fa:	1000                	addi	s0,sp,32
    800031fc:	84aa                	mv	s1,a0
    800031fe:	00014517          	auipc	a0,0x14
    80003202:	a3a50513          	addi	a0,a0,-1478 # 80016c38 <bcache>
    80003206:	ffffe097          	auipc	ra,0xffffe
    8000320a:	9d0080e7          	jalr	-1584(ra) # 80000bd6 <acquire>
    8000320e:	40bc                	lw	a5,64(s1)
    80003210:	37fd                	addiw	a5,a5,-1
    80003212:	c0bc                	sw	a5,64(s1)
    80003214:	00014517          	auipc	a0,0x14
    80003218:	a2450513          	addi	a0,a0,-1500 # 80016c38 <bcache>
    8000321c:	ffffe097          	auipc	ra,0xffffe
    80003220:	a6e080e7          	jalr	-1426(ra) # 80000c8a <release>
    80003224:	60e2                	ld	ra,24(sp)
    80003226:	6442                	ld	s0,16(sp)
    80003228:	64a2                	ld	s1,8(sp)
    8000322a:	6105                	addi	sp,sp,32
    8000322c:	8082                	ret

000000008000322e <bfree>:
    8000322e:	1101                	addi	sp,sp,-32
    80003230:	ec06                	sd	ra,24(sp)
    80003232:	e822                	sd	s0,16(sp)
    80003234:	e426                	sd	s1,8(sp)
    80003236:	e04a                	sd	s2,0(sp)
    80003238:	1000                	addi	s0,sp,32
    8000323a:	84ae                	mv	s1,a1
    8000323c:	00d5d59b          	srliw	a1,a1,0xd
    80003240:	0001c797          	auipc	a5,0x1c
    80003244:	0d47a783          	lw	a5,212(a5) # 8001f314 <sb+0x1c>
    80003248:	9dbd                	addw	a1,a1,a5
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	d9e080e7          	jalr	-610(ra) # 80002fe8 <bread>
    80003252:	0074f713          	andi	a4,s1,7
    80003256:	4785                	li	a5,1
    80003258:	00e797bb          	sllw	a5,a5,a4
    8000325c:	14ce                	slli	s1,s1,0x33
    8000325e:	90d9                	srli	s1,s1,0x36
    80003260:	00950733          	add	a4,a0,s1
    80003264:	05874703          	lbu	a4,88(a4)
    80003268:	00e7f6b3          	and	a3,a5,a4
    8000326c:	c69d                	beqz	a3,8000329a <bfree+0x6c>
    8000326e:	892a                	mv	s2,a0
    80003270:	94aa                	add	s1,s1,a0
    80003272:	fff7c793          	not	a5,a5
    80003276:	8f7d                	and	a4,a4,a5
    80003278:	04e48c23          	sb	a4,88(s1)
    8000327c:	00001097          	auipc	ra,0x1
    80003280:	126080e7          	jalr	294(ra) # 800043a2 <log_write>
    80003284:	854a                	mv	a0,s2
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	e92080e7          	jalr	-366(ra) # 80003118 <brelse>
    8000328e:	60e2                	ld	ra,24(sp)
    80003290:	6442                	ld	s0,16(sp)
    80003292:	64a2                	ld	s1,8(sp)
    80003294:	6902                	ld	s2,0(sp)
    80003296:	6105                	addi	sp,sp,32
    80003298:	8082                	ret
    8000329a:	00005517          	auipc	a0,0x5
    8000329e:	33650513          	addi	a0,a0,822 # 800085d0 <syscalls+0xf0>
    800032a2:	ffffd097          	auipc	ra,0xffffd
    800032a6:	29e080e7          	jalr	670(ra) # 80000540 <panic>

00000000800032aa <balloc>:
    800032aa:	711d                	addi	sp,sp,-96
    800032ac:	ec86                	sd	ra,88(sp)
    800032ae:	e8a2                	sd	s0,80(sp)
    800032b0:	e4a6                	sd	s1,72(sp)
    800032b2:	e0ca                	sd	s2,64(sp)
    800032b4:	fc4e                	sd	s3,56(sp)
    800032b6:	f852                	sd	s4,48(sp)
    800032b8:	f456                	sd	s5,40(sp)
    800032ba:	f05a                	sd	s6,32(sp)
    800032bc:	ec5e                	sd	s7,24(sp)
    800032be:	e862                	sd	s8,16(sp)
    800032c0:	e466                	sd	s9,8(sp)
    800032c2:	1080                	addi	s0,sp,96
    800032c4:	0001c797          	auipc	a5,0x1c
    800032c8:	0387a783          	lw	a5,56(a5) # 8001f2fc <sb+0x4>
    800032cc:	cff5                	beqz	a5,800033c8 <balloc+0x11e>
    800032ce:	8baa                	mv	s7,a0
    800032d0:	4a81                	li	s5,0
    800032d2:	0001cb17          	auipc	s6,0x1c
    800032d6:	026b0b13          	addi	s6,s6,38 # 8001f2f8 <sb>
    800032da:	4c01                	li	s8,0
    800032dc:	4985                	li	s3,1
    800032de:	6a09                	lui	s4,0x2
    800032e0:	6c89                	lui	s9,0x2
    800032e2:	a061                	j	8000336a <balloc+0xc0>
    800032e4:	97ca                	add	a5,a5,s2
    800032e6:	8e55                	or	a2,a2,a3
    800032e8:	04c78c23          	sb	a2,88(a5)
    800032ec:	854a                	mv	a0,s2
    800032ee:	00001097          	auipc	ra,0x1
    800032f2:	0b4080e7          	jalr	180(ra) # 800043a2 <log_write>
    800032f6:	854a                	mv	a0,s2
    800032f8:	00000097          	auipc	ra,0x0
    800032fc:	e20080e7          	jalr	-480(ra) # 80003118 <brelse>
    80003300:	85a6                	mv	a1,s1
    80003302:	855e                	mv	a0,s7
    80003304:	00000097          	auipc	ra,0x0
    80003308:	ce4080e7          	jalr	-796(ra) # 80002fe8 <bread>
    8000330c:	892a                	mv	s2,a0
    8000330e:	40000613          	li	a2,1024
    80003312:	4581                	li	a1,0
    80003314:	05850513          	addi	a0,a0,88
    80003318:	ffffe097          	auipc	ra,0xffffe
    8000331c:	9ba080e7          	jalr	-1606(ra) # 80000cd2 <memset>
    80003320:	854a                	mv	a0,s2
    80003322:	00001097          	auipc	ra,0x1
    80003326:	080080e7          	jalr	128(ra) # 800043a2 <log_write>
    8000332a:	854a                	mv	a0,s2
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	dec080e7          	jalr	-532(ra) # 80003118 <brelse>
    80003334:	8526                	mv	a0,s1
    80003336:	60e6                	ld	ra,88(sp)
    80003338:	6446                	ld	s0,80(sp)
    8000333a:	64a6                	ld	s1,72(sp)
    8000333c:	6906                	ld	s2,64(sp)
    8000333e:	79e2                	ld	s3,56(sp)
    80003340:	7a42                	ld	s4,48(sp)
    80003342:	7aa2                	ld	s5,40(sp)
    80003344:	7b02                	ld	s6,32(sp)
    80003346:	6be2                	ld	s7,24(sp)
    80003348:	6c42                	ld	s8,16(sp)
    8000334a:	6ca2                	ld	s9,8(sp)
    8000334c:	6125                	addi	sp,sp,96
    8000334e:	8082                	ret
    80003350:	854a                	mv	a0,s2
    80003352:	00000097          	auipc	ra,0x0
    80003356:	dc6080e7          	jalr	-570(ra) # 80003118 <brelse>
    8000335a:	015c87bb          	addw	a5,s9,s5
    8000335e:	00078a9b          	sext.w	s5,a5
    80003362:	004b2703          	lw	a4,4(s6)
    80003366:	06eaf163          	bgeu	s5,a4,800033c8 <balloc+0x11e>
    8000336a:	41fad79b          	sraiw	a5,s5,0x1f
    8000336e:	0137d79b          	srliw	a5,a5,0x13
    80003372:	015787bb          	addw	a5,a5,s5
    80003376:	40d7d79b          	sraiw	a5,a5,0xd
    8000337a:	01cb2583          	lw	a1,28(s6)
    8000337e:	9dbd                	addw	a1,a1,a5
    80003380:	855e                	mv	a0,s7
    80003382:	00000097          	auipc	ra,0x0
    80003386:	c66080e7          	jalr	-922(ra) # 80002fe8 <bread>
    8000338a:	892a                	mv	s2,a0
    8000338c:	004b2503          	lw	a0,4(s6)
    80003390:	000a849b          	sext.w	s1,s5
    80003394:	8762                	mv	a4,s8
    80003396:	faa4fde3          	bgeu	s1,a0,80003350 <balloc+0xa6>
    8000339a:	00777693          	andi	a3,a4,7
    8000339e:	00d996bb          	sllw	a3,s3,a3
    800033a2:	41f7579b          	sraiw	a5,a4,0x1f
    800033a6:	01d7d79b          	srliw	a5,a5,0x1d
    800033aa:	9fb9                	addw	a5,a5,a4
    800033ac:	4037d79b          	sraiw	a5,a5,0x3
    800033b0:	00f90633          	add	a2,s2,a5
    800033b4:	05864603          	lbu	a2,88(a2)
    800033b8:	00c6f5b3          	and	a1,a3,a2
    800033bc:	d585                	beqz	a1,800032e4 <balloc+0x3a>
    800033be:	2705                	addiw	a4,a4,1
    800033c0:	2485                	addiw	s1,s1,1
    800033c2:	fd471ae3          	bne	a4,s4,80003396 <balloc+0xec>
    800033c6:	b769                	j	80003350 <balloc+0xa6>
    800033c8:	00005517          	auipc	a0,0x5
    800033cc:	22050513          	addi	a0,a0,544 # 800085e8 <syscalls+0x108>
    800033d0:	ffffd097          	auipc	ra,0xffffd
    800033d4:	1ba080e7          	jalr	442(ra) # 8000058a <printf>
    800033d8:	4481                	li	s1,0
    800033da:	bfa9                	j	80003334 <balloc+0x8a>

00000000800033dc <bmap>:
    800033dc:	7179                	addi	sp,sp,-48
    800033de:	f406                	sd	ra,40(sp)
    800033e0:	f022                	sd	s0,32(sp)
    800033e2:	ec26                	sd	s1,24(sp)
    800033e4:	e84a                	sd	s2,16(sp)
    800033e6:	e44e                	sd	s3,8(sp)
    800033e8:	e052                	sd	s4,0(sp)
    800033ea:	1800                	addi	s0,sp,48
    800033ec:	89aa                	mv	s3,a0
    800033ee:	47ad                	li	a5,11
    800033f0:	02b7e863          	bltu	a5,a1,80003420 <bmap+0x44>
    800033f4:	02059793          	slli	a5,a1,0x20
    800033f8:	01e7d593          	srli	a1,a5,0x1e
    800033fc:	00b504b3          	add	s1,a0,a1
    80003400:	0504a903          	lw	s2,80(s1)
    80003404:	06091e63          	bnez	s2,80003480 <bmap+0xa4>
    80003408:	4108                	lw	a0,0(a0)
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	ea0080e7          	jalr	-352(ra) # 800032aa <balloc>
    80003412:	0005091b          	sext.w	s2,a0
    80003416:	06090563          	beqz	s2,80003480 <bmap+0xa4>
    8000341a:	0524a823          	sw	s2,80(s1)
    8000341e:	a08d                	j	80003480 <bmap+0xa4>
    80003420:	ff45849b          	addiw	s1,a1,-12
    80003424:	0004871b          	sext.w	a4,s1
    80003428:	0ff00793          	li	a5,255
    8000342c:	08e7e563          	bltu	a5,a4,800034b6 <bmap+0xda>
    80003430:	08052903          	lw	s2,128(a0)
    80003434:	00091d63          	bnez	s2,8000344e <bmap+0x72>
    80003438:	4108                	lw	a0,0(a0)
    8000343a:	00000097          	auipc	ra,0x0
    8000343e:	e70080e7          	jalr	-400(ra) # 800032aa <balloc>
    80003442:	0005091b          	sext.w	s2,a0
    80003446:	02090d63          	beqz	s2,80003480 <bmap+0xa4>
    8000344a:	0929a023          	sw	s2,128(s3)
    8000344e:	85ca                	mv	a1,s2
    80003450:	0009a503          	lw	a0,0(s3)
    80003454:	00000097          	auipc	ra,0x0
    80003458:	b94080e7          	jalr	-1132(ra) # 80002fe8 <bread>
    8000345c:	8a2a                	mv	s4,a0
    8000345e:	05850793          	addi	a5,a0,88
    80003462:	02049713          	slli	a4,s1,0x20
    80003466:	01e75593          	srli	a1,a4,0x1e
    8000346a:	00b784b3          	add	s1,a5,a1
    8000346e:	0004a903          	lw	s2,0(s1)
    80003472:	02090063          	beqz	s2,80003492 <bmap+0xb6>
    80003476:	8552                	mv	a0,s4
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	ca0080e7          	jalr	-864(ra) # 80003118 <brelse>
    80003480:	854a                	mv	a0,s2
    80003482:	70a2                	ld	ra,40(sp)
    80003484:	7402                	ld	s0,32(sp)
    80003486:	64e2                	ld	s1,24(sp)
    80003488:	6942                	ld	s2,16(sp)
    8000348a:	69a2                	ld	s3,8(sp)
    8000348c:	6a02                	ld	s4,0(sp)
    8000348e:	6145                	addi	sp,sp,48
    80003490:	8082                	ret
    80003492:	0009a503          	lw	a0,0(s3)
    80003496:	00000097          	auipc	ra,0x0
    8000349a:	e14080e7          	jalr	-492(ra) # 800032aa <balloc>
    8000349e:	0005091b          	sext.w	s2,a0
    800034a2:	fc090ae3          	beqz	s2,80003476 <bmap+0x9a>
    800034a6:	0124a023          	sw	s2,0(s1)
    800034aa:	8552                	mv	a0,s4
    800034ac:	00001097          	auipc	ra,0x1
    800034b0:	ef6080e7          	jalr	-266(ra) # 800043a2 <log_write>
    800034b4:	b7c9                	j	80003476 <bmap+0x9a>
    800034b6:	00005517          	auipc	a0,0x5
    800034ba:	14a50513          	addi	a0,a0,330 # 80008600 <syscalls+0x120>
    800034be:	ffffd097          	auipc	ra,0xffffd
    800034c2:	082080e7          	jalr	130(ra) # 80000540 <panic>

00000000800034c6 <iget>:
    800034c6:	7179                	addi	sp,sp,-48
    800034c8:	f406                	sd	ra,40(sp)
    800034ca:	f022                	sd	s0,32(sp)
    800034cc:	ec26                	sd	s1,24(sp)
    800034ce:	e84a                	sd	s2,16(sp)
    800034d0:	e44e                	sd	s3,8(sp)
    800034d2:	e052                	sd	s4,0(sp)
    800034d4:	1800                	addi	s0,sp,48
    800034d6:	89aa                	mv	s3,a0
    800034d8:	8a2e                	mv	s4,a1
    800034da:	0001c517          	auipc	a0,0x1c
    800034de:	e3e50513          	addi	a0,a0,-450 # 8001f318 <itable>
    800034e2:	ffffd097          	auipc	ra,0xffffd
    800034e6:	6f4080e7          	jalr	1780(ra) # 80000bd6 <acquire>
    800034ea:	4901                	li	s2,0
    800034ec:	0001c497          	auipc	s1,0x1c
    800034f0:	e4448493          	addi	s1,s1,-444 # 8001f330 <itable+0x18>
    800034f4:	0001e697          	auipc	a3,0x1e
    800034f8:	8cc68693          	addi	a3,a3,-1844 # 80020dc0 <log>
    800034fc:	a039                	j	8000350a <iget+0x44>
    800034fe:	02090b63          	beqz	s2,80003534 <iget+0x6e>
    80003502:	08848493          	addi	s1,s1,136
    80003506:	02d48a63          	beq	s1,a3,8000353a <iget+0x74>
    8000350a:	449c                	lw	a5,8(s1)
    8000350c:	fef059e3          	blez	a5,800034fe <iget+0x38>
    80003510:	4098                	lw	a4,0(s1)
    80003512:	ff3716e3          	bne	a4,s3,800034fe <iget+0x38>
    80003516:	40d8                	lw	a4,4(s1)
    80003518:	ff4713e3          	bne	a4,s4,800034fe <iget+0x38>
    8000351c:	2785                	addiw	a5,a5,1
    8000351e:	c49c                	sw	a5,8(s1)
    80003520:	0001c517          	auipc	a0,0x1c
    80003524:	df850513          	addi	a0,a0,-520 # 8001f318 <itable>
    80003528:	ffffd097          	auipc	ra,0xffffd
    8000352c:	762080e7          	jalr	1890(ra) # 80000c8a <release>
    80003530:	8926                	mv	s2,s1
    80003532:	a03d                	j	80003560 <iget+0x9a>
    80003534:	f7f9                	bnez	a5,80003502 <iget+0x3c>
    80003536:	8926                	mv	s2,s1
    80003538:	b7e9                	j	80003502 <iget+0x3c>
    8000353a:	02090c63          	beqz	s2,80003572 <iget+0xac>
    8000353e:	01392023          	sw	s3,0(s2)
    80003542:	01492223          	sw	s4,4(s2)
    80003546:	4785                	li	a5,1
    80003548:	00f92423          	sw	a5,8(s2)
    8000354c:	04092023          	sw	zero,64(s2)
    80003550:	0001c517          	auipc	a0,0x1c
    80003554:	dc850513          	addi	a0,a0,-568 # 8001f318 <itable>
    80003558:	ffffd097          	auipc	ra,0xffffd
    8000355c:	732080e7          	jalr	1842(ra) # 80000c8a <release>
    80003560:	854a                	mv	a0,s2
    80003562:	70a2                	ld	ra,40(sp)
    80003564:	7402                	ld	s0,32(sp)
    80003566:	64e2                	ld	s1,24(sp)
    80003568:	6942                	ld	s2,16(sp)
    8000356a:	69a2                	ld	s3,8(sp)
    8000356c:	6a02                	ld	s4,0(sp)
    8000356e:	6145                	addi	sp,sp,48
    80003570:	8082                	ret
    80003572:	00005517          	auipc	a0,0x5
    80003576:	0a650513          	addi	a0,a0,166 # 80008618 <syscalls+0x138>
    8000357a:	ffffd097          	auipc	ra,0xffffd
    8000357e:	fc6080e7          	jalr	-58(ra) # 80000540 <panic>

0000000080003582 <fsinit>:
    80003582:	7179                	addi	sp,sp,-48
    80003584:	f406                	sd	ra,40(sp)
    80003586:	f022                	sd	s0,32(sp)
    80003588:	ec26                	sd	s1,24(sp)
    8000358a:	e84a                	sd	s2,16(sp)
    8000358c:	e44e                	sd	s3,8(sp)
    8000358e:	1800                	addi	s0,sp,48
    80003590:	892a                	mv	s2,a0
    80003592:	4585                	li	a1,1
    80003594:	00000097          	auipc	ra,0x0
    80003598:	a54080e7          	jalr	-1452(ra) # 80002fe8 <bread>
    8000359c:	84aa                	mv	s1,a0
    8000359e:	0001c997          	auipc	s3,0x1c
    800035a2:	d5a98993          	addi	s3,s3,-678 # 8001f2f8 <sb>
    800035a6:	02000613          	li	a2,32
    800035aa:	05850593          	addi	a1,a0,88
    800035ae:	854e                	mv	a0,s3
    800035b0:	ffffd097          	auipc	ra,0xffffd
    800035b4:	77e080e7          	jalr	1918(ra) # 80000d2e <memmove>
    800035b8:	8526                	mv	a0,s1
    800035ba:	00000097          	auipc	ra,0x0
    800035be:	b5e080e7          	jalr	-1186(ra) # 80003118 <brelse>
    800035c2:	0009a703          	lw	a4,0(s3)
    800035c6:	102037b7          	lui	a5,0x10203
    800035ca:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800035ce:	02f71263          	bne	a4,a5,800035f2 <fsinit+0x70>
    800035d2:	0001c597          	auipc	a1,0x1c
    800035d6:	d2658593          	addi	a1,a1,-730 # 8001f2f8 <sb>
    800035da:	854a                	mv	a0,s2
    800035dc:	00001097          	auipc	ra,0x1
    800035e0:	b4a080e7          	jalr	-1206(ra) # 80004126 <initlog>
    800035e4:	70a2                	ld	ra,40(sp)
    800035e6:	7402                	ld	s0,32(sp)
    800035e8:	64e2                	ld	s1,24(sp)
    800035ea:	6942                	ld	s2,16(sp)
    800035ec:	69a2                	ld	s3,8(sp)
    800035ee:	6145                	addi	sp,sp,48
    800035f0:	8082                	ret
    800035f2:	00005517          	auipc	a0,0x5
    800035f6:	03650513          	addi	a0,a0,54 # 80008628 <syscalls+0x148>
    800035fa:	ffffd097          	auipc	ra,0xffffd
    800035fe:	f46080e7          	jalr	-186(ra) # 80000540 <panic>

0000000080003602 <iinit>:
    80003602:	7179                	addi	sp,sp,-48
    80003604:	f406                	sd	ra,40(sp)
    80003606:	f022                	sd	s0,32(sp)
    80003608:	ec26                	sd	s1,24(sp)
    8000360a:	e84a                	sd	s2,16(sp)
    8000360c:	e44e                	sd	s3,8(sp)
    8000360e:	1800                	addi	s0,sp,48
    80003610:	00005597          	auipc	a1,0x5
    80003614:	03058593          	addi	a1,a1,48 # 80008640 <syscalls+0x160>
    80003618:	0001c517          	auipc	a0,0x1c
    8000361c:	d0050513          	addi	a0,a0,-768 # 8001f318 <itable>
    80003620:	ffffd097          	auipc	ra,0xffffd
    80003624:	526080e7          	jalr	1318(ra) # 80000b46 <initlock>
    80003628:	0001c497          	auipc	s1,0x1c
    8000362c:	d1848493          	addi	s1,s1,-744 # 8001f340 <itable+0x28>
    80003630:	0001d997          	auipc	s3,0x1d
    80003634:	7a098993          	addi	s3,s3,1952 # 80020dd0 <log+0x10>
    80003638:	00005917          	auipc	s2,0x5
    8000363c:	01090913          	addi	s2,s2,16 # 80008648 <syscalls+0x168>
    80003640:	85ca                	mv	a1,s2
    80003642:	8526                	mv	a0,s1
    80003644:	00001097          	auipc	ra,0x1
    80003648:	e42080e7          	jalr	-446(ra) # 80004486 <initsleeplock>
    8000364c:	08848493          	addi	s1,s1,136
    80003650:	ff3498e3          	bne	s1,s3,80003640 <iinit+0x3e>
    80003654:	70a2                	ld	ra,40(sp)
    80003656:	7402                	ld	s0,32(sp)
    80003658:	64e2                	ld	s1,24(sp)
    8000365a:	6942                	ld	s2,16(sp)
    8000365c:	69a2                	ld	s3,8(sp)
    8000365e:	6145                	addi	sp,sp,48
    80003660:	8082                	ret

0000000080003662 <ialloc>:
    80003662:	715d                	addi	sp,sp,-80
    80003664:	e486                	sd	ra,72(sp)
    80003666:	e0a2                	sd	s0,64(sp)
    80003668:	fc26                	sd	s1,56(sp)
    8000366a:	f84a                	sd	s2,48(sp)
    8000366c:	f44e                	sd	s3,40(sp)
    8000366e:	f052                	sd	s4,32(sp)
    80003670:	ec56                	sd	s5,24(sp)
    80003672:	e85a                	sd	s6,16(sp)
    80003674:	e45e                	sd	s7,8(sp)
    80003676:	0880                	addi	s0,sp,80
    80003678:	0001c717          	auipc	a4,0x1c
    8000367c:	c8c72703          	lw	a4,-884(a4) # 8001f304 <sb+0xc>
    80003680:	4785                	li	a5,1
    80003682:	04e7fa63          	bgeu	a5,a4,800036d6 <ialloc+0x74>
    80003686:	8aaa                	mv	s5,a0
    80003688:	8bae                	mv	s7,a1
    8000368a:	4485                	li	s1,1
    8000368c:	0001ca17          	auipc	s4,0x1c
    80003690:	c6ca0a13          	addi	s4,s4,-916 # 8001f2f8 <sb>
    80003694:	00048b1b          	sext.w	s6,s1
    80003698:	0044d593          	srli	a1,s1,0x4
    8000369c:	018a2783          	lw	a5,24(s4)
    800036a0:	9dbd                	addw	a1,a1,a5
    800036a2:	8556                	mv	a0,s5
    800036a4:	00000097          	auipc	ra,0x0
    800036a8:	944080e7          	jalr	-1724(ra) # 80002fe8 <bread>
    800036ac:	892a                	mv	s2,a0
    800036ae:	05850993          	addi	s3,a0,88
    800036b2:	00f4f793          	andi	a5,s1,15
    800036b6:	079a                	slli	a5,a5,0x6
    800036b8:	99be                	add	s3,s3,a5
    800036ba:	00099783          	lh	a5,0(s3)
    800036be:	c3a1                	beqz	a5,800036fe <ialloc+0x9c>
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	a58080e7          	jalr	-1448(ra) # 80003118 <brelse>
    800036c8:	0485                	addi	s1,s1,1
    800036ca:	00ca2703          	lw	a4,12(s4)
    800036ce:	0004879b          	sext.w	a5,s1
    800036d2:	fce7e1e3          	bltu	a5,a4,80003694 <ialloc+0x32>
    800036d6:	00005517          	auipc	a0,0x5
    800036da:	f7a50513          	addi	a0,a0,-134 # 80008650 <syscalls+0x170>
    800036de:	ffffd097          	auipc	ra,0xffffd
    800036e2:	eac080e7          	jalr	-340(ra) # 8000058a <printf>
    800036e6:	4501                	li	a0,0
    800036e8:	60a6                	ld	ra,72(sp)
    800036ea:	6406                	ld	s0,64(sp)
    800036ec:	74e2                	ld	s1,56(sp)
    800036ee:	7942                	ld	s2,48(sp)
    800036f0:	79a2                	ld	s3,40(sp)
    800036f2:	7a02                	ld	s4,32(sp)
    800036f4:	6ae2                	ld	s5,24(sp)
    800036f6:	6b42                	ld	s6,16(sp)
    800036f8:	6ba2                	ld	s7,8(sp)
    800036fa:	6161                	addi	sp,sp,80
    800036fc:	8082                	ret
    800036fe:	04000613          	li	a2,64
    80003702:	4581                	li	a1,0
    80003704:	854e                	mv	a0,s3
    80003706:	ffffd097          	auipc	ra,0xffffd
    8000370a:	5cc080e7          	jalr	1484(ra) # 80000cd2 <memset>
    8000370e:	01799023          	sh	s7,0(s3)
    80003712:	854a                	mv	a0,s2
    80003714:	00001097          	auipc	ra,0x1
    80003718:	c8e080e7          	jalr	-882(ra) # 800043a2 <log_write>
    8000371c:	854a                	mv	a0,s2
    8000371e:	00000097          	auipc	ra,0x0
    80003722:	9fa080e7          	jalr	-1542(ra) # 80003118 <brelse>
    80003726:	85da                	mv	a1,s6
    80003728:	8556                	mv	a0,s5
    8000372a:	00000097          	auipc	ra,0x0
    8000372e:	d9c080e7          	jalr	-612(ra) # 800034c6 <iget>
    80003732:	bf5d                	j	800036e8 <ialloc+0x86>

0000000080003734 <iupdate>:
    80003734:	1101                	addi	sp,sp,-32
    80003736:	ec06                	sd	ra,24(sp)
    80003738:	e822                	sd	s0,16(sp)
    8000373a:	e426                	sd	s1,8(sp)
    8000373c:	e04a                	sd	s2,0(sp)
    8000373e:	1000                	addi	s0,sp,32
    80003740:	84aa                	mv	s1,a0
    80003742:	415c                	lw	a5,4(a0)
    80003744:	0047d79b          	srliw	a5,a5,0x4
    80003748:	0001c597          	auipc	a1,0x1c
    8000374c:	bc85a583          	lw	a1,-1080(a1) # 8001f310 <sb+0x18>
    80003750:	9dbd                	addw	a1,a1,a5
    80003752:	4108                	lw	a0,0(a0)
    80003754:	00000097          	auipc	ra,0x0
    80003758:	894080e7          	jalr	-1900(ra) # 80002fe8 <bread>
    8000375c:	892a                	mv	s2,a0
    8000375e:	05850793          	addi	a5,a0,88
    80003762:	40d8                	lw	a4,4(s1)
    80003764:	8b3d                	andi	a4,a4,15
    80003766:	071a                	slli	a4,a4,0x6
    80003768:	97ba                	add	a5,a5,a4
    8000376a:	04449703          	lh	a4,68(s1)
    8000376e:	00e79023          	sh	a4,0(a5)
    80003772:	04649703          	lh	a4,70(s1)
    80003776:	00e79123          	sh	a4,2(a5)
    8000377a:	04849703          	lh	a4,72(s1)
    8000377e:	00e79223          	sh	a4,4(a5)
    80003782:	04a49703          	lh	a4,74(s1)
    80003786:	00e79323          	sh	a4,6(a5)
    8000378a:	44f8                	lw	a4,76(s1)
    8000378c:	c798                	sw	a4,8(a5)
    8000378e:	03400613          	li	a2,52
    80003792:	05048593          	addi	a1,s1,80
    80003796:	00c78513          	addi	a0,a5,12
    8000379a:	ffffd097          	auipc	ra,0xffffd
    8000379e:	594080e7          	jalr	1428(ra) # 80000d2e <memmove>
    800037a2:	854a                	mv	a0,s2
    800037a4:	00001097          	auipc	ra,0x1
    800037a8:	bfe080e7          	jalr	-1026(ra) # 800043a2 <log_write>
    800037ac:	854a                	mv	a0,s2
    800037ae:	00000097          	auipc	ra,0x0
    800037b2:	96a080e7          	jalr	-1686(ra) # 80003118 <brelse>
    800037b6:	60e2                	ld	ra,24(sp)
    800037b8:	6442                	ld	s0,16(sp)
    800037ba:	64a2                	ld	s1,8(sp)
    800037bc:	6902                	ld	s2,0(sp)
    800037be:	6105                	addi	sp,sp,32
    800037c0:	8082                	ret

00000000800037c2 <idup>:
    800037c2:	1101                	addi	sp,sp,-32
    800037c4:	ec06                	sd	ra,24(sp)
    800037c6:	e822                	sd	s0,16(sp)
    800037c8:	e426                	sd	s1,8(sp)
    800037ca:	1000                	addi	s0,sp,32
    800037cc:	84aa                	mv	s1,a0
    800037ce:	0001c517          	auipc	a0,0x1c
    800037d2:	b4a50513          	addi	a0,a0,-1206 # 8001f318 <itable>
    800037d6:	ffffd097          	auipc	ra,0xffffd
    800037da:	400080e7          	jalr	1024(ra) # 80000bd6 <acquire>
    800037de:	449c                	lw	a5,8(s1)
    800037e0:	2785                	addiw	a5,a5,1
    800037e2:	c49c                	sw	a5,8(s1)
    800037e4:	0001c517          	auipc	a0,0x1c
    800037e8:	b3450513          	addi	a0,a0,-1228 # 8001f318 <itable>
    800037ec:	ffffd097          	auipc	ra,0xffffd
    800037f0:	49e080e7          	jalr	1182(ra) # 80000c8a <release>
    800037f4:	8526                	mv	a0,s1
    800037f6:	60e2                	ld	ra,24(sp)
    800037f8:	6442                	ld	s0,16(sp)
    800037fa:	64a2                	ld	s1,8(sp)
    800037fc:	6105                	addi	sp,sp,32
    800037fe:	8082                	ret

0000000080003800 <ilock>:
    80003800:	1101                	addi	sp,sp,-32
    80003802:	ec06                	sd	ra,24(sp)
    80003804:	e822                	sd	s0,16(sp)
    80003806:	e426                	sd	s1,8(sp)
    80003808:	e04a                	sd	s2,0(sp)
    8000380a:	1000                	addi	s0,sp,32
    8000380c:	c115                	beqz	a0,80003830 <ilock+0x30>
    8000380e:	84aa                	mv	s1,a0
    80003810:	451c                	lw	a5,8(a0)
    80003812:	00f05f63          	blez	a5,80003830 <ilock+0x30>
    80003816:	0541                	addi	a0,a0,16
    80003818:	00001097          	auipc	ra,0x1
    8000381c:	ca8080e7          	jalr	-856(ra) # 800044c0 <acquiresleep>
    80003820:	40bc                	lw	a5,64(s1)
    80003822:	cf99                	beqz	a5,80003840 <ilock+0x40>
    80003824:	60e2                	ld	ra,24(sp)
    80003826:	6442                	ld	s0,16(sp)
    80003828:	64a2                	ld	s1,8(sp)
    8000382a:	6902                	ld	s2,0(sp)
    8000382c:	6105                	addi	sp,sp,32
    8000382e:	8082                	ret
    80003830:	00005517          	auipc	a0,0x5
    80003834:	e3850513          	addi	a0,a0,-456 # 80008668 <syscalls+0x188>
    80003838:	ffffd097          	auipc	ra,0xffffd
    8000383c:	d08080e7          	jalr	-760(ra) # 80000540 <panic>
    80003840:	40dc                	lw	a5,4(s1)
    80003842:	0047d79b          	srliw	a5,a5,0x4
    80003846:	0001c597          	auipc	a1,0x1c
    8000384a:	aca5a583          	lw	a1,-1334(a1) # 8001f310 <sb+0x18>
    8000384e:	9dbd                	addw	a1,a1,a5
    80003850:	4088                	lw	a0,0(s1)
    80003852:	fffff097          	auipc	ra,0xfffff
    80003856:	796080e7          	jalr	1942(ra) # 80002fe8 <bread>
    8000385a:	892a                	mv	s2,a0
    8000385c:	05850593          	addi	a1,a0,88
    80003860:	40dc                	lw	a5,4(s1)
    80003862:	8bbd                	andi	a5,a5,15
    80003864:	079a                	slli	a5,a5,0x6
    80003866:	95be                	add	a1,a1,a5
    80003868:	00059783          	lh	a5,0(a1)
    8000386c:	04f49223          	sh	a5,68(s1)
    80003870:	00259783          	lh	a5,2(a1)
    80003874:	04f49323          	sh	a5,70(s1)
    80003878:	00459783          	lh	a5,4(a1)
    8000387c:	04f49423          	sh	a5,72(s1)
    80003880:	00659783          	lh	a5,6(a1)
    80003884:	04f49523          	sh	a5,74(s1)
    80003888:	459c                	lw	a5,8(a1)
    8000388a:	c4fc                	sw	a5,76(s1)
    8000388c:	03400613          	li	a2,52
    80003890:	05b1                	addi	a1,a1,12
    80003892:	05048513          	addi	a0,s1,80
    80003896:	ffffd097          	auipc	ra,0xffffd
    8000389a:	498080e7          	jalr	1176(ra) # 80000d2e <memmove>
    8000389e:	854a                	mv	a0,s2
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	878080e7          	jalr	-1928(ra) # 80003118 <brelse>
    800038a8:	4785                	li	a5,1
    800038aa:	c0bc                	sw	a5,64(s1)
    800038ac:	04449783          	lh	a5,68(s1)
    800038b0:	fbb5                	bnez	a5,80003824 <ilock+0x24>
    800038b2:	00005517          	auipc	a0,0x5
    800038b6:	dbe50513          	addi	a0,a0,-578 # 80008670 <syscalls+0x190>
    800038ba:	ffffd097          	auipc	ra,0xffffd
    800038be:	c86080e7          	jalr	-890(ra) # 80000540 <panic>

00000000800038c2 <iunlock>:
    800038c2:	1101                	addi	sp,sp,-32
    800038c4:	ec06                	sd	ra,24(sp)
    800038c6:	e822                	sd	s0,16(sp)
    800038c8:	e426                	sd	s1,8(sp)
    800038ca:	e04a                	sd	s2,0(sp)
    800038cc:	1000                	addi	s0,sp,32
    800038ce:	c905                	beqz	a0,800038fe <iunlock+0x3c>
    800038d0:	84aa                	mv	s1,a0
    800038d2:	01050913          	addi	s2,a0,16
    800038d6:	854a                	mv	a0,s2
    800038d8:	00001097          	auipc	ra,0x1
    800038dc:	c82080e7          	jalr	-894(ra) # 8000455a <holdingsleep>
    800038e0:	cd19                	beqz	a0,800038fe <iunlock+0x3c>
    800038e2:	449c                	lw	a5,8(s1)
    800038e4:	00f05d63          	blez	a5,800038fe <iunlock+0x3c>
    800038e8:	854a                	mv	a0,s2
    800038ea:	00001097          	auipc	ra,0x1
    800038ee:	c2c080e7          	jalr	-980(ra) # 80004516 <releasesleep>
    800038f2:	60e2                	ld	ra,24(sp)
    800038f4:	6442                	ld	s0,16(sp)
    800038f6:	64a2                	ld	s1,8(sp)
    800038f8:	6902                	ld	s2,0(sp)
    800038fa:	6105                	addi	sp,sp,32
    800038fc:	8082                	ret
    800038fe:	00005517          	auipc	a0,0x5
    80003902:	d8250513          	addi	a0,a0,-638 # 80008680 <syscalls+0x1a0>
    80003906:	ffffd097          	auipc	ra,0xffffd
    8000390a:	c3a080e7          	jalr	-966(ra) # 80000540 <panic>

000000008000390e <itrunc>:
    8000390e:	7179                	addi	sp,sp,-48
    80003910:	f406                	sd	ra,40(sp)
    80003912:	f022                	sd	s0,32(sp)
    80003914:	ec26                	sd	s1,24(sp)
    80003916:	e84a                	sd	s2,16(sp)
    80003918:	e44e                	sd	s3,8(sp)
    8000391a:	e052                	sd	s4,0(sp)
    8000391c:	1800                	addi	s0,sp,48
    8000391e:	89aa                	mv	s3,a0
    80003920:	05050493          	addi	s1,a0,80
    80003924:	08050913          	addi	s2,a0,128
    80003928:	a021                	j	80003930 <itrunc+0x22>
    8000392a:	0491                	addi	s1,s1,4
    8000392c:	01248d63          	beq	s1,s2,80003946 <itrunc+0x38>
    80003930:	408c                	lw	a1,0(s1)
    80003932:	dde5                	beqz	a1,8000392a <itrunc+0x1c>
    80003934:	0009a503          	lw	a0,0(s3)
    80003938:	00000097          	auipc	ra,0x0
    8000393c:	8f6080e7          	jalr	-1802(ra) # 8000322e <bfree>
    80003940:	0004a023          	sw	zero,0(s1)
    80003944:	b7dd                	j	8000392a <itrunc+0x1c>
    80003946:	0809a583          	lw	a1,128(s3)
    8000394a:	e185                	bnez	a1,8000396a <itrunc+0x5c>
    8000394c:	0409a623          	sw	zero,76(s3)
    80003950:	854e                	mv	a0,s3
    80003952:	00000097          	auipc	ra,0x0
    80003956:	de2080e7          	jalr	-542(ra) # 80003734 <iupdate>
    8000395a:	70a2                	ld	ra,40(sp)
    8000395c:	7402                	ld	s0,32(sp)
    8000395e:	64e2                	ld	s1,24(sp)
    80003960:	6942                	ld	s2,16(sp)
    80003962:	69a2                	ld	s3,8(sp)
    80003964:	6a02                	ld	s4,0(sp)
    80003966:	6145                	addi	sp,sp,48
    80003968:	8082                	ret
    8000396a:	0009a503          	lw	a0,0(s3)
    8000396e:	fffff097          	auipc	ra,0xfffff
    80003972:	67a080e7          	jalr	1658(ra) # 80002fe8 <bread>
    80003976:	8a2a                	mv	s4,a0
    80003978:	05850493          	addi	s1,a0,88
    8000397c:	45850913          	addi	s2,a0,1112
    80003980:	a021                	j	80003988 <itrunc+0x7a>
    80003982:	0491                	addi	s1,s1,4
    80003984:	01248b63          	beq	s1,s2,8000399a <itrunc+0x8c>
    80003988:	408c                	lw	a1,0(s1)
    8000398a:	dde5                	beqz	a1,80003982 <itrunc+0x74>
    8000398c:	0009a503          	lw	a0,0(s3)
    80003990:	00000097          	auipc	ra,0x0
    80003994:	89e080e7          	jalr	-1890(ra) # 8000322e <bfree>
    80003998:	b7ed                	j	80003982 <itrunc+0x74>
    8000399a:	8552                	mv	a0,s4
    8000399c:	fffff097          	auipc	ra,0xfffff
    800039a0:	77c080e7          	jalr	1916(ra) # 80003118 <brelse>
    800039a4:	0809a583          	lw	a1,128(s3)
    800039a8:	0009a503          	lw	a0,0(s3)
    800039ac:	00000097          	auipc	ra,0x0
    800039b0:	882080e7          	jalr	-1918(ra) # 8000322e <bfree>
    800039b4:	0809a023          	sw	zero,128(s3)
    800039b8:	bf51                	j	8000394c <itrunc+0x3e>

00000000800039ba <iput>:
    800039ba:	1101                	addi	sp,sp,-32
    800039bc:	ec06                	sd	ra,24(sp)
    800039be:	e822                	sd	s0,16(sp)
    800039c0:	e426                	sd	s1,8(sp)
    800039c2:	e04a                	sd	s2,0(sp)
    800039c4:	1000                	addi	s0,sp,32
    800039c6:	84aa                	mv	s1,a0
    800039c8:	0001c517          	auipc	a0,0x1c
    800039cc:	95050513          	addi	a0,a0,-1712 # 8001f318 <itable>
    800039d0:	ffffd097          	auipc	ra,0xffffd
    800039d4:	206080e7          	jalr	518(ra) # 80000bd6 <acquire>
    800039d8:	4498                	lw	a4,8(s1)
    800039da:	4785                	li	a5,1
    800039dc:	02f70363          	beq	a4,a5,80003a02 <iput+0x48>
    800039e0:	449c                	lw	a5,8(s1)
    800039e2:	37fd                	addiw	a5,a5,-1
    800039e4:	c49c                	sw	a5,8(s1)
    800039e6:	0001c517          	auipc	a0,0x1c
    800039ea:	93250513          	addi	a0,a0,-1742 # 8001f318 <itable>
    800039ee:	ffffd097          	auipc	ra,0xffffd
    800039f2:	29c080e7          	jalr	668(ra) # 80000c8a <release>
    800039f6:	60e2                	ld	ra,24(sp)
    800039f8:	6442                	ld	s0,16(sp)
    800039fa:	64a2                	ld	s1,8(sp)
    800039fc:	6902                	ld	s2,0(sp)
    800039fe:	6105                	addi	sp,sp,32
    80003a00:	8082                	ret
    80003a02:	40bc                	lw	a5,64(s1)
    80003a04:	dff1                	beqz	a5,800039e0 <iput+0x26>
    80003a06:	04a49783          	lh	a5,74(s1)
    80003a0a:	fbf9                	bnez	a5,800039e0 <iput+0x26>
    80003a0c:	01048913          	addi	s2,s1,16
    80003a10:	854a                	mv	a0,s2
    80003a12:	00001097          	auipc	ra,0x1
    80003a16:	aae080e7          	jalr	-1362(ra) # 800044c0 <acquiresleep>
    80003a1a:	0001c517          	auipc	a0,0x1c
    80003a1e:	8fe50513          	addi	a0,a0,-1794 # 8001f318 <itable>
    80003a22:	ffffd097          	auipc	ra,0xffffd
    80003a26:	268080e7          	jalr	616(ra) # 80000c8a <release>
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	00000097          	auipc	ra,0x0
    80003a30:	ee2080e7          	jalr	-286(ra) # 8000390e <itrunc>
    80003a34:	04049223          	sh	zero,68(s1)
    80003a38:	8526                	mv	a0,s1
    80003a3a:	00000097          	auipc	ra,0x0
    80003a3e:	cfa080e7          	jalr	-774(ra) # 80003734 <iupdate>
    80003a42:	0404a023          	sw	zero,64(s1)
    80003a46:	854a                	mv	a0,s2
    80003a48:	00001097          	auipc	ra,0x1
    80003a4c:	ace080e7          	jalr	-1330(ra) # 80004516 <releasesleep>
    80003a50:	0001c517          	auipc	a0,0x1c
    80003a54:	8c850513          	addi	a0,a0,-1848 # 8001f318 <itable>
    80003a58:	ffffd097          	auipc	ra,0xffffd
    80003a5c:	17e080e7          	jalr	382(ra) # 80000bd6 <acquire>
    80003a60:	b741                	j	800039e0 <iput+0x26>

0000000080003a62 <iunlockput>:
    80003a62:	1101                	addi	sp,sp,-32
    80003a64:	ec06                	sd	ra,24(sp)
    80003a66:	e822                	sd	s0,16(sp)
    80003a68:	e426                	sd	s1,8(sp)
    80003a6a:	1000                	addi	s0,sp,32
    80003a6c:	84aa                	mv	s1,a0
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	e54080e7          	jalr	-428(ra) # 800038c2 <iunlock>
    80003a76:	8526                	mv	a0,s1
    80003a78:	00000097          	auipc	ra,0x0
    80003a7c:	f42080e7          	jalr	-190(ra) # 800039ba <iput>
    80003a80:	60e2                	ld	ra,24(sp)
    80003a82:	6442                	ld	s0,16(sp)
    80003a84:	64a2                	ld	s1,8(sp)
    80003a86:	6105                	addi	sp,sp,32
    80003a88:	8082                	ret

0000000080003a8a <stati>:
    80003a8a:	1141                	addi	sp,sp,-16
    80003a8c:	e422                	sd	s0,8(sp)
    80003a8e:	0800                	addi	s0,sp,16
    80003a90:	411c                	lw	a5,0(a0)
    80003a92:	c19c                	sw	a5,0(a1)
    80003a94:	415c                	lw	a5,4(a0)
    80003a96:	c1dc                	sw	a5,4(a1)
    80003a98:	04451783          	lh	a5,68(a0)
    80003a9c:	00f59423          	sh	a5,8(a1)
    80003aa0:	04a51783          	lh	a5,74(a0)
    80003aa4:	00f59523          	sh	a5,10(a1)
    80003aa8:	04c56783          	lwu	a5,76(a0)
    80003aac:	e99c                	sd	a5,16(a1)
    80003aae:	6422                	ld	s0,8(sp)
    80003ab0:	0141                	addi	sp,sp,16
    80003ab2:	8082                	ret

0000000080003ab4 <readi>:
    80003ab4:	457c                	lw	a5,76(a0)
    80003ab6:	0ed7e963          	bltu	a5,a3,80003ba8 <readi+0xf4>
    80003aba:	7159                	addi	sp,sp,-112
    80003abc:	f486                	sd	ra,104(sp)
    80003abe:	f0a2                	sd	s0,96(sp)
    80003ac0:	eca6                	sd	s1,88(sp)
    80003ac2:	e8ca                	sd	s2,80(sp)
    80003ac4:	e4ce                	sd	s3,72(sp)
    80003ac6:	e0d2                	sd	s4,64(sp)
    80003ac8:	fc56                	sd	s5,56(sp)
    80003aca:	f85a                	sd	s6,48(sp)
    80003acc:	f45e                	sd	s7,40(sp)
    80003ace:	f062                	sd	s8,32(sp)
    80003ad0:	ec66                	sd	s9,24(sp)
    80003ad2:	e86a                	sd	s10,16(sp)
    80003ad4:	e46e                	sd	s11,8(sp)
    80003ad6:	1880                	addi	s0,sp,112
    80003ad8:	8b2a                	mv	s6,a0
    80003ada:	8bae                	mv	s7,a1
    80003adc:	8a32                	mv	s4,a2
    80003ade:	84b6                	mv	s1,a3
    80003ae0:	8aba                	mv	s5,a4
    80003ae2:	9f35                	addw	a4,a4,a3
    80003ae4:	4501                	li	a0,0
    80003ae6:	0ad76063          	bltu	a4,a3,80003b86 <readi+0xd2>
    80003aea:	00e7f463          	bgeu	a5,a4,80003af2 <readi+0x3e>
    80003aee:	40d78abb          	subw	s5,a5,a3
    80003af2:	0a0a8963          	beqz	s5,80003ba4 <readi+0xf0>
    80003af6:	4981                	li	s3,0
    80003af8:	40000c93          	li	s9,1024
    80003afc:	5c7d                	li	s8,-1
    80003afe:	a82d                	j	80003b38 <readi+0x84>
    80003b00:	020d1d93          	slli	s11,s10,0x20
    80003b04:	020ddd93          	srli	s11,s11,0x20
    80003b08:	05890613          	addi	a2,s2,88
    80003b0c:	86ee                	mv	a3,s11
    80003b0e:	963a                	add	a2,a2,a4
    80003b10:	85d2                	mv	a1,s4
    80003b12:	855e                	mv	a0,s7
    80003b14:	fffff097          	auipc	ra,0xfffff
    80003b18:	a74080e7          	jalr	-1420(ra) # 80002588 <either_copyout>
    80003b1c:	05850d63          	beq	a0,s8,80003b76 <readi+0xc2>
    80003b20:	854a                	mv	a0,s2
    80003b22:	fffff097          	auipc	ra,0xfffff
    80003b26:	5f6080e7          	jalr	1526(ra) # 80003118 <brelse>
    80003b2a:	013d09bb          	addw	s3,s10,s3
    80003b2e:	009d04bb          	addw	s1,s10,s1
    80003b32:	9a6e                	add	s4,s4,s11
    80003b34:	0559f763          	bgeu	s3,s5,80003b82 <readi+0xce>
    80003b38:	00a4d59b          	srliw	a1,s1,0xa
    80003b3c:	855a                	mv	a0,s6
    80003b3e:	00000097          	auipc	ra,0x0
    80003b42:	89e080e7          	jalr	-1890(ra) # 800033dc <bmap>
    80003b46:	0005059b          	sext.w	a1,a0
    80003b4a:	cd85                	beqz	a1,80003b82 <readi+0xce>
    80003b4c:	000b2503          	lw	a0,0(s6)
    80003b50:	fffff097          	auipc	ra,0xfffff
    80003b54:	498080e7          	jalr	1176(ra) # 80002fe8 <bread>
    80003b58:	892a                	mv	s2,a0
    80003b5a:	3ff4f713          	andi	a4,s1,1023
    80003b5e:	40ec87bb          	subw	a5,s9,a4
    80003b62:	413a86bb          	subw	a3,s5,s3
    80003b66:	8d3e                	mv	s10,a5
    80003b68:	2781                	sext.w	a5,a5
    80003b6a:	0006861b          	sext.w	a2,a3
    80003b6e:	f8f679e3          	bgeu	a2,a5,80003b00 <readi+0x4c>
    80003b72:	8d36                	mv	s10,a3
    80003b74:	b771                	j	80003b00 <readi+0x4c>
    80003b76:	854a                	mv	a0,s2
    80003b78:	fffff097          	auipc	ra,0xfffff
    80003b7c:	5a0080e7          	jalr	1440(ra) # 80003118 <brelse>
    80003b80:	59fd                	li	s3,-1
    80003b82:	0009851b          	sext.w	a0,s3
    80003b86:	70a6                	ld	ra,104(sp)
    80003b88:	7406                	ld	s0,96(sp)
    80003b8a:	64e6                	ld	s1,88(sp)
    80003b8c:	6946                	ld	s2,80(sp)
    80003b8e:	69a6                	ld	s3,72(sp)
    80003b90:	6a06                	ld	s4,64(sp)
    80003b92:	7ae2                	ld	s5,56(sp)
    80003b94:	7b42                	ld	s6,48(sp)
    80003b96:	7ba2                	ld	s7,40(sp)
    80003b98:	7c02                	ld	s8,32(sp)
    80003b9a:	6ce2                	ld	s9,24(sp)
    80003b9c:	6d42                	ld	s10,16(sp)
    80003b9e:	6da2                	ld	s11,8(sp)
    80003ba0:	6165                	addi	sp,sp,112
    80003ba2:	8082                	ret
    80003ba4:	89d6                	mv	s3,s5
    80003ba6:	bff1                	j	80003b82 <readi+0xce>
    80003ba8:	4501                	li	a0,0
    80003baa:	8082                	ret

0000000080003bac <writei>:
    80003bac:	457c                	lw	a5,76(a0)
    80003bae:	10d7e863          	bltu	a5,a3,80003cbe <writei+0x112>
    80003bb2:	7159                	addi	sp,sp,-112
    80003bb4:	f486                	sd	ra,104(sp)
    80003bb6:	f0a2                	sd	s0,96(sp)
    80003bb8:	eca6                	sd	s1,88(sp)
    80003bba:	e8ca                	sd	s2,80(sp)
    80003bbc:	e4ce                	sd	s3,72(sp)
    80003bbe:	e0d2                	sd	s4,64(sp)
    80003bc0:	fc56                	sd	s5,56(sp)
    80003bc2:	f85a                	sd	s6,48(sp)
    80003bc4:	f45e                	sd	s7,40(sp)
    80003bc6:	f062                	sd	s8,32(sp)
    80003bc8:	ec66                	sd	s9,24(sp)
    80003bca:	e86a                	sd	s10,16(sp)
    80003bcc:	e46e                	sd	s11,8(sp)
    80003bce:	1880                	addi	s0,sp,112
    80003bd0:	8aaa                	mv	s5,a0
    80003bd2:	8bae                	mv	s7,a1
    80003bd4:	8a32                	mv	s4,a2
    80003bd6:	8936                	mv	s2,a3
    80003bd8:	8b3a                	mv	s6,a4
    80003bda:	00e687bb          	addw	a5,a3,a4
    80003bde:	0ed7e263          	bltu	a5,a3,80003cc2 <writei+0x116>
    80003be2:	00043737          	lui	a4,0x43
    80003be6:	0ef76063          	bltu	a4,a5,80003cc6 <writei+0x11a>
    80003bea:	0c0b0863          	beqz	s6,80003cba <writei+0x10e>
    80003bee:	4981                	li	s3,0
    80003bf0:	40000c93          	li	s9,1024
    80003bf4:	5c7d                	li	s8,-1
    80003bf6:	a091                	j	80003c3a <writei+0x8e>
    80003bf8:	020d1d93          	slli	s11,s10,0x20
    80003bfc:	020ddd93          	srli	s11,s11,0x20
    80003c00:	05848513          	addi	a0,s1,88
    80003c04:	86ee                	mv	a3,s11
    80003c06:	8652                	mv	a2,s4
    80003c08:	85de                	mv	a1,s7
    80003c0a:	953a                	add	a0,a0,a4
    80003c0c:	fffff097          	auipc	ra,0xfffff
    80003c10:	9d2080e7          	jalr	-1582(ra) # 800025de <either_copyin>
    80003c14:	07850263          	beq	a0,s8,80003c78 <writei+0xcc>
    80003c18:	8526                	mv	a0,s1
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	788080e7          	jalr	1928(ra) # 800043a2 <log_write>
    80003c22:	8526                	mv	a0,s1
    80003c24:	fffff097          	auipc	ra,0xfffff
    80003c28:	4f4080e7          	jalr	1268(ra) # 80003118 <brelse>
    80003c2c:	013d09bb          	addw	s3,s10,s3
    80003c30:	012d093b          	addw	s2,s10,s2
    80003c34:	9a6e                	add	s4,s4,s11
    80003c36:	0569f663          	bgeu	s3,s6,80003c82 <writei+0xd6>
    80003c3a:	00a9559b          	srliw	a1,s2,0xa
    80003c3e:	8556                	mv	a0,s5
    80003c40:	fffff097          	auipc	ra,0xfffff
    80003c44:	79c080e7          	jalr	1948(ra) # 800033dc <bmap>
    80003c48:	0005059b          	sext.w	a1,a0
    80003c4c:	c99d                	beqz	a1,80003c82 <writei+0xd6>
    80003c4e:	000aa503          	lw	a0,0(s5)
    80003c52:	fffff097          	auipc	ra,0xfffff
    80003c56:	396080e7          	jalr	918(ra) # 80002fe8 <bread>
    80003c5a:	84aa                	mv	s1,a0
    80003c5c:	3ff97713          	andi	a4,s2,1023
    80003c60:	40ec87bb          	subw	a5,s9,a4
    80003c64:	413b06bb          	subw	a3,s6,s3
    80003c68:	8d3e                	mv	s10,a5
    80003c6a:	2781                	sext.w	a5,a5
    80003c6c:	0006861b          	sext.w	a2,a3
    80003c70:	f8f674e3          	bgeu	a2,a5,80003bf8 <writei+0x4c>
    80003c74:	8d36                	mv	s10,a3
    80003c76:	b749                	j	80003bf8 <writei+0x4c>
    80003c78:	8526                	mv	a0,s1
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	49e080e7          	jalr	1182(ra) # 80003118 <brelse>
    80003c82:	04caa783          	lw	a5,76(s5)
    80003c86:	0127f463          	bgeu	a5,s2,80003c8e <writei+0xe2>
    80003c8a:	052aa623          	sw	s2,76(s5)
    80003c8e:	8556                	mv	a0,s5
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	aa4080e7          	jalr	-1372(ra) # 80003734 <iupdate>
    80003c98:	0009851b          	sext.w	a0,s3
    80003c9c:	70a6                	ld	ra,104(sp)
    80003c9e:	7406                	ld	s0,96(sp)
    80003ca0:	64e6                	ld	s1,88(sp)
    80003ca2:	6946                	ld	s2,80(sp)
    80003ca4:	69a6                	ld	s3,72(sp)
    80003ca6:	6a06                	ld	s4,64(sp)
    80003ca8:	7ae2                	ld	s5,56(sp)
    80003caa:	7b42                	ld	s6,48(sp)
    80003cac:	7ba2                	ld	s7,40(sp)
    80003cae:	7c02                	ld	s8,32(sp)
    80003cb0:	6ce2                	ld	s9,24(sp)
    80003cb2:	6d42                	ld	s10,16(sp)
    80003cb4:	6da2                	ld	s11,8(sp)
    80003cb6:	6165                	addi	sp,sp,112
    80003cb8:	8082                	ret
    80003cba:	89da                	mv	s3,s6
    80003cbc:	bfc9                	j	80003c8e <writei+0xe2>
    80003cbe:	557d                	li	a0,-1
    80003cc0:	8082                	ret
    80003cc2:	557d                	li	a0,-1
    80003cc4:	bfe1                	j	80003c9c <writei+0xf0>
    80003cc6:	557d                	li	a0,-1
    80003cc8:	bfd1                	j	80003c9c <writei+0xf0>

0000000080003cca <namecmp>:
    80003cca:	1141                	addi	sp,sp,-16
    80003ccc:	e406                	sd	ra,8(sp)
    80003cce:	e022                	sd	s0,0(sp)
    80003cd0:	0800                	addi	s0,sp,16
    80003cd2:	4639                	li	a2,14
    80003cd4:	ffffd097          	auipc	ra,0xffffd
    80003cd8:	0ce080e7          	jalr	206(ra) # 80000da2 <strncmp>
    80003cdc:	60a2                	ld	ra,8(sp)
    80003cde:	6402                	ld	s0,0(sp)
    80003ce0:	0141                	addi	sp,sp,16
    80003ce2:	8082                	ret

0000000080003ce4 <dirlookup>:
    80003ce4:	7139                	addi	sp,sp,-64
    80003ce6:	fc06                	sd	ra,56(sp)
    80003ce8:	f822                	sd	s0,48(sp)
    80003cea:	f426                	sd	s1,40(sp)
    80003cec:	f04a                	sd	s2,32(sp)
    80003cee:	ec4e                	sd	s3,24(sp)
    80003cf0:	e852                	sd	s4,16(sp)
    80003cf2:	0080                	addi	s0,sp,64
    80003cf4:	04451703          	lh	a4,68(a0)
    80003cf8:	4785                	li	a5,1
    80003cfa:	00f71a63          	bne	a4,a5,80003d0e <dirlookup+0x2a>
    80003cfe:	892a                	mv	s2,a0
    80003d00:	89ae                	mv	s3,a1
    80003d02:	8a32                	mv	s4,a2
    80003d04:	457c                	lw	a5,76(a0)
    80003d06:	4481                	li	s1,0
    80003d08:	4501                	li	a0,0
    80003d0a:	e79d                	bnez	a5,80003d38 <dirlookup+0x54>
    80003d0c:	a8a5                	j	80003d84 <dirlookup+0xa0>
    80003d0e:	00005517          	auipc	a0,0x5
    80003d12:	97a50513          	addi	a0,a0,-1670 # 80008688 <syscalls+0x1a8>
    80003d16:	ffffd097          	auipc	ra,0xffffd
    80003d1a:	82a080e7          	jalr	-2006(ra) # 80000540 <panic>
    80003d1e:	00005517          	auipc	a0,0x5
    80003d22:	98250513          	addi	a0,a0,-1662 # 800086a0 <syscalls+0x1c0>
    80003d26:	ffffd097          	auipc	ra,0xffffd
    80003d2a:	81a080e7          	jalr	-2022(ra) # 80000540 <panic>
    80003d2e:	24c1                	addiw	s1,s1,16
    80003d30:	04c92783          	lw	a5,76(s2)
    80003d34:	04f4f763          	bgeu	s1,a5,80003d82 <dirlookup+0x9e>
    80003d38:	4741                	li	a4,16
    80003d3a:	86a6                	mv	a3,s1
    80003d3c:	fc040613          	addi	a2,s0,-64
    80003d40:	4581                	li	a1,0
    80003d42:	854a                	mv	a0,s2
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	d70080e7          	jalr	-656(ra) # 80003ab4 <readi>
    80003d4c:	47c1                	li	a5,16
    80003d4e:	fcf518e3          	bne	a0,a5,80003d1e <dirlookup+0x3a>
    80003d52:	fc045783          	lhu	a5,-64(s0)
    80003d56:	dfe1                	beqz	a5,80003d2e <dirlookup+0x4a>
    80003d58:	fc240593          	addi	a1,s0,-62
    80003d5c:	854e                	mv	a0,s3
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	f6c080e7          	jalr	-148(ra) # 80003cca <namecmp>
    80003d66:	f561                	bnez	a0,80003d2e <dirlookup+0x4a>
    80003d68:	000a0463          	beqz	s4,80003d70 <dirlookup+0x8c>
    80003d6c:	009a2023          	sw	s1,0(s4)
    80003d70:	fc045583          	lhu	a1,-64(s0)
    80003d74:	00092503          	lw	a0,0(s2)
    80003d78:	fffff097          	auipc	ra,0xfffff
    80003d7c:	74e080e7          	jalr	1870(ra) # 800034c6 <iget>
    80003d80:	a011                	j	80003d84 <dirlookup+0xa0>
    80003d82:	4501                	li	a0,0
    80003d84:	70e2                	ld	ra,56(sp)
    80003d86:	7442                	ld	s0,48(sp)
    80003d88:	74a2                	ld	s1,40(sp)
    80003d8a:	7902                	ld	s2,32(sp)
    80003d8c:	69e2                	ld	s3,24(sp)
    80003d8e:	6a42                	ld	s4,16(sp)
    80003d90:	6121                	addi	sp,sp,64
    80003d92:	8082                	ret

0000000080003d94 <namex>:
    80003d94:	711d                	addi	sp,sp,-96
    80003d96:	ec86                	sd	ra,88(sp)
    80003d98:	e8a2                	sd	s0,80(sp)
    80003d9a:	e4a6                	sd	s1,72(sp)
    80003d9c:	e0ca                	sd	s2,64(sp)
    80003d9e:	fc4e                	sd	s3,56(sp)
    80003da0:	f852                	sd	s4,48(sp)
    80003da2:	f456                	sd	s5,40(sp)
    80003da4:	f05a                	sd	s6,32(sp)
    80003da6:	ec5e                	sd	s7,24(sp)
    80003da8:	e862                	sd	s8,16(sp)
    80003daa:	e466                	sd	s9,8(sp)
    80003dac:	e06a                	sd	s10,0(sp)
    80003dae:	1080                	addi	s0,sp,96
    80003db0:	84aa                	mv	s1,a0
    80003db2:	8b2e                	mv	s6,a1
    80003db4:	8ab2                	mv	s5,a2
    80003db6:	00054703          	lbu	a4,0(a0)
    80003dba:	02f00793          	li	a5,47
    80003dbe:	02f70363          	beq	a4,a5,80003de4 <namex+0x50>
    80003dc2:	ffffe097          	auipc	ra,0xffffe
    80003dc6:	bfc080e7          	jalr	-1028(ra) # 800019be <myproc>
    80003dca:	15853503          	ld	a0,344(a0)
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	9f4080e7          	jalr	-1548(ra) # 800037c2 <idup>
    80003dd6:	8a2a                	mv	s4,a0
    80003dd8:	02f00913          	li	s2,47
    80003ddc:	4cb5                	li	s9,13
    80003dde:	4b81                	li	s7,0
    80003de0:	4c05                	li	s8,1
    80003de2:	a87d                	j	80003ea0 <namex+0x10c>
    80003de4:	4585                	li	a1,1
    80003de6:	4505                	li	a0,1
    80003de8:	fffff097          	auipc	ra,0xfffff
    80003dec:	6de080e7          	jalr	1758(ra) # 800034c6 <iget>
    80003df0:	8a2a                	mv	s4,a0
    80003df2:	b7dd                	j	80003dd8 <namex+0x44>
    80003df4:	8552                	mv	a0,s4
    80003df6:	00000097          	auipc	ra,0x0
    80003dfa:	c6c080e7          	jalr	-916(ra) # 80003a62 <iunlockput>
    80003dfe:	4a01                	li	s4,0
    80003e00:	8552                	mv	a0,s4
    80003e02:	60e6                	ld	ra,88(sp)
    80003e04:	6446                	ld	s0,80(sp)
    80003e06:	64a6                	ld	s1,72(sp)
    80003e08:	6906                	ld	s2,64(sp)
    80003e0a:	79e2                	ld	s3,56(sp)
    80003e0c:	7a42                	ld	s4,48(sp)
    80003e0e:	7aa2                	ld	s5,40(sp)
    80003e10:	7b02                	ld	s6,32(sp)
    80003e12:	6be2                	ld	s7,24(sp)
    80003e14:	6c42                	ld	s8,16(sp)
    80003e16:	6ca2                	ld	s9,8(sp)
    80003e18:	6d02                	ld	s10,0(sp)
    80003e1a:	6125                	addi	sp,sp,96
    80003e1c:	8082                	ret
    80003e1e:	8552                	mv	a0,s4
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	aa2080e7          	jalr	-1374(ra) # 800038c2 <iunlock>
    80003e28:	bfe1                	j	80003e00 <namex+0x6c>
    80003e2a:	8552                	mv	a0,s4
    80003e2c:	00000097          	auipc	ra,0x0
    80003e30:	c36080e7          	jalr	-970(ra) # 80003a62 <iunlockput>
    80003e34:	8a4e                	mv	s4,s3
    80003e36:	b7e9                	j	80003e00 <namex+0x6c>
    80003e38:	40998633          	sub	a2,s3,s1
    80003e3c:	00060d1b          	sext.w	s10,a2
    80003e40:	09acd863          	bge	s9,s10,80003ed0 <namex+0x13c>
    80003e44:	4639                	li	a2,14
    80003e46:	85a6                	mv	a1,s1
    80003e48:	8556                	mv	a0,s5
    80003e4a:	ffffd097          	auipc	ra,0xffffd
    80003e4e:	ee4080e7          	jalr	-284(ra) # 80000d2e <memmove>
    80003e52:	84ce                	mv	s1,s3
    80003e54:	0004c783          	lbu	a5,0(s1)
    80003e58:	01279763          	bne	a5,s2,80003e66 <namex+0xd2>
    80003e5c:	0485                	addi	s1,s1,1
    80003e5e:	0004c783          	lbu	a5,0(s1)
    80003e62:	ff278de3          	beq	a5,s2,80003e5c <namex+0xc8>
    80003e66:	8552                	mv	a0,s4
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	998080e7          	jalr	-1640(ra) # 80003800 <ilock>
    80003e70:	044a1783          	lh	a5,68(s4)
    80003e74:	f98790e3          	bne	a5,s8,80003df4 <namex+0x60>
    80003e78:	000b0563          	beqz	s6,80003e82 <namex+0xee>
    80003e7c:	0004c783          	lbu	a5,0(s1)
    80003e80:	dfd9                	beqz	a5,80003e1e <namex+0x8a>
    80003e82:	865e                	mv	a2,s7
    80003e84:	85d6                	mv	a1,s5
    80003e86:	8552                	mv	a0,s4
    80003e88:	00000097          	auipc	ra,0x0
    80003e8c:	e5c080e7          	jalr	-420(ra) # 80003ce4 <dirlookup>
    80003e90:	89aa                	mv	s3,a0
    80003e92:	dd41                	beqz	a0,80003e2a <namex+0x96>
    80003e94:	8552                	mv	a0,s4
    80003e96:	00000097          	auipc	ra,0x0
    80003e9a:	bcc080e7          	jalr	-1076(ra) # 80003a62 <iunlockput>
    80003e9e:	8a4e                	mv	s4,s3
    80003ea0:	0004c783          	lbu	a5,0(s1)
    80003ea4:	01279763          	bne	a5,s2,80003eb2 <namex+0x11e>
    80003ea8:	0485                	addi	s1,s1,1
    80003eaa:	0004c783          	lbu	a5,0(s1)
    80003eae:	ff278de3          	beq	a5,s2,80003ea8 <namex+0x114>
    80003eb2:	cb9d                	beqz	a5,80003ee8 <namex+0x154>
    80003eb4:	0004c783          	lbu	a5,0(s1)
    80003eb8:	89a6                	mv	s3,s1
    80003eba:	8d5e                	mv	s10,s7
    80003ebc:	865e                	mv	a2,s7
    80003ebe:	01278963          	beq	a5,s2,80003ed0 <namex+0x13c>
    80003ec2:	dbbd                	beqz	a5,80003e38 <namex+0xa4>
    80003ec4:	0985                	addi	s3,s3,1
    80003ec6:	0009c783          	lbu	a5,0(s3)
    80003eca:	ff279ce3          	bne	a5,s2,80003ec2 <namex+0x12e>
    80003ece:	b7ad                	j	80003e38 <namex+0xa4>
    80003ed0:	2601                	sext.w	a2,a2
    80003ed2:	85a6                	mv	a1,s1
    80003ed4:	8556                	mv	a0,s5
    80003ed6:	ffffd097          	auipc	ra,0xffffd
    80003eda:	e58080e7          	jalr	-424(ra) # 80000d2e <memmove>
    80003ede:	9d56                	add	s10,s10,s5
    80003ee0:	000d0023          	sb	zero,0(s10)
    80003ee4:	84ce                	mv	s1,s3
    80003ee6:	b7bd                	j	80003e54 <namex+0xc0>
    80003ee8:	f00b0ce3          	beqz	s6,80003e00 <namex+0x6c>
    80003eec:	8552                	mv	a0,s4
    80003eee:	00000097          	auipc	ra,0x0
    80003ef2:	acc080e7          	jalr	-1332(ra) # 800039ba <iput>
    80003ef6:	4a01                	li	s4,0
    80003ef8:	b721                	j	80003e00 <namex+0x6c>

0000000080003efa <dirlink>:
    80003efa:	7139                	addi	sp,sp,-64
    80003efc:	fc06                	sd	ra,56(sp)
    80003efe:	f822                	sd	s0,48(sp)
    80003f00:	f426                	sd	s1,40(sp)
    80003f02:	f04a                	sd	s2,32(sp)
    80003f04:	ec4e                	sd	s3,24(sp)
    80003f06:	e852                	sd	s4,16(sp)
    80003f08:	0080                	addi	s0,sp,64
    80003f0a:	892a                	mv	s2,a0
    80003f0c:	8a2e                	mv	s4,a1
    80003f0e:	89b2                	mv	s3,a2
    80003f10:	4601                	li	a2,0
    80003f12:	00000097          	auipc	ra,0x0
    80003f16:	dd2080e7          	jalr	-558(ra) # 80003ce4 <dirlookup>
    80003f1a:	e93d                	bnez	a0,80003f90 <dirlink+0x96>
    80003f1c:	04c92483          	lw	s1,76(s2)
    80003f20:	c49d                	beqz	s1,80003f4e <dirlink+0x54>
    80003f22:	4481                	li	s1,0
    80003f24:	4741                	li	a4,16
    80003f26:	86a6                	mv	a3,s1
    80003f28:	fc040613          	addi	a2,s0,-64
    80003f2c:	4581                	li	a1,0
    80003f2e:	854a                	mv	a0,s2
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	b84080e7          	jalr	-1148(ra) # 80003ab4 <readi>
    80003f38:	47c1                	li	a5,16
    80003f3a:	06f51163          	bne	a0,a5,80003f9c <dirlink+0xa2>
    80003f3e:	fc045783          	lhu	a5,-64(s0)
    80003f42:	c791                	beqz	a5,80003f4e <dirlink+0x54>
    80003f44:	24c1                	addiw	s1,s1,16
    80003f46:	04c92783          	lw	a5,76(s2)
    80003f4a:	fcf4ede3          	bltu	s1,a5,80003f24 <dirlink+0x2a>
    80003f4e:	4639                	li	a2,14
    80003f50:	85d2                	mv	a1,s4
    80003f52:	fc240513          	addi	a0,s0,-62
    80003f56:	ffffd097          	auipc	ra,0xffffd
    80003f5a:	e88080e7          	jalr	-376(ra) # 80000dde <strncpy>
    80003f5e:	fd341023          	sh	s3,-64(s0)
    80003f62:	4741                	li	a4,16
    80003f64:	86a6                	mv	a3,s1
    80003f66:	fc040613          	addi	a2,s0,-64
    80003f6a:	4581                	li	a1,0
    80003f6c:	854a                	mv	a0,s2
    80003f6e:	00000097          	auipc	ra,0x0
    80003f72:	c3e080e7          	jalr	-962(ra) # 80003bac <writei>
    80003f76:	1541                	addi	a0,a0,-16
    80003f78:	00a03533          	snez	a0,a0
    80003f7c:	40a00533          	neg	a0,a0
    80003f80:	70e2                	ld	ra,56(sp)
    80003f82:	7442                	ld	s0,48(sp)
    80003f84:	74a2                	ld	s1,40(sp)
    80003f86:	7902                	ld	s2,32(sp)
    80003f88:	69e2                	ld	s3,24(sp)
    80003f8a:	6a42                	ld	s4,16(sp)
    80003f8c:	6121                	addi	sp,sp,64
    80003f8e:	8082                	ret
    80003f90:	00000097          	auipc	ra,0x0
    80003f94:	a2a080e7          	jalr	-1494(ra) # 800039ba <iput>
    80003f98:	557d                	li	a0,-1
    80003f9a:	b7dd                	j	80003f80 <dirlink+0x86>
    80003f9c:	00004517          	auipc	a0,0x4
    80003fa0:	71450513          	addi	a0,a0,1812 # 800086b0 <syscalls+0x1d0>
    80003fa4:	ffffc097          	auipc	ra,0xffffc
    80003fa8:	59c080e7          	jalr	1436(ra) # 80000540 <panic>

0000000080003fac <namei>:
    80003fac:	1101                	addi	sp,sp,-32
    80003fae:	ec06                	sd	ra,24(sp)
    80003fb0:	e822                	sd	s0,16(sp)
    80003fb2:	1000                	addi	s0,sp,32
    80003fb4:	fe040613          	addi	a2,s0,-32
    80003fb8:	4581                	li	a1,0
    80003fba:	00000097          	auipc	ra,0x0
    80003fbe:	dda080e7          	jalr	-550(ra) # 80003d94 <namex>
    80003fc2:	60e2                	ld	ra,24(sp)
    80003fc4:	6442                	ld	s0,16(sp)
    80003fc6:	6105                	addi	sp,sp,32
    80003fc8:	8082                	ret

0000000080003fca <nameiparent>:
    80003fca:	1141                	addi	sp,sp,-16
    80003fcc:	e406                	sd	ra,8(sp)
    80003fce:	e022                	sd	s0,0(sp)
    80003fd0:	0800                	addi	s0,sp,16
    80003fd2:	862e                	mv	a2,a1
    80003fd4:	4585                	li	a1,1
    80003fd6:	00000097          	auipc	ra,0x0
    80003fda:	dbe080e7          	jalr	-578(ra) # 80003d94 <namex>
    80003fde:	60a2                	ld	ra,8(sp)
    80003fe0:	6402                	ld	s0,0(sp)
    80003fe2:	0141                	addi	sp,sp,16
    80003fe4:	8082                	ret

0000000080003fe6 <write_head>:
    80003fe6:	1101                	addi	sp,sp,-32
    80003fe8:	ec06                	sd	ra,24(sp)
    80003fea:	e822                	sd	s0,16(sp)
    80003fec:	e426                	sd	s1,8(sp)
    80003fee:	e04a                	sd	s2,0(sp)
    80003ff0:	1000                	addi	s0,sp,32
    80003ff2:	0001d917          	auipc	s2,0x1d
    80003ff6:	dce90913          	addi	s2,s2,-562 # 80020dc0 <log>
    80003ffa:	01892583          	lw	a1,24(s2)
    80003ffe:	02892503          	lw	a0,40(s2)
    80004002:	fffff097          	auipc	ra,0xfffff
    80004006:	fe6080e7          	jalr	-26(ra) # 80002fe8 <bread>
    8000400a:	84aa                	mv	s1,a0
    8000400c:	02c92683          	lw	a3,44(s2)
    80004010:	cd34                	sw	a3,88(a0)
    80004012:	02d05863          	blez	a3,80004042 <write_head+0x5c>
    80004016:	0001d797          	auipc	a5,0x1d
    8000401a:	dda78793          	addi	a5,a5,-550 # 80020df0 <log+0x30>
    8000401e:	05c50713          	addi	a4,a0,92
    80004022:	36fd                	addiw	a3,a3,-1
    80004024:	02069613          	slli	a2,a3,0x20
    80004028:	01e65693          	srli	a3,a2,0x1e
    8000402c:	0001d617          	auipc	a2,0x1d
    80004030:	dc860613          	addi	a2,a2,-568 # 80020df4 <log+0x34>
    80004034:	96b2                	add	a3,a3,a2
    80004036:	4390                	lw	a2,0(a5)
    80004038:	c310                	sw	a2,0(a4)
    8000403a:	0791                	addi	a5,a5,4
    8000403c:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000403e:	fed79ce3          	bne	a5,a3,80004036 <write_head+0x50>
    80004042:	8526                	mv	a0,s1
    80004044:	fffff097          	auipc	ra,0xfffff
    80004048:	096080e7          	jalr	150(ra) # 800030da <bwrite>
    8000404c:	8526                	mv	a0,s1
    8000404e:	fffff097          	auipc	ra,0xfffff
    80004052:	0ca080e7          	jalr	202(ra) # 80003118 <brelse>
    80004056:	60e2                	ld	ra,24(sp)
    80004058:	6442                	ld	s0,16(sp)
    8000405a:	64a2                	ld	s1,8(sp)
    8000405c:	6902                	ld	s2,0(sp)
    8000405e:	6105                	addi	sp,sp,32
    80004060:	8082                	ret

0000000080004062 <install_trans>:
    80004062:	0001d797          	auipc	a5,0x1d
    80004066:	d8a7a783          	lw	a5,-630(a5) # 80020dec <log+0x2c>
    8000406a:	0af05d63          	blez	a5,80004124 <install_trans+0xc2>
    8000406e:	7139                	addi	sp,sp,-64
    80004070:	fc06                	sd	ra,56(sp)
    80004072:	f822                	sd	s0,48(sp)
    80004074:	f426                	sd	s1,40(sp)
    80004076:	f04a                	sd	s2,32(sp)
    80004078:	ec4e                	sd	s3,24(sp)
    8000407a:	e852                	sd	s4,16(sp)
    8000407c:	e456                	sd	s5,8(sp)
    8000407e:	e05a                	sd	s6,0(sp)
    80004080:	0080                	addi	s0,sp,64
    80004082:	8b2a                	mv	s6,a0
    80004084:	0001da97          	auipc	s5,0x1d
    80004088:	d6ca8a93          	addi	s5,s5,-660 # 80020df0 <log+0x30>
    8000408c:	4a01                	li	s4,0
    8000408e:	0001d997          	auipc	s3,0x1d
    80004092:	d3298993          	addi	s3,s3,-718 # 80020dc0 <log>
    80004096:	a00d                	j	800040b8 <install_trans+0x56>
    80004098:	854a                	mv	a0,s2
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	07e080e7          	jalr	126(ra) # 80003118 <brelse>
    800040a2:	8526                	mv	a0,s1
    800040a4:	fffff097          	auipc	ra,0xfffff
    800040a8:	074080e7          	jalr	116(ra) # 80003118 <brelse>
    800040ac:	2a05                	addiw	s4,s4,1
    800040ae:	0a91                	addi	s5,s5,4
    800040b0:	02c9a783          	lw	a5,44(s3)
    800040b4:	04fa5e63          	bge	s4,a5,80004110 <install_trans+0xae>
    800040b8:	0189a583          	lw	a1,24(s3)
    800040bc:	014585bb          	addw	a1,a1,s4
    800040c0:	2585                	addiw	a1,a1,1
    800040c2:	0289a503          	lw	a0,40(s3)
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	f22080e7          	jalr	-222(ra) # 80002fe8 <bread>
    800040ce:	892a                	mv	s2,a0
    800040d0:	000aa583          	lw	a1,0(s5)
    800040d4:	0289a503          	lw	a0,40(s3)
    800040d8:	fffff097          	auipc	ra,0xfffff
    800040dc:	f10080e7          	jalr	-240(ra) # 80002fe8 <bread>
    800040e0:	84aa                	mv	s1,a0
    800040e2:	40000613          	li	a2,1024
    800040e6:	05890593          	addi	a1,s2,88
    800040ea:	05850513          	addi	a0,a0,88
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	c40080e7          	jalr	-960(ra) # 80000d2e <memmove>
    800040f6:	8526                	mv	a0,s1
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	fe2080e7          	jalr	-30(ra) # 800030da <bwrite>
    80004100:	f80b1ce3          	bnez	s6,80004098 <install_trans+0x36>
    80004104:	8526                	mv	a0,s1
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	0ec080e7          	jalr	236(ra) # 800031f2 <bunpin>
    8000410e:	b769                	j	80004098 <install_trans+0x36>
    80004110:	70e2                	ld	ra,56(sp)
    80004112:	7442                	ld	s0,48(sp)
    80004114:	74a2                	ld	s1,40(sp)
    80004116:	7902                	ld	s2,32(sp)
    80004118:	69e2                	ld	s3,24(sp)
    8000411a:	6a42                	ld	s4,16(sp)
    8000411c:	6aa2                	ld	s5,8(sp)
    8000411e:	6b02                	ld	s6,0(sp)
    80004120:	6121                	addi	sp,sp,64
    80004122:	8082                	ret
    80004124:	8082                	ret

0000000080004126 <initlog>:
    80004126:	7179                	addi	sp,sp,-48
    80004128:	f406                	sd	ra,40(sp)
    8000412a:	f022                	sd	s0,32(sp)
    8000412c:	ec26                	sd	s1,24(sp)
    8000412e:	e84a                	sd	s2,16(sp)
    80004130:	e44e                	sd	s3,8(sp)
    80004132:	1800                	addi	s0,sp,48
    80004134:	892a                	mv	s2,a0
    80004136:	89ae                	mv	s3,a1
    80004138:	0001d497          	auipc	s1,0x1d
    8000413c:	c8848493          	addi	s1,s1,-888 # 80020dc0 <log>
    80004140:	00004597          	auipc	a1,0x4
    80004144:	58058593          	addi	a1,a1,1408 # 800086c0 <syscalls+0x1e0>
    80004148:	8526                	mv	a0,s1
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	9fc080e7          	jalr	-1540(ra) # 80000b46 <initlock>
    80004152:	0149a583          	lw	a1,20(s3)
    80004156:	cc8c                	sw	a1,24(s1)
    80004158:	0109a783          	lw	a5,16(s3)
    8000415c:	ccdc                	sw	a5,28(s1)
    8000415e:	0324a423          	sw	s2,40(s1)
    80004162:	854a                	mv	a0,s2
    80004164:	fffff097          	auipc	ra,0xfffff
    80004168:	e84080e7          	jalr	-380(ra) # 80002fe8 <bread>
    8000416c:	4d34                	lw	a3,88(a0)
    8000416e:	d4d4                	sw	a3,44(s1)
    80004170:	02d05663          	blez	a3,8000419c <initlog+0x76>
    80004174:	05c50793          	addi	a5,a0,92
    80004178:	0001d717          	auipc	a4,0x1d
    8000417c:	c7870713          	addi	a4,a4,-904 # 80020df0 <log+0x30>
    80004180:	36fd                	addiw	a3,a3,-1
    80004182:	02069613          	slli	a2,a3,0x20
    80004186:	01e65693          	srli	a3,a2,0x1e
    8000418a:	06050613          	addi	a2,a0,96
    8000418e:	96b2                	add	a3,a3,a2
    80004190:	4390                	lw	a2,0(a5)
    80004192:	c310                	sw	a2,0(a4)
    80004194:	0791                	addi	a5,a5,4
    80004196:	0711                	addi	a4,a4,4
    80004198:	fed79ce3          	bne	a5,a3,80004190 <initlog+0x6a>
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	f7c080e7          	jalr	-132(ra) # 80003118 <brelse>
    800041a4:	4505                	li	a0,1
    800041a6:	00000097          	auipc	ra,0x0
    800041aa:	ebc080e7          	jalr	-324(ra) # 80004062 <install_trans>
    800041ae:	0001d797          	auipc	a5,0x1d
    800041b2:	c207af23          	sw	zero,-962(a5) # 80020dec <log+0x2c>
    800041b6:	00000097          	auipc	ra,0x0
    800041ba:	e30080e7          	jalr	-464(ra) # 80003fe6 <write_head>
    800041be:	70a2                	ld	ra,40(sp)
    800041c0:	7402                	ld	s0,32(sp)
    800041c2:	64e2                	ld	s1,24(sp)
    800041c4:	6942                	ld	s2,16(sp)
    800041c6:	69a2                	ld	s3,8(sp)
    800041c8:	6145                	addi	sp,sp,48
    800041ca:	8082                	ret

00000000800041cc <begin_op>:
    800041cc:	1101                	addi	sp,sp,-32
    800041ce:	ec06                	sd	ra,24(sp)
    800041d0:	e822                	sd	s0,16(sp)
    800041d2:	e426                	sd	s1,8(sp)
    800041d4:	e04a                	sd	s2,0(sp)
    800041d6:	1000                	addi	s0,sp,32
    800041d8:	0001d517          	auipc	a0,0x1d
    800041dc:	be850513          	addi	a0,a0,-1048 # 80020dc0 <log>
    800041e0:	ffffd097          	auipc	ra,0xffffd
    800041e4:	9f6080e7          	jalr	-1546(ra) # 80000bd6 <acquire>
    800041e8:	0001d497          	auipc	s1,0x1d
    800041ec:	bd848493          	addi	s1,s1,-1064 # 80020dc0 <log>
    800041f0:	4979                	li	s2,30
    800041f2:	a039                	j	80004200 <begin_op+0x34>
    800041f4:	85a6                	mv	a1,s1
    800041f6:	8526                	mv	a0,s1
    800041f8:	ffffe097          	auipc	ra,0xffffe
    800041fc:	f7a080e7          	jalr	-134(ra) # 80002172 <sleep>
    80004200:	50dc                	lw	a5,36(s1)
    80004202:	fbed                	bnez	a5,800041f4 <begin_op+0x28>
    80004204:	5098                	lw	a4,32(s1)
    80004206:	2705                	addiw	a4,a4,1
    80004208:	0007069b          	sext.w	a3,a4
    8000420c:	0027179b          	slliw	a5,a4,0x2
    80004210:	9fb9                	addw	a5,a5,a4
    80004212:	0017979b          	slliw	a5,a5,0x1
    80004216:	54d8                	lw	a4,44(s1)
    80004218:	9fb9                	addw	a5,a5,a4
    8000421a:	00f95963          	bge	s2,a5,8000422c <begin_op+0x60>
    8000421e:	85a6                	mv	a1,s1
    80004220:	8526                	mv	a0,s1
    80004222:	ffffe097          	auipc	ra,0xffffe
    80004226:	f50080e7          	jalr	-176(ra) # 80002172 <sleep>
    8000422a:	bfd9                	j	80004200 <begin_op+0x34>
    8000422c:	0001d517          	auipc	a0,0x1d
    80004230:	b9450513          	addi	a0,a0,-1132 # 80020dc0 <log>
    80004234:	d114                	sw	a3,32(a0)
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	a54080e7          	jalr	-1452(ra) # 80000c8a <release>
    8000423e:	60e2                	ld	ra,24(sp)
    80004240:	6442                	ld	s0,16(sp)
    80004242:	64a2                	ld	s1,8(sp)
    80004244:	6902                	ld	s2,0(sp)
    80004246:	6105                	addi	sp,sp,32
    80004248:	8082                	ret

000000008000424a <end_op>:
    8000424a:	7139                	addi	sp,sp,-64
    8000424c:	fc06                	sd	ra,56(sp)
    8000424e:	f822                	sd	s0,48(sp)
    80004250:	f426                	sd	s1,40(sp)
    80004252:	f04a                	sd	s2,32(sp)
    80004254:	ec4e                	sd	s3,24(sp)
    80004256:	e852                	sd	s4,16(sp)
    80004258:	e456                	sd	s5,8(sp)
    8000425a:	0080                	addi	s0,sp,64
    8000425c:	0001d497          	auipc	s1,0x1d
    80004260:	b6448493          	addi	s1,s1,-1180 # 80020dc0 <log>
    80004264:	8526                	mv	a0,s1
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	970080e7          	jalr	-1680(ra) # 80000bd6 <acquire>
    8000426e:	509c                	lw	a5,32(s1)
    80004270:	37fd                	addiw	a5,a5,-1
    80004272:	0007891b          	sext.w	s2,a5
    80004276:	d09c                	sw	a5,32(s1)
    80004278:	50dc                	lw	a5,36(s1)
    8000427a:	e7b9                	bnez	a5,800042c8 <end_op+0x7e>
    8000427c:	04091e63          	bnez	s2,800042d8 <end_op+0x8e>
    80004280:	0001d497          	auipc	s1,0x1d
    80004284:	b4048493          	addi	s1,s1,-1216 # 80020dc0 <log>
    80004288:	4785                	li	a5,1
    8000428a:	d0dc                	sw	a5,36(s1)
    8000428c:	8526                	mv	a0,s1
    8000428e:	ffffd097          	auipc	ra,0xffffd
    80004292:	9fc080e7          	jalr	-1540(ra) # 80000c8a <release>
    80004296:	54dc                	lw	a5,44(s1)
    80004298:	06f04763          	bgtz	a5,80004306 <end_op+0xbc>
    8000429c:	0001d497          	auipc	s1,0x1d
    800042a0:	b2448493          	addi	s1,s1,-1244 # 80020dc0 <log>
    800042a4:	8526                	mv	a0,s1
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	930080e7          	jalr	-1744(ra) # 80000bd6 <acquire>
    800042ae:	0204a223          	sw	zero,36(s1)
    800042b2:	8526                	mv	a0,s1
    800042b4:	ffffe097          	auipc	ra,0xffffe
    800042b8:	f30080e7          	jalr	-208(ra) # 800021e4 <wakeup>
    800042bc:	8526                	mv	a0,s1
    800042be:	ffffd097          	auipc	ra,0xffffd
    800042c2:	9cc080e7          	jalr	-1588(ra) # 80000c8a <release>
    800042c6:	a03d                	j	800042f4 <end_op+0xaa>
    800042c8:	00004517          	auipc	a0,0x4
    800042cc:	40050513          	addi	a0,a0,1024 # 800086c8 <syscalls+0x1e8>
    800042d0:	ffffc097          	auipc	ra,0xffffc
    800042d4:	270080e7          	jalr	624(ra) # 80000540 <panic>
    800042d8:	0001d497          	auipc	s1,0x1d
    800042dc:	ae848493          	addi	s1,s1,-1304 # 80020dc0 <log>
    800042e0:	8526                	mv	a0,s1
    800042e2:	ffffe097          	auipc	ra,0xffffe
    800042e6:	f02080e7          	jalr	-254(ra) # 800021e4 <wakeup>
    800042ea:	8526                	mv	a0,s1
    800042ec:	ffffd097          	auipc	ra,0xffffd
    800042f0:	99e080e7          	jalr	-1634(ra) # 80000c8a <release>
    800042f4:	70e2                	ld	ra,56(sp)
    800042f6:	7442                	ld	s0,48(sp)
    800042f8:	74a2                	ld	s1,40(sp)
    800042fa:	7902                	ld	s2,32(sp)
    800042fc:	69e2                	ld	s3,24(sp)
    800042fe:	6a42                	ld	s4,16(sp)
    80004300:	6aa2                	ld	s5,8(sp)
    80004302:	6121                	addi	sp,sp,64
    80004304:	8082                	ret
    80004306:	0001da97          	auipc	s5,0x1d
    8000430a:	aeaa8a93          	addi	s5,s5,-1302 # 80020df0 <log+0x30>
    8000430e:	0001da17          	auipc	s4,0x1d
    80004312:	ab2a0a13          	addi	s4,s4,-1358 # 80020dc0 <log>
    80004316:	018a2583          	lw	a1,24(s4)
    8000431a:	012585bb          	addw	a1,a1,s2
    8000431e:	2585                	addiw	a1,a1,1
    80004320:	028a2503          	lw	a0,40(s4)
    80004324:	fffff097          	auipc	ra,0xfffff
    80004328:	cc4080e7          	jalr	-828(ra) # 80002fe8 <bread>
    8000432c:	84aa                	mv	s1,a0
    8000432e:	000aa583          	lw	a1,0(s5)
    80004332:	028a2503          	lw	a0,40(s4)
    80004336:	fffff097          	auipc	ra,0xfffff
    8000433a:	cb2080e7          	jalr	-846(ra) # 80002fe8 <bread>
    8000433e:	89aa                	mv	s3,a0
    80004340:	40000613          	li	a2,1024
    80004344:	05850593          	addi	a1,a0,88
    80004348:	05848513          	addi	a0,s1,88
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	9e2080e7          	jalr	-1566(ra) # 80000d2e <memmove>
    80004354:	8526                	mv	a0,s1
    80004356:	fffff097          	auipc	ra,0xfffff
    8000435a:	d84080e7          	jalr	-636(ra) # 800030da <bwrite>
    8000435e:	854e                	mv	a0,s3
    80004360:	fffff097          	auipc	ra,0xfffff
    80004364:	db8080e7          	jalr	-584(ra) # 80003118 <brelse>
    80004368:	8526                	mv	a0,s1
    8000436a:	fffff097          	auipc	ra,0xfffff
    8000436e:	dae080e7          	jalr	-594(ra) # 80003118 <brelse>
    80004372:	2905                	addiw	s2,s2,1
    80004374:	0a91                	addi	s5,s5,4
    80004376:	02ca2783          	lw	a5,44(s4)
    8000437a:	f8f94ee3          	blt	s2,a5,80004316 <end_op+0xcc>
    8000437e:	00000097          	auipc	ra,0x0
    80004382:	c68080e7          	jalr	-920(ra) # 80003fe6 <write_head>
    80004386:	4501                	li	a0,0
    80004388:	00000097          	auipc	ra,0x0
    8000438c:	cda080e7          	jalr	-806(ra) # 80004062 <install_trans>
    80004390:	0001d797          	auipc	a5,0x1d
    80004394:	a407ae23          	sw	zero,-1444(a5) # 80020dec <log+0x2c>
    80004398:	00000097          	auipc	ra,0x0
    8000439c:	c4e080e7          	jalr	-946(ra) # 80003fe6 <write_head>
    800043a0:	bdf5                	j	8000429c <end_op+0x52>

00000000800043a2 <log_write>:
    800043a2:	1101                	addi	sp,sp,-32
    800043a4:	ec06                	sd	ra,24(sp)
    800043a6:	e822                	sd	s0,16(sp)
    800043a8:	e426                	sd	s1,8(sp)
    800043aa:	e04a                	sd	s2,0(sp)
    800043ac:	1000                	addi	s0,sp,32
    800043ae:	84aa                	mv	s1,a0
    800043b0:	0001d917          	auipc	s2,0x1d
    800043b4:	a1090913          	addi	s2,s2,-1520 # 80020dc0 <log>
    800043b8:	854a                	mv	a0,s2
    800043ba:	ffffd097          	auipc	ra,0xffffd
    800043be:	81c080e7          	jalr	-2020(ra) # 80000bd6 <acquire>
    800043c2:	02c92603          	lw	a2,44(s2)
    800043c6:	47f5                	li	a5,29
    800043c8:	06c7c563          	blt	a5,a2,80004432 <log_write+0x90>
    800043cc:	0001d797          	auipc	a5,0x1d
    800043d0:	a107a783          	lw	a5,-1520(a5) # 80020ddc <log+0x1c>
    800043d4:	37fd                	addiw	a5,a5,-1
    800043d6:	04f65e63          	bge	a2,a5,80004432 <log_write+0x90>
    800043da:	0001d797          	auipc	a5,0x1d
    800043de:	a067a783          	lw	a5,-1530(a5) # 80020de0 <log+0x20>
    800043e2:	06f05063          	blez	a5,80004442 <log_write+0xa0>
    800043e6:	4781                	li	a5,0
    800043e8:	06c05563          	blez	a2,80004452 <log_write+0xb0>
    800043ec:	44cc                	lw	a1,12(s1)
    800043ee:	0001d717          	auipc	a4,0x1d
    800043f2:	a0270713          	addi	a4,a4,-1534 # 80020df0 <log+0x30>
    800043f6:	4781                	li	a5,0
    800043f8:	4314                	lw	a3,0(a4)
    800043fa:	04b68c63          	beq	a3,a1,80004452 <log_write+0xb0>
    800043fe:	2785                	addiw	a5,a5,1
    80004400:	0711                	addi	a4,a4,4
    80004402:	fef61be3          	bne	a2,a5,800043f8 <log_write+0x56>
    80004406:	0621                	addi	a2,a2,8
    80004408:	060a                	slli	a2,a2,0x2
    8000440a:	0001d797          	auipc	a5,0x1d
    8000440e:	9b678793          	addi	a5,a5,-1610 # 80020dc0 <log>
    80004412:	97b2                	add	a5,a5,a2
    80004414:	44d8                	lw	a4,12(s1)
    80004416:	cb98                	sw	a4,16(a5)
    80004418:	8526                	mv	a0,s1
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	d9c080e7          	jalr	-612(ra) # 800031b6 <bpin>
    80004422:	0001d717          	auipc	a4,0x1d
    80004426:	99e70713          	addi	a4,a4,-1634 # 80020dc0 <log>
    8000442a:	575c                	lw	a5,44(a4)
    8000442c:	2785                	addiw	a5,a5,1
    8000442e:	d75c                	sw	a5,44(a4)
    80004430:	a82d                	j	8000446a <log_write+0xc8>
    80004432:	00004517          	auipc	a0,0x4
    80004436:	2a650513          	addi	a0,a0,678 # 800086d8 <syscalls+0x1f8>
    8000443a:	ffffc097          	auipc	ra,0xffffc
    8000443e:	106080e7          	jalr	262(ra) # 80000540 <panic>
    80004442:	00004517          	auipc	a0,0x4
    80004446:	2ae50513          	addi	a0,a0,686 # 800086f0 <syscalls+0x210>
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	0f6080e7          	jalr	246(ra) # 80000540 <panic>
    80004452:	00878693          	addi	a3,a5,8
    80004456:	068a                	slli	a3,a3,0x2
    80004458:	0001d717          	auipc	a4,0x1d
    8000445c:	96870713          	addi	a4,a4,-1688 # 80020dc0 <log>
    80004460:	9736                	add	a4,a4,a3
    80004462:	44d4                	lw	a3,12(s1)
    80004464:	cb14                	sw	a3,16(a4)
    80004466:	faf609e3          	beq	a2,a5,80004418 <log_write+0x76>
    8000446a:	0001d517          	auipc	a0,0x1d
    8000446e:	95650513          	addi	a0,a0,-1706 # 80020dc0 <log>
    80004472:	ffffd097          	auipc	ra,0xffffd
    80004476:	818080e7          	jalr	-2024(ra) # 80000c8a <release>
    8000447a:	60e2                	ld	ra,24(sp)
    8000447c:	6442                	ld	s0,16(sp)
    8000447e:	64a2                	ld	s1,8(sp)
    80004480:	6902                	ld	s2,0(sp)
    80004482:	6105                	addi	sp,sp,32
    80004484:	8082                	ret

0000000080004486 <initsleeplock>:
    80004486:	1101                	addi	sp,sp,-32
    80004488:	ec06                	sd	ra,24(sp)
    8000448a:	e822                	sd	s0,16(sp)
    8000448c:	e426                	sd	s1,8(sp)
    8000448e:	e04a                	sd	s2,0(sp)
    80004490:	1000                	addi	s0,sp,32
    80004492:	84aa                	mv	s1,a0
    80004494:	892e                	mv	s2,a1
    80004496:	00004597          	auipc	a1,0x4
    8000449a:	27a58593          	addi	a1,a1,634 # 80008710 <syscalls+0x230>
    8000449e:	0521                	addi	a0,a0,8
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	6a6080e7          	jalr	1702(ra) # 80000b46 <initlock>
    800044a8:	0324b023          	sd	s2,32(s1)
    800044ac:	0004a023          	sw	zero,0(s1)
    800044b0:	0204a423          	sw	zero,40(s1)
    800044b4:	60e2                	ld	ra,24(sp)
    800044b6:	6442                	ld	s0,16(sp)
    800044b8:	64a2                	ld	s1,8(sp)
    800044ba:	6902                	ld	s2,0(sp)
    800044bc:	6105                	addi	sp,sp,32
    800044be:	8082                	ret

00000000800044c0 <acquiresleep>:
    800044c0:	1101                	addi	sp,sp,-32
    800044c2:	ec06                	sd	ra,24(sp)
    800044c4:	e822                	sd	s0,16(sp)
    800044c6:	e426                	sd	s1,8(sp)
    800044c8:	e04a                	sd	s2,0(sp)
    800044ca:	1000                	addi	s0,sp,32
    800044cc:	84aa                	mv	s1,a0
    800044ce:	00850913          	addi	s2,a0,8
    800044d2:	854a                	mv	a0,s2
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	702080e7          	jalr	1794(ra) # 80000bd6 <acquire>
    800044dc:	409c                	lw	a5,0(s1)
    800044de:	cb89                	beqz	a5,800044f0 <acquiresleep+0x30>
    800044e0:	85ca                	mv	a1,s2
    800044e2:	8526                	mv	a0,s1
    800044e4:	ffffe097          	auipc	ra,0xffffe
    800044e8:	c8e080e7          	jalr	-882(ra) # 80002172 <sleep>
    800044ec:	409c                	lw	a5,0(s1)
    800044ee:	fbed                	bnez	a5,800044e0 <acquiresleep+0x20>
    800044f0:	4785                	li	a5,1
    800044f2:	c09c                	sw	a5,0(s1)
    800044f4:	ffffd097          	auipc	ra,0xffffd
    800044f8:	4ca080e7          	jalr	1226(ra) # 800019be <myproc>
    800044fc:	591c                	lw	a5,48(a0)
    800044fe:	d49c                	sw	a5,40(s1)
    80004500:	854a                	mv	a0,s2
    80004502:	ffffc097          	auipc	ra,0xffffc
    80004506:	788080e7          	jalr	1928(ra) # 80000c8a <release>
    8000450a:	60e2                	ld	ra,24(sp)
    8000450c:	6442                	ld	s0,16(sp)
    8000450e:	64a2                	ld	s1,8(sp)
    80004510:	6902                	ld	s2,0(sp)
    80004512:	6105                	addi	sp,sp,32
    80004514:	8082                	ret

0000000080004516 <releasesleep>:
    80004516:	1101                	addi	sp,sp,-32
    80004518:	ec06                	sd	ra,24(sp)
    8000451a:	e822                	sd	s0,16(sp)
    8000451c:	e426                	sd	s1,8(sp)
    8000451e:	e04a                	sd	s2,0(sp)
    80004520:	1000                	addi	s0,sp,32
    80004522:	84aa                	mv	s1,a0
    80004524:	00850913          	addi	s2,a0,8
    80004528:	854a                	mv	a0,s2
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	6ac080e7          	jalr	1708(ra) # 80000bd6 <acquire>
    80004532:	0004a023          	sw	zero,0(s1)
    80004536:	0204a423          	sw	zero,40(s1)
    8000453a:	8526                	mv	a0,s1
    8000453c:	ffffe097          	auipc	ra,0xffffe
    80004540:	ca8080e7          	jalr	-856(ra) # 800021e4 <wakeup>
    80004544:	854a                	mv	a0,s2
    80004546:	ffffc097          	auipc	ra,0xffffc
    8000454a:	744080e7          	jalr	1860(ra) # 80000c8a <release>
    8000454e:	60e2                	ld	ra,24(sp)
    80004550:	6442                	ld	s0,16(sp)
    80004552:	64a2                	ld	s1,8(sp)
    80004554:	6902                	ld	s2,0(sp)
    80004556:	6105                	addi	sp,sp,32
    80004558:	8082                	ret

000000008000455a <holdingsleep>:
    8000455a:	7179                	addi	sp,sp,-48
    8000455c:	f406                	sd	ra,40(sp)
    8000455e:	f022                	sd	s0,32(sp)
    80004560:	ec26                	sd	s1,24(sp)
    80004562:	e84a                	sd	s2,16(sp)
    80004564:	e44e                	sd	s3,8(sp)
    80004566:	1800                	addi	s0,sp,48
    80004568:	84aa                	mv	s1,a0
    8000456a:	00850913          	addi	s2,a0,8
    8000456e:	854a                	mv	a0,s2
    80004570:	ffffc097          	auipc	ra,0xffffc
    80004574:	666080e7          	jalr	1638(ra) # 80000bd6 <acquire>
    80004578:	409c                	lw	a5,0(s1)
    8000457a:	ef99                	bnez	a5,80004598 <holdingsleep+0x3e>
    8000457c:	4481                	li	s1,0
    8000457e:	854a                	mv	a0,s2
    80004580:	ffffc097          	auipc	ra,0xffffc
    80004584:	70a080e7          	jalr	1802(ra) # 80000c8a <release>
    80004588:	8526                	mv	a0,s1
    8000458a:	70a2                	ld	ra,40(sp)
    8000458c:	7402                	ld	s0,32(sp)
    8000458e:	64e2                	ld	s1,24(sp)
    80004590:	6942                	ld	s2,16(sp)
    80004592:	69a2                	ld	s3,8(sp)
    80004594:	6145                	addi	sp,sp,48
    80004596:	8082                	ret
    80004598:	0284a983          	lw	s3,40(s1)
    8000459c:	ffffd097          	auipc	ra,0xffffd
    800045a0:	422080e7          	jalr	1058(ra) # 800019be <myproc>
    800045a4:	5904                	lw	s1,48(a0)
    800045a6:	413484b3          	sub	s1,s1,s3
    800045aa:	0014b493          	seqz	s1,s1
    800045ae:	bfc1                	j	8000457e <holdingsleep+0x24>

00000000800045b0 <fileinit>:
    800045b0:	1141                	addi	sp,sp,-16
    800045b2:	e406                	sd	ra,8(sp)
    800045b4:	e022                	sd	s0,0(sp)
    800045b6:	0800                	addi	s0,sp,16
    800045b8:	00004597          	auipc	a1,0x4
    800045bc:	16858593          	addi	a1,a1,360 # 80008720 <syscalls+0x240>
    800045c0:	0001d517          	auipc	a0,0x1d
    800045c4:	94850513          	addi	a0,a0,-1720 # 80020f08 <ftable>
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	57e080e7          	jalr	1406(ra) # 80000b46 <initlock>
    800045d0:	60a2                	ld	ra,8(sp)
    800045d2:	6402                	ld	s0,0(sp)
    800045d4:	0141                	addi	sp,sp,16
    800045d6:	8082                	ret

00000000800045d8 <filealloc>:
    800045d8:	1101                	addi	sp,sp,-32
    800045da:	ec06                	sd	ra,24(sp)
    800045dc:	e822                	sd	s0,16(sp)
    800045de:	e426                	sd	s1,8(sp)
    800045e0:	1000                	addi	s0,sp,32
    800045e2:	0001d517          	auipc	a0,0x1d
    800045e6:	92650513          	addi	a0,a0,-1754 # 80020f08 <ftable>
    800045ea:	ffffc097          	auipc	ra,0xffffc
    800045ee:	5ec080e7          	jalr	1516(ra) # 80000bd6 <acquire>
    800045f2:	0001d497          	auipc	s1,0x1d
    800045f6:	92e48493          	addi	s1,s1,-1746 # 80020f20 <ftable+0x18>
    800045fa:	0001e717          	auipc	a4,0x1e
    800045fe:	8c670713          	addi	a4,a4,-1850 # 80021ec0 <disk>
    80004602:	40dc                	lw	a5,4(s1)
    80004604:	cf99                	beqz	a5,80004622 <filealloc+0x4a>
    80004606:	02848493          	addi	s1,s1,40
    8000460a:	fee49ce3          	bne	s1,a4,80004602 <filealloc+0x2a>
    8000460e:	0001d517          	auipc	a0,0x1d
    80004612:	8fa50513          	addi	a0,a0,-1798 # 80020f08 <ftable>
    80004616:	ffffc097          	auipc	ra,0xffffc
    8000461a:	674080e7          	jalr	1652(ra) # 80000c8a <release>
    8000461e:	4481                	li	s1,0
    80004620:	a819                	j	80004636 <filealloc+0x5e>
    80004622:	4785                	li	a5,1
    80004624:	c0dc                	sw	a5,4(s1)
    80004626:	0001d517          	auipc	a0,0x1d
    8000462a:	8e250513          	addi	a0,a0,-1822 # 80020f08 <ftable>
    8000462e:	ffffc097          	auipc	ra,0xffffc
    80004632:	65c080e7          	jalr	1628(ra) # 80000c8a <release>
    80004636:	8526                	mv	a0,s1
    80004638:	60e2                	ld	ra,24(sp)
    8000463a:	6442                	ld	s0,16(sp)
    8000463c:	64a2                	ld	s1,8(sp)
    8000463e:	6105                	addi	sp,sp,32
    80004640:	8082                	ret

0000000080004642 <filedup>:
    80004642:	1101                	addi	sp,sp,-32
    80004644:	ec06                	sd	ra,24(sp)
    80004646:	e822                	sd	s0,16(sp)
    80004648:	e426                	sd	s1,8(sp)
    8000464a:	1000                	addi	s0,sp,32
    8000464c:	84aa                	mv	s1,a0
    8000464e:	0001d517          	auipc	a0,0x1d
    80004652:	8ba50513          	addi	a0,a0,-1862 # 80020f08 <ftable>
    80004656:	ffffc097          	auipc	ra,0xffffc
    8000465a:	580080e7          	jalr	1408(ra) # 80000bd6 <acquire>
    8000465e:	40dc                	lw	a5,4(s1)
    80004660:	02f05263          	blez	a5,80004684 <filedup+0x42>
    80004664:	2785                	addiw	a5,a5,1
    80004666:	c0dc                	sw	a5,4(s1)
    80004668:	0001d517          	auipc	a0,0x1d
    8000466c:	8a050513          	addi	a0,a0,-1888 # 80020f08 <ftable>
    80004670:	ffffc097          	auipc	ra,0xffffc
    80004674:	61a080e7          	jalr	1562(ra) # 80000c8a <release>
    80004678:	8526                	mv	a0,s1
    8000467a:	60e2                	ld	ra,24(sp)
    8000467c:	6442                	ld	s0,16(sp)
    8000467e:	64a2                	ld	s1,8(sp)
    80004680:	6105                	addi	sp,sp,32
    80004682:	8082                	ret
    80004684:	00004517          	auipc	a0,0x4
    80004688:	0a450513          	addi	a0,a0,164 # 80008728 <syscalls+0x248>
    8000468c:	ffffc097          	auipc	ra,0xffffc
    80004690:	eb4080e7          	jalr	-332(ra) # 80000540 <panic>

0000000080004694 <fileclose>:
    80004694:	7139                	addi	sp,sp,-64
    80004696:	fc06                	sd	ra,56(sp)
    80004698:	f822                	sd	s0,48(sp)
    8000469a:	f426                	sd	s1,40(sp)
    8000469c:	f04a                	sd	s2,32(sp)
    8000469e:	ec4e                	sd	s3,24(sp)
    800046a0:	e852                	sd	s4,16(sp)
    800046a2:	e456                	sd	s5,8(sp)
    800046a4:	0080                	addi	s0,sp,64
    800046a6:	84aa                	mv	s1,a0
    800046a8:	0001d517          	auipc	a0,0x1d
    800046ac:	86050513          	addi	a0,a0,-1952 # 80020f08 <ftable>
    800046b0:	ffffc097          	auipc	ra,0xffffc
    800046b4:	526080e7          	jalr	1318(ra) # 80000bd6 <acquire>
    800046b8:	40dc                	lw	a5,4(s1)
    800046ba:	06f05163          	blez	a5,8000471c <fileclose+0x88>
    800046be:	37fd                	addiw	a5,a5,-1
    800046c0:	0007871b          	sext.w	a4,a5
    800046c4:	c0dc                	sw	a5,4(s1)
    800046c6:	06e04363          	bgtz	a4,8000472c <fileclose+0x98>
    800046ca:	0004a903          	lw	s2,0(s1)
    800046ce:	0094ca83          	lbu	s5,9(s1)
    800046d2:	0104ba03          	ld	s4,16(s1)
    800046d6:	0184b983          	ld	s3,24(s1)
    800046da:	0004a223          	sw	zero,4(s1)
    800046de:	0004a023          	sw	zero,0(s1)
    800046e2:	0001d517          	auipc	a0,0x1d
    800046e6:	82650513          	addi	a0,a0,-2010 # 80020f08 <ftable>
    800046ea:	ffffc097          	auipc	ra,0xffffc
    800046ee:	5a0080e7          	jalr	1440(ra) # 80000c8a <release>
    800046f2:	4785                	li	a5,1
    800046f4:	04f90d63          	beq	s2,a5,8000474e <fileclose+0xba>
    800046f8:	3979                	addiw	s2,s2,-2
    800046fa:	4785                	li	a5,1
    800046fc:	0527e063          	bltu	a5,s2,8000473c <fileclose+0xa8>
    80004700:	00000097          	auipc	ra,0x0
    80004704:	acc080e7          	jalr	-1332(ra) # 800041cc <begin_op>
    80004708:	854e                	mv	a0,s3
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	2b0080e7          	jalr	688(ra) # 800039ba <iput>
    80004712:	00000097          	auipc	ra,0x0
    80004716:	b38080e7          	jalr	-1224(ra) # 8000424a <end_op>
    8000471a:	a00d                	j	8000473c <fileclose+0xa8>
    8000471c:	00004517          	auipc	a0,0x4
    80004720:	01450513          	addi	a0,a0,20 # 80008730 <syscalls+0x250>
    80004724:	ffffc097          	auipc	ra,0xffffc
    80004728:	e1c080e7          	jalr	-484(ra) # 80000540 <panic>
    8000472c:	0001c517          	auipc	a0,0x1c
    80004730:	7dc50513          	addi	a0,a0,2012 # 80020f08 <ftable>
    80004734:	ffffc097          	auipc	ra,0xffffc
    80004738:	556080e7          	jalr	1366(ra) # 80000c8a <release>
    8000473c:	70e2                	ld	ra,56(sp)
    8000473e:	7442                	ld	s0,48(sp)
    80004740:	74a2                	ld	s1,40(sp)
    80004742:	7902                	ld	s2,32(sp)
    80004744:	69e2                	ld	s3,24(sp)
    80004746:	6a42                	ld	s4,16(sp)
    80004748:	6aa2                	ld	s5,8(sp)
    8000474a:	6121                	addi	sp,sp,64
    8000474c:	8082                	ret
    8000474e:	85d6                	mv	a1,s5
    80004750:	8552                	mv	a0,s4
    80004752:	00000097          	auipc	ra,0x0
    80004756:	34c080e7          	jalr	844(ra) # 80004a9e <pipeclose>
    8000475a:	b7cd                	j	8000473c <fileclose+0xa8>

000000008000475c <filestat>:
    8000475c:	715d                	addi	sp,sp,-80
    8000475e:	e486                	sd	ra,72(sp)
    80004760:	e0a2                	sd	s0,64(sp)
    80004762:	fc26                	sd	s1,56(sp)
    80004764:	f84a                	sd	s2,48(sp)
    80004766:	f44e                	sd	s3,40(sp)
    80004768:	0880                	addi	s0,sp,80
    8000476a:	84aa                	mv	s1,a0
    8000476c:	89ae                	mv	s3,a1
    8000476e:	ffffd097          	auipc	ra,0xffffd
    80004772:	250080e7          	jalr	592(ra) # 800019be <myproc>
    80004776:	409c                	lw	a5,0(s1)
    80004778:	37f9                	addiw	a5,a5,-2
    8000477a:	4705                	li	a4,1
    8000477c:	04f76763          	bltu	a4,a5,800047ca <filestat+0x6e>
    80004780:	892a                	mv	s2,a0
    80004782:	6c88                	ld	a0,24(s1)
    80004784:	fffff097          	auipc	ra,0xfffff
    80004788:	07c080e7          	jalr	124(ra) # 80003800 <ilock>
    8000478c:	fb840593          	addi	a1,s0,-72
    80004790:	6c88                	ld	a0,24(s1)
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	2f8080e7          	jalr	760(ra) # 80003a8a <stati>
    8000479a:	6c88                	ld	a0,24(s1)
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	126080e7          	jalr	294(ra) # 800038c2 <iunlock>
    800047a4:	46e1                	li	a3,24
    800047a6:	fb840613          	addi	a2,s0,-72
    800047aa:	85ce                	mv	a1,s3
    800047ac:	05893503          	ld	a0,88(s2)
    800047b0:	ffffd097          	auipc	ra,0xffffd
    800047b4:	ebc080e7          	jalr	-324(ra) # 8000166c <copyout>
    800047b8:	41f5551b          	sraiw	a0,a0,0x1f
    800047bc:	60a6                	ld	ra,72(sp)
    800047be:	6406                	ld	s0,64(sp)
    800047c0:	74e2                	ld	s1,56(sp)
    800047c2:	7942                	ld	s2,48(sp)
    800047c4:	79a2                	ld	s3,40(sp)
    800047c6:	6161                	addi	sp,sp,80
    800047c8:	8082                	ret
    800047ca:	557d                	li	a0,-1
    800047cc:	bfc5                	j	800047bc <filestat+0x60>

00000000800047ce <fileread>:
    800047ce:	7179                	addi	sp,sp,-48
    800047d0:	f406                	sd	ra,40(sp)
    800047d2:	f022                	sd	s0,32(sp)
    800047d4:	ec26                	sd	s1,24(sp)
    800047d6:	e84a                	sd	s2,16(sp)
    800047d8:	e44e                	sd	s3,8(sp)
    800047da:	1800                	addi	s0,sp,48
    800047dc:	00854783          	lbu	a5,8(a0)
    800047e0:	c3d5                	beqz	a5,80004884 <fileread+0xb6>
    800047e2:	84aa                	mv	s1,a0
    800047e4:	89ae                	mv	s3,a1
    800047e6:	8932                	mv	s2,a2
    800047e8:	411c                	lw	a5,0(a0)
    800047ea:	4705                	li	a4,1
    800047ec:	04e78963          	beq	a5,a4,8000483e <fileread+0x70>
    800047f0:	470d                	li	a4,3
    800047f2:	04e78d63          	beq	a5,a4,8000484c <fileread+0x7e>
    800047f6:	4709                	li	a4,2
    800047f8:	06e79e63          	bne	a5,a4,80004874 <fileread+0xa6>
    800047fc:	6d08                	ld	a0,24(a0)
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	002080e7          	jalr	2(ra) # 80003800 <ilock>
    80004806:	874a                	mv	a4,s2
    80004808:	5094                	lw	a3,32(s1)
    8000480a:	864e                	mv	a2,s3
    8000480c:	4585                	li	a1,1
    8000480e:	6c88                	ld	a0,24(s1)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	2a4080e7          	jalr	676(ra) # 80003ab4 <readi>
    80004818:	892a                	mv	s2,a0
    8000481a:	00a05563          	blez	a0,80004824 <fileread+0x56>
    8000481e:	509c                	lw	a5,32(s1)
    80004820:	9fa9                	addw	a5,a5,a0
    80004822:	d09c                	sw	a5,32(s1)
    80004824:	6c88                	ld	a0,24(s1)
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	09c080e7          	jalr	156(ra) # 800038c2 <iunlock>
    8000482e:	854a                	mv	a0,s2
    80004830:	70a2                	ld	ra,40(sp)
    80004832:	7402                	ld	s0,32(sp)
    80004834:	64e2                	ld	s1,24(sp)
    80004836:	6942                	ld	s2,16(sp)
    80004838:	69a2                	ld	s3,8(sp)
    8000483a:	6145                	addi	sp,sp,48
    8000483c:	8082                	ret
    8000483e:	6908                	ld	a0,16(a0)
    80004840:	00000097          	auipc	ra,0x0
    80004844:	3c6080e7          	jalr	966(ra) # 80004c06 <piperead>
    80004848:	892a                	mv	s2,a0
    8000484a:	b7d5                	j	8000482e <fileread+0x60>
    8000484c:	02451783          	lh	a5,36(a0)
    80004850:	03079693          	slli	a3,a5,0x30
    80004854:	92c1                	srli	a3,a3,0x30
    80004856:	4725                	li	a4,9
    80004858:	02d76863          	bltu	a4,a3,80004888 <fileread+0xba>
    8000485c:	0792                	slli	a5,a5,0x4
    8000485e:	0001c717          	auipc	a4,0x1c
    80004862:	60a70713          	addi	a4,a4,1546 # 80020e68 <devsw>
    80004866:	97ba                	add	a5,a5,a4
    80004868:	639c                	ld	a5,0(a5)
    8000486a:	c38d                	beqz	a5,8000488c <fileread+0xbe>
    8000486c:	4505                	li	a0,1
    8000486e:	9782                	jalr	a5
    80004870:	892a                	mv	s2,a0
    80004872:	bf75                	j	8000482e <fileread+0x60>
    80004874:	00004517          	auipc	a0,0x4
    80004878:	ecc50513          	addi	a0,a0,-308 # 80008740 <syscalls+0x260>
    8000487c:	ffffc097          	auipc	ra,0xffffc
    80004880:	cc4080e7          	jalr	-828(ra) # 80000540 <panic>
    80004884:	597d                	li	s2,-1
    80004886:	b765                	j	8000482e <fileread+0x60>
    80004888:	597d                	li	s2,-1
    8000488a:	b755                	j	8000482e <fileread+0x60>
    8000488c:	597d                	li	s2,-1
    8000488e:	b745                	j	8000482e <fileread+0x60>

0000000080004890 <filewrite>:
    80004890:	715d                	addi	sp,sp,-80
    80004892:	e486                	sd	ra,72(sp)
    80004894:	e0a2                	sd	s0,64(sp)
    80004896:	fc26                	sd	s1,56(sp)
    80004898:	f84a                	sd	s2,48(sp)
    8000489a:	f44e                	sd	s3,40(sp)
    8000489c:	f052                	sd	s4,32(sp)
    8000489e:	ec56                	sd	s5,24(sp)
    800048a0:	e85a                	sd	s6,16(sp)
    800048a2:	e45e                	sd	s7,8(sp)
    800048a4:	e062                	sd	s8,0(sp)
    800048a6:	0880                	addi	s0,sp,80
    800048a8:	00954783          	lbu	a5,9(a0)
    800048ac:	10078663          	beqz	a5,800049b8 <filewrite+0x128>
    800048b0:	892a                	mv	s2,a0
    800048b2:	8b2e                	mv	s6,a1
    800048b4:	8a32                	mv	s4,a2
    800048b6:	411c                	lw	a5,0(a0)
    800048b8:	4705                	li	a4,1
    800048ba:	02e78263          	beq	a5,a4,800048de <filewrite+0x4e>
    800048be:	470d                	li	a4,3
    800048c0:	02e78663          	beq	a5,a4,800048ec <filewrite+0x5c>
    800048c4:	4709                	li	a4,2
    800048c6:	0ee79163          	bne	a5,a4,800049a8 <filewrite+0x118>
    800048ca:	0ac05d63          	blez	a2,80004984 <filewrite+0xf4>
    800048ce:	4981                	li	s3,0
    800048d0:	6b85                	lui	s7,0x1
    800048d2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800048d6:	6c05                	lui	s8,0x1
    800048d8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800048dc:	a861                	j	80004974 <filewrite+0xe4>
    800048de:	6908                	ld	a0,16(a0)
    800048e0:	00000097          	auipc	ra,0x0
    800048e4:	22e080e7          	jalr	558(ra) # 80004b0e <pipewrite>
    800048e8:	8a2a                	mv	s4,a0
    800048ea:	a045                	j	8000498a <filewrite+0xfa>
    800048ec:	02451783          	lh	a5,36(a0)
    800048f0:	03079693          	slli	a3,a5,0x30
    800048f4:	92c1                	srli	a3,a3,0x30
    800048f6:	4725                	li	a4,9
    800048f8:	0cd76263          	bltu	a4,a3,800049bc <filewrite+0x12c>
    800048fc:	0792                	slli	a5,a5,0x4
    800048fe:	0001c717          	auipc	a4,0x1c
    80004902:	56a70713          	addi	a4,a4,1386 # 80020e68 <devsw>
    80004906:	97ba                	add	a5,a5,a4
    80004908:	679c                	ld	a5,8(a5)
    8000490a:	cbdd                	beqz	a5,800049c0 <filewrite+0x130>
    8000490c:	4505                	li	a0,1
    8000490e:	9782                	jalr	a5
    80004910:	8a2a                	mv	s4,a0
    80004912:	a8a5                	j	8000498a <filewrite+0xfa>
    80004914:	00048a9b          	sext.w	s5,s1
    80004918:	00000097          	auipc	ra,0x0
    8000491c:	8b4080e7          	jalr	-1868(ra) # 800041cc <begin_op>
    80004920:	01893503          	ld	a0,24(s2)
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	edc080e7          	jalr	-292(ra) # 80003800 <ilock>
    8000492c:	8756                	mv	a4,s5
    8000492e:	02092683          	lw	a3,32(s2)
    80004932:	01698633          	add	a2,s3,s6
    80004936:	4585                	li	a1,1
    80004938:	01893503          	ld	a0,24(s2)
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	270080e7          	jalr	624(ra) # 80003bac <writei>
    80004944:	84aa                	mv	s1,a0
    80004946:	00a05763          	blez	a0,80004954 <filewrite+0xc4>
    8000494a:	02092783          	lw	a5,32(s2)
    8000494e:	9fa9                	addw	a5,a5,a0
    80004950:	02f92023          	sw	a5,32(s2)
    80004954:	01893503          	ld	a0,24(s2)
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	f6a080e7          	jalr	-150(ra) # 800038c2 <iunlock>
    80004960:	00000097          	auipc	ra,0x0
    80004964:	8ea080e7          	jalr	-1814(ra) # 8000424a <end_op>
    80004968:	009a9f63          	bne	s5,s1,80004986 <filewrite+0xf6>
    8000496c:	013489bb          	addw	s3,s1,s3
    80004970:	0149db63          	bge	s3,s4,80004986 <filewrite+0xf6>
    80004974:	413a04bb          	subw	s1,s4,s3
    80004978:	0004879b          	sext.w	a5,s1
    8000497c:	f8fbdce3          	bge	s7,a5,80004914 <filewrite+0x84>
    80004980:	84e2                	mv	s1,s8
    80004982:	bf49                	j	80004914 <filewrite+0x84>
    80004984:	4981                	li	s3,0
    80004986:	013a1f63          	bne	s4,s3,800049a4 <filewrite+0x114>
    8000498a:	8552                	mv	a0,s4
    8000498c:	60a6                	ld	ra,72(sp)
    8000498e:	6406                	ld	s0,64(sp)
    80004990:	74e2                	ld	s1,56(sp)
    80004992:	7942                	ld	s2,48(sp)
    80004994:	79a2                	ld	s3,40(sp)
    80004996:	7a02                	ld	s4,32(sp)
    80004998:	6ae2                	ld	s5,24(sp)
    8000499a:	6b42                	ld	s6,16(sp)
    8000499c:	6ba2                	ld	s7,8(sp)
    8000499e:	6c02                	ld	s8,0(sp)
    800049a0:	6161                	addi	sp,sp,80
    800049a2:	8082                	ret
    800049a4:	5a7d                	li	s4,-1
    800049a6:	b7d5                	j	8000498a <filewrite+0xfa>
    800049a8:	00004517          	auipc	a0,0x4
    800049ac:	da850513          	addi	a0,a0,-600 # 80008750 <syscalls+0x270>
    800049b0:	ffffc097          	auipc	ra,0xffffc
    800049b4:	b90080e7          	jalr	-1136(ra) # 80000540 <panic>
    800049b8:	5a7d                	li	s4,-1
    800049ba:	bfc1                	j	8000498a <filewrite+0xfa>
    800049bc:	5a7d                	li	s4,-1
    800049be:	b7f1                	j	8000498a <filewrite+0xfa>
    800049c0:	5a7d                	li	s4,-1
    800049c2:	b7e1                	j	8000498a <filewrite+0xfa>

00000000800049c4 <pipealloc>:
    800049c4:	7179                	addi	sp,sp,-48
    800049c6:	f406                	sd	ra,40(sp)
    800049c8:	f022                	sd	s0,32(sp)
    800049ca:	ec26                	sd	s1,24(sp)
    800049cc:	e84a                	sd	s2,16(sp)
    800049ce:	e44e                	sd	s3,8(sp)
    800049d0:	e052                	sd	s4,0(sp)
    800049d2:	1800                	addi	s0,sp,48
    800049d4:	84aa                	mv	s1,a0
    800049d6:	8a2e                	mv	s4,a1
    800049d8:	0005b023          	sd	zero,0(a1)
    800049dc:	00053023          	sd	zero,0(a0)
    800049e0:	00000097          	auipc	ra,0x0
    800049e4:	bf8080e7          	jalr	-1032(ra) # 800045d8 <filealloc>
    800049e8:	e088                	sd	a0,0(s1)
    800049ea:	c551                	beqz	a0,80004a76 <pipealloc+0xb2>
    800049ec:	00000097          	auipc	ra,0x0
    800049f0:	bec080e7          	jalr	-1044(ra) # 800045d8 <filealloc>
    800049f4:	00aa3023          	sd	a0,0(s4)
    800049f8:	c92d                	beqz	a0,80004a6a <pipealloc+0xa6>
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	0ec080e7          	jalr	236(ra) # 80000ae6 <kalloc>
    80004a02:	892a                	mv	s2,a0
    80004a04:	c125                	beqz	a0,80004a64 <pipealloc+0xa0>
    80004a06:	4985                	li	s3,1
    80004a08:	23352023          	sw	s3,544(a0)
    80004a0c:	23352223          	sw	s3,548(a0)
    80004a10:	20052e23          	sw	zero,540(a0)
    80004a14:	20052c23          	sw	zero,536(a0)
    80004a18:	00004597          	auipc	a1,0x4
    80004a1c:	d4858593          	addi	a1,a1,-696 # 80008760 <syscalls+0x280>
    80004a20:	ffffc097          	auipc	ra,0xffffc
    80004a24:	126080e7          	jalr	294(ra) # 80000b46 <initlock>
    80004a28:	609c                	ld	a5,0(s1)
    80004a2a:	0137a023          	sw	s3,0(a5)
    80004a2e:	609c                	ld	a5,0(s1)
    80004a30:	01378423          	sb	s3,8(a5)
    80004a34:	609c                	ld	a5,0(s1)
    80004a36:	000784a3          	sb	zero,9(a5)
    80004a3a:	609c                	ld	a5,0(s1)
    80004a3c:	0127b823          	sd	s2,16(a5)
    80004a40:	000a3783          	ld	a5,0(s4)
    80004a44:	0137a023          	sw	s3,0(a5)
    80004a48:	000a3783          	ld	a5,0(s4)
    80004a4c:	00078423          	sb	zero,8(a5)
    80004a50:	000a3783          	ld	a5,0(s4)
    80004a54:	013784a3          	sb	s3,9(a5)
    80004a58:	000a3783          	ld	a5,0(s4)
    80004a5c:	0127b823          	sd	s2,16(a5)
    80004a60:	4501                	li	a0,0
    80004a62:	a025                	j	80004a8a <pipealloc+0xc6>
    80004a64:	6088                	ld	a0,0(s1)
    80004a66:	e501                	bnez	a0,80004a6e <pipealloc+0xaa>
    80004a68:	a039                	j	80004a76 <pipealloc+0xb2>
    80004a6a:	6088                	ld	a0,0(s1)
    80004a6c:	c51d                	beqz	a0,80004a9a <pipealloc+0xd6>
    80004a6e:	00000097          	auipc	ra,0x0
    80004a72:	c26080e7          	jalr	-986(ra) # 80004694 <fileclose>
    80004a76:	000a3783          	ld	a5,0(s4)
    80004a7a:	557d                	li	a0,-1
    80004a7c:	c799                	beqz	a5,80004a8a <pipealloc+0xc6>
    80004a7e:	853e                	mv	a0,a5
    80004a80:	00000097          	auipc	ra,0x0
    80004a84:	c14080e7          	jalr	-1004(ra) # 80004694 <fileclose>
    80004a88:	557d                	li	a0,-1
    80004a8a:	70a2                	ld	ra,40(sp)
    80004a8c:	7402                	ld	s0,32(sp)
    80004a8e:	64e2                	ld	s1,24(sp)
    80004a90:	6942                	ld	s2,16(sp)
    80004a92:	69a2                	ld	s3,8(sp)
    80004a94:	6a02                	ld	s4,0(sp)
    80004a96:	6145                	addi	sp,sp,48
    80004a98:	8082                	ret
    80004a9a:	557d                	li	a0,-1
    80004a9c:	b7fd                	j	80004a8a <pipealloc+0xc6>

0000000080004a9e <pipeclose>:
    80004a9e:	1101                	addi	sp,sp,-32
    80004aa0:	ec06                	sd	ra,24(sp)
    80004aa2:	e822                	sd	s0,16(sp)
    80004aa4:	e426                	sd	s1,8(sp)
    80004aa6:	e04a                	sd	s2,0(sp)
    80004aa8:	1000                	addi	s0,sp,32
    80004aaa:	84aa                	mv	s1,a0
    80004aac:	892e                	mv	s2,a1
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	128080e7          	jalr	296(ra) # 80000bd6 <acquire>
    80004ab6:	02090d63          	beqz	s2,80004af0 <pipeclose+0x52>
    80004aba:	2204a223          	sw	zero,548(s1)
    80004abe:	21848513          	addi	a0,s1,536
    80004ac2:	ffffd097          	auipc	ra,0xffffd
    80004ac6:	722080e7          	jalr	1826(ra) # 800021e4 <wakeup>
    80004aca:	2204b783          	ld	a5,544(s1)
    80004ace:	eb95                	bnez	a5,80004b02 <pipeclose+0x64>
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	ffffc097          	auipc	ra,0xffffc
    80004ad6:	1b8080e7          	jalr	440(ra) # 80000c8a <release>
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffc097          	auipc	ra,0xffffc
    80004ae0:	f0c080e7          	jalr	-244(ra) # 800009e8 <kfree>
    80004ae4:	60e2                	ld	ra,24(sp)
    80004ae6:	6442                	ld	s0,16(sp)
    80004ae8:	64a2                	ld	s1,8(sp)
    80004aea:	6902                	ld	s2,0(sp)
    80004aec:	6105                	addi	sp,sp,32
    80004aee:	8082                	ret
    80004af0:	2204a023          	sw	zero,544(s1)
    80004af4:	21c48513          	addi	a0,s1,540
    80004af8:	ffffd097          	auipc	ra,0xffffd
    80004afc:	6ec080e7          	jalr	1772(ra) # 800021e4 <wakeup>
    80004b00:	b7e9                	j	80004aca <pipeclose+0x2c>
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffc097          	auipc	ra,0xffffc
    80004b08:	186080e7          	jalr	390(ra) # 80000c8a <release>
    80004b0c:	bfe1                	j	80004ae4 <pipeclose+0x46>

0000000080004b0e <pipewrite>:
    80004b0e:	711d                	addi	sp,sp,-96
    80004b10:	ec86                	sd	ra,88(sp)
    80004b12:	e8a2                	sd	s0,80(sp)
    80004b14:	e4a6                	sd	s1,72(sp)
    80004b16:	e0ca                	sd	s2,64(sp)
    80004b18:	fc4e                	sd	s3,56(sp)
    80004b1a:	f852                	sd	s4,48(sp)
    80004b1c:	f456                	sd	s5,40(sp)
    80004b1e:	f05a                	sd	s6,32(sp)
    80004b20:	ec5e                	sd	s7,24(sp)
    80004b22:	e862                	sd	s8,16(sp)
    80004b24:	1080                	addi	s0,sp,96
    80004b26:	84aa                	mv	s1,a0
    80004b28:	8aae                	mv	s5,a1
    80004b2a:	8a32                	mv	s4,a2
    80004b2c:	ffffd097          	auipc	ra,0xffffd
    80004b30:	e92080e7          	jalr	-366(ra) # 800019be <myproc>
    80004b34:	89aa                	mv	s3,a0
    80004b36:	8526                	mv	a0,s1
    80004b38:	ffffc097          	auipc	ra,0xffffc
    80004b3c:	09e080e7          	jalr	158(ra) # 80000bd6 <acquire>
    80004b40:	0b405663          	blez	s4,80004bec <pipewrite+0xde>
    80004b44:	4901                	li	s2,0
    80004b46:	5b7d                	li	s6,-1
    80004b48:	21848c13          	addi	s8,s1,536
    80004b4c:	21c48b93          	addi	s7,s1,540
    80004b50:	a089                	j	80004b92 <pipewrite+0x84>
    80004b52:	8526                	mv	a0,s1
    80004b54:	ffffc097          	auipc	ra,0xffffc
    80004b58:	136080e7          	jalr	310(ra) # 80000c8a <release>
    80004b5c:	597d                	li	s2,-1
    80004b5e:	854a                	mv	a0,s2
    80004b60:	60e6                	ld	ra,88(sp)
    80004b62:	6446                	ld	s0,80(sp)
    80004b64:	64a6                	ld	s1,72(sp)
    80004b66:	6906                	ld	s2,64(sp)
    80004b68:	79e2                	ld	s3,56(sp)
    80004b6a:	7a42                	ld	s4,48(sp)
    80004b6c:	7aa2                	ld	s5,40(sp)
    80004b6e:	7b02                	ld	s6,32(sp)
    80004b70:	6be2                	ld	s7,24(sp)
    80004b72:	6c42                	ld	s8,16(sp)
    80004b74:	6125                	addi	sp,sp,96
    80004b76:	8082                	ret
    80004b78:	8562                	mv	a0,s8
    80004b7a:	ffffd097          	auipc	ra,0xffffd
    80004b7e:	66a080e7          	jalr	1642(ra) # 800021e4 <wakeup>
    80004b82:	85a6                	mv	a1,s1
    80004b84:	855e                	mv	a0,s7
    80004b86:	ffffd097          	auipc	ra,0xffffd
    80004b8a:	5ec080e7          	jalr	1516(ra) # 80002172 <sleep>
    80004b8e:	07495063          	bge	s2,s4,80004bee <pipewrite+0xe0>
    80004b92:	2204a783          	lw	a5,544(s1)
    80004b96:	dfd5                	beqz	a5,80004b52 <pipewrite+0x44>
    80004b98:	854e                	mv	a0,s3
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	88e080e7          	jalr	-1906(ra) # 80002428 <killed>
    80004ba2:	f945                	bnez	a0,80004b52 <pipewrite+0x44>
    80004ba4:	2184a783          	lw	a5,536(s1)
    80004ba8:	21c4a703          	lw	a4,540(s1)
    80004bac:	2007879b          	addiw	a5,a5,512
    80004bb0:	fcf704e3          	beq	a4,a5,80004b78 <pipewrite+0x6a>
    80004bb4:	4685                	li	a3,1
    80004bb6:	01590633          	add	a2,s2,s5
    80004bba:	faf40593          	addi	a1,s0,-81
    80004bbe:	0589b503          	ld	a0,88(s3)
    80004bc2:	ffffd097          	auipc	ra,0xffffd
    80004bc6:	b36080e7          	jalr	-1226(ra) # 800016f8 <copyin>
    80004bca:	03650263          	beq	a0,s6,80004bee <pipewrite+0xe0>
    80004bce:	21c4a783          	lw	a5,540(s1)
    80004bd2:	0017871b          	addiw	a4,a5,1
    80004bd6:	20e4ae23          	sw	a4,540(s1)
    80004bda:	1ff7f793          	andi	a5,a5,511
    80004bde:	97a6                	add	a5,a5,s1
    80004be0:	faf44703          	lbu	a4,-81(s0)
    80004be4:	00e78c23          	sb	a4,24(a5)
    80004be8:	2905                	addiw	s2,s2,1
    80004bea:	b755                	j	80004b8e <pipewrite+0x80>
    80004bec:	4901                	li	s2,0
    80004bee:	21848513          	addi	a0,s1,536
    80004bf2:	ffffd097          	auipc	ra,0xffffd
    80004bf6:	5f2080e7          	jalr	1522(ra) # 800021e4 <wakeup>
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffc097          	auipc	ra,0xffffc
    80004c00:	08e080e7          	jalr	142(ra) # 80000c8a <release>
    80004c04:	bfa9                	j	80004b5e <pipewrite+0x50>

0000000080004c06 <piperead>:
    80004c06:	715d                	addi	sp,sp,-80
    80004c08:	e486                	sd	ra,72(sp)
    80004c0a:	e0a2                	sd	s0,64(sp)
    80004c0c:	fc26                	sd	s1,56(sp)
    80004c0e:	f84a                	sd	s2,48(sp)
    80004c10:	f44e                	sd	s3,40(sp)
    80004c12:	f052                	sd	s4,32(sp)
    80004c14:	ec56                	sd	s5,24(sp)
    80004c16:	e85a                	sd	s6,16(sp)
    80004c18:	0880                	addi	s0,sp,80
    80004c1a:	84aa                	mv	s1,a0
    80004c1c:	892e                	mv	s2,a1
    80004c1e:	8ab2                	mv	s5,a2
    80004c20:	ffffd097          	auipc	ra,0xffffd
    80004c24:	d9e080e7          	jalr	-610(ra) # 800019be <myproc>
    80004c28:	8a2a                	mv	s4,a0
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffc097          	auipc	ra,0xffffc
    80004c30:	faa080e7          	jalr	-86(ra) # 80000bd6 <acquire>
    80004c34:	2184a703          	lw	a4,536(s1)
    80004c38:	21c4a783          	lw	a5,540(s1)
    80004c3c:	21848993          	addi	s3,s1,536
    80004c40:	02f71763          	bne	a4,a5,80004c6e <piperead+0x68>
    80004c44:	2244a783          	lw	a5,548(s1)
    80004c48:	c39d                	beqz	a5,80004c6e <piperead+0x68>
    80004c4a:	8552                	mv	a0,s4
    80004c4c:	ffffd097          	auipc	ra,0xffffd
    80004c50:	7dc080e7          	jalr	2012(ra) # 80002428 <killed>
    80004c54:	e949                	bnez	a0,80004ce6 <piperead+0xe0>
    80004c56:	85a6                	mv	a1,s1
    80004c58:	854e                	mv	a0,s3
    80004c5a:	ffffd097          	auipc	ra,0xffffd
    80004c5e:	518080e7          	jalr	1304(ra) # 80002172 <sleep>
    80004c62:	2184a703          	lw	a4,536(s1)
    80004c66:	21c4a783          	lw	a5,540(s1)
    80004c6a:	fcf70de3          	beq	a4,a5,80004c44 <piperead+0x3e>
    80004c6e:	4981                	li	s3,0
    80004c70:	5b7d                	li	s6,-1
    80004c72:	05505463          	blez	s5,80004cba <piperead+0xb4>
    80004c76:	2184a783          	lw	a5,536(s1)
    80004c7a:	21c4a703          	lw	a4,540(s1)
    80004c7e:	02f70e63          	beq	a4,a5,80004cba <piperead+0xb4>
    80004c82:	0017871b          	addiw	a4,a5,1
    80004c86:	20e4ac23          	sw	a4,536(s1)
    80004c8a:	1ff7f793          	andi	a5,a5,511
    80004c8e:	97a6                	add	a5,a5,s1
    80004c90:	0187c783          	lbu	a5,24(a5)
    80004c94:	faf40fa3          	sb	a5,-65(s0)
    80004c98:	4685                	li	a3,1
    80004c9a:	fbf40613          	addi	a2,s0,-65
    80004c9e:	85ca                	mv	a1,s2
    80004ca0:	058a3503          	ld	a0,88(s4)
    80004ca4:	ffffd097          	auipc	ra,0xffffd
    80004ca8:	9c8080e7          	jalr	-1592(ra) # 8000166c <copyout>
    80004cac:	01650763          	beq	a0,s6,80004cba <piperead+0xb4>
    80004cb0:	2985                	addiw	s3,s3,1
    80004cb2:	0905                	addi	s2,s2,1
    80004cb4:	fd3a91e3          	bne	s5,s3,80004c76 <piperead+0x70>
    80004cb8:	89d6                	mv	s3,s5
    80004cba:	21c48513          	addi	a0,s1,540
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	526080e7          	jalr	1318(ra) # 800021e4 <wakeup>
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	ffffc097          	auipc	ra,0xffffc
    80004ccc:	fc2080e7          	jalr	-62(ra) # 80000c8a <release>
    80004cd0:	854e                	mv	a0,s3
    80004cd2:	60a6                	ld	ra,72(sp)
    80004cd4:	6406                	ld	s0,64(sp)
    80004cd6:	74e2                	ld	s1,56(sp)
    80004cd8:	7942                	ld	s2,48(sp)
    80004cda:	79a2                	ld	s3,40(sp)
    80004cdc:	7a02                	ld	s4,32(sp)
    80004cde:	6ae2                	ld	s5,24(sp)
    80004ce0:	6b42                	ld	s6,16(sp)
    80004ce2:	6161                	addi	sp,sp,80
    80004ce4:	8082                	ret
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	ffffc097          	auipc	ra,0xffffc
    80004cec:	fa2080e7          	jalr	-94(ra) # 80000c8a <release>
    80004cf0:	59fd                	li	s3,-1
    80004cf2:	bff9                	j	80004cd0 <piperead+0xca>

0000000080004cf4 <flags2perm>:
    80004cf4:	1141                	addi	sp,sp,-16
    80004cf6:	e422                	sd	s0,8(sp)
    80004cf8:	0800                	addi	s0,sp,16
    80004cfa:	87aa                	mv	a5,a0
    80004cfc:	8905                	andi	a0,a0,1
    80004cfe:	050e                	slli	a0,a0,0x3
    80004d00:	8b89                	andi	a5,a5,2
    80004d02:	c399                	beqz	a5,80004d08 <flags2perm+0x14>
    80004d04:	00456513          	ori	a0,a0,4
    80004d08:	6422                	ld	s0,8(sp)
    80004d0a:	0141                	addi	sp,sp,16
    80004d0c:	8082                	ret

0000000080004d0e <exec>:
    80004d0e:	de010113          	addi	sp,sp,-544
    80004d12:	20113c23          	sd	ra,536(sp)
    80004d16:	20813823          	sd	s0,528(sp)
    80004d1a:	20913423          	sd	s1,520(sp)
    80004d1e:	21213023          	sd	s2,512(sp)
    80004d22:	ffce                	sd	s3,504(sp)
    80004d24:	fbd2                	sd	s4,496(sp)
    80004d26:	f7d6                	sd	s5,488(sp)
    80004d28:	f3da                	sd	s6,480(sp)
    80004d2a:	efde                	sd	s7,472(sp)
    80004d2c:	ebe2                	sd	s8,464(sp)
    80004d2e:	e7e6                	sd	s9,456(sp)
    80004d30:	e3ea                	sd	s10,448(sp)
    80004d32:	ff6e                	sd	s11,440(sp)
    80004d34:	1400                	addi	s0,sp,544
    80004d36:	892a                	mv	s2,a0
    80004d38:	dea43423          	sd	a0,-536(s0)
    80004d3c:	deb43823          	sd	a1,-528(s0)
    80004d40:	ffffd097          	auipc	ra,0xffffd
    80004d44:	c7e080e7          	jalr	-898(ra) # 800019be <myproc>
    80004d48:	84aa                	mv	s1,a0
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	482080e7          	jalr	1154(ra) # 800041cc <begin_op>
    80004d52:	854a                	mv	a0,s2
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	258080e7          	jalr	600(ra) # 80003fac <namei>
    80004d5c:	c93d                	beqz	a0,80004dd2 <exec+0xc4>
    80004d5e:	8aaa                	mv	s5,a0
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	aa0080e7          	jalr	-1376(ra) # 80003800 <ilock>
    80004d68:	04000713          	li	a4,64
    80004d6c:	4681                	li	a3,0
    80004d6e:	e5040613          	addi	a2,s0,-432
    80004d72:	4581                	li	a1,0
    80004d74:	8556                	mv	a0,s5
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	d3e080e7          	jalr	-706(ra) # 80003ab4 <readi>
    80004d7e:	04000793          	li	a5,64
    80004d82:	00f51a63          	bne	a0,a5,80004d96 <exec+0x88>
    80004d86:	e5042703          	lw	a4,-432(s0)
    80004d8a:	464c47b7          	lui	a5,0x464c4
    80004d8e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d92:	04f70663          	beq	a4,a5,80004dde <exec+0xd0>
    80004d96:	8556                	mv	a0,s5
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	cca080e7          	jalr	-822(ra) # 80003a62 <iunlockput>
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	4aa080e7          	jalr	1194(ra) # 8000424a <end_op>
    80004da8:	557d                	li	a0,-1
    80004daa:	21813083          	ld	ra,536(sp)
    80004dae:	21013403          	ld	s0,528(sp)
    80004db2:	20813483          	ld	s1,520(sp)
    80004db6:	20013903          	ld	s2,512(sp)
    80004dba:	79fe                	ld	s3,504(sp)
    80004dbc:	7a5e                	ld	s4,496(sp)
    80004dbe:	7abe                	ld	s5,488(sp)
    80004dc0:	7b1e                	ld	s6,480(sp)
    80004dc2:	6bfe                	ld	s7,472(sp)
    80004dc4:	6c5e                	ld	s8,464(sp)
    80004dc6:	6cbe                	ld	s9,456(sp)
    80004dc8:	6d1e                	ld	s10,448(sp)
    80004dca:	7dfa                	ld	s11,440(sp)
    80004dcc:	22010113          	addi	sp,sp,544
    80004dd0:	8082                	ret
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	478080e7          	jalr	1144(ra) # 8000424a <end_op>
    80004dda:	557d                	li	a0,-1
    80004ddc:	b7f9                	j	80004daa <exec+0x9c>
    80004dde:	8526                	mv	a0,s1
    80004de0:	ffffd097          	auipc	ra,0xffffd
    80004de4:	ca2080e7          	jalr	-862(ra) # 80001a82 <proc_pagetable>
    80004de8:	8b2a                	mv	s6,a0
    80004dea:	d555                	beqz	a0,80004d96 <exec+0x88>
    80004dec:	e7042783          	lw	a5,-400(s0)
    80004df0:	e8845703          	lhu	a4,-376(s0)
    80004df4:	c735                	beqz	a4,80004e60 <exec+0x152>
    80004df6:	4901                	li	s2,0
    80004df8:	e0043423          	sd	zero,-504(s0)
    80004dfc:	6a05                	lui	s4,0x1
    80004dfe:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004e02:	dee43023          	sd	a4,-544(s0)
    80004e06:	6d85                	lui	s11,0x1
    80004e08:	7d7d                	lui	s10,0xfffff
    80004e0a:	ac3d                	j	80005048 <exec+0x33a>
    80004e0c:	00004517          	auipc	a0,0x4
    80004e10:	95c50513          	addi	a0,a0,-1700 # 80008768 <syscalls+0x288>
    80004e14:	ffffb097          	auipc	ra,0xffffb
    80004e18:	72c080e7          	jalr	1836(ra) # 80000540 <panic>
    80004e1c:	874a                	mv	a4,s2
    80004e1e:	009c86bb          	addw	a3,s9,s1
    80004e22:	4581                	li	a1,0
    80004e24:	8556                	mv	a0,s5
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	c8e080e7          	jalr	-882(ra) # 80003ab4 <readi>
    80004e2e:	2501                	sext.w	a0,a0
    80004e30:	1aa91963          	bne	s2,a0,80004fe2 <exec+0x2d4>
    80004e34:	009d84bb          	addw	s1,s11,s1
    80004e38:	013d09bb          	addw	s3,s10,s3
    80004e3c:	1f74f663          	bgeu	s1,s7,80005028 <exec+0x31a>
    80004e40:	02049593          	slli	a1,s1,0x20
    80004e44:	9181                	srli	a1,a1,0x20
    80004e46:	95e2                	add	a1,a1,s8
    80004e48:	855a                	mv	a0,s6
    80004e4a:	ffffc097          	auipc	ra,0xffffc
    80004e4e:	212080e7          	jalr	530(ra) # 8000105c <walkaddr>
    80004e52:	862a                	mv	a2,a0
    80004e54:	dd45                	beqz	a0,80004e0c <exec+0xfe>
    80004e56:	8952                	mv	s2,s4
    80004e58:	fd49f2e3          	bgeu	s3,s4,80004e1c <exec+0x10e>
    80004e5c:	894e                	mv	s2,s3
    80004e5e:	bf7d                	j	80004e1c <exec+0x10e>
    80004e60:	4901                	li	s2,0
    80004e62:	8556                	mv	a0,s5
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	bfe080e7          	jalr	-1026(ra) # 80003a62 <iunlockput>
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	3de080e7          	jalr	990(ra) # 8000424a <end_op>
    80004e74:	ffffd097          	auipc	ra,0xffffd
    80004e78:	b4a080e7          	jalr	-1206(ra) # 800019be <myproc>
    80004e7c:	8baa                	mv	s7,a0
    80004e7e:	05053d03          	ld	s10,80(a0)
    80004e82:	6785                	lui	a5,0x1
    80004e84:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004e86:	97ca                	add	a5,a5,s2
    80004e88:	777d                	lui	a4,0xfffff
    80004e8a:	8ff9                	and	a5,a5,a4
    80004e8c:	def43c23          	sd	a5,-520(s0)
    80004e90:	4691                	li	a3,4
    80004e92:	6609                	lui	a2,0x2
    80004e94:	963e                	add	a2,a2,a5
    80004e96:	85be                	mv	a1,a5
    80004e98:	855a                	mv	a0,s6
    80004e9a:	ffffc097          	auipc	ra,0xffffc
    80004e9e:	576080e7          	jalr	1398(ra) # 80001410 <uvmalloc>
    80004ea2:	8c2a                	mv	s8,a0
    80004ea4:	4a81                	li	s5,0
    80004ea6:	12050e63          	beqz	a0,80004fe2 <exec+0x2d4>
    80004eaa:	75f9                	lui	a1,0xffffe
    80004eac:	95aa                	add	a1,a1,a0
    80004eae:	855a                	mv	a0,s6
    80004eb0:	ffffc097          	auipc	ra,0xffffc
    80004eb4:	78a080e7          	jalr	1930(ra) # 8000163a <uvmclear>
    80004eb8:	7afd                	lui	s5,0xfffff
    80004eba:	9ae2                	add	s5,s5,s8
    80004ebc:	df043783          	ld	a5,-528(s0)
    80004ec0:	6388                	ld	a0,0(a5)
    80004ec2:	c925                	beqz	a0,80004f32 <exec+0x224>
    80004ec4:	e9040993          	addi	s3,s0,-368
    80004ec8:	f9040c93          	addi	s9,s0,-112
    80004ecc:	8962                	mv	s2,s8
    80004ece:	4481                	li	s1,0
    80004ed0:	ffffc097          	auipc	ra,0xffffc
    80004ed4:	f7e080e7          	jalr	-130(ra) # 80000e4e <strlen>
    80004ed8:	0015079b          	addiw	a5,a0,1
    80004edc:	40f907b3          	sub	a5,s2,a5
    80004ee0:	ff07f913          	andi	s2,a5,-16
    80004ee4:	13596663          	bltu	s2,s5,80005010 <exec+0x302>
    80004ee8:	df043d83          	ld	s11,-528(s0)
    80004eec:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004ef0:	8552                	mv	a0,s4
    80004ef2:	ffffc097          	auipc	ra,0xffffc
    80004ef6:	f5c080e7          	jalr	-164(ra) # 80000e4e <strlen>
    80004efa:	0015069b          	addiw	a3,a0,1
    80004efe:	8652                	mv	a2,s4
    80004f00:	85ca                	mv	a1,s2
    80004f02:	855a                	mv	a0,s6
    80004f04:	ffffc097          	auipc	ra,0xffffc
    80004f08:	768080e7          	jalr	1896(ra) # 8000166c <copyout>
    80004f0c:	10054663          	bltz	a0,80005018 <exec+0x30a>
    80004f10:	0129b023          	sd	s2,0(s3)
    80004f14:	0485                	addi	s1,s1,1
    80004f16:	008d8793          	addi	a5,s11,8
    80004f1a:	def43823          	sd	a5,-528(s0)
    80004f1e:	008db503          	ld	a0,8(s11)
    80004f22:	c911                	beqz	a0,80004f36 <exec+0x228>
    80004f24:	09a1                	addi	s3,s3,8
    80004f26:	fb3c95e3          	bne	s9,s3,80004ed0 <exec+0x1c2>
    80004f2a:	df843c23          	sd	s8,-520(s0)
    80004f2e:	4a81                	li	s5,0
    80004f30:	a84d                	j	80004fe2 <exec+0x2d4>
    80004f32:	8962                	mv	s2,s8
    80004f34:	4481                	li	s1,0
    80004f36:	00349793          	slli	a5,s1,0x3
    80004f3a:	f9078793          	addi	a5,a5,-112
    80004f3e:	97a2                	add	a5,a5,s0
    80004f40:	f007b023          	sd	zero,-256(a5)
    80004f44:	00148693          	addi	a3,s1,1
    80004f48:	068e                	slli	a3,a3,0x3
    80004f4a:	40d90933          	sub	s2,s2,a3
    80004f4e:	ff097913          	andi	s2,s2,-16
    80004f52:	01597663          	bgeu	s2,s5,80004f5e <exec+0x250>
    80004f56:	df843c23          	sd	s8,-520(s0)
    80004f5a:	4a81                	li	s5,0
    80004f5c:	a059                	j	80004fe2 <exec+0x2d4>
    80004f5e:	e9040613          	addi	a2,s0,-368
    80004f62:	85ca                	mv	a1,s2
    80004f64:	855a                	mv	a0,s6
    80004f66:	ffffc097          	auipc	ra,0xffffc
    80004f6a:	706080e7          	jalr	1798(ra) # 8000166c <copyout>
    80004f6e:	0a054963          	bltz	a0,80005020 <exec+0x312>
    80004f72:	060bb783          	ld	a5,96(s7)
    80004f76:	0727bc23          	sd	s2,120(a5)
    80004f7a:	de843783          	ld	a5,-536(s0)
    80004f7e:	0007c703          	lbu	a4,0(a5)
    80004f82:	cf11                	beqz	a4,80004f9e <exec+0x290>
    80004f84:	0785                	addi	a5,a5,1
    80004f86:	02f00693          	li	a3,47
    80004f8a:	a039                	j	80004f98 <exec+0x28a>
    80004f8c:	def43423          	sd	a5,-536(s0)
    80004f90:	0785                	addi	a5,a5,1
    80004f92:	fff7c703          	lbu	a4,-1(a5)
    80004f96:	c701                	beqz	a4,80004f9e <exec+0x290>
    80004f98:	fed71ce3          	bne	a4,a3,80004f90 <exec+0x282>
    80004f9c:	bfc5                	j	80004f8c <exec+0x27e>
    80004f9e:	4641                	li	a2,16
    80004fa0:	de843583          	ld	a1,-536(s0)
    80004fa4:	160b8513          	addi	a0,s7,352
    80004fa8:	ffffc097          	auipc	ra,0xffffc
    80004fac:	e74080e7          	jalr	-396(ra) # 80000e1c <safestrcpy>
    80004fb0:	058bb503          	ld	a0,88(s7)
    80004fb4:	056bbc23          	sd	s6,88(s7)
    80004fb8:	058bb823          	sd	s8,80(s7)
    80004fbc:	060bb783          	ld	a5,96(s7)
    80004fc0:	e6843703          	ld	a4,-408(s0)
    80004fc4:	ef98                	sd	a4,24(a5)
    80004fc6:	060bb783          	ld	a5,96(s7)
    80004fca:	0327b823          	sd	s2,48(a5)
    80004fce:	85ea                	mv	a1,s10
    80004fd0:	ffffd097          	auipc	ra,0xffffd
    80004fd4:	b4e080e7          	jalr	-1202(ra) # 80001b1e <proc_freepagetable>
    80004fd8:	0004851b          	sext.w	a0,s1
    80004fdc:	b3f9                	j	80004daa <exec+0x9c>
    80004fde:	df243c23          	sd	s2,-520(s0)
    80004fe2:	df843583          	ld	a1,-520(s0)
    80004fe6:	855a                	mv	a0,s6
    80004fe8:	ffffd097          	auipc	ra,0xffffd
    80004fec:	b36080e7          	jalr	-1226(ra) # 80001b1e <proc_freepagetable>
    80004ff0:	da0a93e3          	bnez	s5,80004d96 <exec+0x88>
    80004ff4:	557d                	li	a0,-1
    80004ff6:	bb55                	j	80004daa <exec+0x9c>
    80004ff8:	df243c23          	sd	s2,-520(s0)
    80004ffc:	b7dd                	j	80004fe2 <exec+0x2d4>
    80004ffe:	df243c23          	sd	s2,-520(s0)
    80005002:	b7c5                	j	80004fe2 <exec+0x2d4>
    80005004:	df243c23          	sd	s2,-520(s0)
    80005008:	bfe9                	j	80004fe2 <exec+0x2d4>
    8000500a:	df243c23          	sd	s2,-520(s0)
    8000500e:	bfd1                	j	80004fe2 <exec+0x2d4>
    80005010:	df843c23          	sd	s8,-520(s0)
    80005014:	4a81                	li	s5,0
    80005016:	b7f1                	j	80004fe2 <exec+0x2d4>
    80005018:	df843c23          	sd	s8,-520(s0)
    8000501c:	4a81                	li	s5,0
    8000501e:	b7d1                	j	80004fe2 <exec+0x2d4>
    80005020:	df843c23          	sd	s8,-520(s0)
    80005024:	4a81                	li	s5,0
    80005026:	bf75                	j	80004fe2 <exec+0x2d4>
    80005028:	df843903          	ld	s2,-520(s0)
    8000502c:	e0843783          	ld	a5,-504(s0)
    80005030:	0017869b          	addiw	a3,a5,1
    80005034:	e0d43423          	sd	a3,-504(s0)
    80005038:	e0043783          	ld	a5,-512(s0)
    8000503c:	0387879b          	addiw	a5,a5,56
    80005040:	e8845703          	lhu	a4,-376(s0)
    80005044:	e0e6dfe3          	bge	a3,a4,80004e62 <exec+0x154>
    80005048:	2781                	sext.w	a5,a5
    8000504a:	e0f43023          	sd	a5,-512(s0)
    8000504e:	03800713          	li	a4,56
    80005052:	86be                	mv	a3,a5
    80005054:	e1840613          	addi	a2,s0,-488
    80005058:	4581                	li	a1,0
    8000505a:	8556                	mv	a0,s5
    8000505c:	fffff097          	auipc	ra,0xfffff
    80005060:	a58080e7          	jalr	-1448(ra) # 80003ab4 <readi>
    80005064:	03800793          	li	a5,56
    80005068:	f6f51be3          	bne	a0,a5,80004fde <exec+0x2d0>
    8000506c:	e1842783          	lw	a5,-488(s0)
    80005070:	4705                	li	a4,1
    80005072:	fae79de3          	bne	a5,a4,8000502c <exec+0x31e>
    80005076:	e4043483          	ld	s1,-448(s0)
    8000507a:	e3843783          	ld	a5,-456(s0)
    8000507e:	f6f4ede3          	bltu	s1,a5,80004ff8 <exec+0x2ea>
    80005082:	e2843783          	ld	a5,-472(s0)
    80005086:	94be                	add	s1,s1,a5
    80005088:	f6f4ebe3          	bltu	s1,a5,80004ffe <exec+0x2f0>
    8000508c:	de043703          	ld	a4,-544(s0)
    80005090:	8ff9                	and	a5,a5,a4
    80005092:	fbad                	bnez	a5,80005004 <exec+0x2f6>
    80005094:	e1c42503          	lw	a0,-484(s0)
    80005098:	00000097          	auipc	ra,0x0
    8000509c:	c5c080e7          	jalr	-932(ra) # 80004cf4 <flags2perm>
    800050a0:	86aa                	mv	a3,a0
    800050a2:	8626                	mv	a2,s1
    800050a4:	85ca                	mv	a1,s2
    800050a6:	855a                	mv	a0,s6
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	368080e7          	jalr	872(ra) # 80001410 <uvmalloc>
    800050b0:	dea43c23          	sd	a0,-520(s0)
    800050b4:	d939                	beqz	a0,8000500a <exec+0x2fc>
    800050b6:	e2843c03          	ld	s8,-472(s0)
    800050ba:	e2042c83          	lw	s9,-480(s0)
    800050be:	e3842b83          	lw	s7,-456(s0)
    800050c2:	f60b83e3          	beqz	s7,80005028 <exec+0x31a>
    800050c6:	89de                	mv	s3,s7
    800050c8:	4481                	li	s1,0
    800050ca:	bb9d                	j	80004e40 <exec+0x132>

00000000800050cc <argfd>:
    800050cc:	7179                	addi	sp,sp,-48
    800050ce:	f406                	sd	ra,40(sp)
    800050d0:	f022                	sd	s0,32(sp)
    800050d2:	ec26                	sd	s1,24(sp)
    800050d4:	e84a                	sd	s2,16(sp)
    800050d6:	1800                	addi	s0,sp,48
    800050d8:	892e                	mv	s2,a1
    800050da:	84b2                	mv	s1,a2
    800050dc:	fdc40593          	addi	a1,s0,-36
    800050e0:	ffffe097          	auipc	ra,0xffffe
    800050e4:	b88080e7          	jalr	-1144(ra) # 80002c68 <argint>
    800050e8:	fdc42703          	lw	a4,-36(s0)
    800050ec:	47bd                	li	a5,15
    800050ee:	02e7eb63          	bltu	a5,a4,80005124 <argfd+0x58>
    800050f2:	ffffd097          	auipc	ra,0xffffd
    800050f6:	8cc080e7          	jalr	-1844(ra) # 800019be <myproc>
    800050fa:	fdc42703          	lw	a4,-36(s0)
    800050fe:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd01a>
    80005102:	078e                	slli	a5,a5,0x3
    80005104:	953e                	add	a0,a0,a5
    80005106:	651c                	ld	a5,8(a0)
    80005108:	c385                	beqz	a5,80005128 <argfd+0x5c>
    8000510a:	00090463          	beqz	s2,80005112 <argfd+0x46>
    8000510e:	00e92023          	sw	a4,0(s2)
    80005112:	4501                	li	a0,0
    80005114:	c091                	beqz	s1,80005118 <argfd+0x4c>
    80005116:	e09c                	sd	a5,0(s1)
    80005118:	70a2                	ld	ra,40(sp)
    8000511a:	7402                	ld	s0,32(sp)
    8000511c:	64e2                	ld	s1,24(sp)
    8000511e:	6942                	ld	s2,16(sp)
    80005120:	6145                	addi	sp,sp,48
    80005122:	8082                	ret
    80005124:	557d                	li	a0,-1
    80005126:	bfcd                	j	80005118 <argfd+0x4c>
    80005128:	557d                	li	a0,-1
    8000512a:	b7fd                	j	80005118 <argfd+0x4c>

000000008000512c <fdalloc>:
    8000512c:	1101                	addi	sp,sp,-32
    8000512e:	ec06                	sd	ra,24(sp)
    80005130:	e822                	sd	s0,16(sp)
    80005132:	e426                	sd	s1,8(sp)
    80005134:	1000                	addi	s0,sp,32
    80005136:	84aa                	mv	s1,a0
    80005138:	ffffd097          	auipc	ra,0xffffd
    8000513c:	886080e7          	jalr	-1914(ra) # 800019be <myproc>
    80005140:	862a                	mv	a2,a0
    80005142:	0d850793          	addi	a5,a0,216
    80005146:	4501                	li	a0,0
    80005148:	46c1                	li	a3,16
    8000514a:	6398                	ld	a4,0(a5)
    8000514c:	cb19                	beqz	a4,80005162 <fdalloc+0x36>
    8000514e:	2505                	addiw	a0,a0,1
    80005150:	07a1                	addi	a5,a5,8
    80005152:	fed51ce3          	bne	a0,a3,8000514a <fdalloc+0x1e>
    80005156:	557d                	li	a0,-1
    80005158:	60e2                	ld	ra,24(sp)
    8000515a:	6442                	ld	s0,16(sp)
    8000515c:	64a2                	ld	s1,8(sp)
    8000515e:	6105                	addi	sp,sp,32
    80005160:	8082                	ret
    80005162:	01a50793          	addi	a5,a0,26
    80005166:	078e                	slli	a5,a5,0x3
    80005168:	963e                	add	a2,a2,a5
    8000516a:	e604                	sd	s1,8(a2)
    8000516c:	b7f5                	j	80005158 <fdalloc+0x2c>

000000008000516e <create>:
    8000516e:	715d                	addi	sp,sp,-80
    80005170:	e486                	sd	ra,72(sp)
    80005172:	e0a2                	sd	s0,64(sp)
    80005174:	fc26                	sd	s1,56(sp)
    80005176:	f84a                	sd	s2,48(sp)
    80005178:	f44e                	sd	s3,40(sp)
    8000517a:	f052                	sd	s4,32(sp)
    8000517c:	ec56                	sd	s5,24(sp)
    8000517e:	e85a                	sd	s6,16(sp)
    80005180:	0880                	addi	s0,sp,80
    80005182:	8b2e                	mv	s6,a1
    80005184:	89b2                	mv	s3,a2
    80005186:	8936                	mv	s2,a3
    80005188:	fb040593          	addi	a1,s0,-80
    8000518c:	fffff097          	auipc	ra,0xfffff
    80005190:	e3e080e7          	jalr	-450(ra) # 80003fca <nameiparent>
    80005194:	84aa                	mv	s1,a0
    80005196:	14050f63          	beqz	a0,800052f4 <create+0x186>
    8000519a:	ffffe097          	auipc	ra,0xffffe
    8000519e:	666080e7          	jalr	1638(ra) # 80003800 <ilock>
    800051a2:	4601                	li	a2,0
    800051a4:	fb040593          	addi	a1,s0,-80
    800051a8:	8526                	mv	a0,s1
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	b3a080e7          	jalr	-1222(ra) # 80003ce4 <dirlookup>
    800051b2:	8aaa                	mv	s5,a0
    800051b4:	c931                	beqz	a0,80005208 <create+0x9a>
    800051b6:	8526                	mv	a0,s1
    800051b8:	fffff097          	auipc	ra,0xfffff
    800051bc:	8aa080e7          	jalr	-1878(ra) # 80003a62 <iunlockput>
    800051c0:	8556                	mv	a0,s5
    800051c2:	ffffe097          	auipc	ra,0xffffe
    800051c6:	63e080e7          	jalr	1598(ra) # 80003800 <ilock>
    800051ca:	000b059b          	sext.w	a1,s6
    800051ce:	4789                	li	a5,2
    800051d0:	02f59563          	bne	a1,a5,800051fa <create+0x8c>
    800051d4:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd044>
    800051d8:	37f9                	addiw	a5,a5,-2
    800051da:	17c2                	slli	a5,a5,0x30
    800051dc:	93c1                	srli	a5,a5,0x30
    800051de:	4705                	li	a4,1
    800051e0:	00f76d63          	bltu	a4,a5,800051fa <create+0x8c>
    800051e4:	8556                	mv	a0,s5
    800051e6:	60a6                	ld	ra,72(sp)
    800051e8:	6406                	ld	s0,64(sp)
    800051ea:	74e2                	ld	s1,56(sp)
    800051ec:	7942                	ld	s2,48(sp)
    800051ee:	79a2                	ld	s3,40(sp)
    800051f0:	7a02                	ld	s4,32(sp)
    800051f2:	6ae2                	ld	s5,24(sp)
    800051f4:	6b42                	ld	s6,16(sp)
    800051f6:	6161                	addi	sp,sp,80
    800051f8:	8082                	ret
    800051fa:	8556                	mv	a0,s5
    800051fc:	fffff097          	auipc	ra,0xfffff
    80005200:	866080e7          	jalr	-1946(ra) # 80003a62 <iunlockput>
    80005204:	4a81                	li	s5,0
    80005206:	bff9                	j	800051e4 <create+0x76>
    80005208:	85da                	mv	a1,s6
    8000520a:	4088                	lw	a0,0(s1)
    8000520c:	ffffe097          	auipc	ra,0xffffe
    80005210:	456080e7          	jalr	1110(ra) # 80003662 <ialloc>
    80005214:	8a2a                	mv	s4,a0
    80005216:	c539                	beqz	a0,80005264 <create+0xf6>
    80005218:	ffffe097          	auipc	ra,0xffffe
    8000521c:	5e8080e7          	jalr	1512(ra) # 80003800 <ilock>
    80005220:	053a1323          	sh	s3,70(s4)
    80005224:	052a1423          	sh	s2,72(s4)
    80005228:	4905                	li	s2,1
    8000522a:	052a1523          	sh	s2,74(s4)
    8000522e:	8552                	mv	a0,s4
    80005230:	ffffe097          	auipc	ra,0xffffe
    80005234:	504080e7          	jalr	1284(ra) # 80003734 <iupdate>
    80005238:	000b059b          	sext.w	a1,s6
    8000523c:	03258b63          	beq	a1,s2,80005272 <create+0x104>
    80005240:	004a2603          	lw	a2,4(s4)
    80005244:	fb040593          	addi	a1,s0,-80
    80005248:	8526                	mv	a0,s1
    8000524a:	fffff097          	auipc	ra,0xfffff
    8000524e:	cb0080e7          	jalr	-848(ra) # 80003efa <dirlink>
    80005252:	06054f63          	bltz	a0,800052d0 <create+0x162>
    80005256:	8526                	mv	a0,s1
    80005258:	fffff097          	auipc	ra,0xfffff
    8000525c:	80a080e7          	jalr	-2038(ra) # 80003a62 <iunlockput>
    80005260:	8ad2                	mv	s5,s4
    80005262:	b749                	j	800051e4 <create+0x76>
    80005264:	8526                	mv	a0,s1
    80005266:	ffffe097          	auipc	ra,0xffffe
    8000526a:	7fc080e7          	jalr	2044(ra) # 80003a62 <iunlockput>
    8000526e:	8ad2                	mv	s5,s4
    80005270:	bf95                	j	800051e4 <create+0x76>
    80005272:	004a2603          	lw	a2,4(s4)
    80005276:	00003597          	auipc	a1,0x3
    8000527a:	51258593          	addi	a1,a1,1298 # 80008788 <syscalls+0x2a8>
    8000527e:	8552                	mv	a0,s4
    80005280:	fffff097          	auipc	ra,0xfffff
    80005284:	c7a080e7          	jalr	-902(ra) # 80003efa <dirlink>
    80005288:	04054463          	bltz	a0,800052d0 <create+0x162>
    8000528c:	40d0                	lw	a2,4(s1)
    8000528e:	00003597          	auipc	a1,0x3
    80005292:	50258593          	addi	a1,a1,1282 # 80008790 <syscalls+0x2b0>
    80005296:	8552                	mv	a0,s4
    80005298:	fffff097          	auipc	ra,0xfffff
    8000529c:	c62080e7          	jalr	-926(ra) # 80003efa <dirlink>
    800052a0:	02054863          	bltz	a0,800052d0 <create+0x162>
    800052a4:	004a2603          	lw	a2,4(s4)
    800052a8:	fb040593          	addi	a1,s0,-80
    800052ac:	8526                	mv	a0,s1
    800052ae:	fffff097          	auipc	ra,0xfffff
    800052b2:	c4c080e7          	jalr	-948(ra) # 80003efa <dirlink>
    800052b6:	00054d63          	bltz	a0,800052d0 <create+0x162>
    800052ba:	04a4d783          	lhu	a5,74(s1)
    800052be:	2785                	addiw	a5,a5,1
    800052c0:	04f49523          	sh	a5,74(s1)
    800052c4:	8526                	mv	a0,s1
    800052c6:	ffffe097          	auipc	ra,0xffffe
    800052ca:	46e080e7          	jalr	1134(ra) # 80003734 <iupdate>
    800052ce:	b761                	j	80005256 <create+0xe8>
    800052d0:	040a1523          	sh	zero,74(s4)
    800052d4:	8552                	mv	a0,s4
    800052d6:	ffffe097          	auipc	ra,0xffffe
    800052da:	45e080e7          	jalr	1118(ra) # 80003734 <iupdate>
    800052de:	8552                	mv	a0,s4
    800052e0:	ffffe097          	auipc	ra,0xffffe
    800052e4:	782080e7          	jalr	1922(ra) # 80003a62 <iunlockput>
    800052e8:	8526                	mv	a0,s1
    800052ea:	ffffe097          	auipc	ra,0xffffe
    800052ee:	778080e7          	jalr	1912(ra) # 80003a62 <iunlockput>
    800052f2:	bdcd                	j	800051e4 <create+0x76>
    800052f4:	8aaa                	mv	s5,a0
    800052f6:	b5fd                	j	800051e4 <create+0x76>

00000000800052f8 <sys_dup>:
    800052f8:	7179                	addi	sp,sp,-48
    800052fa:	f406                	sd	ra,40(sp)
    800052fc:	f022                	sd	s0,32(sp)
    800052fe:	ec26                	sd	s1,24(sp)
    80005300:	e84a                	sd	s2,16(sp)
    80005302:	1800                	addi	s0,sp,48
    80005304:	fd840613          	addi	a2,s0,-40
    80005308:	4581                	li	a1,0
    8000530a:	4501                	li	a0,0
    8000530c:	00000097          	auipc	ra,0x0
    80005310:	dc0080e7          	jalr	-576(ra) # 800050cc <argfd>
    80005314:	57fd                	li	a5,-1
    80005316:	02054363          	bltz	a0,8000533c <sys_dup+0x44>
    8000531a:	fd843903          	ld	s2,-40(s0)
    8000531e:	854a                	mv	a0,s2
    80005320:	00000097          	auipc	ra,0x0
    80005324:	e0c080e7          	jalr	-500(ra) # 8000512c <fdalloc>
    80005328:	84aa                	mv	s1,a0
    8000532a:	57fd                	li	a5,-1
    8000532c:	00054863          	bltz	a0,8000533c <sys_dup+0x44>
    80005330:	854a                	mv	a0,s2
    80005332:	fffff097          	auipc	ra,0xfffff
    80005336:	310080e7          	jalr	784(ra) # 80004642 <filedup>
    8000533a:	87a6                	mv	a5,s1
    8000533c:	853e                	mv	a0,a5
    8000533e:	70a2                	ld	ra,40(sp)
    80005340:	7402                	ld	s0,32(sp)
    80005342:	64e2                	ld	s1,24(sp)
    80005344:	6942                	ld	s2,16(sp)
    80005346:	6145                	addi	sp,sp,48
    80005348:	8082                	ret

000000008000534a <sys_read>:
    8000534a:	7179                	addi	sp,sp,-48
    8000534c:	f406                	sd	ra,40(sp)
    8000534e:	f022                	sd	s0,32(sp)
    80005350:	1800                	addi	s0,sp,48
    80005352:	fd840593          	addi	a1,s0,-40
    80005356:	4505                	li	a0,1
    80005358:	ffffe097          	auipc	ra,0xffffe
    8000535c:	930080e7          	jalr	-1744(ra) # 80002c88 <argaddr>
    80005360:	fe440593          	addi	a1,s0,-28
    80005364:	4509                	li	a0,2
    80005366:	ffffe097          	auipc	ra,0xffffe
    8000536a:	902080e7          	jalr	-1790(ra) # 80002c68 <argint>
    8000536e:	fe840613          	addi	a2,s0,-24
    80005372:	4581                	li	a1,0
    80005374:	4501                	li	a0,0
    80005376:	00000097          	auipc	ra,0x0
    8000537a:	d56080e7          	jalr	-682(ra) # 800050cc <argfd>
    8000537e:	87aa                	mv	a5,a0
    80005380:	557d                	li	a0,-1
    80005382:	0007cc63          	bltz	a5,8000539a <sys_read+0x50>
    80005386:	fe442603          	lw	a2,-28(s0)
    8000538a:	fd843583          	ld	a1,-40(s0)
    8000538e:	fe843503          	ld	a0,-24(s0)
    80005392:	fffff097          	auipc	ra,0xfffff
    80005396:	43c080e7          	jalr	1084(ra) # 800047ce <fileread>
    8000539a:	70a2                	ld	ra,40(sp)
    8000539c:	7402                	ld	s0,32(sp)
    8000539e:	6145                	addi	sp,sp,48
    800053a0:	8082                	ret

00000000800053a2 <sys_write>:
    800053a2:	7179                	addi	sp,sp,-48
    800053a4:	f406                	sd	ra,40(sp)
    800053a6:	f022                	sd	s0,32(sp)
    800053a8:	1800                	addi	s0,sp,48
    800053aa:	fd840593          	addi	a1,s0,-40
    800053ae:	4505                	li	a0,1
    800053b0:	ffffe097          	auipc	ra,0xffffe
    800053b4:	8d8080e7          	jalr	-1832(ra) # 80002c88 <argaddr>
    800053b8:	fe440593          	addi	a1,s0,-28
    800053bc:	4509                	li	a0,2
    800053be:	ffffe097          	auipc	ra,0xffffe
    800053c2:	8aa080e7          	jalr	-1878(ra) # 80002c68 <argint>
    800053c6:	fe840613          	addi	a2,s0,-24
    800053ca:	4581                	li	a1,0
    800053cc:	4501                	li	a0,0
    800053ce:	00000097          	auipc	ra,0x0
    800053d2:	cfe080e7          	jalr	-770(ra) # 800050cc <argfd>
    800053d6:	87aa                	mv	a5,a0
    800053d8:	557d                	li	a0,-1
    800053da:	0007cc63          	bltz	a5,800053f2 <sys_write+0x50>
    800053de:	fe442603          	lw	a2,-28(s0)
    800053e2:	fd843583          	ld	a1,-40(s0)
    800053e6:	fe843503          	ld	a0,-24(s0)
    800053ea:	fffff097          	auipc	ra,0xfffff
    800053ee:	4a6080e7          	jalr	1190(ra) # 80004890 <filewrite>
    800053f2:	70a2                	ld	ra,40(sp)
    800053f4:	7402                	ld	s0,32(sp)
    800053f6:	6145                	addi	sp,sp,48
    800053f8:	8082                	ret

00000000800053fa <sys_close>:
    800053fa:	1101                	addi	sp,sp,-32
    800053fc:	ec06                	sd	ra,24(sp)
    800053fe:	e822                	sd	s0,16(sp)
    80005400:	1000                	addi	s0,sp,32
    80005402:	fe040613          	addi	a2,s0,-32
    80005406:	fec40593          	addi	a1,s0,-20
    8000540a:	4501                	li	a0,0
    8000540c:	00000097          	auipc	ra,0x0
    80005410:	cc0080e7          	jalr	-832(ra) # 800050cc <argfd>
    80005414:	57fd                	li	a5,-1
    80005416:	02054463          	bltz	a0,8000543e <sys_close+0x44>
    8000541a:	ffffc097          	auipc	ra,0xffffc
    8000541e:	5a4080e7          	jalr	1444(ra) # 800019be <myproc>
    80005422:	fec42783          	lw	a5,-20(s0)
    80005426:	07e9                	addi	a5,a5,26
    80005428:	078e                	slli	a5,a5,0x3
    8000542a:	953e                	add	a0,a0,a5
    8000542c:	00053423          	sd	zero,8(a0)
    80005430:	fe043503          	ld	a0,-32(s0)
    80005434:	fffff097          	auipc	ra,0xfffff
    80005438:	260080e7          	jalr	608(ra) # 80004694 <fileclose>
    8000543c:	4781                	li	a5,0
    8000543e:	853e                	mv	a0,a5
    80005440:	60e2                	ld	ra,24(sp)
    80005442:	6442                	ld	s0,16(sp)
    80005444:	6105                	addi	sp,sp,32
    80005446:	8082                	ret

0000000080005448 <sys_fstat>:
    80005448:	1101                	addi	sp,sp,-32
    8000544a:	ec06                	sd	ra,24(sp)
    8000544c:	e822                	sd	s0,16(sp)
    8000544e:	1000                	addi	s0,sp,32
    80005450:	fe040593          	addi	a1,s0,-32
    80005454:	4505                	li	a0,1
    80005456:	ffffe097          	auipc	ra,0xffffe
    8000545a:	832080e7          	jalr	-1998(ra) # 80002c88 <argaddr>
    8000545e:	fe840613          	addi	a2,s0,-24
    80005462:	4581                	li	a1,0
    80005464:	4501                	li	a0,0
    80005466:	00000097          	auipc	ra,0x0
    8000546a:	c66080e7          	jalr	-922(ra) # 800050cc <argfd>
    8000546e:	87aa                	mv	a5,a0
    80005470:	557d                	li	a0,-1
    80005472:	0007ca63          	bltz	a5,80005486 <sys_fstat+0x3e>
    80005476:	fe043583          	ld	a1,-32(s0)
    8000547a:	fe843503          	ld	a0,-24(s0)
    8000547e:	fffff097          	auipc	ra,0xfffff
    80005482:	2de080e7          	jalr	734(ra) # 8000475c <filestat>
    80005486:	60e2                	ld	ra,24(sp)
    80005488:	6442                	ld	s0,16(sp)
    8000548a:	6105                	addi	sp,sp,32
    8000548c:	8082                	ret

000000008000548e <sys_link>:
    8000548e:	7169                	addi	sp,sp,-304
    80005490:	f606                	sd	ra,296(sp)
    80005492:	f222                	sd	s0,288(sp)
    80005494:	ee26                	sd	s1,280(sp)
    80005496:	ea4a                	sd	s2,272(sp)
    80005498:	1a00                	addi	s0,sp,304
    8000549a:	08000613          	li	a2,128
    8000549e:	ed040593          	addi	a1,s0,-304
    800054a2:	4501                	li	a0,0
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	804080e7          	jalr	-2044(ra) # 80002ca8 <argstr>
    800054ac:	57fd                	li	a5,-1
    800054ae:	10054e63          	bltz	a0,800055ca <sys_link+0x13c>
    800054b2:	08000613          	li	a2,128
    800054b6:	f5040593          	addi	a1,s0,-176
    800054ba:	4505                	li	a0,1
    800054bc:	ffffd097          	auipc	ra,0xffffd
    800054c0:	7ec080e7          	jalr	2028(ra) # 80002ca8 <argstr>
    800054c4:	57fd                	li	a5,-1
    800054c6:	10054263          	bltz	a0,800055ca <sys_link+0x13c>
    800054ca:	fffff097          	auipc	ra,0xfffff
    800054ce:	d02080e7          	jalr	-766(ra) # 800041cc <begin_op>
    800054d2:	ed040513          	addi	a0,s0,-304
    800054d6:	fffff097          	auipc	ra,0xfffff
    800054da:	ad6080e7          	jalr	-1322(ra) # 80003fac <namei>
    800054de:	84aa                	mv	s1,a0
    800054e0:	c551                	beqz	a0,8000556c <sys_link+0xde>
    800054e2:	ffffe097          	auipc	ra,0xffffe
    800054e6:	31e080e7          	jalr	798(ra) # 80003800 <ilock>
    800054ea:	04449703          	lh	a4,68(s1)
    800054ee:	4785                	li	a5,1
    800054f0:	08f70463          	beq	a4,a5,80005578 <sys_link+0xea>
    800054f4:	04a4d783          	lhu	a5,74(s1)
    800054f8:	2785                	addiw	a5,a5,1
    800054fa:	04f49523          	sh	a5,74(s1)
    800054fe:	8526                	mv	a0,s1
    80005500:	ffffe097          	auipc	ra,0xffffe
    80005504:	234080e7          	jalr	564(ra) # 80003734 <iupdate>
    80005508:	8526                	mv	a0,s1
    8000550a:	ffffe097          	auipc	ra,0xffffe
    8000550e:	3b8080e7          	jalr	952(ra) # 800038c2 <iunlock>
    80005512:	fd040593          	addi	a1,s0,-48
    80005516:	f5040513          	addi	a0,s0,-176
    8000551a:	fffff097          	auipc	ra,0xfffff
    8000551e:	ab0080e7          	jalr	-1360(ra) # 80003fca <nameiparent>
    80005522:	892a                	mv	s2,a0
    80005524:	c935                	beqz	a0,80005598 <sys_link+0x10a>
    80005526:	ffffe097          	auipc	ra,0xffffe
    8000552a:	2da080e7          	jalr	730(ra) # 80003800 <ilock>
    8000552e:	00092703          	lw	a4,0(s2)
    80005532:	409c                	lw	a5,0(s1)
    80005534:	04f71d63          	bne	a4,a5,8000558e <sys_link+0x100>
    80005538:	40d0                	lw	a2,4(s1)
    8000553a:	fd040593          	addi	a1,s0,-48
    8000553e:	854a                	mv	a0,s2
    80005540:	fffff097          	auipc	ra,0xfffff
    80005544:	9ba080e7          	jalr	-1606(ra) # 80003efa <dirlink>
    80005548:	04054363          	bltz	a0,8000558e <sys_link+0x100>
    8000554c:	854a                	mv	a0,s2
    8000554e:	ffffe097          	auipc	ra,0xffffe
    80005552:	514080e7          	jalr	1300(ra) # 80003a62 <iunlockput>
    80005556:	8526                	mv	a0,s1
    80005558:	ffffe097          	auipc	ra,0xffffe
    8000555c:	462080e7          	jalr	1122(ra) # 800039ba <iput>
    80005560:	fffff097          	auipc	ra,0xfffff
    80005564:	cea080e7          	jalr	-790(ra) # 8000424a <end_op>
    80005568:	4781                	li	a5,0
    8000556a:	a085                	j	800055ca <sys_link+0x13c>
    8000556c:	fffff097          	auipc	ra,0xfffff
    80005570:	cde080e7          	jalr	-802(ra) # 8000424a <end_op>
    80005574:	57fd                	li	a5,-1
    80005576:	a891                	j	800055ca <sys_link+0x13c>
    80005578:	8526                	mv	a0,s1
    8000557a:	ffffe097          	auipc	ra,0xffffe
    8000557e:	4e8080e7          	jalr	1256(ra) # 80003a62 <iunlockput>
    80005582:	fffff097          	auipc	ra,0xfffff
    80005586:	cc8080e7          	jalr	-824(ra) # 8000424a <end_op>
    8000558a:	57fd                	li	a5,-1
    8000558c:	a83d                	j	800055ca <sys_link+0x13c>
    8000558e:	854a                	mv	a0,s2
    80005590:	ffffe097          	auipc	ra,0xffffe
    80005594:	4d2080e7          	jalr	1234(ra) # 80003a62 <iunlockput>
    80005598:	8526                	mv	a0,s1
    8000559a:	ffffe097          	auipc	ra,0xffffe
    8000559e:	266080e7          	jalr	614(ra) # 80003800 <ilock>
    800055a2:	04a4d783          	lhu	a5,74(s1)
    800055a6:	37fd                	addiw	a5,a5,-1
    800055a8:	04f49523          	sh	a5,74(s1)
    800055ac:	8526                	mv	a0,s1
    800055ae:	ffffe097          	auipc	ra,0xffffe
    800055b2:	186080e7          	jalr	390(ra) # 80003734 <iupdate>
    800055b6:	8526                	mv	a0,s1
    800055b8:	ffffe097          	auipc	ra,0xffffe
    800055bc:	4aa080e7          	jalr	1194(ra) # 80003a62 <iunlockput>
    800055c0:	fffff097          	auipc	ra,0xfffff
    800055c4:	c8a080e7          	jalr	-886(ra) # 8000424a <end_op>
    800055c8:	57fd                	li	a5,-1
    800055ca:	853e                	mv	a0,a5
    800055cc:	70b2                	ld	ra,296(sp)
    800055ce:	7412                	ld	s0,288(sp)
    800055d0:	64f2                	ld	s1,280(sp)
    800055d2:	6952                	ld	s2,272(sp)
    800055d4:	6155                	addi	sp,sp,304
    800055d6:	8082                	ret

00000000800055d8 <sys_unlink>:
    800055d8:	7151                	addi	sp,sp,-240
    800055da:	f586                	sd	ra,232(sp)
    800055dc:	f1a2                	sd	s0,224(sp)
    800055de:	eda6                	sd	s1,216(sp)
    800055e0:	e9ca                	sd	s2,208(sp)
    800055e2:	e5ce                	sd	s3,200(sp)
    800055e4:	1980                	addi	s0,sp,240
    800055e6:	08000613          	li	a2,128
    800055ea:	f3040593          	addi	a1,s0,-208
    800055ee:	4501                	li	a0,0
    800055f0:	ffffd097          	auipc	ra,0xffffd
    800055f4:	6b8080e7          	jalr	1720(ra) # 80002ca8 <argstr>
    800055f8:	18054163          	bltz	a0,8000577a <sys_unlink+0x1a2>
    800055fc:	fffff097          	auipc	ra,0xfffff
    80005600:	bd0080e7          	jalr	-1072(ra) # 800041cc <begin_op>
    80005604:	fb040593          	addi	a1,s0,-80
    80005608:	f3040513          	addi	a0,s0,-208
    8000560c:	fffff097          	auipc	ra,0xfffff
    80005610:	9be080e7          	jalr	-1602(ra) # 80003fca <nameiparent>
    80005614:	84aa                	mv	s1,a0
    80005616:	c979                	beqz	a0,800056ec <sys_unlink+0x114>
    80005618:	ffffe097          	auipc	ra,0xffffe
    8000561c:	1e8080e7          	jalr	488(ra) # 80003800 <ilock>
    80005620:	00003597          	auipc	a1,0x3
    80005624:	16858593          	addi	a1,a1,360 # 80008788 <syscalls+0x2a8>
    80005628:	fb040513          	addi	a0,s0,-80
    8000562c:	ffffe097          	auipc	ra,0xffffe
    80005630:	69e080e7          	jalr	1694(ra) # 80003cca <namecmp>
    80005634:	14050a63          	beqz	a0,80005788 <sys_unlink+0x1b0>
    80005638:	00003597          	auipc	a1,0x3
    8000563c:	15858593          	addi	a1,a1,344 # 80008790 <syscalls+0x2b0>
    80005640:	fb040513          	addi	a0,s0,-80
    80005644:	ffffe097          	auipc	ra,0xffffe
    80005648:	686080e7          	jalr	1670(ra) # 80003cca <namecmp>
    8000564c:	12050e63          	beqz	a0,80005788 <sys_unlink+0x1b0>
    80005650:	f2c40613          	addi	a2,s0,-212
    80005654:	fb040593          	addi	a1,s0,-80
    80005658:	8526                	mv	a0,s1
    8000565a:	ffffe097          	auipc	ra,0xffffe
    8000565e:	68a080e7          	jalr	1674(ra) # 80003ce4 <dirlookup>
    80005662:	892a                	mv	s2,a0
    80005664:	12050263          	beqz	a0,80005788 <sys_unlink+0x1b0>
    80005668:	ffffe097          	auipc	ra,0xffffe
    8000566c:	198080e7          	jalr	408(ra) # 80003800 <ilock>
    80005670:	04a91783          	lh	a5,74(s2)
    80005674:	08f05263          	blez	a5,800056f8 <sys_unlink+0x120>
    80005678:	04491703          	lh	a4,68(s2)
    8000567c:	4785                	li	a5,1
    8000567e:	08f70563          	beq	a4,a5,80005708 <sys_unlink+0x130>
    80005682:	4641                	li	a2,16
    80005684:	4581                	li	a1,0
    80005686:	fc040513          	addi	a0,s0,-64
    8000568a:	ffffb097          	auipc	ra,0xffffb
    8000568e:	648080e7          	jalr	1608(ra) # 80000cd2 <memset>
    80005692:	4741                	li	a4,16
    80005694:	f2c42683          	lw	a3,-212(s0)
    80005698:	fc040613          	addi	a2,s0,-64
    8000569c:	4581                	li	a1,0
    8000569e:	8526                	mv	a0,s1
    800056a0:	ffffe097          	auipc	ra,0xffffe
    800056a4:	50c080e7          	jalr	1292(ra) # 80003bac <writei>
    800056a8:	47c1                	li	a5,16
    800056aa:	0af51563          	bne	a0,a5,80005754 <sys_unlink+0x17c>
    800056ae:	04491703          	lh	a4,68(s2)
    800056b2:	4785                	li	a5,1
    800056b4:	0af70863          	beq	a4,a5,80005764 <sys_unlink+0x18c>
    800056b8:	8526                	mv	a0,s1
    800056ba:	ffffe097          	auipc	ra,0xffffe
    800056be:	3a8080e7          	jalr	936(ra) # 80003a62 <iunlockput>
    800056c2:	04a95783          	lhu	a5,74(s2)
    800056c6:	37fd                	addiw	a5,a5,-1
    800056c8:	04f91523          	sh	a5,74(s2)
    800056cc:	854a                	mv	a0,s2
    800056ce:	ffffe097          	auipc	ra,0xffffe
    800056d2:	066080e7          	jalr	102(ra) # 80003734 <iupdate>
    800056d6:	854a                	mv	a0,s2
    800056d8:	ffffe097          	auipc	ra,0xffffe
    800056dc:	38a080e7          	jalr	906(ra) # 80003a62 <iunlockput>
    800056e0:	fffff097          	auipc	ra,0xfffff
    800056e4:	b6a080e7          	jalr	-1174(ra) # 8000424a <end_op>
    800056e8:	4501                	li	a0,0
    800056ea:	a84d                	j	8000579c <sys_unlink+0x1c4>
    800056ec:	fffff097          	auipc	ra,0xfffff
    800056f0:	b5e080e7          	jalr	-1186(ra) # 8000424a <end_op>
    800056f4:	557d                	li	a0,-1
    800056f6:	a05d                	j	8000579c <sys_unlink+0x1c4>
    800056f8:	00003517          	auipc	a0,0x3
    800056fc:	0a050513          	addi	a0,a0,160 # 80008798 <syscalls+0x2b8>
    80005700:	ffffb097          	auipc	ra,0xffffb
    80005704:	e40080e7          	jalr	-448(ra) # 80000540 <panic>
    80005708:	04c92703          	lw	a4,76(s2)
    8000570c:	02000793          	li	a5,32
    80005710:	f6e7f9e3          	bgeu	a5,a4,80005682 <sys_unlink+0xaa>
    80005714:	02000993          	li	s3,32
    80005718:	4741                	li	a4,16
    8000571a:	86ce                	mv	a3,s3
    8000571c:	f1840613          	addi	a2,s0,-232
    80005720:	4581                	li	a1,0
    80005722:	854a                	mv	a0,s2
    80005724:	ffffe097          	auipc	ra,0xffffe
    80005728:	390080e7          	jalr	912(ra) # 80003ab4 <readi>
    8000572c:	47c1                	li	a5,16
    8000572e:	00f51b63          	bne	a0,a5,80005744 <sys_unlink+0x16c>
    80005732:	f1845783          	lhu	a5,-232(s0)
    80005736:	e7a1                	bnez	a5,8000577e <sys_unlink+0x1a6>
    80005738:	29c1                	addiw	s3,s3,16
    8000573a:	04c92783          	lw	a5,76(s2)
    8000573e:	fcf9ede3          	bltu	s3,a5,80005718 <sys_unlink+0x140>
    80005742:	b781                	j	80005682 <sys_unlink+0xaa>
    80005744:	00003517          	auipc	a0,0x3
    80005748:	06c50513          	addi	a0,a0,108 # 800087b0 <syscalls+0x2d0>
    8000574c:	ffffb097          	auipc	ra,0xffffb
    80005750:	df4080e7          	jalr	-524(ra) # 80000540 <panic>
    80005754:	00003517          	auipc	a0,0x3
    80005758:	07450513          	addi	a0,a0,116 # 800087c8 <syscalls+0x2e8>
    8000575c:	ffffb097          	auipc	ra,0xffffb
    80005760:	de4080e7          	jalr	-540(ra) # 80000540 <panic>
    80005764:	04a4d783          	lhu	a5,74(s1)
    80005768:	37fd                	addiw	a5,a5,-1
    8000576a:	04f49523          	sh	a5,74(s1)
    8000576e:	8526                	mv	a0,s1
    80005770:	ffffe097          	auipc	ra,0xffffe
    80005774:	fc4080e7          	jalr	-60(ra) # 80003734 <iupdate>
    80005778:	b781                	j	800056b8 <sys_unlink+0xe0>
    8000577a:	557d                	li	a0,-1
    8000577c:	a005                	j	8000579c <sys_unlink+0x1c4>
    8000577e:	854a                	mv	a0,s2
    80005780:	ffffe097          	auipc	ra,0xffffe
    80005784:	2e2080e7          	jalr	738(ra) # 80003a62 <iunlockput>
    80005788:	8526                	mv	a0,s1
    8000578a:	ffffe097          	auipc	ra,0xffffe
    8000578e:	2d8080e7          	jalr	728(ra) # 80003a62 <iunlockput>
    80005792:	fffff097          	auipc	ra,0xfffff
    80005796:	ab8080e7          	jalr	-1352(ra) # 8000424a <end_op>
    8000579a:	557d                	li	a0,-1
    8000579c:	70ae                	ld	ra,232(sp)
    8000579e:	740e                	ld	s0,224(sp)
    800057a0:	64ee                	ld	s1,216(sp)
    800057a2:	694e                	ld	s2,208(sp)
    800057a4:	69ae                	ld	s3,200(sp)
    800057a6:	616d                	addi	sp,sp,240
    800057a8:	8082                	ret

00000000800057aa <sys_open>:
    800057aa:	7131                	addi	sp,sp,-192
    800057ac:	fd06                	sd	ra,184(sp)
    800057ae:	f922                	sd	s0,176(sp)
    800057b0:	f526                	sd	s1,168(sp)
    800057b2:	f14a                	sd	s2,160(sp)
    800057b4:	ed4e                	sd	s3,152(sp)
    800057b6:	0180                	addi	s0,sp,192
    800057b8:	f4c40593          	addi	a1,s0,-180
    800057bc:	4505                	li	a0,1
    800057be:	ffffd097          	auipc	ra,0xffffd
    800057c2:	4aa080e7          	jalr	1194(ra) # 80002c68 <argint>
    800057c6:	08000613          	li	a2,128
    800057ca:	f5040593          	addi	a1,s0,-176
    800057ce:	4501                	li	a0,0
    800057d0:	ffffd097          	auipc	ra,0xffffd
    800057d4:	4d8080e7          	jalr	1240(ra) # 80002ca8 <argstr>
    800057d8:	87aa                	mv	a5,a0
    800057da:	557d                	li	a0,-1
    800057dc:	0a07c963          	bltz	a5,8000588e <sys_open+0xe4>
    800057e0:	fffff097          	auipc	ra,0xfffff
    800057e4:	9ec080e7          	jalr	-1556(ra) # 800041cc <begin_op>
    800057e8:	f4c42783          	lw	a5,-180(s0)
    800057ec:	2007f793          	andi	a5,a5,512
    800057f0:	cfc5                	beqz	a5,800058a8 <sys_open+0xfe>
    800057f2:	4681                	li	a3,0
    800057f4:	4601                	li	a2,0
    800057f6:	4589                	li	a1,2
    800057f8:	f5040513          	addi	a0,s0,-176
    800057fc:	00000097          	auipc	ra,0x0
    80005800:	972080e7          	jalr	-1678(ra) # 8000516e <create>
    80005804:	84aa                	mv	s1,a0
    80005806:	c959                	beqz	a0,8000589c <sys_open+0xf2>
    80005808:	04449703          	lh	a4,68(s1)
    8000580c:	478d                	li	a5,3
    8000580e:	00f71763          	bne	a4,a5,8000581c <sys_open+0x72>
    80005812:	0464d703          	lhu	a4,70(s1)
    80005816:	47a5                	li	a5,9
    80005818:	0ce7ed63          	bltu	a5,a4,800058f2 <sys_open+0x148>
    8000581c:	fffff097          	auipc	ra,0xfffff
    80005820:	dbc080e7          	jalr	-580(ra) # 800045d8 <filealloc>
    80005824:	89aa                	mv	s3,a0
    80005826:	10050363          	beqz	a0,8000592c <sys_open+0x182>
    8000582a:	00000097          	auipc	ra,0x0
    8000582e:	902080e7          	jalr	-1790(ra) # 8000512c <fdalloc>
    80005832:	892a                	mv	s2,a0
    80005834:	0e054763          	bltz	a0,80005922 <sys_open+0x178>
    80005838:	04449703          	lh	a4,68(s1)
    8000583c:	478d                	li	a5,3
    8000583e:	0cf70563          	beq	a4,a5,80005908 <sys_open+0x15e>
    80005842:	4789                	li	a5,2
    80005844:	00f9a023          	sw	a5,0(s3)
    80005848:	0209a023          	sw	zero,32(s3)
    8000584c:	0099bc23          	sd	s1,24(s3)
    80005850:	f4c42783          	lw	a5,-180(s0)
    80005854:	0017c713          	xori	a4,a5,1
    80005858:	8b05                	andi	a4,a4,1
    8000585a:	00e98423          	sb	a4,8(s3)
    8000585e:	0037f713          	andi	a4,a5,3
    80005862:	00e03733          	snez	a4,a4
    80005866:	00e984a3          	sb	a4,9(s3)
    8000586a:	4007f793          	andi	a5,a5,1024
    8000586e:	c791                	beqz	a5,8000587a <sys_open+0xd0>
    80005870:	04449703          	lh	a4,68(s1)
    80005874:	4789                	li	a5,2
    80005876:	0af70063          	beq	a4,a5,80005916 <sys_open+0x16c>
    8000587a:	8526                	mv	a0,s1
    8000587c:	ffffe097          	auipc	ra,0xffffe
    80005880:	046080e7          	jalr	70(ra) # 800038c2 <iunlock>
    80005884:	fffff097          	auipc	ra,0xfffff
    80005888:	9c6080e7          	jalr	-1594(ra) # 8000424a <end_op>
    8000588c:	854a                	mv	a0,s2
    8000588e:	70ea                	ld	ra,184(sp)
    80005890:	744a                	ld	s0,176(sp)
    80005892:	74aa                	ld	s1,168(sp)
    80005894:	790a                	ld	s2,160(sp)
    80005896:	69ea                	ld	s3,152(sp)
    80005898:	6129                	addi	sp,sp,192
    8000589a:	8082                	ret
    8000589c:	fffff097          	auipc	ra,0xfffff
    800058a0:	9ae080e7          	jalr	-1618(ra) # 8000424a <end_op>
    800058a4:	557d                	li	a0,-1
    800058a6:	b7e5                	j	8000588e <sys_open+0xe4>
    800058a8:	f5040513          	addi	a0,s0,-176
    800058ac:	ffffe097          	auipc	ra,0xffffe
    800058b0:	700080e7          	jalr	1792(ra) # 80003fac <namei>
    800058b4:	84aa                	mv	s1,a0
    800058b6:	c905                	beqz	a0,800058e6 <sys_open+0x13c>
    800058b8:	ffffe097          	auipc	ra,0xffffe
    800058bc:	f48080e7          	jalr	-184(ra) # 80003800 <ilock>
    800058c0:	04449703          	lh	a4,68(s1)
    800058c4:	4785                	li	a5,1
    800058c6:	f4f711e3          	bne	a4,a5,80005808 <sys_open+0x5e>
    800058ca:	f4c42783          	lw	a5,-180(s0)
    800058ce:	d7b9                	beqz	a5,8000581c <sys_open+0x72>
    800058d0:	8526                	mv	a0,s1
    800058d2:	ffffe097          	auipc	ra,0xffffe
    800058d6:	190080e7          	jalr	400(ra) # 80003a62 <iunlockput>
    800058da:	fffff097          	auipc	ra,0xfffff
    800058de:	970080e7          	jalr	-1680(ra) # 8000424a <end_op>
    800058e2:	557d                	li	a0,-1
    800058e4:	b76d                	j	8000588e <sys_open+0xe4>
    800058e6:	fffff097          	auipc	ra,0xfffff
    800058ea:	964080e7          	jalr	-1692(ra) # 8000424a <end_op>
    800058ee:	557d                	li	a0,-1
    800058f0:	bf79                	j	8000588e <sys_open+0xe4>
    800058f2:	8526                	mv	a0,s1
    800058f4:	ffffe097          	auipc	ra,0xffffe
    800058f8:	16e080e7          	jalr	366(ra) # 80003a62 <iunlockput>
    800058fc:	fffff097          	auipc	ra,0xfffff
    80005900:	94e080e7          	jalr	-1714(ra) # 8000424a <end_op>
    80005904:	557d                	li	a0,-1
    80005906:	b761                	j	8000588e <sys_open+0xe4>
    80005908:	00f9a023          	sw	a5,0(s3)
    8000590c:	04649783          	lh	a5,70(s1)
    80005910:	02f99223          	sh	a5,36(s3)
    80005914:	bf25                	j	8000584c <sys_open+0xa2>
    80005916:	8526                	mv	a0,s1
    80005918:	ffffe097          	auipc	ra,0xffffe
    8000591c:	ff6080e7          	jalr	-10(ra) # 8000390e <itrunc>
    80005920:	bfa9                	j	8000587a <sys_open+0xd0>
    80005922:	854e                	mv	a0,s3
    80005924:	fffff097          	auipc	ra,0xfffff
    80005928:	d70080e7          	jalr	-656(ra) # 80004694 <fileclose>
    8000592c:	8526                	mv	a0,s1
    8000592e:	ffffe097          	auipc	ra,0xffffe
    80005932:	134080e7          	jalr	308(ra) # 80003a62 <iunlockput>
    80005936:	fffff097          	auipc	ra,0xfffff
    8000593a:	914080e7          	jalr	-1772(ra) # 8000424a <end_op>
    8000593e:	557d                	li	a0,-1
    80005940:	b7b9                	j	8000588e <sys_open+0xe4>

0000000080005942 <sys_mkdir>:
    80005942:	7175                	addi	sp,sp,-144
    80005944:	e506                	sd	ra,136(sp)
    80005946:	e122                	sd	s0,128(sp)
    80005948:	0900                	addi	s0,sp,144
    8000594a:	fffff097          	auipc	ra,0xfffff
    8000594e:	882080e7          	jalr	-1918(ra) # 800041cc <begin_op>
    80005952:	08000613          	li	a2,128
    80005956:	f7040593          	addi	a1,s0,-144
    8000595a:	4501                	li	a0,0
    8000595c:	ffffd097          	auipc	ra,0xffffd
    80005960:	34c080e7          	jalr	844(ra) # 80002ca8 <argstr>
    80005964:	02054963          	bltz	a0,80005996 <sys_mkdir+0x54>
    80005968:	4681                	li	a3,0
    8000596a:	4601                	li	a2,0
    8000596c:	4585                	li	a1,1
    8000596e:	f7040513          	addi	a0,s0,-144
    80005972:	fffff097          	auipc	ra,0xfffff
    80005976:	7fc080e7          	jalr	2044(ra) # 8000516e <create>
    8000597a:	cd11                	beqz	a0,80005996 <sys_mkdir+0x54>
    8000597c:	ffffe097          	auipc	ra,0xffffe
    80005980:	0e6080e7          	jalr	230(ra) # 80003a62 <iunlockput>
    80005984:	fffff097          	auipc	ra,0xfffff
    80005988:	8c6080e7          	jalr	-1850(ra) # 8000424a <end_op>
    8000598c:	4501                	li	a0,0
    8000598e:	60aa                	ld	ra,136(sp)
    80005990:	640a                	ld	s0,128(sp)
    80005992:	6149                	addi	sp,sp,144
    80005994:	8082                	ret
    80005996:	fffff097          	auipc	ra,0xfffff
    8000599a:	8b4080e7          	jalr	-1868(ra) # 8000424a <end_op>
    8000599e:	557d                	li	a0,-1
    800059a0:	b7fd                	j	8000598e <sys_mkdir+0x4c>

00000000800059a2 <sys_mknod>:
    800059a2:	7135                	addi	sp,sp,-160
    800059a4:	ed06                	sd	ra,152(sp)
    800059a6:	e922                	sd	s0,144(sp)
    800059a8:	1100                	addi	s0,sp,160
    800059aa:	fffff097          	auipc	ra,0xfffff
    800059ae:	822080e7          	jalr	-2014(ra) # 800041cc <begin_op>
    800059b2:	f6c40593          	addi	a1,s0,-148
    800059b6:	4505                	li	a0,1
    800059b8:	ffffd097          	auipc	ra,0xffffd
    800059bc:	2b0080e7          	jalr	688(ra) # 80002c68 <argint>
    800059c0:	f6840593          	addi	a1,s0,-152
    800059c4:	4509                	li	a0,2
    800059c6:	ffffd097          	auipc	ra,0xffffd
    800059ca:	2a2080e7          	jalr	674(ra) # 80002c68 <argint>
    800059ce:	08000613          	li	a2,128
    800059d2:	f7040593          	addi	a1,s0,-144
    800059d6:	4501                	li	a0,0
    800059d8:	ffffd097          	auipc	ra,0xffffd
    800059dc:	2d0080e7          	jalr	720(ra) # 80002ca8 <argstr>
    800059e0:	02054b63          	bltz	a0,80005a16 <sys_mknod+0x74>
    800059e4:	f6841683          	lh	a3,-152(s0)
    800059e8:	f6c41603          	lh	a2,-148(s0)
    800059ec:	458d                	li	a1,3
    800059ee:	f7040513          	addi	a0,s0,-144
    800059f2:	fffff097          	auipc	ra,0xfffff
    800059f6:	77c080e7          	jalr	1916(ra) # 8000516e <create>
    800059fa:	cd11                	beqz	a0,80005a16 <sys_mknod+0x74>
    800059fc:	ffffe097          	auipc	ra,0xffffe
    80005a00:	066080e7          	jalr	102(ra) # 80003a62 <iunlockput>
    80005a04:	fffff097          	auipc	ra,0xfffff
    80005a08:	846080e7          	jalr	-1978(ra) # 8000424a <end_op>
    80005a0c:	4501                	li	a0,0
    80005a0e:	60ea                	ld	ra,152(sp)
    80005a10:	644a                	ld	s0,144(sp)
    80005a12:	610d                	addi	sp,sp,160
    80005a14:	8082                	ret
    80005a16:	fffff097          	auipc	ra,0xfffff
    80005a1a:	834080e7          	jalr	-1996(ra) # 8000424a <end_op>
    80005a1e:	557d                	li	a0,-1
    80005a20:	b7fd                	j	80005a0e <sys_mknod+0x6c>

0000000080005a22 <sys_chdir>:
    80005a22:	7135                	addi	sp,sp,-160
    80005a24:	ed06                	sd	ra,152(sp)
    80005a26:	e922                	sd	s0,144(sp)
    80005a28:	e526                	sd	s1,136(sp)
    80005a2a:	e14a                	sd	s2,128(sp)
    80005a2c:	1100                	addi	s0,sp,160
    80005a2e:	ffffc097          	auipc	ra,0xffffc
    80005a32:	f90080e7          	jalr	-112(ra) # 800019be <myproc>
    80005a36:	892a                	mv	s2,a0
    80005a38:	ffffe097          	auipc	ra,0xffffe
    80005a3c:	794080e7          	jalr	1940(ra) # 800041cc <begin_op>
    80005a40:	08000613          	li	a2,128
    80005a44:	f6040593          	addi	a1,s0,-160
    80005a48:	4501                	li	a0,0
    80005a4a:	ffffd097          	auipc	ra,0xffffd
    80005a4e:	25e080e7          	jalr	606(ra) # 80002ca8 <argstr>
    80005a52:	04054b63          	bltz	a0,80005aa8 <sys_chdir+0x86>
    80005a56:	f6040513          	addi	a0,s0,-160
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	552080e7          	jalr	1362(ra) # 80003fac <namei>
    80005a62:	84aa                	mv	s1,a0
    80005a64:	c131                	beqz	a0,80005aa8 <sys_chdir+0x86>
    80005a66:	ffffe097          	auipc	ra,0xffffe
    80005a6a:	d9a080e7          	jalr	-614(ra) # 80003800 <ilock>
    80005a6e:	04449703          	lh	a4,68(s1)
    80005a72:	4785                	li	a5,1
    80005a74:	04f71063          	bne	a4,a5,80005ab4 <sys_chdir+0x92>
    80005a78:	8526                	mv	a0,s1
    80005a7a:	ffffe097          	auipc	ra,0xffffe
    80005a7e:	e48080e7          	jalr	-440(ra) # 800038c2 <iunlock>
    80005a82:	15893503          	ld	a0,344(s2)
    80005a86:	ffffe097          	auipc	ra,0xffffe
    80005a8a:	f34080e7          	jalr	-204(ra) # 800039ba <iput>
    80005a8e:	ffffe097          	auipc	ra,0xffffe
    80005a92:	7bc080e7          	jalr	1980(ra) # 8000424a <end_op>
    80005a96:	14993c23          	sd	s1,344(s2)
    80005a9a:	4501                	li	a0,0
    80005a9c:	60ea                	ld	ra,152(sp)
    80005a9e:	644a                	ld	s0,144(sp)
    80005aa0:	64aa                	ld	s1,136(sp)
    80005aa2:	690a                	ld	s2,128(sp)
    80005aa4:	610d                	addi	sp,sp,160
    80005aa6:	8082                	ret
    80005aa8:	ffffe097          	auipc	ra,0xffffe
    80005aac:	7a2080e7          	jalr	1954(ra) # 8000424a <end_op>
    80005ab0:	557d                	li	a0,-1
    80005ab2:	b7ed                	j	80005a9c <sys_chdir+0x7a>
    80005ab4:	8526                	mv	a0,s1
    80005ab6:	ffffe097          	auipc	ra,0xffffe
    80005aba:	fac080e7          	jalr	-84(ra) # 80003a62 <iunlockput>
    80005abe:	ffffe097          	auipc	ra,0xffffe
    80005ac2:	78c080e7          	jalr	1932(ra) # 8000424a <end_op>
    80005ac6:	557d                	li	a0,-1
    80005ac8:	bfd1                	j	80005a9c <sys_chdir+0x7a>

0000000080005aca <sys_exec>:
    80005aca:	7145                	addi	sp,sp,-464
    80005acc:	e786                	sd	ra,456(sp)
    80005ace:	e3a2                	sd	s0,448(sp)
    80005ad0:	ff26                	sd	s1,440(sp)
    80005ad2:	fb4a                	sd	s2,432(sp)
    80005ad4:	f74e                	sd	s3,424(sp)
    80005ad6:	f352                	sd	s4,416(sp)
    80005ad8:	ef56                	sd	s5,408(sp)
    80005ada:	0b80                	addi	s0,sp,464
    80005adc:	e3840593          	addi	a1,s0,-456
    80005ae0:	4505                	li	a0,1
    80005ae2:	ffffd097          	auipc	ra,0xffffd
    80005ae6:	1a6080e7          	jalr	422(ra) # 80002c88 <argaddr>
    80005aea:	08000613          	li	a2,128
    80005aee:	f4040593          	addi	a1,s0,-192
    80005af2:	4501                	li	a0,0
    80005af4:	ffffd097          	auipc	ra,0xffffd
    80005af8:	1b4080e7          	jalr	436(ra) # 80002ca8 <argstr>
    80005afc:	87aa                	mv	a5,a0
    80005afe:	557d                	li	a0,-1
    80005b00:	0c07c363          	bltz	a5,80005bc6 <sys_exec+0xfc>
    80005b04:	10000613          	li	a2,256
    80005b08:	4581                	li	a1,0
    80005b0a:	e4040513          	addi	a0,s0,-448
    80005b0e:	ffffb097          	auipc	ra,0xffffb
    80005b12:	1c4080e7          	jalr	452(ra) # 80000cd2 <memset>
    80005b16:	e4040493          	addi	s1,s0,-448
    80005b1a:	89a6                	mv	s3,s1
    80005b1c:	4901                	li	s2,0
    80005b1e:	02000a13          	li	s4,32
    80005b22:	00090a9b          	sext.w	s5,s2
    80005b26:	00391513          	slli	a0,s2,0x3
    80005b2a:	e3040593          	addi	a1,s0,-464
    80005b2e:	e3843783          	ld	a5,-456(s0)
    80005b32:	953e                	add	a0,a0,a5
    80005b34:	ffffd097          	auipc	ra,0xffffd
    80005b38:	096080e7          	jalr	150(ra) # 80002bca <fetchaddr>
    80005b3c:	02054a63          	bltz	a0,80005b70 <sys_exec+0xa6>
    80005b40:	e3043783          	ld	a5,-464(s0)
    80005b44:	c3b9                	beqz	a5,80005b8a <sys_exec+0xc0>
    80005b46:	ffffb097          	auipc	ra,0xffffb
    80005b4a:	fa0080e7          	jalr	-96(ra) # 80000ae6 <kalloc>
    80005b4e:	85aa                	mv	a1,a0
    80005b50:	00a9b023          	sd	a0,0(s3)
    80005b54:	cd11                	beqz	a0,80005b70 <sys_exec+0xa6>
    80005b56:	6605                	lui	a2,0x1
    80005b58:	e3043503          	ld	a0,-464(s0)
    80005b5c:	ffffd097          	auipc	ra,0xffffd
    80005b60:	0c0080e7          	jalr	192(ra) # 80002c1c <fetchstr>
    80005b64:	00054663          	bltz	a0,80005b70 <sys_exec+0xa6>
    80005b68:	0905                	addi	s2,s2,1
    80005b6a:	09a1                	addi	s3,s3,8
    80005b6c:	fb491be3          	bne	s2,s4,80005b22 <sys_exec+0x58>
    80005b70:	f4040913          	addi	s2,s0,-192
    80005b74:	6088                	ld	a0,0(s1)
    80005b76:	c539                	beqz	a0,80005bc4 <sys_exec+0xfa>
    80005b78:	ffffb097          	auipc	ra,0xffffb
    80005b7c:	e70080e7          	jalr	-400(ra) # 800009e8 <kfree>
    80005b80:	04a1                	addi	s1,s1,8
    80005b82:	ff2499e3          	bne	s1,s2,80005b74 <sys_exec+0xaa>
    80005b86:	557d                	li	a0,-1
    80005b88:	a83d                	j	80005bc6 <sys_exec+0xfc>
    80005b8a:	0a8e                	slli	s5,s5,0x3
    80005b8c:	fc0a8793          	addi	a5,s5,-64
    80005b90:	00878ab3          	add	s5,a5,s0
    80005b94:	e80ab023          	sd	zero,-384(s5)
    80005b98:	e4040593          	addi	a1,s0,-448
    80005b9c:	f4040513          	addi	a0,s0,-192
    80005ba0:	fffff097          	auipc	ra,0xfffff
    80005ba4:	16e080e7          	jalr	366(ra) # 80004d0e <exec>
    80005ba8:	892a                	mv	s2,a0
    80005baa:	f4040993          	addi	s3,s0,-192
    80005bae:	6088                	ld	a0,0(s1)
    80005bb0:	c901                	beqz	a0,80005bc0 <sys_exec+0xf6>
    80005bb2:	ffffb097          	auipc	ra,0xffffb
    80005bb6:	e36080e7          	jalr	-458(ra) # 800009e8 <kfree>
    80005bba:	04a1                	addi	s1,s1,8
    80005bbc:	ff3499e3          	bne	s1,s3,80005bae <sys_exec+0xe4>
    80005bc0:	854a                	mv	a0,s2
    80005bc2:	a011                	j	80005bc6 <sys_exec+0xfc>
    80005bc4:	557d                	li	a0,-1
    80005bc6:	60be                	ld	ra,456(sp)
    80005bc8:	641e                	ld	s0,448(sp)
    80005bca:	74fa                	ld	s1,440(sp)
    80005bcc:	795a                	ld	s2,432(sp)
    80005bce:	79ba                	ld	s3,424(sp)
    80005bd0:	7a1a                	ld	s4,416(sp)
    80005bd2:	6afa                	ld	s5,408(sp)
    80005bd4:	6179                	addi	sp,sp,464
    80005bd6:	8082                	ret

0000000080005bd8 <sys_pipe>:
    80005bd8:	7139                	addi	sp,sp,-64
    80005bda:	fc06                	sd	ra,56(sp)
    80005bdc:	f822                	sd	s0,48(sp)
    80005bde:	f426                	sd	s1,40(sp)
    80005be0:	0080                	addi	s0,sp,64
    80005be2:	ffffc097          	auipc	ra,0xffffc
    80005be6:	ddc080e7          	jalr	-548(ra) # 800019be <myproc>
    80005bea:	84aa                	mv	s1,a0
    80005bec:	fd840593          	addi	a1,s0,-40
    80005bf0:	4501                	li	a0,0
    80005bf2:	ffffd097          	auipc	ra,0xffffd
    80005bf6:	096080e7          	jalr	150(ra) # 80002c88 <argaddr>
    80005bfa:	fc840593          	addi	a1,s0,-56
    80005bfe:	fd040513          	addi	a0,s0,-48
    80005c02:	fffff097          	auipc	ra,0xfffff
    80005c06:	dc2080e7          	jalr	-574(ra) # 800049c4 <pipealloc>
    80005c0a:	57fd                	li	a5,-1
    80005c0c:	0c054463          	bltz	a0,80005cd4 <sys_pipe+0xfc>
    80005c10:	fcf42223          	sw	a5,-60(s0)
    80005c14:	fd043503          	ld	a0,-48(s0)
    80005c18:	fffff097          	auipc	ra,0xfffff
    80005c1c:	514080e7          	jalr	1300(ra) # 8000512c <fdalloc>
    80005c20:	fca42223          	sw	a0,-60(s0)
    80005c24:	08054b63          	bltz	a0,80005cba <sys_pipe+0xe2>
    80005c28:	fc843503          	ld	a0,-56(s0)
    80005c2c:	fffff097          	auipc	ra,0xfffff
    80005c30:	500080e7          	jalr	1280(ra) # 8000512c <fdalloc>
    80005c34:	fca42023          	sw	a0,-64(s0)
    80005c38:	06054863          	bltz	a0,80005ca8 <sys_pipe+0xd0>
    80005c3c:	4691                	li	a3,4
    80005c3e:	fc440613          	addi	a2,s0,-60
    80005c42:	fd843583          	ld	a1,-40(s0)
    80005c46:	6ca8                	ld	a0,88(s1)
    80005c48:	ffffc097          	auipc	ra,0xffffc
    80005c4c:	a24080e7          	jalr	-1500(ra) # 8000166c <copyout>
    80005c50:	02054063          	bltz	a0,80005c70 <sys_pipe+0x98>
    80005c54:	4691                	li	a3,4
    80005c56:	fc040613          	addi	a2,s0,-64
    80005c5a:	fd843583          	ld	a1,-40(s0)
    80005c5e:	0591                	addi	a1,a1,4
    80005c60:	6ca8                	ld	a0,88(s1)
    80005c62:	ffffc097          	auipc	ra,0xffffc
    80005c66:	a0a080e7          	jalr	-1526(ra) # 8000166c <copyout>
    80005c6a:	4781                	li	a5,0
    80005c6c:	06055463          	bgez	a0,80005cd4 <sys_pipe+0xfc>
    80005c70:	fc442783          	lw	a5,-60(s0)
    80005c74:	07e9                	addi	a5,a5,26
    80005c76:	078e                	slli	a5,a5,0x3
    80005c78:	97a6                	add	a5,a5,s1
    80005c7a:	0007b423          	sd	zero,8(a5)
    80005c7e:	fc042783          	lw	a5,-64(s0)
    80005c82:	07e9                	addi	a5,a5,26
    80005c84:	078e                	slli	a5,a5,0x3
    80005c86:	94be                	add	s1,s1,a5
    80005c88:	0004b423          	sd	zero,8(s1)
    80005c8c:	fd043503          	ld	a0,-48(s0)
    80005c90:	fffff097          	auipc	ra,0xfffff
    80005c94:	a04080e7          	jalr	-1532(ra) # 80004694 <fileclose>
    80005c98:	fc843503          	ld	a0,-56(s0)
    80005c9c:	fffff097          	auipc	ra,0xfffff
    80005ca0:	9f8080e7          	jalr	-1544(ra) # 80004694 <fileclose>
    80005ca4:	57fd                	li	a5,-1
    80005ca6:	a03d                	j	80005cd4 <sys_pipe+0xfc>
    80005ca8:	fc442783          	lw	a5,-60(s0)
    80005cac:	0007c763          	bltz	a5,80005cba <sys_pipe+0xe2>
    80005cb0:	07e9                	addi	a5,a5,26
    80005cb2:	078e                	slli	a5,a5,0x3
    80005cb4:	97a6                	add	a5,a5,s1
    80005cb6:	0007b423          	sd	zero,8(a5)
    80005cba:	fd043503          	ld	a0,-48(s0)
    80005cbe:	fffff097          	auipc	ra,0xfffff
    80005cc2:	9d6080e7          	jalr	-1578(ra) # 80004694 <fileclose>
    80005cc6:	fc843503          	ld	a0,-56(s0)
    80005cca:	fffff097          	auipc	ra,0xfffff
    80005cce:	9ca080e7          	jalr	-1590(ra) # 80004694 <fileclose>
    80005cd2:	57fd                	li	a5,-1
    80005cd4:	853e                	mv	a0,a5
    80005cd6:	70e2                	ld	ra,56(sp)
    80005cd8:	7442                	ld	s0,48(sp)
    80005cda:	74a2                	ld	s1,40(sp)
    80005cdc:	6121                	addi	sp,sp,64
    80005cde:	8082                	ret

0000000080005ce0 <kernelvec>:
    80005ce0:	7111                	addi	sp,sp,-256
    80005ce2:	e006                	sd	ra,0(sp)
    80005ce4:	e40a                	sd	sp,8(sp)
    80005ce6:	e80e                	sd	gp,16(sp)
    80005ce8:	ec12                	sd	tp,24(sp)
    80005cea:	f016                	sd	t0,32(sp)
    80005cec:	f41a                	sd	t1,40(sp)
    80005cee:	f81e                	sd	t2,48(sp)
    80005cf0:	fc22                	sd	s0,56(sp)
    80005cf2:	e0a6                	sd	s1,64(sp)
    80005cf4:	e4aa                	sd	a0,72(sp)
    80005cf6:	e8ae                	sd	a1,80(sp)
    80005cf8:	ecb2                	sd	a2,88(sp)
    80005cfa:	f0b6                	sd	a3,96(sp)
    80005cfc:	f4ba                	sd	a4,104(sp)
    80005cfe:	f8be                	sd	a5,112(sp)
    80005d00:	fcc2                	sd	a6,120(sp)
    80005d02:	e146                	sd	a7,128(sp)
    80005d04:	e54a                	sd	s2,136(sp)
    80005d06:	e94e                	sd	s3,144(sp)
    80005d08:	ed52                	sd	s4,152(sp)
    80005d0a:	f156                	sd	s5,160(sp)
    80005d0c:	f55a                	sd	s6,168(sp)
    80005d0e:	f95e                	sd	s7,176(sp)
    80005d10:	fd62                	sd	s8,184(sp)
    80005d12:	e1e6                	sd	s9,192(sp)
    80005d14:	e5ea                	sd	s10,200(sp)
    80005d16:	e9ee                	sd	s11,208(sp)
    80005d18:	edf2                	sd	t3,216(sp)
    80005d1a:	f1f6                	sd	t4,224(sp)
    80005d1c:	f5fa                	sd	t5,232(sp)
    80005d1e:	f9fe                	sd	t6,240(sp)
    80005d20:	d77fc0ef          	jal	ra,80002a96 <kerneltrap>
    80005d24:	6082                	ld	ra,0(sp)
    80005d26:	6122                	ld	sp,8(sp)
    80005d28:	61c2                	ld	gp,16(sp)
    80005d2a:	7282                	ld	t0,32(sp)
    80005d2c:	7322                	ld	t1,40(sp)
    80005d2e:	73c2                	ld	t2,48(sp)
    80005d30:	7462                	ld	s0,56(sp)
    80005d32:	6486                	ld	s1,64(sp)
    80005d34:	6526                	ld	a0,72(sp)
    80005d36:	65c6                	ld	a1,80(sp)
    80005d38:	6666                	ld	a2,88(sp)
    80005d3a:	7686                	ld	a3,96(sp)
    80005d3c:	7726                	ld	a4,104(sp)
    80005d3e:	77c6                	ld	a5,112(sp)
    80005d40:	7866                	ld	a6,120(sp)
    80005d42:	688a                	ld	a7,128(sp)
    80005d44:	692a                	ld	s2,136(sp)
    80005d46:	69ca                	ld	s3,144(sp)
    80005d48:	6a6a                	ld	s4,152(sp)
    80005d4a:	7a8a                	ld	s5,160(sp)
    80005d4c:	7b2a                	ld	s6,168(sp)
    80005d4e:	7bca                	ld	s7,176(sp)
    80005d50:	7c6a                	ld	s8,184(sp)
    80005d52:	6c8e                	ld	s9,192(sp)
    80005d54:	6d2e                	ld	s10,200(sp)
    80005d56:	6dce                	ld	s11,208(sp)
    80005d58:	6e6e                	ld	t3,216(sp)
    80005d5a:	7e8e                	ld	t4,224(sp)
    80005d5c:	7f2e                	ld	t5,232(sp)
    80005d5e:	7fce                	ld	t6,240(sp)
    80005d60:	6111                	addi	sp,sp,256
    80005d62:	10200073          	sret
    80005d66:	00000013          	nop
    80005d6a:	00000013          	nop
    80005d6e:	0001                	nop

0000000080005d70 <timervec>:
    80005d70:	34051573          	csrrw	a0,mscratch,a0
    80005d74:	e10c                	sd	a1,0(a0)
    80005d76:	e510                	sd	a2,8(a0)
    80005d78:	e914                	sd	a3,16(a0)
    80005d7a:	6d0c                	ld	a1,24(a0)
    80005d7c:	7110                	ld	a2,32(a0)
    80005d7e:	6194                	ld	a3,0(a1)
    80005d80:	96b2                	add	a3,a3,a2
    80005d82:	e194                	sd	a3,0(a1)
    80005d84:	4589                	li	a1,2
    80005d86:	14459073          	csrw	sip,a1
    80005d8a:	6914                	ld	a3,16(a0)
    80005d8c:	6510                	ld	a2,8(a0)
    80005d8e:	610c                	ld	a1,0(a0)
    80005d90:	34051573          	csrrw	a0,mscratch,a0
    80005d94:	30200073          	mret
	...

0000000080005d9a <plicinit>:
    80005d9a:	1141                	addi	sp,sp,-16
    80005d9c:	e422                	sd	s0,8(sp)
    80005d9e:	0800                	addi	s0,sp,16
    80005da0:	0c0007b7          	lui	a5,0xc000
    80005da4:	4705                	li	a4,1
    80005da6:	d798                	sw	a4,40(a5)
    80005da8:	c3d8                	sw	a4,4(a5)
    80005daa:	6422                	ld	s0,8(sp)
    80005dac:	0141                	addi	sp,sp,16
    80005dae:	8082                	ret

0000000080005db0 <plicinithart>:
    80005db0:	1141                	addi	sp,sp,-16
    80005db2:	e406                	sd	ra,8(sp)
    80005db4:	e022                	sd	s0,0(sp)
    80005db6:	0800                	addi	s0,sp,16
    80005db8:	ffffc097          	auipc	ra,0xffffc
    80005dbc:	bda080e7          	jalr	-1062(ra) # 80001992 <cpuid>
    80005dc0:	0085171b          	slliw	a4,a0,0x8
    80005dc4:	0c0027b7          	lui	a5,0xc002
    80005dc8:	97ba                	add	a5,a5,a4
    80005dca:	40200713          	li	a4,1026
    80005dce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80005dd2:	00d5151b          	slliw	a0,a0,0xd
    80005dd6:	0c2017b7          	lui	a5,0xc201
    80005dda:	97aa                	add	a5,a5,a0
    80005ddc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
    80005de0:	60a2                	ld	ra,8(sp)
    80005de2:	6402                	ld	s0,0(sp)
    80005de4:	0141                	addi	sp,sp,16
    80005de6:	8082                	ret

0000000080005de8 <plic_claim>:
    80005de8:	1141                	addi	sp,sp,-16
    80005dea:	e406                	sd	ra,8(sp)
    80005dec:	e022                	sd	s0,0(sp)
    80005dee:	0800                	addi	s0,sp,16
    80005df0:	ffffc097          	auipc	ra,0xffffc
    80005df4:	ba2080e7          	jalr	-1118(ra) # 80001992 <cpuid>
    80005df8:	00d5151b          	slliw	a0,a0,0xd
    80005dfc:	0c2017b7          	lui	a5,0xc201
    80005e00:	97aa                	add	a5,a5,a0
    80005e02:	43c8                	lw	a0,4(a5)
    80005e04:	60a2                	ld	ra,8(sp)
    80005e06:	6402                	ld	s0,0(sp)
    80005e08:	0141                	addi	sp,sp,16
    80005e0a:	8082                	ret

0000000080005e0c <plic_complete>:
    80005e0c:	1101                	addi	sp,sp,-32
    80005e0e:	ec06                	sd	ra,24(sp)
    80005e10:	e822                	sd	s0,16(sp)
    80005e12:	e426                	sd	s1,8(sp)
    80005e14:	1000                	addi	s0,sp,32
    80005e16:	84aa                	mv	s1,a0
    80005e18:	ffffc097          	auipc	ra,0xffffc
    80005e1c:	b7a080e7          	jalr	-1158(ra) # 80001992 <cpuid>
    80005e20:	00d5151b          	slliw	a0,a0,0xd
    80005e24:	0c2017b7          	lui	a5,0xc201
    80005e28:	97aa                	add	a5,a5,a0
    80005e2a:	c3c4                	sw	s1,4(a5)
    80005e2c:	60e2                	ld	ra,24(sp)
    80005e2e:	6442                	ld	s0,16(sp)
    80005e30:	64a2                	ld	s1,8(sp)
    80005e32:	6105                	addi	sp,sp,32
    80005e34:	8082                	ret

0000000080005e36 <free_desc>:
    80005e36:	1141                	addi	sp,sp,-16
    80005e38:	e406                	sd	ra,8(sp)
    80005e3a:	e022                	sd	s0,0(sp)
    80005e3c:	0800                	addi	s0,sp,16
    80005e3e:	479d                	li	a5,7
    80005e40:	04a7cc63          	blt	a5,a0,80005e98 <free_desc+0x62>
    80005e44:	0001c797          	auipc	a5,0x1c
    80005e48:	07c78793          	addi	a5,a5,124 # 80021ec0 <disk>
    80005e4c:	97aa                	add	a5,a5,a0
    80005e4e:	0187c783          	lbu	a5,24(a5)
    80005e52:	ebb9                	bnez	a5,80005ea8 <free_desc+0x72>
    80005e54:	00451693          	slli	a3,a0,0x4
    80005e58:	0001c797          	auipc	a5,0x1c
    80005e5c:	06878793          	addi	a5,a5,104 # 80021ec0 <disk>
    80005e60:	6398                	ld	a4,0(a5)
    80005e62:	9736                	add	a4,a4,a3
    80005e64:	00073023          	sd	zero,0(a4)
    80005e68:	6398                	ld	a4,0(a5)
    80005e6a:	9736                	add	a4,a4,a3
    80005e6c:	00072423          	sw	zero,8(a4)
    80005e70:	00071623          	sh	zero,12(a4)
    80005e74:	00071723          	sh	zero,14(a4)
    80005e78:	97aa                	add	a5,a5,a0
    80005e7a:	4705                	li	a4,1
    80005e7c:	00e78c23          	sb	a4,24(a5)
    80005e80:	0001c517          	auipc	a0,0x1c
    80005e84:	05850513          	addi	a0,a0,88 # 80021ed8 <disk+0x18>
    80005e88:	ffffc097          	auipc	ra,0xffffc
    80005e8c:	35c080e7          	jalr	860(ra) # 800021e4 <wakeup>
    80005e90:	60a2                	ld	ra,8(sp)
    80005e92:	6402                	ld	s0,0(sp)
    80005e94:	0141                	addi	sp,sp,16
    80005e96:	8082                	ret
    80005e98:	00003517          	auipc	a0,0x3
    80005e9c:	94050513          	addi	a0,a0,-1728 # 800087d8 <syscalls+0x2f8>
    80005ea0:	ffffa097          	auipc	ra,0xffffa
    80005ea4:	6a0080e7          	jalr	1696(ra) # 80000540 <panic>
    80005ea8:	00003517          	auipc	a0,0x3
    80005eac:	94050513          	addi	a0,a0,-1728 # 800087e8 <syscalls+0x308>
    80005eb0:	ffffa097          	auipc	ra,0xffffa
    80005eb4:	690080e7          	jalr	1680(ra) # 80000540 <panic>

0000000080005eb8 <virtio_disk_init>:
    80005eb8:	1101                	addi	sp,sp,-32
    80005eba:	ec06                	sd	ra,24(sp)
    80005ebc:	e822                	sd	s0,16(sp)
    80005ebe:	e426                	sd	s1,8(sp)
    80005ec0:	e04a                	sd	s2,0(sp)
    80005ec2:	1000                	addi	s0,sp,32
    80005ec4:	00003597          	auipc	a1,0x3
    80005ec8:	93458593          	addi	a1,a1,-1740 # 800087f8 <syscalls+0x318>
    80005ecc:	0001c517          	auipc	a0,0x1c
    80005ed0:	11c50513          	addi	a0,a0,284 # 80021fe8 <disk+0x128>
    80005ed4:	ffffb097          	auipc	ra,0xffffb
    80005ed8:	c72080e7          	jalr	-910(ra) # 80000b46 <initlock>
    80005edc:	100017b7          	lui	a5,0x10001
    80005ee0:	4398                	lw	a4,0(a5)
    80005ee2:	2701                	sext.w	a4,a4
    80005ee4:	747277b7          	lui	a5,0x74727
    80005ee8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005eec:	14f71b63          	bne	a4,a5,80006042 <virtio_disk_init+0x18a>
    80005ef0:	100017b7          	lui	a5,0x10001
    80005ef4:	43dc                	lw	a5,4(a5)
    80005ef6:	2781                	sext.w	a5,a5
    80005ef8:	4709                	li	a4,2
    80005efa:	14e79463          	bne	a5,a4,80006042 <virtio_disk_init+0x18a>
    80005efe:	100017b7          	lui	a5,0x10001
    80005f02:	479c                	lw	a5,8(a5)
    80005f04:	2781                	sext.w	a5,a5
    80005f06:	12e79e63          	bne	a5,a4,80006042 <virtio_disk_init+0x18a>
    80005f0a:	100017b7          	lui	a5,0x10001
    80005f0e:	47d8                	lw	a4,12(a5)
    80005f10:	2701                	sext.w	a4,a4
    80005f12:	554d47b7          	lui	a5,0x554d4
    80005f16:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f1a:	12f71463          	bne	a4,a5,80006042 <virtio_disk_init+0x18a>
    80005f1e:	100017b7          	lui	a5,0x10001
    80005f22:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
    80005f26:	4705                	li	a4,1
    80005f28:	dbb8                	sw	a4,112(a5)
    80005f2a:	470d                	li	a4,3
    80005f2c:	dbb8                	sw	a4,112(a5)
    80005f2e:	4b98                	lw	a4,16(a5)
    80005f30:	c7ffe6b7          	lui	a3,0xc7ffe
    80005f34:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc75f>
    80005f38:	8f75                	and	a4,a4,a3
    80005f3a:	d398                	sw	a4,32(a5)
    80005f3c:	472d                	li	a4,11
    80005f3e:	dbb8                	sw	a4,112(a5)
    80005f40:	5bbc                	lw	a5,112(a5)
    80005f42:	0007891b          	sext.w	s2,a5
    80005f46:	8ba1                	andi	a5,a5,8
    80005f48:	10078563          	beqz	a5,80006052 <virtio_disk_init+0x19a>
    80005f4c:	100017b7          	lui	a5,0x10001
    80005f50:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    80005f54:	43fc                	lw	a5,68(a5)
    80005f56:	2781                	sext.w	a5,a5
    80005f58:	10079563          	bnez	a5,80006062 <virtio_disk_init+0x1aa>
    80005f5c:	100017b7          	lui	a5,0x10001
    80005f60:	5bdc                	lw	a5,52(a5)
    80005f62:	2781                	sext.w	a5,a5
    80005f64:	10078763          	beqz	a5,80006072 <virtio_disk_init+0x1ba>
    80005f68:	471d                	li	a4,7
    80005f6a:	10f77c63          	bgeu	a4,a5,80006082 <virtio_disk_init+0x1ca>
    80005f6e:	ffffb097          	auipc	ra,0xffffb
    80005f72:	b78080e7          	jalr	-1160(ra) # 80000ae6 <kalloc>
    80005f76:	0001c497          	auipc	s1,0x1c
    80005f7a:	f4a48493          	addi	s1,s1,-182 # 80021ec0 <disk>
    80005f7e:	e088                	sd	a0,0(s1)
    80005f80:	ffffb097          	auipc	ra,0xffffb
    80005f84:	b66080e7          	jalr	-1178(ra) # 80000ae6 <kalloc>
    80005f88:	e488                	sd	a0,8(s1)
    80005f8a:	ffffb097          	auipc	ra,0xffffb
    80005f8e:	b5c080e7          	jalr	-1188(ra) # 80000ae6 <kalloc>
    80005f92:	87aa                	mv	a5,a0
    80005f94:	e888                	sd	a0,16(s1)
    80005f96:	6088                	ld	a0,0(s1)
    80005f98:	cd6d                	beqz	a0,80006092 <virtio_disk_init+0x1da>
    80005f9a:	0001c717          	auipc	a4,0x1c
    80005f9e:	f2e73703          	ld	a4,-210(a4) # 80021ec8 <disk+0x8>
    80005fa2:	cb65                	beqz	a4,80006092 <virtio_disk_init+0x1da>
    80005fa4:	c7fd                	beqz	a5,80006092 <virtio_disk_init+0x1da>
    80005fa6:	6605                	lui	a2,0x1
    80005fa8:	4581                	li	a1,0
    80005faa:	ffffb097          	auipc	ra,0xffffb
    80005fae:	d28080e7          	jalr	-728(ra) # 80000cd2 <memset>
    80005fb2:	0001c497          	auipc	s1,0x1c
    80005fb6:	f0e48493          	addi	s1,s1,-242 # 80021ec0 <disk>
    80005fba:	6605                	lui	a2,0x1
    80005fbc:	4581                	li	a1,0
    80005fbe:	6488                	ld	a0,8(s1)
    80005fc0:	ffffb097          	auipc	ra,0xffffb
    80005fc4:	d12080e7          	jalr	-750(ra) # 80000cd2 <memset>
    80005fc8:	6605                	lui	a2,0x1
    80005fca:	4581                	li	a1,0
    80005fcc:	6888                	ld	a0,16(s1)
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	d04080e7          	jalr	-764(ra) # 80000cd2 <memset>
    80005fd6:	100017b7          	lui	a5,0x10001
    80005fda:	4721                	li	a4,8
    80005fdc:	df98                	sw	a4,56(a5)
    80005fde:	4098                	lw	a4,0(s1)
    80005fe0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
    80005fe4:	40d8                	lw	a4,4(s1)
    80005fe6:	08e7a223          	sw	a4,132(a5)
    80005fea:	6498                	ld	a4,8(s1)
    80005fec:	0007069b          	sext.w	a3,a4
    80005ff0:	08d7a823          	sw	a3,144(a5)
    80005ff4:	9701                	srai	a4,a4,0x20
    80005ff6:	08e7aa23          	sw	a4,148(a5)
    80005ffa:	6898                	ld	a4,16(s1)
    80005ffc:	0007069b          	sext.w	a3,a4
    80006000:	0ad7a023          	sw	a3,160(a5)
    80006004:	9701                	srai	a4,a4,0x20
    80006006:	0ae7a223          	sw	a4,164(a5)
    8000600a:	4705                	li	a4,1
    8000600c:	c3f8                	sw	a4,68(a5)
    8000600e:	00e48c23          	sb	a4,24(s1)
    80006012:	00e48ca3          	sb	a4,25(s1)
    80006016:	00e48d23          	sb	a4,26(s1)
    8000601a:	00e48da3          	sb	a4,27(s1)
    8000601e:	00e48e23          	sb	a4,28(s1)
    80006022:	00e48ea3          	sb	a4,29(s1)
    80006026:	00e48f23          	sb	a4,30(s1)
    8000602a:	00e48fa3          	sb	a4,31(s1)
    8000602e:	00496913          	ori	s2,s2,4
    80006032:	0727a823          	sw	s2,112(a5)
    80006036:	60e2                	ld	ra,24(sp)
    80006038:	6442                	ld	s0,16(sp)
    8000603a:	64a2                	ld	s1,8(sp)
    8000603c:	6902                	ld	s2,0(sp)
    8000603e:	6105                	addi	sp,sp,32
    80006040:	8082                	ret
    80006042:	00002517          	auipc	a0,0x2
    80006046:	7c650513          	addi	a0,a0,1990 # 80008808 <syscalls+0x328>
    8000604a:	ffffa097          	auipc	ra,0xffffa
    8000604e:	4f6080e7          	jalr	1270(ra) # 80000540 <panic>
    80006052:	00002517          	auipc	a0,0x2
    80006056:	7d650513          	addi	a0,a0,2006 # 80008828 <syscalls+0x348>
    8000605a:	ffffa097          	auipc	ra,0xffffa
    8000605e:	4e6080e7          	jalr	1254(ra) # 80000540 <panic>
    80006062:	00002517          	auipc	a0,0x2
    80006066:	7e650513          	addi	a0,a0,2022 # 80008848 <syscalls+0x368>
    8000606a:	ffffa097          	auipc	ra,0xffffa
    8000606e:	4d6080e7          	jalr	1238(ra) # 80000540 <panic>
    80006072:	00002517          	auipc	a0,0x2
    80006076:	7f650513          	addi	a0,a0,2038 # 80008868 <syscalls+0x388>
    8000607a:	ffffa097          	auipc	ra,0xffffa
    8000607e:	4c6080e7          	jalr	1222(ra) # 80000540 <panic>
    80006082:	00003517          	auipc	a0,0x3
    80006086:	80650513          	addi	a0,a0,-2042 # 80008888 <syscalls+0x3a8>
    8000608a:	ffffa097          	auipc	ra,0xffffa
    8000608e:	4b6080e7          	jalr	1206(ra) # 80000540 <panic>
    80006092:	00003517          	auipc	a0,0x3
    80006096:	81650513          	addi	a0,a0,-2026 # 800088a8 <syscalls+0x3c8>
    8000609a:	ffffa097          	auipc	ra,0xffffa
    8000609e:	4a6080e7          	jalr	1190(ra) # 80000540 <panic>

00000000800060a2 <virtio_disk_rw>:
    800060a2:	7119                	addi	sp,sp,-128
    800060a4:	fc86                	sd	ra,120(sp)
    800060a6:	f8a2                	sd	s0,112(sp)
    800060a8:	f4a6                	sd	s1,104(sp)
    800060aa:	f0ca                	sd	s2,96(sp)
    800060ac:	ecce                	sd	s3,88(sp)
    800060ae:	e8d2                	sd	s4,80(sp)
    800060b0:	e4d6                	sd	s5,72(sp)
    800060b2:	e0da                	sd	s6,64(sp)
    800060b4:	fc5e                	sd	s7,56(sp)
    800060b6:	f862                	sd	s8,48(sp)
    800060b8:	f466                	sd	s9,40(sp)
    800060ba:	f06a                	sd	s10,32(sp)
    800060bc:	ec6e                	sd	s11,24(sp)
    800060be:	0100                	addi	s0,sp,128
    800060c0:	8aaa                	mv	s5,a0
    800060c2:	8c2e                	mv	s8,a1
    800060c4:	00c52d03          	lw	s10,12(a0)
    800060c8:	001d1d1b          	slliw	s10,s10,0x1
    800060cc:	1d02                	slli	s10,s10,0x20
    800060ce:	020d5d13          	srli	s10,s10,0x20
    800060d2:	0001c517          	auipc	a0,0x1c
    800060d6:	f1650513          	addi	a0,a0,-234 # 80021fe8 <disk+0x128>
    800060da:	ffffb097          	auipc	ra,0xffffb
    800060de:	afc080e7          	jalr	-1284(ra) # 80000bd6 <acquire>
    800060e2:	4981                	li	s3,0
    800060e4:	44a1                	li	s1,8
    800060e6:	0001cb97          	auipc	s7,0x1c
    800060ea:	ddab8b93          	addi	s7,s7,-550 # 80021ec0 <disk>
    800060ee:	4b0d                	li	s6,3
    800060f0:	0001cc97          	auipc	s9,0x1c
    800060f4:	ef8c8c93          	addi	s9,s9,-264 # 80021fe8 <disk+0x128>
    800060f8:	a08d                	j	8000615a <virtio_disk_rw+0xb8>
    800060fa:	00fb8733          	add	a4,s7,a5
    800060fe:	00070c23          	sb	zero,24(a4)
    80006102:	c19c                	sw	a5,0(a1)
    80006104:	0207c563          	bltz	a5,8000612e <virtio_disk_rw+0x8c>
    80006108:	2905                	addiw	s2,s2,1
    8000610a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000610c:	05690c63          	beq	s2,s6,80006164 <virtio_disk_rw+0xc2>
    80006110:	85b2                	mv	a1,a2
    80006112:	0001c717          	auipc	a4,0x1c
    80006116:	dae70713          	addi	a4,a4,-594 # 80021ec0 <disk>
    8000611a:	87ce                	mv	a5,s3
    8000611c:	01874683          	lbu	a3,24(a4)
    80006120:	fee9                	bnez	a3,800060fa <virtio_disk_rw+0x58>
    80006122:	2785                	addiw	a5,a5,1
    80006124:	0705                	addi	a4,a4,1
    80006126:	fe979be3          	bne	a5,s1,8000611c <virtio_disk_rw+0x7a>
    8000612a:	57fd                	li	a5,-1
    8000612c:	c19c                	sw	a5,0(a1)
    8000612e:	01205d63          	blez	s2,80006148 <virtio_disk_rw+0xa6>
    80006132:	8dce                	mv	s11,s3
    80006134:	000a2503          	lw	a0,0(s4)
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	cfe080e7          	jalr	-770(ra) # 80005e36 <free_desc>
    80006140:	2d85                	addiw	s11,s11,1
    80006142:	0a11                	addi	s4,s4,4
    80006144:	ff2d98e3          	bne	s11,s2,80006134 <virtio_disk_rw+0x92>
    80006148:	85e6                	mv	a1,s9
    8000614a:	0001c517          	auipc	a0,0x1c
    8000614e:	d8e50513          	addi	a0,a0,-626 # 80021ed8 <disk+0x18>
    80006152:	ffffc097          	auipc	ra,0xffffc
    80006156:	020080e7          	jalr	32(ra) # 80002172 <sleep>
    8000615a:	f8040a13          	addi	s4,s0,-128
    8000615e:	8652                	mv	a2,s4
    80006160:	894e                	mv	s2,s3
    80006162:	b77d                	j	80006110 <virtio_disk_rw+0x6e>
    80006164:	f8042503          	lw	a0,-128(s0)
    80006168:	00a50713          	addi	a4,a0,10
    8000616c:	0712                	slli	a4,a4,0x4
    8000616e:	0001c797          	auipc	a5,0x1c
    80006172:	d5278793          	addi	a5,a5,-686 # 80021ec0 <disk>
    80006176:	00e786b3          	add	a3,a5,a4
    8000617a:	01803633          	snez	a2,s8
    8000617e:	c690                	sw	a2,8(a3)
    80006180:	0006a623          	sw	zero,12(a3)
    80006184:	01a6b823          	sd	s10,16(a3)
    80006188:	f6070613          	addi	a2,a4,-160
    8000618c:	6394                	ld	a3,0(a5)
    8000618e:	96b2                	add	a3,a3,a2
    80006190:	00870593          	addi	a1,a4,8
    80006194:	95be                	add	a1,a1,a5
    80006196:	e28c                	sd	a1,0(a3)
    80006198:	0007b803          	ld	a6,0(a5)
    8000619c:	9642                	add	a2,a2,a6
    8000619e:	46c1                	li	a3,16
    800061a0:	c614                	sw	a3,8(a2)
    800061a2:	4585                	li	a1,1
    800061a4:	00b61623          	sh	a1,12(a2)
    800061a8:	f8442683          	lw	a3,-124(s0)
    800061ac:	00d61723          	sh	a3,14(a2)
    800061b0:	0692                	slli	a3,a3,0x4
    800061b2:	9836                	add	a6,a6,a3
    800061b4:	058a8613          	addi	a2,s5,88
    800061b8:	00c83023          	sd	a2,0(a6)
    800061bc:	0007b803          	ld	a6,0(a5)
    800061c0:	96c2                	add	a3,a3,a6
    800061c2:	40000613          	li	a2,1024
    800061c6:	c690                	sw	a2,8(a3)
    800061c8:	001c3613          	seqz	a2,s8
    800061cc:	0016161b          	slliw	a2,a2,0x1
    800061d0:	00166613          	ori	a2,a2,1
    800061d4:	00c69623          	sh	a2,12(a3)
    800061d8:	f8842603          	lw	a2,-120(s0)
    800061dc:	00c69723          	sh	a2,14(a3)
    800061e0:	00250693          	addi	a3,a0,2
    800061e4:	0692                	slli	a3,a3,0x4
    800061e6:	96be                	add	a3,a3,a5
    800061e8:	58fd                	li	a7,-1
    800061ea:	01168823          	sb	a7,16(a3)
    800061ee:	0612                	slli	a2,a2,0x4
    800061f0:	9832                	add	a6,a6,a2
    800061f2:	f9070713          	addi	a4,a4,-112
    800061f6:	973e                	add	a4,a4,a5
    800061f8:	00e83023          	sd	a4,0(a6)
    800061fc:	6398                	ld	a4,0(a5)
    800061fe:	9732                	add	a4,a4,a2
    80006200:	c70c                	sw	a1,8(a4)
    80006202:	4609                	li	a2,2
    80006204:	00c71623          	sh	a2,12(a4)
    80006208:	00071723          	sh	zero,14(a4)
    8000620c:	00baa223          	sw	a1,4(s5)
    80006210:	0156b423          	sd	s5,8(a3)
    80006214:	6794                	ld	a3,8(a5)
    80006216:	0026d703          	lhu	a4,2(a3)
    8000621a:	8b1d                	andi	a4,a4,7
    8000621c:	0706                	slli	a4,a4,0x1
    8000621e:	96ba                	add	a3,a3,a4
    80006220:	00a69223          	sh	a0,4(a3)
    80006224:	0ff0000f          	fence
    80006228:	6798                	ld	a4,8(a5)
    8000622a:	00275783          	lhu	a5,2(a4)
    8000622e:	2785                	addiw	a5,a5,1
    80006230:	00f71123          	sh	a5,2(a4)
    80006234:	0ff0000f          	fence
    80006238:	100017b7          	lui	a5,0x10001
    8000623c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    80006240:	004aa783          	lw	a5,4(s5)
    80006244:	0001c917          	auipc	s2,0x1c
    80006248:	da490913          	addi	s2,s2,-604 # 80021fe8 <disk+0x128>
    8000624c:	4485                	li	s1,1
    8000624e:	00b79c63          	bne	a5,a1,80006266 <virtio_disk_rw+0x1c4>
    80006252:	85ca                	mv	a1,s2
    80006254:	8556                	mv	a0,s5
    80006256:	ffffc097          	auipc	ra,0xffffc
    8000625a:	f1c080e7          	jalr	-228(ra) # 80002172 <sleep>
    8000625e:	004aa783          	lw	a5,4(s5)
    80006262:	fe9788e3          	beq	a5,s1,80006252 <virtio_disk_rw+0x1b0>
    80006266:	f8042903          	lw	s2,-128(s0)
    8000626a:	00290713          	addi	a4,s2,2
    8000626e:	0712                	slli	a4,a4,0x4
    80006270:	0001c797          	auipc	a5,0x1c
    80006274:	c5078793          	addi	a5,a5,-944 # 80021ec0 <disk>
    80006278:	97ba                	add	a5,a5,a4
    8000627a:	0007b423          	sd	zero,8(a5)
    8000627e:	0001c997          	auipc	s3,0x1c
    80006282:	c4298993          	addi	s3,s3,-958 # 80021ec0 <disk>
    80006286:	00491713          	slli	a4,s2,0x4
    8000628a:	0009b783          	ld	a5,0(s3)
    8000628e:	97ba                	add	a5,a5,a4
    80006290:	00c7d483          	lhu	s1,12(a5)
    80006294:	854a                	mv	a0,s2
    80006296:	00e7d903          	lhu	s2,14(a5)
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	b9c080e7          	jalr	-1124(ra) # 80005e36 <free_desc>
    800062a2:	8885                	andi	s1,s1,1
    800062a4:	f0ed                	bnez	s1,80006286 <virtio_disk_rw+0x1e4>
    800062a6:	0001c517          	auipc	a0,0x1c
    800062aa:	d4250513          	addi	a0,a0,-702 # 80021fe8 <disk+0x128>
    800062ae:	ffffb097          	auipc	ra,0xffffb
    800062b2:	9dc080e7          	jalr	-1572(ra) # 80000c8a <release>
    800062b6:	70e6                	ld	ra,120(sp)
    800062b8:	7446                	ld	s0,112(sp)
    800062ba:	74a6                	ld	s1,104(sp)
    800062bc:	7906                	ld	s2,96(sp)
    800062be:	69e6                	ld	s3,88(sp)
    800062c0:	6a46                	ld	s4,80(sp)
    800062c2:	6aa6                	ld	s5,72(sp)
    800062c4:	6b06                	ld	s6,64(sp)
    800062c6:	7be2                	ld	s7,56(sp)
    800062c8:	7c42                	ld	s8,48(sp)
    800062ca:	7ca2                	ld	s9,40(sp)
    800062cc:	7d02                	ld	s10,32(sp)
    800062ce:	6de2                	ld	s11,24(sp)
    800062d0:	6109                	addi	sp,sp,128
    800062d2:	8082                	ret

00000000800062d4 <virtio_disk_intr>:
    800062d4:	1101                	addi	sp,sp,-32
    800062d6:	ec06                	sd	ra,24(sp)
    800062d8:	e822                	sd	s0,16(sp)
    800062da:	e426                	sd	s1,8(sp)
    800062dc:	1000                	addi	s0,sp,32
    800062de:	0001c497          	auipc	s1,0x1c
    800062e2:	be248493          	addi	s1,s1,-1054 # 80021ec0 <disk>
    800062e6:	0001c517          	auipc	a0,0x1c
    800062ea:	d0250513          	addi	a0,a0,-766 # 80021fe8 <disk+0x128>
    800062ee:	ffffb097          	auipc	ra,0xffffb
    800062f2:	8e8080e7          	jalr	-1816(ra) # 80000bd6 <acquire>
    800062f6:	10001737          	lui	a4,0x10001
    800062fa:	533c                	lw	a5,96(a4)
    800062fc:	8b8d                	andi	a5,a5,3
    800062fe:	d37c                	sw	a5,100(a4)
    80006300:	0ff0000f          	fence
    80006304:	689c                	ld	a5,16(s1)
    80006306:	0204d703          	lhu	a4,32(s1)
    8000630a:	0027d783          	lhu	a5,2(a5)
    8000630e:	04f70863          	beq	a4,a5,8000635e <virtio_disk_intr+0x8a>
    80006312:	0ff0000f          	fence
    80006316:	6898                	ld	a4,16(s1)
    80006318:	0204d783          	lhu	a5,32(s1)
    8000631c:	8b9d                	andi	a5,a5,7
    8000631e:	078e                	slli	a5,a5,0x3
    80006320:	97ba                	add	a5,a5,a4
    80006322:	43dc                	lw	a5,4(a5)
    80006324:	00278713          	addi	a4,a5,2
    80006328:	0712                	slli	a4,a4,0x4
    8000632a:	9726                	add	a4,a4,s1
    8000632c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006330:	e721                	bnez	a4,80006378 <virtio_disk_intr+0xa4>
    80006332:	0789                	addi	a5,a5,2
    80006334:	0792                	slli	a5,a5,0x4
    80006336:	97a6                	add	a5,a5,s1
    80006338:	6788                	ld	a0,8(a5)
    8000633a:	00052223          	sw	zero,4(a0)
    8000633e:	ffffc097          	auipc	ra,0xffffc
    80006342:	ea6080e7          	jalr	-346(ra) # 800021e4 <wakeup>
    80006346:	0204d783          	lhu	a5,32(s1)
    8000634a:	2785                	addiw	a5,a5,1
    8000634c:	17c2                	slli	a5,a5,0x30
    8000634e:	93c1                	srli	a5,a5,0x30
    80006350:	02f49023          	sh	a5,32(s1)
    80006354:	6898                	ld	a4,16(s1)
    80006356:	00275703          	lhu	a4,2(a4)
    8000635a:	faf71ce3          	bne	a4,a5,80006312 <virtio_disk_intr+0x3e>
    8000635e:	0001c517          	auipc	a0,0x1c
    80006362:	c8a50513          	addi	a0,a0,-886 # 80021fe8 <disk+0x128>
    80006366:	ffffb097          	auipc	ra,0xffffb
    8000636a:	924080e7          	jalr	-1756(ra) # 80000c8a <release>
    8000636e:	60e2                	ld	ra,24(sp)
    80006370:	6442                	ld	s0,16(sp)
    80006372:	64a2                	ld	s1,8(sp)
    80006374:	6105                	addi	sp,sp,32
    80006376:	8082                	ret
    80006378:	00002517          	auipc	a0,0x2
    8000637c:	54850513          	addi	a0,a0,1352 # 800088c0 <syscalls+0x3e0>
    80006380:	ffffa097          	auipc	ra,0xffffa
    80006384:	1c0080e7          	jalr	448(ra) # 80000540 <panic>
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
