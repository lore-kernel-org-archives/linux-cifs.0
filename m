From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Suspend failed - unable to freeze cifsd
Date: Thu, 13 Jan 2011 14:01:10 -0500
Message-ID: <20110113140110.26a33f2f@barsoom.rdu.redhat.com>
References: <20110112103422.53368ef0@pluto-lenny.milky.way>
	<20110112114904.34efd9d1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Benjamin S." <da_joind-hi6Y0CQ0nG0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110112114904.34efd9d1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 12 Jan 2011 11:49:04 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, 12 Jan 2011 10:34:22 +0100
> "Benjamin S." <da_joind-hi6Y0CQ0nG0@public.gmane.org> wrote:
> 
> > 
> > 
> > dmesg Output after I have tried to suspend my computer:
> > 
> > [334447.728980] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [334447.729525] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [334447.729571] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [334447.729979] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [334447.730806] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [334447.730853] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [334447.730918] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [334447.734428] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [334447.734465] [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> > [347809.421490] PM: Syncing filesystems ... done.
> > [347809.647465] Freezing user space processes ... (elapsed 0.01 seconds) done.
> > [347809.663090] Freezing remaining freezable tasks ...
> > [347829.678854] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
> > [347829.678873] cifsd         S ffff880127f7b1b0     0  1821      2 0x00800000
> > [347829.678883]  ffff880127f7b1b0 0000000000000046 ffff88005fe008a8 ffff8800ffffffff
> > [347829.678890]  ffff880127cee6b0 0000000000011100 ffff880127737fd8 0000000000004000
> > [347829.678897]  ffff880127737fd8 0000000000011100 ffff880127f7b1b0 ffff880127736010
> > [347829.678904] Call Trace:
> > [347829.678915]  [<ffffffff811e85dd>] ? sk_reset_timer+0xf/0x19
> > [347829.678921]  [<ffffffff8122cf3f>] ? tcp_connect+0x43c/0x445
> > [347829.678928]  [<ffffffff8123374e>] ? tcp_v4_connect+0x40d/0x47f
> > [347829.678935]  [<ffffffff8126ce41>] ? schedule_timeout+0x21/0x1ad
> > [347829.678942]  [<ffffffff8126e358>] ? _raw_spin_lock_bh+0x9/0x1f
> > [347829.678947]  [<ffffffff811e81c7>] ? release_sock+0x19/0xef
> > [347829.678953]  [<ffffffff8123e8be>] ? inet_stream_connect+0x14c/0x24a
> > [347829.678961]  [<ffffffff8104485b>] ? autoremove_wake_function+0x0/0x2a
> > [347829.678986]  [<ffffffffa02ccfe2>] ? ipv4_connect+0x39c/0x3b5 [cifs]
> > [347829.678991]  [<ffffffffa02cd7b7>] ? cifs_reconnect+0x1fc/0x28a [cifs]
> > [347829.678999]  [<ffffffffa02cdbdc>] ? cifs_demultiplex_thread+0x397/0xb9f [cifs]
> > [347829.679003]  [<ffffffff81076afc>] ? perf_event_exit_task+0xb9/0x1bf
> > [347829.679007]  [<ffffffffa02cd845>] ? cifs_demultiplex_thread+0x0/0xb9f [cifs]
> > [347829.679012]  [<ffffffffa02cd845>] ? cifs_demultiplex_thread+0x0/0xb9f [cifs]
> > [347829.679014]  [<ffffffff810444a1>] ? kthread+0x7a/0x82
> > [347829.679018]  [<ffffffff81002d14>] ? kernel_thread_helper+0x4/0x10
> > [347829.679020]  [<ffffffff81044427>] ? kthread+0x0/0x82
> > [347829.679022]  [<ffffffff81002d10>] ? kernel_thread_helper+0x0/0x10
> > [347829.679036]
> > [347829.679037] Restarting tasks ... done.
> > [347829.679862] video LNXVIDEO:00: Restoring backlight state
> > 
> > 
> > client :
> > ii  cifs-utils        2:4.5-2         Common Internet File System utilities
> > ii  samba             2:3.4.8~dfsg-2  SMB/CIFS file, print, and login server for Unix
> > ii  samba-common      2:3.4.8~dfsg-2  common files used by both the Samba server and client
> > ii  samba-common-bin  2:3.4.8~dfsg-2  common files used by both the Samba server and client
> > 
> > shares are mounted with mount.cifs
> > 
> > 
> > server:
> > ii  samba             2:3.5.6~dfsg-3  SMB/CIFS file, print, and login server for Unix
> > ii  samba-common      2:3.5.6~dfsg-3  common files used by both the Samba server and client
> > ii  samba-common-bin  2:3.5.6~dfsg-3  common files used by both the Samba server and client
> > 
> > 
> > I tried to suspend multiple times, but every time I got the same 
> > stack trace. Before I tried to suspend I thought the shares are
> > responding slower than they normally do.
> > 
> 
> Looks like it's stuck down in the TCP connect routines. I suspect that
> it takes longer than 20s for a connect attempt to time out and the task
> is stuck sleeping for longer than that.
> 
> The problem is likely similar to this bug:
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=11050
> 
> There are a set of patches waiting to be merged for 2.6.38 that change
> the timeout and reconnect behavior with CIFS that may paper over the
> problem.
> 
> Other than that, I'm not sure what we can do as cifsd is blocked
> waiting for the connection to complete. cifsd unfortunately was
> designed to work similarly to a userspace thread, and can't easily take
> advantage of the socket callback routines to do a non-blocking connect.
> 

Benjamin, would you be able to test this patch? It should apply to the
current mainline tree. It builds cleanly, but I haven't tested it yet...

---------------[snip]-----------------
[PATCH] cifs: set socket send and receive timeouts before attempting connect

Benjamin S. reported that he was unable to suspend his machine while
it had a cifs share mounted. The freezer caused this to spew when he
tried it:

-----------------------[snip]------------------
[347809.421490] PM: Syncing filesystems ... done.
[347809.647465] Freezing user space processes ... (elapsed 0.01 seconds)
done.
[347809.663090] Freezing remaining freezable tasks ...
[347829.678854] Freezing of tasks failed after 20.01 seconds (1 tasks
refusing to freeze, wq_busy=0):
[347829.678873] cifsd         S ffff880127f7b1b0     0  1821      2
0x00800000
[347829.678883]  ffff880127f7b1b0 0000000000000046 ffff88005fe008a8
ffff8800ffffffff
[347829.678890]  ffff880127cee6b0 0000000000011100 ffff880127737fd8
0000000000004000
[347829.678897]  ffff880127737fd8 0000000000011100 ffff880127f7b1b0
ffff880127736010
[347829.678904] Call Trace:
[347829.678915]  [<ffffffff811e85dd>] ? sk_reset_timer+0xf/0x19
[347829.678921]  [<ffffffff8122cf3f>] ? tcp_connect+0x43c/0x445
[347829.678928]  [<ffffffff8123374e>] ? tcp_v4_connect+0x40d/0x47f
[347829.678935]  [<ffffffff8126ce41>] ? schedule_timeout+0x21/0x1ad
[347829.678942]  [<ffffffff8126e358>] ? _raw_spin_lock_bh+0x9/0x1f
[347829.678947]  [<ffffffff811e81c7>] ? release_sock+0x19/0xef
[347829.678953]  [<ffffffff8123e8be>] ? inet_stream_connect+0x14c/0x24a
[347829.678961]  [<ffffffff8104485b>] ? autoremove_wake_function+0x0/0x2a
[347829.678986]  [<ffffffffa02ccfe2>] ? ipv4_connect+0x39c/0x3b5 [cifs]
[347829.678991]  [<ffffffffa02cd7b7>] ? cifs_reconnect+0x1fc/0x28a [cifs]
[347829.678999]  [<ffffffffa02cdbdc>] ? cifs_demultiplex_thread+0x397/0xb9f
[cifs]
[347829.679003]  [<ffffffff81076afc>] ? perf_event_exit_task+0xb9/0x1bf
[347829.679007]  [<ffffffffa02cd845>] ? cifs_demultiplex_thread+0x0/0xb9f
[cifs]
[347829.679012]  [<ffffffffa02cd845>] ? cifs_demultiplex_thread+0x0/0xb9f
[cifs]
[347829.679014]  [<ffffffff810444a1>] ? kthread+0x7a/0x82
[347829.679018]  [<ffffffff81002d14>] ? kernel_thread_helper+0x4/0x10
[347829.679020]  [<ffffffff81044427>] ? kthread+0x0/0x82
[347829.679022]  [<ffffffff81002d10>] ? kernel_thread_helper+0x0/0x10
[347829.679036]
[347829.679037] Restarting tasks ... done.
-----------------------[snip]------------------

We do attempt to perform a try_to_freeze in cifs_reconnect, but the
connection attempt itself seems to be taking longer than 20s to time
out. The connect timeout is governed by the socket send and receive
timeouts, so we can shorten that period by setting those timeouts
before attempting the connect instead of after.

Reported-by: Benjamin S <da_joind-hi6Y0CQ0nG0@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
tried it:
---
 fs/cifs/connect.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 99a5f18..32c2f55 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2290,14 +2290,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	if (rc < 0)
 		return rc;
 
-	rc = socket->ops->connect(socket, saddr, slen, 0);
-	if (rc < 0) {
-		cFYI(1, "Error %d connecting to server", rc);
-		sock_release(socket);
-		server->ssocket = NULL;
-		return rc;
-	}
-
 	/*
 	 * Eventually check for other socket options to change from
 	 * the default. sock_setsockopt not used because it expects
@@ -2326,6 +2318,14 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		 socket->sk->sk_sndbuf,
 		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
 
+	rc = socket->ops->connect(socket, saddr, slen, 0);
+	if (rc < 0) {
+		cFYI(1, "Error %d connecting to server", rc);
+		sock_release(socket);
+		server->ssocket = NULL;
+		return rc;
+	}
+
 	if (sport == htons(RFC1001_PORT))
 		rc = ip_rfc1001_connect(server);
 
-- 
1.7.3.4
