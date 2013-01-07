From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [3.8-rc2] stuck at reading CIFS mounted directory
Date: Mon, 07 Jan 2013 15:10:05 +0530
Message-ID: <50EA97F5.5050801@suse.com>
References: <1839076.322591357261060518.JavaMail.weblogic@epml11>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: jongman.heo-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1839076.322591357261060518.JavaMail.weblogic@epml11>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)

On 01/04/2013 06:27 AM, Jongman Heo wrote:
> Hi, all,
>=20
> In 3.8-rc2, access to CIFS-mounted directory (df, ls, or similar) got=
 stuck with following message.
>=20
> It's mounted with...
>   mount -t cifs //<win_host_ip_address>/Share  /mnt/window -o user=3D=
jongman.heo,password=3Dxxxx,sec=3Dntlm
>=20
>=20
> [16655.288591] INFO: task bash:4042 blocked for more than 120 seconds=
=2E
> [16655.318117] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" dis=
ables this message.
> [16655.318123] bash            D dada9c5c     0  4042      1 0x000000=
04
> [16655.318132]  dada9cd0 00000082 00000282 dada9c5c c09022c6 dada9c7c=
 c044d316 c0c7c300
> [16655.318139]  d6db3a7b 00000f09 c0c7c300 00000000 00000f09 f3b7b240=
 c04401ba 00000000
> [16655.318145]  c0b9e0d8 f598e960 00000000 00000303 dada9c98 dada9c98=
 f598e960 00000006
> [16655.318150] Call Trace:
> [16655.342785]  [<c09022c6>] ? _raw_spin_unlock_irqrestore+0xf/0x11
> [16655.351554]  [<c044d316>] ? __wake_up+0x3b/0x42
> [16655.358802]  [<c04401ba>] ? call_usermodehelper_fns+0x148/0x152
> [16655.358840]  [<c0440468>] ? __request_module+0x15e/0x1a1
> [16655.358842]  [<c043fe3d>] ? call_usermodehelper_freeinfo+0x19/0x19
> [16655.358845]  [<c0901a9a>] schedule+0x51/0x53
> [16655.358847]  [<c0901bed>] schedule_preempt_disabled+0x8/0xa
> [16655.384345]  [<c0900de6>] __mutex_lock_common+0xd6/0x123
> [16655.384430]  [<c0900f39>] __mutex_lock_slowpath+0x20/0x22
> [16655.384436]  [<c0900edf>] ? mutex_lock+0x18/0x25
> [16655.384441]  [<c0900edf>] mutex_lock+0x18/0x25
> [16655.384892]  [<c05e1650>] cifs_reconnect_tcon+0x170/0x252
> [16655.384953]  [<c044c652>] ? should_resched+0x8/0x22
> [16655.384963]  [<c09018dc>] ? _cond_resched+0x8/0x1c
> [16655.384969]  [<c05e174f>] smb_init+0x1d/0x6d
> [16655.385023]  [<c05e4f7f>] CIFSSMBQPathInfo+0x4e/0x1e4
> [16655.385071]  [<c05fe062>] cifs_query_path_info+0x38/0x73
> [16655.385080]  [<c05f460a>] cifs_get_inode_info+0x122/0x3ac
> [16655.385548]  [<c04e1f2f>] ? walk_component+0x14a/0x17a
> [16655.385570]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
> [16655.385585]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
> [16655.385596]  [<c05ecf6e>] ? build_path_from_dentry+0xa3/0x19e
> [16655.385601]  [<c04e225c>] ? getname_flags+0x59/0xeb
> [16655.385606]  [<c090227a>] ? _raw_spin_lock+0x8/0xa
> [16655.385613]  [<c05f5c84>] cifs_revalidate_dentry_attr+0x120/0x168
> [16655.385618]  [<c05f5d6d>] cifs_getattr+0x5e/0xe3
> [16655.385625]  [<c04dde86>] vfs_getattr+0x37/0x4e
> [16655.385631]  [<c05f5d0f>] ? cifs_revalidate_dentry+0x20/0x20
> [16655.385639]  [<c04ddef6>] vfs_fstatat+0x59/0x8a
> [16655.385645]  [<c04ddf5b>] vfs_stat+0x19/0x1b
> [16655.385652]  [<c04de160>] sys_stat64+0x11/0x22
> [16655.385659]  [<c044c652>] ? should_resched+0x8/0x22
> [16655.385668]  [<c09018dc>] ? _cond_resched+0x8/0x1c
> [16655.385674]  [<c0443b74>] ? task_work_run+0x6d/0x79
> [16655.385825]  [<c0904f3d>] ? __do_page_fault+0x33b/0x33b
> [16655.385834]  [<c0904f45>] ? do_page_fault+0x8/0xa
> [16655.385840]  [<c0907911>] sysenter_do_call+0x12/0x2c
>=20
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BDzX=EF=BF=BD=EF=BF=BD=17=EF=BF=BD=EF=BF=BD=DC=
=A8}=EF=BF=BD=EF=BF=BD=EF=BF=BD=C6=A0z=EF=BF=BD&j:+v=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=BF=BD+zf=EF=
=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD~=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BDi=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=1E=EF=BF=BDw=EF=
=BF=BD=EF=BF=BD=EF=BF=BD?=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD&=EF=BF=BD=
)=DF=A2=1Bf=EF=BF=BD=EF=BF=BD^j=C7=ABy=EF=BF=BDm=EF=BF=BD=EF=BF=BD@A=EF=
=BF=BDa=EF=BF=BD=EF=BF=BD=7F=EF=BF=BD=0C0=EF=BF=BD=EF=BF=BDh=EF=BF=BD=0F=
=EF=BF=BDi=7F
>=20


--=20
Suresh Jayaraman
