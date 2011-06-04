From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Fri, 03 Jun 2011 22:03:43 -0700
Message-ID: <4DE9BCAF.10303@candelatech.com>
References: <4DE5385C.1030808@candelatech.com>	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>	<4DE54561.1090906@candelatech.com>	<20110531164408.178eeebf@tlielax.poochiereds.net>	<BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>	<4DE55537.5040705@candelatech.com>	<BANLkTimNgW-Ff_50HeuFqmS7PXXjuLmYVw@mail.gmail.com>	<20110601140139.079287da@tlielax.poochiereds.net>	<4DE67FFE.3040907@candelatech.com>	<20110601150621.7b465941@tlielax.poochiereds.net>	<4DE69041.5070802@candelatech.com>	<4DE94B97.8090302@candelatech.com> <20110603214204.318602e8@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110603214204.318602e8-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/03/2011 06:42 PM, Jeff Layton wrote:
> On Fri, 03 Jun 2011 14:01:11 -0700
> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  wrote:
>
>> Ok, we had some luck.  Here's the backtrace and attending dmesg
>> output.  The filer has been doing failover, but it has not gone
>> into a failed state...so, the system *should* be able to reconnect.
>>
>> We have the system in the failed state now and will leave it that way
>> for a bit in case you have some commands you'd like me to run.
>>
>> Aside from the hung cifs processes (anything accessing those mounts
>> gets into the D state), the system seems fine.
>>
>>
>> CIFS VFS: Unexpected lookup error -112
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Unexpected lookup error -11
>> CIFS VFS: Unexpected lookup error -112
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Unexpected lookup error -112
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Unexpected lookup error -11
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: Reconnecting tcp session
>> CIFS VFS: need to reconnect in sendv here
>> ------------[ cut here ]------------
>> WARNING: at /home/greearb/git/linux-2.6.dev.38.y/fs/cifs/transport.c:137 smb_sendv+0x7a/0x2cf [cifs]()
>> BUG: unable to handle kernel
>> Hardware name: X8ST3
>> NULL pointer dereference
>> Modules linked in: at 0000000000000020
>>    be2iscsi
>> IP: iscsi_boot_sysfs [<ffffffff81356230>] __sock_recvmsg_nosec+0x12/0x6e
>>    bnx2iPGD 0  cnic
>>    uio
>> Oops: 0000 [#1]  cxgb3iPREEMPT  libcxgbiSMP  cxgb3
>>    mdio
>> last sysfs file: /sys/devices/platform/host10/session7/target10:0:0/10:0:0:0/block/sde/sde1/stat
>>    ib_iserCPU 2  rdma_cm
>> Modules linked in: ib_cm be2iscsi iw_cm iscsi_boot_sysfs ib_sa bnx2i ib_mad cnic ib_core uio ib_addr cxgb3i md4 libcxgbi nls_utf8 cxgb3 cifs mdio xt_TPROXY
>> ib_iser rdma_cm nf_tproxy_core ib_cm xt_socket iw_cm ib_sa ip6_tables ib_mad ib_core nf_defrag_ipv6 ib_addr md4 nls_utf8 xt_connlimit cifs xt_TPROXY
>> nf_tproxy_core xt_socket ip6_tables nf_defrag_ipv6 xt_connlimit 8021q garp bridge stp llc fuse macvlan wanlink(P) pktgen iscsi_tcp libiscsi_tcp libiscsi
>> scsi_transport_iscsi nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput i2c_i801 e1000e 8021q i2c_core garp igb bridge ioatdma stp iTCO_wdt llc
>> i7core_edac fuse iTCO_vendor_support macvlan pcspkr wanlink(P) dca pktgen edac_core iscsi_tcp microcode [last unloaded: ipt_addrtype] libiscsi_tcp
>>    libiscsi
>>    scsi_transport_iscsi
>> Pid: 5047, comm: cifsd Tainted: P            2.6.38.8+ #12 nfs  lockdSupermicro X8ST3 fscache/X8ST3 nfs_acl
>>    auth_rpcgss
>> RIP: 0010:[<ffffffff81356230>]  [<ffffffff81356230>] __sock_recvmsg_nosec+0x12/0x6e
>>    sunrpc
>> RSP: 0018:ffff8802e64e5bc0  EFLAGS: 00010286
>>    ipv6
>> RAX: 0000000000000000 RBX: ffff8802e64e5c40 RCX: 0000000000000004
>>    uinput
>> RDX: ffff8802e64e5e40 RSI: 0000000000000000 RDI: ffff8802e64e5c40
>>    i2c_i801
>> RBP: ffff8802e64e5bf0 R08: 0000000000000000 R09: 0000000000000000
>> R10: ffff8802e64e5d80 R11: ffff8802e64e5e40 R12: ffff8802e64e5d10
>>    e1000e
>> R13: 0000000000000000 R14: ffff8802e64e5c40 R15: ffff8802e6429f80
>>    i2c_core
>> FS:  0000000000000000(0000) GS:ffff8800df440000(0000) knlGS:0000000000000000
>>    igb
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>    ioatdma
>> CR2: 0000000000000020 CR3: 0000000001803000 CR4: 00000000000006e0
>>    iTCO_wdt
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>    i7core_edac
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>    iTCO_vendor_supportProcess cifsd (pid: 5047, threadinfo ffff8802e64e4000, task ffff88030482d880)
>>    pcspkr
>> Stack:
>>    dca ffff8802e64e5c10 edac_core ffffffff81039b72 microcode ffff880200000001 [last unloaded: ipt_addrtype] ffff880305a40fc8
>>
>>    ffff8802e64e5e40Pid: 4754, comm: btserver Tainted: P            2.6.38.8+ #12
>>    0000000000000004Call Trace:
>>    ffff8802e64e5c30 ffffffff8135792c
>>    0000000000000000 0000000000000000 [<ffffffff8104556a>] ? warn_slowpath_common+0x80/0x98
>>    ffff8802e64e5c40 ffffffffffffffff [<ffffffff81045597>] ? warn_slowpath_null+0x15/0x17
>>
>> Call Trace:
>>    [<ffffffffa0330a2c>] ? smb_sendv+0x7a/0x2cf [cifs]
>>    [<ffffffff81039b72>] ? select_idle_sibling+0xec/0x127
>>    [<ffffffff8135792c>] __sock_recvmsg+0x49/0x54
>>    [<ffffffff81357e96>] sock_recvmsg+0xa6/0xbf
>>    [<ffffffff8103fde4>] ? get_parent_ip+0x11/0x42
>>    [<ffffffff81041ee4>] ? try_to_wake_up+0x1ad/0x1c8
>>    [<ffffffff8103fde4>] ? get_parent_ip+0x11/0x42
>>    [<ffffffff81041f0c>] ? default_wake_function+0xd/0xf
>>    [<ffffffff8105c7e0>] ? autoremove_wake_function+0x11/0x34
>>    [<ffffffffa0330ca2>] ? smb_send+0x21/0x23 [cifs]
>>    [<ffffffff8103fde4>] ? get_parent_ip+0x11/0x42
>>    [<ffffffff814164ec>] ? sub_preempt_count+0x92/0xa5
>>    [<ffffffffa03311d1>] ? SendReceive+0x13f/0x317 [cifs]
>>    [<ffffffff814133f8>] ? _raw_spin_unlock_irqrestore+0x3a/0x47
>>    [<ffffffff810382c6>] ? __wake_up+0x3f/0x48
>>    [<ffffffffa031d839>] ? CIFSSMBNegotiate+0x191/0x766 [cifs]
>>    [<ffffffff81357ee4>] kernel_recvmsg+0x35/0x41
>>    [<ffffffff81412526>] ? __mutex_lock_common+0x358/0x3bc
>>    [<ffffffffa0321d20>] cifs_demultiplex_thread+0x21e/0xcd9 [cifs]
>>    [<ffffffffa031fd7b>] ? cifs_negotiate_protocol+0x37/0x87 [cifs]
>>    [<ffffffff8103fde4>] ? get_parent_ip+0x11/0x42
>>    [<ffffffff8141259e>] ? __mutex_lock_slowpath+0x14/0x16
>>    [<ffffffff8103838e>] ? need_resched+0x1e/0x28
>>    [<ffffffffa0315fed>] ? cifs_reconnect_tcon+0x19a/0x2c9 [cifs]
>>    [<ffffffffa0321b02>] ? cifs_demultiplex_thread+0x0/0xcd9 [cifs]
>>    [<ffffffff8105c7cf>] ? autoremove_wake_function+0x0/0x34
>>    [<ffffffffa0321b02>] ? cifs_demultiplex_thread+0x0/0xcd9 [cifs]
>>    [<ffffffff8105c3bf>] kthread+0x7d/0x85
>>    [<ffffffffa031af96>] ? small_smb_init+0x27/0x70 [cifs]
>>    [<ffffffff8100b8e4>] kernel_thread_helper+0x4/0x10
>>    [<ffffffffa031c0ad>] ? CIFSSMBWrite2+0xa3/0x242 [cifs]
>>    [<ffffffff8105c342>] ? kthread+0x0/0x85
>>    [<ffffffff8100b8e0>] ? kernel_thread_helper+0x0/0x10
>>    [<ffffffffa032a117>] ? cifs_writepages+0x461/0x714 [cifs]
>> Code: 48 8b 4d d8  [<ffffffff810ac1e8>] ? do_writepages+0x1f/0x28
>> 48 8b  [<ffffffff810a4735>] ? __filemap_fdatawrite_range+0x4e/0x50
>> 55 e0 48  [<ffffffff810a4c3c>] ? filemap_fdatawrite+0x1a/0x1c
>> 8b 75  [<ffffffff810a4c56>] ? filemap_write_and_wait+0x18/0x33
>> e8 ff 90  [<ffffffffa0326648>] ? cifs_flush+0x2d/0x60 [cifs]
>> a8 00  [<ffffffff810e901f>] ? filp_close+0x3e/0x6d
>> 00 00  [<ffffffff810e90f6>] ? sys_close+0xa8/0xe2
>> 48 83 c4  [<ffffffff8100aad2>] ? system_call_fastpath+0x16/0x1b
>> 28 5b
>> ---[ end trace 3387e7bab0a9c645 ]---
>
> Kaboom. So you're seeing oopses too. Could you get a listing of the
> place where it oopsed by following the instructions here?
>
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Oopses
>
> I suspect that "sock" is NULL in this case too and it blew up in
> kernel_recvmsg.

I added code to WARN_ON when ssocket was null.  This isn't a real panic,
just a WARN_ON:


static int
smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
{
	int rc = 0;
	int i = 0;
	struct msghdr smb_msg;
	struct smb_hdr *smb_buffer = iov[0].iov_base;
	unsigned int len = iov[0].iov_len;
	unsigned int total_len;
	int first_vec = 0;
	unsigned int smb_buf_length = smb_buffer->smb_buf_length;
	struct socket *ssocket = server->ssocket;

	if (ssocket == NULL) {
		cERROR(1, "need to reconnect in sendv here");
*** HERE ***	WARN_ON_ONCE(1);
  		return -ENOTSOCK; /* BB eventually add reconnect code here */
	}

A second warn-on when ENOTSOCK is perculated up to the calling stack
a bit causes the other stack dumpage.  I think the one above is root
cause...need to figure out how to have it gracefully bail out and re-connect
when it hits this state, as current code just calls this general loop over
and over again.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
