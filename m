From: =?iso-8859-1?Q?Tobias_Doerffel?= <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org>
Subject: =?iso-8859-1?Q?Hanging_cifsiod_/_OpLock_break_problems?=
Date: Tue, 3 Mar 2015 10:25:19 +0100
Message-ID: <zarafa.54f57dff.559b.17aa37831ab590f0@zarafa.ed-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?iso-8859-1?Q?linux-cifs=40vger=2Ekernel=2Eorg?=
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

we're having constant issues with CIFS mounts on our Linux terminal ser=
vers (Ubuntu 12.04 with updated kernel). Usually after 1 or 2 days we s=
ee the following in dmesg:

[63840.116062] INFO: task cifsiod:1393 blocked for more than 120 second=
s.
[63840.116101]       Not tainted 3.19.0-7-generic #7-Ubuntu
[63840.116135] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
[63840.116175] cifsiod         D ffff88079ba3fbb8     0  1393      2 0x=
00000000
[63840.116193] Workqueue: cifsiod cifs_oplock_break [cifs]
[63840.116195]  ffff88079ba3fbb8 ffff880799305850 0000000000014200 ffff=
88079ba3ffd8
[63840.116197]  0000000000014200 ffff8804c3cdd850 ffff880799305850 ffff=
88079c7971c0
[63840.116198]  ffff8807bfc94af8 ffff8807bff995e8 0000000000000002 ffff=
ffff817cb0d0
[63840.116200] Call Trace:
[63840.116207]  [<ffffffff817cb0d0>] ? bit_wait_timeout+0x70/0x70
[63840.116209]  [<ffffffff817ca800>] io_schedule+0xa0/0x130
[63840.116210]  [<ffffffff817cb0fb>] bit_wait_io+0x2b/0x50
[63840.116212]  [<ffffffff817caca7>] __wait_on_bit+0x67/0x90
[63840.116215]  [<ffffffff8117ba00>] ? find_get_pages_tag+0x110/0x190
[63840.116217]  [<ffffffff8117a645>] wait_on_page_bit+0xc5/0xd0
[63840.116220]  [<ffffffff810b6f70>] ? autoremove_wake_function+0x40/0x=
40
[63840.116221]  [<ffffffff8117a739>] filemap_fdatawait_range+0xe9/0x180
[63840.116225]  [<ffffffff810a0070>] ? sched_ttwu_pending+0x70/0x70
[63840.116227]  [<ffffffff8117a7f7>] filemap_fdatawait+0x27/0x30
[63840.116232]  [<ffffffffc049fb31>] cifs_oplock_break+0x301/0x330 [cif=
s]
[63840.116234]  [<ffffffff8108f218>] process_one_work+0x158/0x460
[63840.116236]  [<ffffffff8108f6ac>] rescuer_thread+0x18c/0x460
[63840.116237]  [<ffffffff8108f520>] ? process_one_work+0x460/0x460
[63840.116239]  [<ffffffff810950e9>] kthread+0xc9/0xe0
[63840.116241]  [<ffffffff81095020>] ? kthread_create_on_node+0x1c0/0x1=
c0
[63840.116243]  [<ffffffff817cf2bc>] ret_from_fork+0x7c/0xb0
[63840.116244]  [<ffffffff81095020>] ? kthread_create_on_node+0x1c0/0x1=
c0


The same repeats for various other processes like kworker and the hangi=
ng userspace process. This happens with all recent kernel versions (3.1=
3-3.19) and forces us to reboot the server regularly as the requesting =
processes always hang with process state "D" and (I/O) load increases f=
rom day to day. Further information:

Mount options: sec=3Dkrb5,multiuser,mfsymlinks,dir_mode=3D0700,file_mod=
e=3D0700,nomapposix,noserverino,cache=3Dloose,nobrl
CIFS server: Samba 4.1.17 with default configuration

We can't use cache=3Dstrict as it causes problems with certain userspac=
e programs. I was hoping ca7df8e0bb2a5ec79691de8a1a4c0e611fe04e60 fixes=
 the issue but apparently it does not. Is there anything else we can tr=
y or examine?

Best regards

Tobias


--
Dipl.-Inf. Tobias Doerffel

-----------------------------------------------
EDC Electronic Design Chemnitz GmbH
Technologie-Campus 4, 09126 Chemnitz

Gesch=E4ftsf=FChrer: Dr.-Ing. Steffen Heinz
                 Dipl.-Ing. Andr=E9 Lange
Tel.:            +49 371 52 45 90
=46ax.:            +49 371 52 45 910
E-Mail:          info-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org

Sitz der Gesellschaft: Chemnitz
HRB 23986, Amtsgericht Chemnitz
USTID: DE258181725
-----------------------------------------------
