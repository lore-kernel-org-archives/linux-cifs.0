From: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: cifs running amok after being disconnected (timeout?)
Date: Mon, 27 Feb 2017 11:42:26 -0800
Message-ID: <58B48122.5000708@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

mounted a Win7SP1 share on a linux dir, first oddity, when
I did, I saw:
Feb 24 12:27:10 Ishtar kernel: [598035.310815] FS-Cache: Loaded
Feb 24 12:27:10 Ishtar kernel: [598035.326570] FS-Cache: Netfs 'cifs' 
registered for caching
Feb 24 12:27:10 Ishtar kernel: [598035.326868] Key type cifs.idmap 
registered
Feb 24 12:27:42 Ishtar kernel: [598066.465632] INFO: trying to register 
non-static key.
Feb 24 12:27:42 Ishtar kernel: [598066.470733] the code is fine but 
needs lockdep annotation.
Feb 24 12:27:42 Ishtar kernel: [598066.476348] turning off the locking 
correctness validator.
Feb 24 12:27:42 Ishtar kernel: [598066.481963] CPU: 0 PID: 89872 Comm: 
ls Not tainted 4.9.0-Isht-Van #1
Feb 24 12:27:42 Ishtar kernel: [598066.488454] Hardware name: Dell Inc. 
PowerEdge T610/0CX0R0, BIOS 6.3.0 07/24/2012
Feb 24 12:27:42 Ishtar kernel: [598066.496112]  ffffc9000f777cb0 
ffffffff813d6b41 ffff881165b210c0 0000000000000000
Feb 24 12:27:42 Ishtar kernel: [598066.503730]  ffffc9000f777d18 
ffffffff810ba5c5 ffff88145ae25000 ffff88180e402f00
Feb 24 12:27:42 Ishtar kernel: [598066.511341]  ffffea00516b8800 
0000000000000202 ffffc9000f777d00 00000000810994c7
Feb 24 12:27:42 Ishtar kernel: [598066.518956] Call Trace:
Feb 24 12:27:42 Ishtar kernel: [598066.521538]  [<ffffffff813d6b41>] 
dump_stack+0x4d/0x6c
Feb 24 12:27:42 Ishtar kernel: [598066.526826]  [<ffffffff810ba5c5>] 
register_lock_class+0x2a5/0x530
Feb 24 12:27:42 Ishtar kernel: [598066.533078]  [<ffffffff810bbf1c>] 
__lock_acquire.isra.32+0x5c/0xb60
Feb 24 12:27:42 Ishtar kernel: [598066.539504]  [<ffffffff810bcaf1>] 
lock_acquire+0xd1/0x180
Feb 24 12:27:42 Ishtar kernel: [598066.545073]  [<ffffffffa0040e16>] ? 
cifs_closedir+0x56/0x120 [cifs]
Feb 24 12:27:42 Ishtar kernel: [598066.551474]  [<ffffffff8172b95d>] 
_raw_spin_lock+0x3d/0x80
Feb 24 12:27:42 Ishtar kernel: [598066.557094]  [<ffffffffa0040e16>] ? 
cifs_closedir+0x56/0x120 [cifs]
Feb 24 12:27:42 Ishtar kernel: [598066.563494]  [<ffffffffa0040e16>] 
cifs_closedir+0x56/0x120 [cifs]
Feb 24 12:27:42 Ishtar kernel: [598066.569718]  [<ffffffffa0040dc0>] ? 
cifs_open+0x6c0/0x6c0 [cifs]
Feb 24 12:27:42 Ishtar kernel: [598066.575854]  [<ffffffff812106c3>] 
__fput+0xd3/0x210
Feb 24 12:27:42 Ishtar kernel: [598066.580862]  [<ffffffff8121080e>] 
____fput+0xe/0x10
Feb 24 12:27:42 Ishtar kernel: [598066.585871]  [<ffffffff81083f27>] 
task_work_run+0x67/0xb0
Feb 24 12:27:42 Ishtar kernel: [598066.591403]  [<ffffffff81002627>] 
exit_to_usermode_loop+0xf7/0x100
Feb 24 12:27:42 Ishtar kernel: [598066.597714]  [<ffffffff81002c3d>] 
syscall_return_slowpath+0x5d/0x60
Feb 24 12:27:42 Ishtar kernel: [598066.604115]  [<ffffffff8172c2a4>] 
entry_SYSCALL_64_fastpath+0x97/0x99

Then a bit later, saw about 2-4MB i/o going back and forth between
my server and my workstation... Seems cifs was sending a 'ping' (an SMB 
ping),
but windows had disconnected the session (and I guess cifs missed it?), 
so it
kept sending back TCP-resets (I knew I should have saved the wireshark 
trace).

I tried turning on debug by echoing 1 to /proc/fs/cifs/traceSMB, and that
"effectively" stopped the conversation, as it was then saturating my
message log with lines like:
Feb 24 12:56:56 Ishtar kernel: [599820.667536] 0000 2600 53ff 424d 002b 
0000 0000 0001  ...&.SMB+.......
Feb 24 12:56:56 Ishtar kernel: [599820.674164] 0001 0000 0000 0000 0000 
0000 ffff 65af  ...............e
Feb 24 12:56:56 Ishtar kernel: [599820.680748] 0000 0000 0101 0100 
6100                 .........a
Feb 24 12:56:56 Ishtar kernel: [599820.689158] 0000 2600 53ff 424d 002b 
0000 0000 0001  ...&.SMB+.......
....
Feb 24 12:57:41 Ishtar kernel: [599866.128306] 0001 0000 0000 0000 0000 
0000 ffff 6932  ..............2i
Feb 24 12:57:41 Ishtar kernel: [599866.134910] 0000 0000 0101 0100 
6100                 .........a
Feb 24 12:57:41 Ishtar kernel: [599866.141390] 0000 2600 53ff 424d 002b 
0000 0000 0001  ...&.SMB+.......
Feb 24 12:57:41 Ishtar kernel: [599866.147994] 0001 0000 0000 0000 0000 
0000 ffff 6932  ..............2i
Feb 24 12:57:41 Ishtar kernel: [599866.154593] 0000 0000 0101 0100 
6100                 .........a

