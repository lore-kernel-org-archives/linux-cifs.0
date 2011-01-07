From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: cFYI the entire error code in map_smb_to_linux_error
Date: Fri,  7 Jan 2011 11:32:03 -0500
Message-ID: <1294417923-4622-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We currently only print the DOS error part.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/netmisc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 9aad47a..6783ce6 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -899,8 +899,8 @@ map_smb_to_linux_error(struct smb_hdr *smb, int logErr)
 	}
 	/* else ERRHRD class errors or junk  - return EIO */
 
-	cFYI(1, "Mapping smb error code %d to POSIX err %d",
-		 smberrcode, rc);
+	cFYI(1, "Mapping smb error code 0x%x to POSIX err %d",
+		 le32_to_cpu(smb->Status.CifsError), rc);
 
 	/* generic corrective action e.g. reconnect SMB session on
 	 * ERRbaduid could be added */
-- 
1.7.3.4
