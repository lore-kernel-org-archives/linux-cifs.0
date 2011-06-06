From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Mon, 6 Jun 2011 10:37:50 -0500
Message-ID: <BANLkTi=62rqs9JZtSVW7KnTF7hZ9Zrq_nQ@mail.gmail.com>
References: <4DE5385C.1030808@candelatech.com>
	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>
	<4DE54561.1090906@candelatech.com>
	<20110531164408.178eeebf@tlielax.poochiereds.net>
	<BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>
	<4DE55537.5040705@candelatech.com>
	<BANLkTimNgW-Ff_50HeuFqmS7PXXjuLmYVw@mail.gmail.com>
	<20110601140139.079287da@tlielax.poochiereds.net>
	<4DE67FFE.3040907@candelatech.com>
	<20110601150621.7b465941@tlielax.poochiereds.net>
	<4DE69041.5070802@candelatech.com>
	<4DE94B97.8090302@candelatech.com>
	<20110603214204.318602e8@corrin.poochiereds.net>
	<4DE9BCAF.10303@candelatech.com>
	<20110604071923.777c666f@corrin.poochiereds.net>
	<20110606094547.0c04d1c5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110606094547.0c04d1c5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sounds promising.

Any others have thoughts about Jeff's proposed solution?

Ben,
If you get test data on this with and without patch - let us know.

