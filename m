From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: silence printk when establishing first session on socket
Date: Mon,  6 Jun 2011 15:40:23 -0400
Message-ID: <1307389223-25744-1-git-send-email-jlayton@redhat.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When signing is enabled, the first session that's established on a
socket will cause a printk like this to pop:

    CIFS VFS: Unexpected SMB signature

This is because the key exchange hasn't happened yet, so the signature
field is bogus. Don't try to check the signature on the socket until the
first session has been established. Also, eliminate the specific check
for SMB_COM_NEGOTIATE since this check covers that case too.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index dfbd9f1..5a0ee7f 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -184,7 +184,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 	if (cifs_pdu == NULL || server == NULL)
 		return -EINVAL;
 
-	if (cifs_pdu->Command == SMB_COM_NEGOTIATE)
+	if (!server->session_estab)
 		return 0;
 
 	if (cifs_pdu->Command == SMB_COM_LOCKING_ANDX) {
-- 
1.7.5.2
