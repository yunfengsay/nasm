code  segment
              assume    cs:code,ds:code
              org       100h
        main  proc      near
              mov       ax,0004	；设置图形显示模式4
              int       10h
			
              mov       ah,0bh	；选择彩色组0
              mov       bh,1
              mov       bl,0
              int       10h
			
              mov       cx,0	；直线起始点坐标为（0，0）
              mov       dx,0
   lineloop:
              call      pixel	；画出一个绿色点
              inc       cx	；X坐标加1
              inc       dx	；Y坐标加1
              cmp       dx,199	；画到第199个点了吗？
              jnz       lineloop	；若没画完直线，转LINELOOP继续
			
              mov       ah,0	；等待键盘输入
              int       16h
			
              mov       ax,0003h	；设置字符显示模式3
              int       10h
              mov       ah,4ch	；结束进程
              int       21h
        main  endp
			
       pixel  proc      near	；画点子程序，使用直接写屏方法
              push      ax	；保存寄存器
              push      bx
              push      cx
              push      dx
              push      di
              push      es
			
              mov       ax,0b800h	；ES:DI指向图形显示缓冲区首
              mov       es,ax
              mov       di,0
			
              mov       ax,dx	；Y坐标送入AX寄存器
              shr       ax,1	；判断Y坐标是否为奇数
              jnc       even_line	；若移出的位是0，说明所画线位于偶数行
              mov       di,2000h	；所画线位于奇数行，DI指向偏移2000H处
  even_line:
              mov       bx,80	；计算"行数 x 80"
              mul       bx
              add       di,ax	；"行数 x 80"累加入DI寄存器
			
              mov       ax,cx	；计算一行内的偏移量
              mov       bl,4
              div       bl
			
              push      ax	；暂存余数
              mov       ah,0	；将商转换成16位累加入DI寄存器
              add       di,ax
			
              pop       cx	；将余数送入CH寄存器
              xchg      ch,cl	；交换CH，CL寄存器
              shl       cl,1	；余数 x 2作为移位计数
              mov       al,01000000b	；最高两位为颜色值
              shr       al,cl	；将颜色值移到指定位置
			
              or        byte ptr es:[di],al	；将含有颜色值的字节送入显示缓冲区
			
              pop       es	；恢复寄存器
              pop       di
              pop       dx
              pop       cx
              pop       bx
              pop       ax
              ret       ；返回主过程
       pixel  endp
        code  ends
              end       main