On Mon, Jun 6, 2011 at 8:45 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sat, 4 Jun 2011 07:19:23 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Fri, 03 Jun 2011 22:03:43 -0700
>> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
>>
>> > On 06/03/2011 06:42 PM, Jeff Layton wrote:
>> > > On Fri, 03 Jun 2011 14:01:11 -0700
>> > > Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> =A0wrote:
>> > >
>> > >> Ok, we had some luck. =A0Here's the backtrace and attending dme=
sg
>> > >> output. =A0The filer has been doing failover, but it has not go=
ne
>> > >> into a failed state...so, the system *should* be able to reconn=
ect.
>> > >>
>> > >> We have the system in the failed state now and will leave it th=
at way
>> > >> for a bit in case you have some commands you'd like me to run.
>> > >>
>> > >> Aside from the hung cifs processes (anything accessing those mo=
unts
>> > >> gets into the D state), the system seems fine.
>> > >>
>> > >>
>> > >> CIFS VFS: Unexpected lookup error -112
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Unexpected lookup error -11
>> > >> CIFS VFS: Unexpected lookup error -112
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Unexpected lookup error -112
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Unexpected lookup error -11
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: Reconnecting tcp session
>> > >> CIFS VFS: need to reconnect in sendv here
>> > >> ------------[ cut here ]------------
>> > >> WARNING: at /home/greearb/git/linux-2.6.dev.38.y/fs/cifs/transp=
ort.c:137 smb_sendv+0x7a/0x2cf [cifs]()
>> > >> BUG: unable to handle kernel
>> > >> Hardware name: X8ST3
>> > >> NULL pointer dereference
>> > >> Modules linked in: at 0000000000000020
>> > >> =A0 =A0be2iscsi
>> > >> IP: iscsi_boot_sysfs [<ffffffff81356230>] __sock_recvmsg_nosec+=
0x12/0x6e
>> > >> =A0 =A0bnx2iPGD 0 =A0cnic
>> > >> =A0 =A0uio
>> > >> Oops: 0000 [#1] =A0cxgb3iPREEMPT =A0libcxgbiSMP =A0cxgb3
>> > >> =A0 =A0mdio
>> > >> last sysfs file: /sys/devices/platform/host10/session7/target10=
:0:0/10:0:0:0/block/sde/sde1/stat
>> > >> =A0 =A0ib_iserCPU 2 =A0rdma_cm
>> > >> Modules linked in: ib_cm be2iscsi iw_cm iscsi_boot_sysfs ib_sa =
bnx2i ib_mad cnic ib_core uio ib_addr cxgb3i md4 libcxgbi nls_utf8 cxgb=
3 cifs mdio xt_TPROXY
>> > >> ib_iser rdma_cm nf_tproxy_core ib_cm xt_socket iw_cm ib_sa ip6_=
tables ib_mad ib_core nf_defrag_ipv6 ib_addr md4 nls_utf8 xt_connlimit =
cifs xt_TPROXY
>> > >> nf_tproxy_core xt_socket ip6_tables nf_defrag_ipv6 xt_connlimit=
 8021q garp bridge stp llc fuse macvlan wanlink(P) pktgen iscsi_tcp lib=
iscsi_tcp libiscsi
>> > >> scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss sunr=
pc ipv6 uinput i2c_i801 e1000e 8021q i2c_core garp igb bridge ioatdma s=
tp iTCO_wdt llc
>> > >> i7core_edac fuse iTCO_vendor_support macvlan pcspkr wanlink(P) =
dca pktgen edac_core iscsi_tcp microcode [last unloaded: ipt_addrtype] =
libiscsi_tcp
>> > >> =A0 =A0libiscsi
>> > >> =A0 =A0scsi_transport_iscsi
>> > >> Pid: 5047, comm: cifsd Tainted: P =A0 =A0 =A0 =A0 =A0 =A02.6.38=
=2E8+ #12 nfs =A0lockdSupermicro X8ST3 fscache/X8ST3 nfs_acl
>> > >> =A0 =A0auth_rpcgss
>> > >> RIP: 0010:[<ffffffff81356230>] =A0[<ffffffff81356230>] __sock_r=
ecvmsg_nosec+0x12/0x6e
>> > >> =A0 =A0sunrpc
>> > >> RSP: 0018:ffff8802e64e5bc0 =A0EFLAGS: 00010286
>> > >> =A0 =A0ipv6
>> > >> RAX: 0000000000000000 RBX: ffff8802e64e5c40 RCX: 00000000000000=
04
>> > >> =A0 =A0uinput
>> > >> RDX: ffff8802e64e5e40 RSI: 0000000000000000 RDI: ffff8802e64e5c=
40
>> > >> =A0 =A0i2c_i801
>> > >> RBP: ffff8802e64e5bf0 R08: 0000000000000000 R09: 00000000000000=
00
>> > >> R10: ffff8802e64e5d80 R11: ffff8802e64e5e40 R12: ffff8802e64e5d=
10
>> > >> =A0 =A0e1000e
>> > >> R13: 0000000000000000 R14: ffff8802e64e5c40 R15: ffff8802e6429f=
80
>> > >> =A0 =A0i2c_core
>> > >> FS: =A00000000000000000(0000) GS:ffff8800df440000(0000) knlGS:0=
000000000000000
>> > >> =A0 =A0igb
>> > >> CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> > >> =A0 =A0ioatdma
>> > >> CR2: 0000000000000020 CR3: 0000000001803000 CR4: 00000000000006=
e0
>> > >> =A0 =A0iTCO_wdt
>> > >> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000000=
00
>> > >> =A0 =A0i7core_edac
>> > >> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000004=
00
>> > >> =A0 =A0iTCO_vendor_supportProcess cifsd (pid: 5047, threadinfo =
ffff8802e64e4000, task ffff88030482d880)
>> > >> =A0 =A0pcspkr
>> > >> Stack:
>> > >> =A0 =A0dca ffff8802e64e5c10 edac_core ffffffff81039b72 microcod=
e ffff880200000001 [last unloaded: ipt_addrtype] ffff880305a40fc8
>> > >>
>> > >> =A0 =A0ffff8802e64e5e40Pid: 4754, comm: btserver Tainted: P =A0=
 =A0 =A0 =A0 =A0 =A02.6.38.8+ #12
>> > >> =A0 =A00000000000000004Call Trace:
>> > >> =A0 =A0ffff8802e64e5c30 ffffffff8135792c
>> > >> =A0 =A00000000000000000 0000000000000000 [<ffffffff8104556a>] ?=
 warn_slowpath_common+0x80/0x98
>> > >> =A0 =A0ffff8802e64e5c40 ffffffffffffffff [<ffffffff81045597>] ?=
 warn_slowpath_null+0x15/0x17
>> > >>
>> > >> Call Trace:
>> > >> =A0 =A0[<ffffffffa0330a2c>] ? smb_sendv+0x7a/0x2cf [cifs]
>> > >> =A0 =A0[<ffffffff81039b72>] ? select_idle_sibling+0xec/0x127
>> > >> =A0 =A0[<ffffffff8135792c>] __sock_recvmsg+0x49/0x54
>> > >> =A0 =A0[<ffffffff81357e96>] sock_recvmsg+0xa6/0xbf
>> > >> =A0 =A0[<ffffffff8103fde4>] ? get_parent_ip+0x11/0x42
>> > >> =A0 =A0[<ffffffff81041ee4>] ? try_to_wake_up+0x1ad/0x1c8
>> > >> =A0 =A0[<ffffffff8103fde4>] ? get_parent_ip+0x11/0x42
>> > >> =A0 =A0[<ffffffff81041f0c>] ? default_wake_function+0xd/0xf
>> > >> =A0 =A0[<ffffffff8105c7e0>] ? autoremove_wake_function+0x11/0x3=
4
>> > >> =A0 =A0[<ffffffffa0330ca2>] ? smb_send+0x21/0x23 [cifs]
>> > >> =A0 =A0[<ffffffff8103fde4>] ? get_parent_ip+0x11/0x42
>> > >> =A0 =A0[<ffffffff814164ec>] ? sub_preempt_count+0x92/0xa5
>> > >> =A0 =A0[<ffffffffa03311d1>] ? SendReceive+0x13f/0x317 [cifs]
>> > >> =A0 =A0[<ffffffff814133f8>] ? _raw_spin_unlock_irqrestore+0x3a/=
0x47
>> > >> =A0 =A0[<ffffffff810382c6>] ? __wake_up+0x3f/0x48
>> > >> =A0 =A0[<ffffffffa031d839>] ? CIFSSMBNegotiate+0x191/0x766 [cif=
s]
>> > >> =A0 =A0[<ffffffff81357ee4>] kernel_recvmsg+0x35/0x41
>> > >> =A0 =A0[<ffffffff81412526>] ? __mutex_lock_common+0x358/0x3bc
>> > >> =A0 =A0[<ffffffffa0321d20>] cifs_demultiplex_thread+0x21e/0xcd9=
 [cifs]
>> > >> =A0 =A0[<ffffffffa031fd7b>] ? cifs_negotiate_protocol+0x37/0x87=
 [cifs]
>> > >> =A0 =A0[<ffffffff8103fde4>] ? get_parent_ip+0x11/0x42
>> > >> =A0 =A0[<ffffffff8141259e>] ? __mutex_lock_slowpath+0x14/0x16
>> > >> =A0 =A0[<ffffffff8103838e>] ? need_resched+0x1e/0x28
>> > >> =A0 =A0[<ffffffffa0315fed>] ? cifs_reconnect_tcon+0x19a/0x2c9 [=
cifs]
>> > >> =A0 =A0[<ffffffffa0321b02>] ? cifs_demultiplex_thread+0x0/0xcd9=
 [cifs]
>> > >> =A0 =A0[<ffffffff8105c7cf>] ? autoremove_wake_function+0x0/0x34
>> > >> =A0 =A0[<ffffffffa0321b02>] ? cifs_demultiplex_thread+0x0/0xcd9=
 [cifs]
>> > >> =A0 =A0[<ffffffff8105c3bf>] kthread+0x7d/0x85
>> > >> =A0 =A0[<ffffffffa031af96>] ? small_smb_init+0x27/0x70 [cifs]
>> > >> =A0 =A0[<ffffffff8100b8e4>] kernel_thread_helper+0x4/0x10
>> > >> =A0 =A0[<ffffffffa031c0ad>] ? CIFSSMBWrite2+0xa3/0x242 [cifs]
>> > >> =A0 =A0[<ffffffff8105c342>] ? kthread+0x0/0x85
>> > >> =A0 =A0[<ffffffff8100b8e0>] ? kernel_thread_helper+0x0/0x10
>> > >> =A0 =A0[<ffffffffa032a117>] ? cifs_writepages+0x461/0x714 [cifs=
]
>> > >> Code: 48 8b 4d d8 =A0[<ffffffff810ac1e8>] ? do_writepages+0x1f/=
0x28
>> > >> 48 8b =A0[<ffffffff810a4735>] ? __filemap_fdatawrite_range+0x4e=
/0x50
>> > >> 55 e0 48 =A0[<ffffffff810a4c3c>] ? filemap_fdatawrite+0x1a/0x1c
>> > >> 8b 75 =A0[<ffffffff810a4c56>] ? filemap_write_and_wait+0x18/0x3=
3
>> > >> e8 ff 90 =A0[<ffffffffa0326648>] ? cifs_flush+0x2d/0x60 [cifs]
>> > >> a8 00 =A0[<ffffffff810e901f>] ? filp_close+0x3e/0x6d
>> > >> 00 00 =A0[<ffffffff810e90f6>] ? sys_close+0xa8/0xe2
>> > >> 48 83 c4 =A0[<ffffffff8100aad2>] ? system_call_fastpath+0x16/0x=
1b
>> > >> 28 5b
>> > >> ---[ end trace 3387e7bab0a9c645 ]---
>> > >
>> > > Kaboom. So you're seeing oopses too. Could you get a listing of =
the
>> > > place where it oopsed by following the instructions here?
>> > >
>> > > http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Oopses
>> > >
>> > > I suspect that "sock" is NULL in this case too and it blew up in
>> > > kernel_recvmsg.
>> >
>> > I added code to WARN_ON when ssocket was null. =A0This isn't a rea=
l panic,
>> > just a WARN_ON:
>> >
>> >
>> > static int
>> > smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_=
vec)
>> > {
>> > =A0 =A0 int rc =3D 0;
>> > =A0 =A0 int i =3D 0;
>> > =A0 =A0 struct msghdr smb_msg;
>> > =A0 =A0 struct smb_hdr *smb_buffer =3D iov[0].iov_base;
>> > =A0 =A0 unsigned int len =3D iov[0].iov_len;
>> > =A0 =A0 unsigned int total_len;
>> > =A0 =A0 int first_vec =3D 0;
>> > =A0 =A0 unsigned int smb_buf_length =3D smb_buffer->smb_buf_length=
;
>> > =A0 =A0 struct socket *ssocket =3D server->ssocket;
>> >
>> > =A0 =A0 if (ssocket =3D=3D NULL) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "need to reconnect in sendv here=
");
>> > *** HERE *** =A0 =A0 =A0 =A0WARN_ON_ONCE(1);
>> > =A0 =A0 =A0 =A0 =A0 =A0 return -ENOTSOCK; /* BB eventually add rec=
onnect code here */
>> > =A0 =A0 }
>> >
>> > A second warn-on when ENOTSOCK is perculated up to the calling sta=
ck
>> > a bit causes the other stack dumpage. =A0I think the one above is =
root
>> > cause...need to figure out how to have it gracefully bail out and =
re-connect
>> > when it hits this state, as current code just calls this general l=
oop over
>> > and over again.
>> >
>>
>> No, your warning is there, but it's Oopsing too:
>>
>> > >> ------------[ cut here ]------------
>> > >> WARNING: at /home/greearb/git/linux-2.6.dev.38.y/fs/cifs/transp=
ort.c:137 smb_sendv+0x7a/0x2cf [cifs]()
>> > >> BUG: unable to handle kernel
>> > >> Hardware name: X8ST3
>> > >> NULL pointer dereference
>> > >> Modules linked in: at 0000000000000020
>> > >> =A0 =A0be2iscsi
>> > >> IP: iscsi_boot_sysfs [<ffffffff81356230>] __sock_recvmsg_nosec+=
0x12/0x6e
>>
>>
>> ...smb_sendv is called by the "send" side which is generally a
>> userspace process. The oops happened on the receive side. cifsd call=
ed
>> kernel_recvmsg, and it looks like it passed in a NULL sock pointer.
>>
>
> I suspect that the following (untested) patch will fix this. I think
> the symptoms that you've seen are consistent with the patch
> description. Ben, would you be able to test this in your setup? This
> should at least prevent the oopses.
>
> ------------------[snip]--------------------
>
> [PATCH] cifs: don't allow cifs_reconnect to exit with NULL socket =A0=
pointer
>
> It's possible for the following set of events to happen:
>
> cifsd calls cifs_reconnect which reconnects the socket. A userspace
> process then calls cifs_negotiate_protocol to handle the NEGOTIATE an=
d
> gets a reply. But, while processing the reply, cifsd calls
> cifs_reconnect again. =A0Eventually the GlobalMid_Lock is dropped and=
 the
