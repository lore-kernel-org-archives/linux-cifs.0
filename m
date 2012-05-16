From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: SLUB cifs_request: kmem_cache_destroy called for cache that still
 has objects.
Date: Tue, 15 May 2012 20:46:42 -0400
Message-ID: <20120515204642.1a5bedee@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I saw this today when unplugging cifs.ko in a stock -rc7 kernel. I
never mounted any cifs mounts, so this is entirely due to module
initialization as far as I can tell:

[  464.776843] SLUB cifs_request: kmem_cache_destroy called for cache that still has objects.
[  464.779071] Pid: 4738, comm: rmmod Not tainted 3.4.0-0.rc7.git0.1.fc18.x86_64 #1
[  464.780243] Call Trace:
[  464.780433]  [<ffffffff8116b53a>] kmem_cache_destroy+0x2ba/0x360
[  464.780870]  [<ffffffffa00d6469>] cifs_destroy_request_bufs+0x21/0x3b [cifs]
[  464.781397]  [<ffffffffa00d66a6>] exit_cifs+0x30/0x98a [cifs]
[  464.781944]  [<ffffffff810b4a3e>] sys_delete_module+0x16e/0x2d0
[  464.782482]  [<ffffffff8117c186>] ? filp_close+0x66/0xa0
[  464.782903]  [<ffffffff81603769>] system_call_fastpath+0x16/0x1b

...any ideas?
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
