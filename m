From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: set socket send and receive timeouts before attempting connect
Date: Thu,  9 Jun 2011 09:53:43 -0400
Message-ID: <1307627623-4794-1-git-send-email-jlayton@redhat.com>
Cc: awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, da_joind-hi6Y0CQ0nG0@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Benjamin S. reported that he was unable to suspend his machine while
it had a cifs share mounted. The freezer caused this to spew when he
tried it:

-----------------------[snip]------------------
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ...
Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
cifsd         S ffff880127f7b1b0     0  1821      2 0x00800000
 ffff880127f7b1b0 0000000000000046 ffff88005fe008a8 ffff8800ffffffff
 ffff880127cee6b0 0000000000011100 ffff880127737fd8 0000000000004000
 ffff880127737fd8 0000000000011100 ffff880127f7b1b0 ffff880127736010
Call Trace:
 [<ffffffff811e85dd>] ? sk_reset_timer+0xf/0x19
 [<ffffffff8122cf3f>] ? tcp_connect+0x43c/0x445
 [<ffffffff8123374e>] ? tcp_v4_connect+0x40d/0x47f
 [<ffffffff8126ce41>] ? schedule_timeout+0x21/0x1ad
 [<ffffffff8126e358>] ? _raw_spin_lock_bh+0x9/0x1f
 [<ffffffff811e81c7>] ? release_sock+0x19/0xef
 [<ffffffff8123e8be>] ? inet_stream_connect+0x14c/0x24a
 [<ffffffff8104485b>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffffa02ccfe2>] ? ipv4_connect+0x39c/0x3b5 [cifs]
 [<ffffffffa02cd7b7>] ? cifs_reconnect+0x1fc/0x28a [cifs]
 [<ffffffffa02cdbdc>] ? cifs_demultiplex_thread+0x397/0xb9f [cifs]
 [<ffffffff81076afc>] ? perf_event_exit_task+0xb9/0x1bf
 [<ffffffffa02cd845>] ? cifs_demultiplex_thread+0x0/0xb9f [cifs]
 [<ffffffffa02cd845>] ? cifs_demultiplex_thread+0x0/0xb9f [cifs]
 [<ffffffff810444a1>] ? kthread+0x7a/0x82
 [<ffffffff81002d14>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81044427>] ? kthread+0x0/0x82
 [<ffffffff81002d10>] ? kernel_thread_helper+0x0/0x10

Restarting tasks ... done.
-----------------------[snip]------------------

We do attempt to perform a try_to_freeze in cifs_reconnect, but the
connection attempt itself seems to be taking longer than 20s to time
out. The connect timeout is governed by the socket send and receive
timeouts, so we can shorten that period by setting those timeouts
before attempting the connect instead of after.

Adam Williamson tested the patch and said that it seems to have fixed
suspending on his laptop when a cifs share is mounted.

Reported-by: Benjamin S <da_joind-hi6Y0CQ0nG0@public.gmane.org>
Tested-by: Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 61ed0ba..4ec9630 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2471,14 +2471,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
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
@@ -2507,6 +2499,14 @@ generic_ip_connect(struct TCP_Server_Info *server)
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
1.7.5.2