> reply from the earlier NEGOTIATE completes and the tcpStatus is set t=
o
> CifsGood. cifs_reconnect then goes through and closes the socket and =
sets the
> pointer to zero, but because the status is now CifsGood, the new sock=
et
> is not created and cifs_reconnect exits with the socket pointer set t=
o
> NULL.
>
> Fix this by only setting the tcpStatus to CifsGood if the tcpStatus i=
s
> CifsNeedNegotiate, and by making sure that generic_ip_connect is alwa=
ys
> called at least once in cifs_reconnect.
>
> Note that this is not a perfect fix for this issue. It's still possib=
le
> that the NEGOTIATE reply is handled after the socket has been closed =
and
> reconnected. In that case, the socket state will look correct but it =
no
> NEGOTIATE was performed on it. In that situation though the server
> should just shut down the socket on the next attempted send, rather
> than causing the oops that occurs today.
>
> Reported-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 84c7307..8bb55bc 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -152,7 +152,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->callback(mid_entry);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 while (server->tcpStatus =3D=3D CifsNeedReconnect) {
> + =A0 =A0 =A0 do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0try_to_freeze();
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we should try only the port we conn=
ected to before */
> @@ -167,7 +167,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server=
->tcpStatus =3D CifsNeedNegotiate;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 } while (server->tcpStatus =3D=3D CifsNeedReconnect);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -3371,7 +3371,7 @@ int cifs_negotiate_protocol(unsigned int xid, s=
truct cifs_ses *ses)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (rc =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus !=3D CifsExiting)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsNeedNe=
gotiate)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->tcpStatus =3D =
CifsGood;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EHOSTDOWN;
> --
> 1.7.5.2
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
