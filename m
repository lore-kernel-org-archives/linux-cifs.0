From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] [cifs] smb2 mounts with signing fail due to incorrect security mode bits check
Date: Wed, 26 Jun 2013 15:47:19 -0500
Message-ID: <1372279639-31426-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This happens in for-next branch.

sign enable and sign required bits are different in smb and smb2
negprot response so a mount with sec=xi option fails for smb2.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifssmb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a35aad2..46f2ec1 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -407,8 +407,10 @@ decode_ext_sec_blob(struct cifs_ses *ses, NEGOTIATE_RSP *pSMBr)
 int
 cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 {
-	bool srv_sign_required = server->sec_mode & SECMODE_SIGN_REQUIRED;
-	bool srv_sign_enabled = server->sec_mode & SECMODE_SIGN_ENABLED;
+	bool srv_sign_required = server->sec_mode & SECMODE_SIGN_REQUIRED ||
+		server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	bool srv_sign_enabled = server->sec_mode & SECMODE_SIGN_ENABLED ||
+		server->sec_mode & SMB2_NEGOTIATE_SIGNING_ENABLED;
 	bool mnt_sign_enabled = global_secflags & CIFSSEC_MAY_SIGN;
 
 	/*
-- 
1.7.12.4
