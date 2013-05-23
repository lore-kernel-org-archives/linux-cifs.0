From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/19] cifs: throw a warning if negotiate or sess_setup ops are passed NULL server or session pointers
Date: Thu, 23 May 2013 11:05:48 -0400
Message-ID: <1369321563-16893-5-git-send-email-jlayton@redhat.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

These look pretty cargo-culty to me, but let's be certain. Leave
them in place for now. Pop a WARN if it ever does happen. Also,
move to a more standard idiom for setting the "server" pointer.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c | 11 +++++------
 fs/cifs/sess.c    |  4 +++-
 fs/cifs/smb2pdu.c | 20 ++++++++------------
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a58dc77..c1c2006 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -375,16 +375,15 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	int rc = 0;
 	int bytes_returned;
 	int i;
-	struct TCP_Server_Info *server;
+	struct TCP_Server_Info *server = ses->server;
 	u16 count;
 	unsigned int secFlags;
 
-	if (ses->server)
-		server = ses->server;
-	else {
-		rc = -EIO;
-		return rc;
+	if (!server) {
+		WARN(1, "%s: server is NULL!\n", __func__);
+		return -EIO;
 	}
+
 	rc = smb_init(SMB_COM_NEGOTIATE, 0, NULL /* no tcon yet */ ,
 		      (void **) &pSMB, (void **) &pSMBr);
 	if (rc)
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 838e224..e8c5dc9 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -576,8 +576,10 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	u16 blob_len;
 	char *ntlmsspblob = NULL;
 
-	if (ses == NULL)
+	if (ses == NULL) {
+		WARN(1, "%s: ses == NULL!", __func__);
 		return -EINVAL;
+	}
 
 	type = ses->server->secType;
 	cifs_dbg(FYI, "sess setup type %d\n", type);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2b95ce2..3af66aa 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -328,7 +328,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	struct kvec iov[1];
 	int rc = 0;
 	int resp_buftype;
-	struct TCP_Server_Info *server;
+	struct TCP_Server_Info *server = ses->server;
 	unsigned int sec_flags;
 	u16 temp = 0;
 	int blob_offset, blob_length;
@@ -337,11 +337,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 
 	cifs_dbg(FYI, "Negotiate protocol\n");
 
-	if (ses->server)
-		server = ses->server;
-	else {
-		rc = -EIO;
-		return rc;
+	if (!server) {
+		WARN(1, "%s: server is NULL!\n", __func__);
+		return -EIO;
 	}
 
 	rc = small_smb2_init(SMB2_NEGOTIATE, NULL, (void **) &req);
@@ -480,7 +478,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	int rc = 0;
 	int resp_buftype;
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
-	struct TCP_Server_Info *server;
+	struct TCP_Server_Info *server = ses->server;
 	unsigned int sec_flags;
 	u8 temp = 0;
 	u16 blob_length = 0;
@@ -490,11 +488,9 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 
 	cifs_dbg(FYI, "Session Setup\n");
 
-	if (ses->server)
-		server = ses->server;
-	else {
-		rc = -EIO;
-		return rc;
+	if (!server) {
+		WARN(1, "%s: server is NULL!\n", __func__);
+		return -EIO;
 	}
 
 	/*
-- 
1.8.1.4
