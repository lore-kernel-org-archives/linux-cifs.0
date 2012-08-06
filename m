From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 10/15] cifs: add deprecation warning to sockopt=TCP_NODELAY option
Date: Mon,  6 Aug 2012 07:31:07 -0400
Message-ID: <1344252672-15244-11-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we're using TCP_CORK on the socket, there's no value in
continuting to support this option. Schedule it for removal in 3.8.

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5210bc8..d0af8fb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1680,12 +1680,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (string == NULL)
 				goto out_nomem;
 
-			/*
-			 * FIXME: since we now cork/uncork the socket while
-			 * 	  sending, should we deprecate this option?
-			 */
-			if (strnicmp(string, "TCP_NODELAY", 11) == 0)
+			if (strnicmp(string, "TCP_NODELAY", 11) == 0) {
+				printk(KERN_WARNING "CIFS: the "
+					"sockopt=TCP_NODELAY option has been "
+					"deprecated and will be removed "
+					"in 3.8\n");
 				vol->sockopt_tcp_nodelay = 1;
+			}
 			break;
 		case Opt_netbiosname:
 			string = match_strdup(args);
-- 
1.7.11.2
