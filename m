From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 02/19] cifs: remove useless memset in LANMAN auth code
Date: Tue, 28 May 2013 08:11:43 -0400
Message-ID: <1369743120-18941-3-git-send-email-jlayton@redhat.com>
References: <1369743120-18941-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369743120-18941-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It turns out that CIFS_SESS_KEY_SIZE == CIFS_ENCPWD_SIZE, so this
memset doesn't do anything useful.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsencrypt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 71436d1..a85a83d 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -276,7 +276,6 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 		strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
 
 	if (!encrypt && global_secflags & CIFSSEC_MAY_PLNTXT) {
-		memset(lnm_session_key, 0, CIFS_SESS_KEY_SIZE);
 		memcpy(lnm_session_key, password_with_pad,
 			CIFS_ENCPWD_SIZE);
 		return 0;
-- 
1.8.1.4
