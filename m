From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: smb2 kernel panic on module unload
Date: Wed, 8 Sep 2010 14:35:18 -0500
Message-ID: <AANLkTi=QVcwkh6_jdY+MghqppF00bC6quaNpSJygQ_tv@mail.gmail.com>
References: <4C87D7D1.806@candelatech.com>
	<AANLkTine_Q8fdf7Dpz4Rm1V4PXcc3VQ-Z1U_VHZu_P5u@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTine_Q8fdf7Dpz4Rm1V4PXcc3VQ-Z1U_VHZu_P5u-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
=46rom: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, Sep 8, 2010 at 2:35 PM
Subject: Re: smb2 kernel panic on module unload
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>


On Wed, Sep 8, 2010 at 1:37 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wr=
ote:
> I saw this when attempting to rmmod smb2.
>
> Thanks,
> Ben
>
>
> ------------[ cut here ]------------
> WARNING: at fs/proc/generic.c:816 remove_proc_entry+0xf3/0x26d()
> Hardware name: X8STi
> name 'DebugData'
> Modules linked in: smb2(-) xt_CT iptable_raw ipt_addrtype xt_DSCP xt_=
dscp
> xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hash=
limit
> xt_connmark 8021q garp bridge stp llc veth fuse arc4 michael_mic macv=
lan
> pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd
> fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput ixgbe ioatdma e1000e g=
hes dca
> mdio hed iTCO_wdt iTCO_vendor_support i2c_i801 pcspkr i2c_core microc=
ode
> i7core_edac edac_core [last unloaded: ipt_addrtype]
> Pid: 12935, comm: rmmod Not tainted 2.6.36-rc2+ #1
> Call Trace:
> =A0[<ffffffff81043a26>] warn_slowpath_common+0x80/0x98
> =A0[<ffffffff81043ad2>] warn_slowpath_fmt+0x41/0x43
> =A0[<ffffffff8140744b>] ? _raw_spin_unlock+0x45/0x52
> =A0[<ffffffff811357fe>] remove_proc_entry+0xf3/0x26d
> =A0[<ffffffff8106a5fb>] ? mark_held_locks+0x52/0x70
> =A0[<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
> =A0[<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
> =A0[<ffffffff81405a03>] ? __mutex_unlock_slowpath+0x114/0x149
> =A0[<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
> =A0[<ffffffffa034ab20>] smb2_proc_clean+0x20/0xc8 [smb2]
> =A0[<ffffffffa03537e3>] exit_smb2+0x27/0x86 [smb2]
> =A0[<ffffffff8107375b>] sys_delete_module+0x1aa/0x20e
> =A0[<ffffffff81407bf9>] ? retint_swapgs+0x13/0x1b
> =A0[<ffffffff8106a87b>] ? trace_hardirqs_on_caller+0x111/0x135
> =A0[<ffffffff8108e299>] ? audit_syscall_entry+0x119/0x145
> =A0[<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
> ---[ end trace 8d1d6075190420c5 ]---

Yes - known problem introduced by some code cleanup



--=20
Thanks,

Steve
