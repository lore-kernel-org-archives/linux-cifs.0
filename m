From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: clean up checks in cifs_echo_request
Date: Wed,  9 Feb 2011 12:01:42 -0500
Message-ID: <1297270902-16876-1-git-send-email-jlayton@redhat.com>
References: <20110209070041.5d0ca858@tlielax.poochiereds.net>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110209070041.5d0ca858-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Follow-on patch to 7e90d705 which is already in Steve's tree...

The check for tcpStatus == CifsGood is not meaningful since it doesn't
indicate whether the NEGOTIATE request has been done. Also, clarify
why we're checking for maxBuf == 0.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 10011e9..161f24c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -338,10 +338,11 @@ cifs_echo_request(struct work_struct *work)
 					struct TCP_Server_Info, echo.work);
 
 	/*
-	 * We cannot send an echo until the NEGOTIATE_PROTOCOL request is done.
-	 * Also, no need to ping if we got a response recently
+	 * We cannot send an echo until the NEGOTIATE_PROTOCOL request is
+	 * done, which is indicated by maxBuf != 0. Also, no need to ping if
+	 * we got a response recently
 	 */
-	if ((server->tcpStatus != CifsGood) || (server->maxBuf == 0) ||
+	if (server->maxBuf == 0 ||
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
-- 
1.7.4
