From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/3] cifs.upcall: fix memory and call krb5_auth_con_free()
Date: Tue, 28 Dec 2010 09:41:31 +0100
Message-ID: <1293525693-11562-2-git-send-email-metze@samba.org>
References: <1293525693-11562-1-git-send-email-metze@samba.org>
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293525693-11562-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

metze
---
 cifs.upcall.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 9b1436e..9116e56 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -313,13 +313,15 @@ cifs_krb5_get_req(const char *principal, const char *ccname,
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to get session key for %s",
 		       __func__, principal);
-		goto out_free_creds;
+		goto out_free_auth;
 	}
 
 	*mechtoken = data_blob(apreq_pkt.data, apreq_pkt.length);
 	*sess_key = data_blob(KRB5_KEY_DATA(tokb), KRB5_KEY_LENGTH(tokb));
 
 	krb5_free_keyblock(context, tokb);
+out_free_auth:
+	krb5_auth_con_free(context, auth_context);
 out_free_creds:
 	krb5_free_creds(context, out_creds);
 out_free_principal:
-- 
1.7.0.4
