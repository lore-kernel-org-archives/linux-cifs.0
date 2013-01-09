From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [3.8-rc2] stuck at reading CIFS mounted directory
Date: Wed, 9 Jan 2013 06:27:33 -0500
Message-ID: <20130109062733.028a90a0@tlielax.poochiereds.net>
References: <16401870.457771357701460059.JavaMail.weblogic@epml11>
Mime-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: jongman.heo-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <16401870.457771357701460059.JavaMail.weblogic@epml11>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 09 Jan 2013 03:17:40 +0000 (GMT)
=C7=E3=C1=BE=B8=B8 <jongman.heo-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:

> Hi,
>=20
> > ------- Original Message -------
> > Sender : Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Date : 2013-01-08 00:13 (GMT+09:00)
> > Title : Re: [3.8-rc2] stuck at reading CIFS mounted directory
> >=20
> > On Mon, 07 Jan 2013 15:10:05 +0530
> > Suresh Jayaraman wrote:
> >=20
> > > (Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> > >=20
> > > On 01/04/2013 06:27 AM, Jongman Heo wrote:
> > > > Hi, all,
> > > >=20
> > > > In 3.8-rc2, access to CIFS-mounted directory (df, ls, or simila=
r) got stuck with following message.
> > > >=20
> > > > It's mounted with...
> > > >   mount -t cifs ///Share  /mnt/window -o user=3Djongman.heo,pas=
sword=3Dxxxx,sec=3Dntlm
> > > >=20
> > > >=20
> > > > [16655.288591] INFO: task bash:4042 blocked for more than 120 s=
econds.
> > > > [16655.318117] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
> > > > [16655.318123] bash            D dada9c5c     0  4042      1 0x=
00000004
> > > > [16655.318132]  dada9cd0 00000082 00000282 dada9c5c c09022c6 da=
da9c7c c044d316 c0c7c300
> > > > [16655.318139]  d6db3a7b 00000f09 c0c7c300 00000000 00000f09 f3=
b7b240 c04401ba 00000000
> > > > [16655.318145]  c0b9e0d8 f598e960 00000000 00000303 dada9c98 da=
da9c98 f598e960 00000006
> > > > [16655.318150] Call Trace:
> > > > [16655.342785]  [] ? _raw_spin_unlock_irqrestore+0xf/0x11
> > > > [16655.351554]  [] ? __wake_up+0x3b/0x42
> > > > [16655.358802]  [] ? call_usermodehelper_fns+0x148/0x152
> > > > [16655.358840]  [] ? __request_module+0x15e/0x1a1
> > > > [16655.358842]  [] ? call_usermodehelper_freeinfo+0x19/0x19
> > > > [16655.358845]  [] schedule+0x51/0x53
> > > > [16655.358847]  [] schedule_preempt_disabled+0x8/0xa
> > > > [16655.384345]  [] __mutex_lock_common+0xd6/0x123
> > > > [16655.384430]  [] __mutex_lock_slowpath+0x20/0x22
> > > > [16655.384436]  [] ? mutex_lock+0x18/0x25
> > > > [16655.384441]  [] mutex_lock+0x18/0x25
> > > > [16655.384892]  [] cifs_reconnect_tcon+0x170/0x252
> > > > [16655.384953]  [] ? should_resched+0x8/0x22
> > > > [16655.384963]  [] ? _cond_resched+0x8/0x1c
> > > > [16655.384969]  [] smb_init+0x1d/0x6d
> > > > [16655.385023]  [] CIFSSMBQPathInfo+0x4e/0x1e4
> > > > [16655.385071]  [] cifs_query_path_info+0x38/0x73
> > > > [16655.385080]  [] cifs_get_inode_info+0x122/0x3ac
> > > > [16655.385548]  [] ? walk_component+0x14a/0x17a
> > > > [16655.385570]  [] ? build_path_from_dentry+0xa3/0x19e
> > > > [16655.385585]  [] ? build_path_from_dentry+0xa3/0x19e
> > > > [16655.385596]  [] ? build_path_from_dentry+0xa3/0x19e
> > > > [16655.385601]  [] ? getname_flags+0x59/0xeb
> > > > [16655.385606]  [] ? _raw_spin_lock+0x8/0xa
> > > > [16655.385613]  [] cifs_revalidate_dentry_attr+0x120/0x168
> > > > [16655.385618]  [] cifs_getattr+0x5e/0xe3
> > > > [16655.385625]  [] vfs_getattr+0x37/0x4e
> > > > [16655.385631]  [] ? cifs_revalidate_dentry+0x20/0x20
> > > > [16655.385639]  [] vfs_fstatat+0x59/0x8a
> > > > [16655.385645]  [] vfs_stat+0x19/0x1b
> > > > [16655.385652]  [] sys_stat64+0x11/0x22
> > > > [16655.385659]  [] ? should_resched+0x8/0x22
> > > > [16655.385668]  [] ? _cond_resched+0x8/0x1c
> > > > [16655.385674]  [] ? task_work_run+0x6d/0x79
> > > > [16655.385825]  [] ? __do_page_fault+0x33b/0x33b
> > > > [16655.385834]  [] ? do_page_fault+0x8/0xa
> > > > [16655.385840]  [] sysenter_do_call+0x12/0x2c
> > > >=20
> > > > N?????r??y???b?X???v?^?)?{.n?+????{????zX??=17???}????z?&j:+v??=
?=07????zZ+??+zf???h???~????i???z?=1E?w????????&?)?=1Bf??^j?y?m??@A?a??=
=7F? 0??h?=0F?i=7F
> > > >=20
> > >=20
> > >=20
> >=20
> > Looks like it's waiting on the session_mutex to become free. The
> > question is what's holding it and why. Some questions:
> >=20
> > 1) is this a regression? If so, what version were you using previou=
sly?
>=20
> Yeah, regression. IIRC I didn't have this issue with 3.7.
>=20
> > 2) any other processes stuck on on this mutex? What about the cifsd
> > thread for this mount? Is it stuck holding it? You may want to
> > "cat /proc//stack" on any other threads that might be related here
> > and see if you can figure out what they're doing.
>=20
> After the hang happens, CIFS is working well. Stack of cifsd doesn't =
show any interesting thing.
>=20
> [ORANGE@/mnt/window] ps ax | grep cifsd
>  1135 ?        S      1:13 [cifsd]
> [ORANGE@/mnt/window] cat /proc/1135/stack
> [<c0833b8b>] sk_wait_data+0x63/0x9b
> [<c0872e20>] tcp_recvmsg+0x3aa/0x780
> [<c088cf40>] inet_recvmsg+0x51/0x63
> [<c0830628>] sock_recvmsg+0x80/0x9d
> [<c0830674>] kernel_recvmsg+0x2f/0x3f
> [<c05ea2e9>] cifs_readv_from_socket+0x142/0x1d3
> [<c05ea396>] cifs_read_from_socket+0x1c/0x1e
> [<c05eaad2>] cifs_demultiplex_thread+0x701/0x72b
> [<c0445ca4>] kthread+0x6b/0x70
> [<c09078b7>] ret_from_kernel_thread+0x1b/0x28
> [<ffffffff>] 0xffffffff
>=20
>=20
> Host : Windows 7
> Guest : VMWare Fedora 16 + 3.8 custom kernel
>=20
> I feel that the issue is more likely to happen in this case.
>=20
>  mount cifs directory from VMWare guest -> go to S3 sleep mode (by cl=
osing lid of laptop) -> open lid -> check cifs directory of VMWare
>=20
>=20
> Following is more call stack trace I hit today.
>=20
> [23245.542488] INFO: task bash:2711 blocked for more than 120 seconds=
=2E
> [23245.571664] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [23245.571672] bash            D f3bd5c5c     0  2711   2689 0x000000=
00
> [23245.580899]  f3bd5cd0 00000086 00000282 f3bd5c5c c0902306 f3bd5c7c=
 c044d2be c0c7c300
