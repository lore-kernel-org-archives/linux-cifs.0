From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: oops with 2.1 client code
Date: Tue, 18 Sep 2012 15:18:42 -0700
Message-ID: <20120918151842.66d3ef0a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

So I had a SMB2.1 share mounted (isilon server) on a KVM VM. I
suspended my laptop for an hour and went to a talk, and then came back
and tried to access the mount and couldn't (stupid error on my part,
forgot to plug in the network cable). I then decided to unmount the
share and got the following oops:

[75594.865377] BUG: unable to handle kernel NULL pointer dereference at 0000000000000045
[75594.866267] IP: [<ffffffffa02b7723>] SendReceive2+0xe3/0x360 [cifs]
[75594.866267] PGD 0 
[75594.866267] Oops: 0002 [#1] SMP 
[75594.866267] Modules linked in: cifs(O)(U) arc4 md4 nls_utf8 dns_resolver fscache ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_state nf_conntrack ip6_tables snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer microcode virtio_net i2c_piix4 virtio_balloon snd soundcore xfs cirrus drm_kms_helper ttm virtio_blk drm i2c_core [last unloaded: cifs]
[75594.866267] CPU 3 
[75594.866267] Pid: 5724, comm: umount Tainted: G           O 3.6.0-0.rc6.git0.2.fc18.x86_64 #1 Bochs Bochs
[75594.866267] RIP: 0010:[<ffffffffa02b7723>]  [<ffffffffa02b7723>] SendReceive2+0xe3/0x360 [cifs]
[75594.866267] RSP: 0018:ffff880026f3fcb8  EFLAGS: 00010246
[75594.866267] RAX: fffffffffffffff5 RBX: ffff880026f3fd58 RCX: 0000000000000001
[75594.866267] RDX: ffff88001e2aae68 RSI: 0000000000000001 RDI: ffffffffa02f72e0
[75594.866267] RBP: ffff880026f3fd38 R08: 0000000000000002 R09: 0000000000000000
[75594.866267] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000040
[75594.866267] R13: ffff880037212df0 R14: ffff880026f3fd54 R15: 0000000000000000
[75594.866267] FS:  00007fe3c5a3d840(0000) GS:ffff88003e400000(0000) knlGS:0000000000000000
[75594.866267] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[75594.866267] CR2: 0000000000000045 CR3: 0000000021133000 CR4: 00000000000006e0
[75594.866267] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[75594.866267] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[75594.866267] Process umount (pid: 5724, threadinfo ffff880026f3e000, task ffff8800356dcd00)
[75594.866267] Stack:
[75594.866267]  ffff880000000001 ffff880003e2a700 0000000000000000 ffffffffa02b4d1a
[75594.866267]  ffff880026f3fd68 ffff880026f3fd58 0000000000000001 0000000000000000
[75594.866267]  0000000000000000 0000000000000000 ffff880026f3fd58 ffff880037212df0
[75594.866267] Call Trace:
[75594.866267]  [<ffffffffa02b4d1a>] ? cifs_small_buf_get+0x1a/0x30 [cifs]
[75594.866267]  [<ffffffffa02b79d5>] SendReceiveNoRsp+0x35/0x40 [cifs]
[75594.866267]  [<ffffffffa02c77b4>] SMB2_logoff+0x74/0xc0 [cifs]
[75594.866267]  [<ffffffffa02a0a79>] cifs_put_smb_ses+0xe9/0x160 [cifs]
[75594.866267]  [<ffffffffa02a0bbc>] cifs_put_tcon+0xcc/0x140 [cifs]
[75594.866267]  [<ffffffffa02a2e24>] cifs_put_tlink+0x44/0x70 [cifs]
[75594.866267]  [<ffffffffa02a43ad>] cifs_umount+0x5d/0xc0 [cifs]
[75594.866267]  [<ffffffffa0292262>] cifs_kill_sb+0x22/0x30 [cifs]
[75594.866267]  [<ffffffff811d3db6>] ? deactivate_super+0x46/0x70
[75594.866267]  [<ffffffff811d3127>] deactivate_locked_super+0x57/0x90
[75594.866267]  [<ffffffff811d3dbe>] deactivate_super+0x4e/0x70
[75594.866267]  [<ffffffff811f23e7>] mntput_no_expire+0xd7/0x130
[75594.866267]  [<ffffffff811f3416>] sys_umount+0x76/0x390
[75594.866267]  [<ffffffff816e75e9>] system_call_fastpath+0x16/0x1b
[75594.866267] Code: bd c8 00 00 00 31 f6 89 4d 80 48 81 c7 80 02 00 00 e8 d2 2e 42 e1 49 8b 85 c8 00 00 00 48 8d 75 a8 4c 89 ef 48 8b 40 38 ff 50 10 <c7> 40 50 02 00 00 00 8b 4d 80 48 89 de 49 8b bd c8 00 00 00 48 
[75594.866267] RIP  [<ffffffffa02b7723>] SendReceive2+0xe3/0x360 [cifs]
[75594.866267]  RSP <ffff880026f3fcb8>
[75594.866267] CR2: 0000000000000045
[75595.054685] ---[ end trace 66e187b5db0827e0 ]---


....here's where it crashed -- not sure why the midQ was NULL at this
point:

(gdb) list *(SendReceive2+0xe3)
0x25753 is in SendReceive2 (fs/cifs/transport.c:707).
702			/* Update # of requests on wire to server */
703			add_credits(ses->server, 1, optype);
704			return rc;
705		}
706	
707		midQ->mid_state = MID_REQUEST_SUBMITTED;
708		cifs_in_send_inc(ses->server);
709		rc = smb_sendv(ses->server, iov, n_vec);
710		cifs_in_send_dec(ses->server);
711		cifs_save_when_sent(midQ);


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
