From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/3] cifs.upcall: use krb5_auth_con_init() to create an explicit auth_context
Date: Tue, 28 Dec 2010 09:41:32 +0100
Message-ID: <1293525693-11562-3-git-send-email-metze@samba.org>
References: <1293525693-11562-1-git-send-email-metze@samba.org>
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293525693-11562-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

metze
---
 cifs.upcall.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 9116e56..d895ccd 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -299,14 +299,24 @@ cifs_krb5_get_req(const char *principal, const char *ccname,
 		goto out_free_principal;
 	}
 
-	apreq_pkt.data = NULL;
 	in_data.length = 0;
+	in_data.data = NULL;
+
+	ret = krb5_auth_con_init(context, &auth_context);
+	if (ret) {
+		syslog(LOG_DEBUG, "%s: unable to create auth_context: %d",
+		       __func__, ret);
+		goto out_free_creds;
+	}
+
+	apreq_pkt.length = 0;
+	apreq_pkt.data = NULL;
 	ret = krb5_mk_req_extended(context, &auth_context, AP_OPTS_USE_SUBKEY,
 				   &in_data, out_creds, &apreq_pkt);
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to make AP-REQ for %s",
 		       __func__, principal);
-		goto out_free_creds;
+		goto out_free_auth;
 	}
 
 	ret = krb5_auth_con_getsendsubkey(context, auth_context, &tokb);
-- 
1.7.0.4
