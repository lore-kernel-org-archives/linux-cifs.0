From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: remove checks for ses->status == CifsExiting
Date: Mon,  7 Feb 2011 08:54:35 -0500
Message-ID: <1297086876-19165-2-git-send-email-jlayton@redhat.com>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297086876-19165-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ses->status is never set to CifsExiting, so these checks are
always false.

Tested-by: JG <jg-9fI4heB6ewM@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 46c66ed..904aa47 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -136,9 +136,6 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
 		}
 	}
 
-	if (ses->status == CifsExiting)
-		return -EIO;
-
 	/*
 	 * Give demultiplex thread up to 10 seconds to reconnect, should be
 	 * greater than cifs socket timeout which is 7 seconds
@@ -156,7 +153,7 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
 		 * retrying until process is killed or server comes
 		 * back on-line
 		 */
-		if (!tcon->retry || ses->status == CifsExiting) {
+		if (!tcon->retry) {
 			cFYI(1, "gave up waiting on reconnect in smb_init");
 			return -EHOSTDOWN;
 		}
-- 
1.7.4
