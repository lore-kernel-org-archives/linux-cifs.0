From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 6/7] CIFS: Move protocol specific session setup/logoff code to ops struct
Date: Mon, 28 May 2012 13:30:13 +0400
Message-ID: <1338197414-22340-7-git-send-email-pshilovsky@samba.org>
References: <1338197414-22340-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338197414-22340-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    4 ++++
 fs/cifs/cifsproto.h |    4 ++--
 fs/cifs/connect.c   |    4 ++--
 fs/cifs/sess.c      |    3 +--
 fs/cifs/smb1ops.c   |    2 ++
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9152e31..a725d4a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -196,6 +196,10 @@ struct smb_version_operations {
 	bool (*need_neg)(struct TCP_Server_Info *);
 	/* negotiate to the server */
 	int (*negotiate)(int, struct cifs_ses *);
+	/* setup smb sessionn */
+	int (*sess_setup)(int, struct cifs_ses *, const struct nls_table *);
+	/* close smb session */
+	int (*logoff)(int, struct cifs_ses *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 41d5a76..ecb8b28 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -112,8 +112,8 @@ extern void header_assemble(struct smb_hdr *, char /* command */ ,
 extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				struct cifs_ses *ses,
 				void **request_buf);
-extern int CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
-			     const struct nls_table *nls_cp);
+extern int CIFS_SessSetup(int xid, struct cifs_ses *ses,
+			  const struct nls_table *nls_cp);
 extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
 extern u64 cifs_UnixTimeToNT(struct timespec);
 extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0b9351a..416e941 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2262,7 +2262,7 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 
 	if (ses->status == CifsGood) {
 		xid = GetXid();
-		CIFSSMBLogoff(xid, ses);
+		S_OPV(server, logoff, xid, ses);
 		_FreeXid(xid);
 	}
 	sesInfoFree(ses);
@@ -3978,7 +3978,7 @@ int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
 	cFYI(1, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
 		 server->sec_mode, server->capabilities, server->timeAdj);
 
-	rc = CIFS_SessSetup(xid, ses, nls_info);
+	rc = S_OP(server, sess_setup, -ENOSYS, xid, ses, nls_info);
 	if (rc) {
 		cERROR(1, "Send error in SessSetup = %d", rc);
 	} else {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index f88fa4d..382a96f 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -556,8 +556,7 @@ setup_ntlmv2_ret:
 }
 
 int
-CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
-	       const struct nls_table *nls_cp)
+CIFS_SessSetup(int xid, struct cifs_ses *ses, const struct nls_table *nls_cp)
 {
 	int rc = 0;
 	int wct;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 0ae208a..6fe8617 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -416,6 +416,8 @@ struct smb_version_operations smb1_operations = {
 	.check_trans2 = cifs_check_trans2,
 	.need_neg = cifs_need_neg,
 	.negotiate = cifs_negotiate,
+	.sess_setup = CIFS_SessSetup,
+	.logoff = CIFSSMBLogoff,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
