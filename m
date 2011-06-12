From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: correctly handle NULL tcon pointer in CIFSTCon
Date: Sat, 11 Jun 2011 21:17:10 -0400
Message-ID: <1307841430-9876-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org, cmdkhh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Long ago (in commit 00e485b0), I added some code to handle share-level
passwords in CIFSTCon. That code ignored the fact that it's legit to
pass in a NULL tcon pointer when connecting to the IPC$ share on the
server.

This wasn't really a problem until recently as we only called CIFSTCon
this way when the server returned -EREMOTE. With the introduction of
commit c1508ca2 however, it gets called this way on every mount, causing
an oops when share-level security is in effect.

Fix this by simply treating a NULL tcon pointer as if user-level
security were in effect. I'm not aware of any servers that protect the
IPC$ share with a specific password anyway. Also, add a comment to the
top of CIFSTCon to ensure that we don't make the same mistake again.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7b6cad2..fa5a5d7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3174,6 +3174,10 @@ out:
 	return rc;
 }
 
+/*
+ * Issue a TREE_CONNECT request. Note that for IPC$ shares, that the tcon
+ * pointer may be NULL.
+ */
 int
 CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	 const char *tree, struct cifs_tcon *tcon,
@@ -3208,7 +3212,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	pSMB->AndXCommand = 0xFF;
 	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
 	bcc_ptr = &pSMB->Password[0];
-	if ((ses->server->sec_mode) & SECMODE_USER) {
+	if (!tcon || (ses->server->sec_mode & SECMODE_USER)) {
 		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
 		*bcc_ptr = 0; /* password is null byte */
 		bcc_ptr++;              /* skip password */
-- 
1.7.5.2
