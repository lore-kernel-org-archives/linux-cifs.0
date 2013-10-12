From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2] cifs: Send a logoff request before removing a smb session
Date: Sat, 12 Oct 2013 10:06:03 -0500
Message-ID: <1381590363-4725-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Send a smb session logoff request before removing smb session off of the list.
On a signed smb session, remvoing a session off of the list before sending
a logoff request results in server returning an error for lack of
smb signature.

Never seen an error during smb logoff, so as per MS-SMB2 3.2.5.1,
not sure how an error during logoff should be retried. So for now,
if a server returns an error to a logoff request, log the error and
remove the session off of the list.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c       | 25 ++++++++++++++++++++-----
 fs/cifs/smb2transport.c | 10 ++++++++--
 fs/cifs/transport.c     | 11 +++++++++--
 3 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a279ffc..62a5514 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2242,6 +2242,8 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		if (ses->status == CifsExiting)
+			continue;
 		if (!match_session(ses, vol))
 			continue;
 		++ses->ses_count;
@@ -2255,24 +2257,37 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 static void
 cifs_put_smb_ses(struct cifs_ses *ses)
 {
-	unsigned int xid;
+	unsigned int rc, xid;
 	struct TCP_Server_Info *server = ses->server;
 
 	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
+
 	spin_lock(&cifs_tcp_ses_lock);
+	if (ses->status == CifsExiting) {
+		spin_unlock(&cifs_tcp_ses_lock);
+		return;
+	}
 	if (--ses->ses_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	}
-
-	list_del_init(&ses->smb_ses_list);
+	if (ses->status == CifsGood)
+		ses->status = CifsExiting;
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	if (ses->status == CifsGood && server->ops->logoff) {
+	if (ses->status == CifsExiting && server->ops->logoff) {
 		xid = get_xid();
-		server->ops->logoff(xid, ses);
+		rc = server->ops->logoff(xid, ses);
+		if (rc)
+			cifs_dbg(VFS, "%s: Session Logoff failure rc=%d\n",
+				__func__, rc);
 		_free_xid(xid);
 	}
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_del_init(&ses->smb_ses_list);
+	spin_unlock(&cifs_tcp_ses_lock);
+
 	sesInfoFree(ses);
 	cifs_put_tcp_session(server);
 }
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 340abca..ee1963b 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -516,13 +516,19 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
 		return -EAGAIN;
 	}
 
-	if (ses->status != CifsGood) {
-		/* check if SMB2 session is bad because we are setting it up */
+	if (ses->status == CifsNew) {
 		if ((buf->Command != SMB2_SESSION_SETUP) &&
 		    (buf->Command != SMB2_NEGOTIATE))
 			return -EAGAIN;
 		/* else ok - we are setting up session */
 	}
+
+	if (ses->status == CifsExiting) {
+		if (buf->Command != SMB2_LOGOFF)
+			return -EAGAIN;
+		/* else ok - we are shutting down the session */
+	}
+
 	*mid = smb2_mid_entry_alloc(buf, ses->server);
 	if (*mid == NULL)
 		return -ENOMEM;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 6fdcb1b..fc6e652 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -426,13 +426,20 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 		return -EAGAIN;
 	}
 
-	if (ses->status != CifsGood) {
-		/* check if SMB session is bad because we are setting it up */
+	if (ses->status == CifsNew) {
 		if ((in_buf->Command != SMB_COM_SESSION_SETUP_ANDX) &&
 			(in_buf->Command != SMB_COM_NEGOTIATE))
 			return -EAGAIN;
 		/* else ok - we are setting up session */
 	}
+
+	if (ses->status == CifsExiting) {
+		/* check if SMB session is bad because we are setting it up */
+		if (in_buf->Command != SMB_COM_LOGOFF_ANDX)
+			return -EAGAIN;
+		/* else ok - we are shutting down session */
+	}
+
 	*ppmidQ = AllocMidQEntry(in_buf, ses->server);
 	if (*ppmidQ == NULL)
 		return -ENOMEM;
-- 
1.8.1.2