----
~ 7000+ lines before I echo'd 0 to the trace to turn if off.

the cifs kernel thread was @100%.

I eventually just unmounted the 'share' to stop the weirdness.

Any idea what might have been going on?  Anything better tracing
options to determine what was going on?

Both systems have each other's file systems mounted, which can enable some
weird I/O paths, but nothing that should just keep repeating. 

But I can do an 'ls' on Windows(cygwin) of //Ishtar/Athena_C -- which
does 2 levels of indirection, but .....about .. AH... did a mount, and in
messages log saw this before another loop started:

Feb 24 16:20:43 Ishtar kernel: [612047.880423] CIFS VFS: Server Athenae 
has not responded in 120 seconds. Reconnecting...

... wireshark .. in 4 seconds recorded 116755 packets bouncing back and 
forth.

I saved about 2-3 iterations of the loop
into a capture (appended)

I've had these two machines w/each other mounted off+on
for years, and this has started in the past few months...


Any idea what's going on?
Still seems to be looping -- until I unmount the winfs
on the linux machine.


begin 750 cifs-loop.pcapng
M"@T-"H@```!-/"L:`0```/__________`P`K`#8T+6)I="!7:6YD;W=S(#<@
M4V5R=FEC92!086-K(#$L(&)U:6QD(#<V,#$`!``T`$1U;7!C87`@,2XQ,BXW
M("AV,2XQ,BXW+3`M9S=F8S@Y-S@@9G)O;2!M87-T97(M,2XQ,BD`````B```
M``$```"(`````0``````!``"`#(`7$1E=FEC95Q.4$9?>T$U13@U.#E"+3%!
M-3(M-#-!1BU"-C`P+3%"0T0U.#@Y-3E&,7T```D``0`&````#``K`#8T+6)I
M="!7:6YD;W=S(#<@4V5R=FEC92!086-K(#$L(&)U:6QD(#<V,#$``````(@`
M```&````9`````````!/204`OV63V$(```!"`````!47O[ZRH#:?%<XH"`!%
M```T0!5``(`&``#`J`,,P*@#`0&]H*+(=$HB)S4B3(`2(`"'A````@0%M`$#
M`P@!`00"``!D````!@```%P`````````3TD%`.1ED]@\````/````*`VGQ7.
M*``5%[^^L@@`10``*#L!0`!`!GAQP*@#`<"H`PR@H@&])S4B3,AT2B-0$``;
M*>,``````````%P````&````@`````````!/204`^&63V&````!@````H#:?
M%<XH`!47O[ZR"`!%``!2.P)``$`&>$;`J`,!P*@##*"B`;TG-2),R'1*(U`8
M`!O9\0``````)O]334(K```````!`````````````````/__U9\``````0$`
M`0!A@`````8```!8`````````$])!0#_99/8-@```#8`````%1>_OK*@-I\5
MSB@(`$4``"A`%D``@`8``,"H`PS`J`,!`;V@HLAT2B,G-2)V4!0``(=X````
M`%@````&````9`````````!/204`/6:3V$(```!"````H#:?%<XH`!47O[ZR
M"`!%```T:M9``$`&2)#`J`,!P*@##*"D`;WEGW.=`````(`":0!EQ0```@0C
M``$!!`(!`P,*``!D````!@```&0`````````3TD%`$=FD]A"````0@`````5
M%[^^LJ`VGQ7.*`@`10``-$`70`"`!@``P*@##,"H`P$!O:"DF;"]">6?<YZ`
M$B``AX0```($!;0!`P,(`0$$`@``9`````8```!<`````````$])!0!M9I/8
M/````#P```"@-I\5SB@`%1>_OK((`$4``"AJUT``0`9(F\"H`P'`J`,,H*0!
MO>6?<YZ9L+T*4!``&]8```````````!<````!@```(``````````3TD%`(!F
MD]A@````8````*`VGQ7.*``5%[^^L@@`10``4FK80`!`!DAPP*@#`<"H`PR@
MI`&]Y9]SGIFPO0I0&``;A@\``````";_4TU"*P```````0``````````````
M``#__]6?``````$!``$`88`````&````6`````````!/204`B6:3V#8````V
M`````!47O[ZRH#:?%<XH"`!%```H0!A``(`&``#`J`,,P*@#`0&]H*29L+T*
MY9]SR%`4``"'>`````!8````!@```&0`````````3TD%`-1FD]A"````0@``
M`*`VGQ7.*``5%[^^L@@`10``-#H:0`!`!GE,P*@#`<"H`PR@I@&]E:<C40``
M``"``FD`!@@```($(P`!`00"`0,#"@``9`````4```!L`````````$])!0`L
M;9/8`0`<`$-O=6YT97)S('!R;W9I9&5D(&)Y(&1U;7!C87`"``@`3TD%`,2V
M4M@#``@`3TD%`"QMD]@$``@`$\@!```````%``@`````````````````;```
!````
`
end
