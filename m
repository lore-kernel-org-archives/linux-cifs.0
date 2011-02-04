From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: enable signing flag in SMB header when server has it on
Date: Fri,  4 Feb 2011 07:21:26 -0500
Message-ID: <1296822086-6377-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs_sign_smb only generates a signature if the correct Flags2 bit is
set. Make sure that it gets set correctly if we're sending an async
call.

This patch fixes:

    https://bugzilla.kernel.org/show_bug.cgi?id=28142

Reported-and-Tested-by: JG <jg-9fI4heB6ewM@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b8c5e2e..fbc5aac 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -359,6 +359,10 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
 	if (rc)
 		return rc;
 
+	/* enable signing if server requires it */
+	if (server->secMode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+		in_buf->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
+
 	mutex_lock(&server->srv_mutex);
 	mid = AllocMidQEntry(in_buf, server);
 	if (mid == NULL) {
-- 
1.7.3.4
