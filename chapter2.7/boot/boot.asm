;RatsOS
;TAB=4
[BITs 16]
	ORG     0x7c00 				;指明程序的偏移的基地址

;启动程序
	JMP     Entry
	DB      0x90
	DB      "RATSBOOT"     		;启动区的名称可以是任意的字符串（8字节）    

;程序核心内容
Entry:

	MOV AH,0x06				;清除屏幕					
	MOV AL,0
	MOV CX,0   
    MOV DX,0xffff  
    MOV BH,0x17				;属性为蓝底白字
	INT 0x10
	

	MOV AH,0x02				;光标位置初始化
	MOV DX,0
	MOV BH,0
	MOV DH,0x0
	MOV DL,0x0
	INT 0x10

	;---------------------------
	;输出字符串
	mov di,HelloText		;将HelloText的地址放入di
	mov dh,0				;设置显示行
	call PutString			;调用函数
	
;程序挂起
Fin:
	HLT 					;让CPU挂起，等待指令。
	JMP Fin

; ------------------------------------------------------------------------
;准备显示字符串
HelloText: DB "hello,ratsos!",0


; ------------------------------------------------------------------------
; 显示字符串函数:PutString
; 参数:
; si = 字符串开始地址,
; dh = 第N行，0开始
; ------------------------------------------------------------------------
PutString:
			mov cx,0			;BIOS中断参数：显示字符串长度
			mov bx,di
	.s1:;获取字符串长度
			mov al,[bx]			;读取1个字节到al
			add bx,1			;读取下个字节
			cmp al,0			;是否以0结束
			je .s2
			add	cx,1			;计数器
			jmp .s1
	.s2:;显示字符串
			mov bx,di
			mov bp,bx
			mov ax,ds
			mov es,ax			;BIOS中断参数：计算[ES:BP]为显示字符串开始地址

			mov ah,0x13			;BIOS中断参数：显示文字串
			mov al,0x01			;BIOS中断参数：文本输出方式(40×25 16色 文本)
			mov bh,0x0			;BIOS中断参数：指定分页为0
			mov bl,0x1F			;BIOS中断参数：指定白色文字			
			mov dl,0			;列号为0
			int 0x10			;调用BIOS中断操作显卡。输出字符串
			ret

FillSector:
	RESB    510-($-$$)       	;处理当前行$至结束(1FE)的填充
	DB      0x55, 0xaa