From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 04/32] CIFS: Move protocol specific session setup/logoff code to ops struct
Date: Fri, 13 Jul 2012 11:53:17 +0400
Message-ID: <1342166025-29377-5-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    5 +++++
 fs/cifs/cifsproto.h |   10 +++++-----
 fs/cifs/cifssmb.c   |    2 +-
 fs/cifs/connect.c   |   18 ++++++++++--------
 fs/cifs/sess.c      |    2 +-
 fs/cifs/smb1ops.c   |    2 ++
 6 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8a41505..a6eb9be 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -196,6 +196,11 @@ struct smb_version_operations {
 	bool (*need_neg)(struct TCP_Server_Info *);
 	/* negotiate to the server */
 	int (*negotiate)(const unsigned int, struct cifs_ses *);
+	/* setup smb sessionn */
+	int (*sess_setup)(const unsigned int, struct cifs_ses *,
+			  const struct nls_table *);
+	/* close smb session */
+	int (*logoff)(const unsigned int, struct cifs_ses *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 047b87e..a4360c5 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -112,8 +112,8 @@ extern void header_assemble(struct smb_hdr *, char /* command */ ,
 extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				struct cifs_ses *ses,
 				void **request_buf);
-extern int CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
-			     const struct nls_table *nls_cp);
+extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
+			  const struct nls_table *nls_cp);
 extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
 extern u64 cifs_UnixTimeToNT(struct timespec);
 extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
@@ -180,8 +180,8 @@ void cifs_proc_clean(void);
 
 extern int cifs_negotiate_protocol(const unsigned int xid,
 				   struct cifs_ses *ses);
-extern int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
-			struct nls_table *nls_info);
+extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
+			      struct nls_table *nls_info);
 extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
 
 extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
@@ -390,7 +390,7 @@ extern int CIFSSMBPosixLock(const int xid, struct cifs_tcon *tcon,
 			const __u16 lock_type, const bool waitFlag);
 extern int CIFSSMBTDis(const int xid, struct cifs_tcon *tcon);
 extern int CIFSSMBEcho(struct TCP_Server_Info *server);
-extern int CIFSSMBLogoff(const int xid, struct cifs_ses *ses);
+extern int CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses);
 
 extern struct cifs_ses *sesInfoAlloc(void);
 extern void sesInfoFree(struct cifs_ses *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 22a6d6b..db5cf5d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -781,7 +781,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 }
 
 int
-CIFSSMBLogoff(const int xid, struct cifs_ses *ses)
+CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses)
 {
 	LOGOFF_ANDX_REQ *pSMB;
 	int rc = 0;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 91b66b0..47e0491 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2252,7 +2252,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 static void
 cifs_put_smb_ses(struct cifs_ses *ses)
 {
-	int xid;
+	unsigned int xid;
 	struct TCP_Server_Info *server = ses->server;
 
 	cFYI(1, "%s: ses_count=%d\n", __func__, ses->ses_count);
@@ -2265,9 +2265,9 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 	list_del_init(&ses->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	if (ses->status == CifsGood) {
+	if (ses->status == CifsGood && server->ops->logoff) {
 		xid = GetXid();
-		CIFSSMBLogoff(xid, ses);
+		server->ops->logoff(xid, ses);
 		_FreeXid(xid);
 	}
 	sesInfoFree(ses);
@@ -3988,11 +3988,11 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses)
 	return rc;
 }
 
-
-int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
-			struct nls_table *nls_info)
+int
+cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
+		   struct nls_table *nls_info)
 {
-	int rc = 0;
+	int rc = -ENOSYS;
 	struct TCP_Server_Info *server = ses->server;
 
 	ses->flags = 0;
@@ -4003,7 +4003,9 @@ int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
 	cFYI(1, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
 		 server->sec_mode, server->capabilities, server->timeAdj);
 
-	rc = CIFS_SessSetup(xid, ses, nls_info);
+	if (server->ops->sess_setup)
+		rc = server->ops->sess_setup(xid, ses, nls_info);
+
 	if (rc) {
 		cERROR(1, "Send error in SessSetup = %d", rc);
 	} else {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index f88fa4d..e25b312 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -556,7 +556,7 @@ setup_ntlmv2_ret:
 }
 
 int
-CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
+CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	       const struct nls_table *nls_cp)
 {
 	int rc = 0;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index ea4fb8a..6b0a5d6 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -430,6 +430,8 @@ struct smb_version_operations smb1_operations = {
 	.check_trans2 = cifs_check_trans2,
 	.need_neg = cifs_need_neg,
 	.negotiate = cifs_negotiate,
+	.sess_setup = CIFS_SessSetup,
+	.logoff = CIFSSMBLogoff,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
