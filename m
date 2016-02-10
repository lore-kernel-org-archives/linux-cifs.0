From: Anton Protopopov <a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: fix erroneous return value
Date: Wed, 10 Feb 2016 12:50:21 -0500
Message-ID: <1455126621-28052-1-git-send-email-a.s.protopopov@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Anton Protopopov <a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The setup_ntlmv2_rsp() function may return positive value ENOMEM instead
of -ENOMEM in case of kmalloc failure.

Signed-off-by: Anton Protopopov <a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index afa09fc..e682b36 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -714,7 +714,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 
 	ses->auth_key.response = kmalloc(baselen + tilen, GFP_KERNEL);
 	if (!ses->auth_key.response) {
-		rc = ENOMEM;
+		rc = -ENOMEM;
 		ses->auth_key.len = 0;
 		goto setup_ntlmv2_rsp_ret;
 	}
-- 
2.6.5