> [23245.580910]  b538a613 000014fd c0c7c300 00000000 000014fd f3bf0c90=
 c0440162 00000000
> [23245.580919]  c0b9e0d8 f3b8ab60 00000000 00000303 f3bd5c98 f3bd5c98=
 f3b8ab60 00000006
> [23245.580928] Call Trace:
> [23245.603320]  [<c0902306>] ? _raw_spin_unlock_irqrestore+0xf/0x11
> [23245.609972]  [<c044d2be>] ? __wake_up+0x3b/0x42
> [23245.610114]  [<c0440162>] ? call_usermodehelper_fns+0x148/0x152
> [23245.610389]  [<c0440410>] ? __request_module+0x15e/0x1a1
> [23245.610397]  [<c043fde5>] ? call_usermodehelper_freeinfo+0x19/0x19
> [23245.610404]  [<c0901ada>] schedule+0x51/0x53
> [23245.610409]  [<c0901c2d>] schedule_preempt_disabled+0x8/0xa
> [23245.610894]  [<c0900e26>] __mutex_lock_common+0xd6/0x123
> [23245.610914]  [<c0900f79>] __mutex_lock_slowpath+0x20/0x22
> [23245.610920]  [<c0900f1f>] ? mutex_lock+0x18/0x25
> [23245.610925]  [<c0900f1f>] mutex_lock+0x18/0x25
> [23245.611495]  [<c05e1580>] cifs_reconnect_tcon+0x170/0x252
> [23245.611506]  [<c0450644>] ? resched_task+0x5e/0x61
> [23245.620010]  [<c05e167f>] smb_init+0x1d/0x6d
> [23245.620183]  [<c05e4eaf>] CIFSSMBQPathInfo+0x4e/0x1e4
> [23245.620248]  [<c05fdfbc>] cifs_query_path_info+0x38/0x73
> [23245.620265]  [<c05f455a>] cifs_get_inode_info+0x122/0x3ac
> [23245.620721]  [<c04e1e87>] ? walk_component+0x14a/0x17a
> [23245.620736]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
> [23245.620742]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
> [23245.620748]  [<c05ece9e>] ? build_path_from_dentry+0xa3/0x19e
> [23245.620754]  [<c04e215c>] ? getname_flags+0x1/0xeb
> [23245.620759]  [<c09022ba>] ? _raw_spin_lock+0x8/0xa
> [23245.620766]  [<c05f5bd4>] cifs_revalidate_dentry_attr+0x120/0x168
> [23245.620772]  [<c05f5cbd>] cifs_getattr+0x5e/0xe3
> [23245.620779]  [<c04dda16>] ? cp_new_stat64+0xef/0x101
> [23245.620785]  [<c04dddde>] vfs_getattr+0x37/0x4e
> [23245.620790]  [<c05f5c5f>] ? cifs_revalidate_dentry+0x20/0x20
> [23245.620796]  [<c04dde4e>] vfs_fstatat+0x59/0x8a
> [23245.620816]  [<c04ddeb3>] vfs_stat+0x19/0x1b
> [23245.620828]  [<c04de0b8>] sys_stat64+0x11/0x22
> [23245.620887]  [<c0907951>] sysenter_do_call+0x12/0x2c

I can't tell much from those messages, unfortunately. They just tell me
that this process is stuck waiting on a mutex (probably the
session_mutex). One thing you could do is follow the instructions here:

    https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Oopses

=2E..and get a line number for cifs_reconnect_tcon+0x170.

The real questions are what's holding this mutex and why isn't it
releasing it?

It might be worthwhile to poke around in the live kernel with a kernel
debugger (such as "crash") to see if you can determine that.
Alternately, git bisect might be another way to track this down.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
