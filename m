From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: lockdep pops with -rc5 kernel
Date: Tue, 1 May 2012 17:22:20 -0400
Message-ID: <20120501172220.4d34b839@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm still seeing this lockdep pop with -rc5 kernel. I thought Pavel had
fixed this, but maybe his patch hasn't been merged yet? Or am I
mistaken? In any case, it looks like it just needs some lockdep
annotation and we probably want this fixed before 3.4 ships...

[   55.218753] INFO: trying to register non-static key.
[   55.219396] the code is fine but needs lockdep annotation.
[   55.219396] turning off the locking correctness validator.
[   55.219396] Pid: 855, comm: mount.cifs Not tainted 3.4.0-rc5+ #15
[   55.219396] Call Trace:
[   55.219396]  [<ffffffff810cd7b6>] __lock_acquire+0x1306/0x1ad0
[   55.219396]  [<ffffffff810ccbe3>] ? __lock_acquire+0x733/0x1ad0
[   55.219396]  [<ffffffff810cf2ad>] ? trace_hardirqs_on+0xd/0x10
[   55.219396]  [<ffffffff8132ff8d>] ? pointer.isra.11+0x1fd/0x2d0
[   55.219396]  [<ffffffff810ce661>] lock_acquire+0xa1/0x1f0
[   55.219396]  [<ffffffffa00f96fe>] ? cifs_set_credits+0x2e/0x70 [cifs]
[   55.219396]  [<ffffffffa00e8ca0>] ? cifs_get_smb_ses+0x160/0x4c0 [cifs]
[   55.219396]  [<ffffffff816ad646>] _raw_spin_lock+0x46/0x80
[   55.219396]  [<ffffffffa00f96fe>] ? cifs_set_credits+0x2e/0x70 [cifs]
[   55.219396]  [<ffffffff816aa323>] ? mutex_lock_nested+0x2c3/0x390
[   55.219396]  [<ffffffffa00f96fe>] cifs_set_credits+0x2e/0x70 [cifs]
[   55.219396]  [<ffffffffa00e88ad>] cifs_negotiate_protocol+0x4d/0xe0 [cifs]
[   55.219396]  [<ffffffffa00e8cab>] cifs_get_smb_ses+0x16b/0x4c0 [cifs]
[   55.219396]  [<ffffffffa00e9099>] cifs_mount+0x99/0x6f0 [cifs]
[   55.219396]  [<ffffffffa00d6efc>] cifs_do_mount+0xac/0x4d0 [cifs]
[   55.219396]  [<ffffffff811c28b3>] mount_fs+0x43/0x1b0
[   55.219396]  [<ffffffff811df38f>] vfs_kern_mount+0x6f/0x100
[   55.219396]  [<ffffffff811dff14>] do_kern_mount+0x54/0x110
[   55.219396]  [<ffffffff811e177a>] do_mount+0x26a/0x840
[   55.219396]  [<ffffffff81155324>] ? __get_free_pages+0x14/0x50
[   55.219396]  [<ffffffff811e137a>] ? copy_mount_options+0x3a/0x180
[   55.219396]  [<ffffffff811e1e8d>] sys_mount+0x8d/0xe0
[   55.219396]  [<ffffffff816b6f29>] system_call_fastpath+0x16/0x1b

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
