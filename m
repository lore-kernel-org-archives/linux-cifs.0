From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/18] cifs: add ability to send an echo request
Date: Fri, 17 Dec 2010 10:08:12 -0500
Message-ID: <1292598497-29796-14-git-send-email-jlayton@redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifspdu.h   |   15 +++++++++++++++
 fs/cifs/cifsproto.h |    2 ++
 fs/cifs/cifssmb.c   |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c |    2 +-
 4 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index de36b09..ea205b4 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -50,6 +50,7 @@
 #define SMB_COM_SETATTR               0x09 /* trivial response */
 #define SMB_COM_LOCKING_ANDX          0x24 /* trivial response */
 #define SMB_COM_COPY                  0x29 /* trivial rsp, fail filename ignrd*/
+#define SMB_COM_ECHO                  0x2B /* echo request */
 #define SMB_COM_OPEN_ANDX             0x2D /* Legacy open for old servers */
 #define SMB_COM_READ_ANDX             0x2E
 #define SMB_COM_WRITE_ANDX            0x2F
@@ -760,6 +761,20 @@ typedef struct smb_com_tconx_rsp_ext {
  *
  */
 
+typedef struct smb_com_echo_req {
+	struct	smb_hdr hdr;
+	__le16	EchoCount;
+	__le16	ByteCount;
+	char	Data[1];
+} __attribute__((packed)) ECHO_REQ;
+
+typedef struct smb_com_echo_rsp {
+	struct	smb_hdr hdr;
+	__le16	SequenceNumber;
+	__le16	ByteCount;
+	char	Data[1];
+} __attribute__((packed)) ECHO_RSP;
+
 typedef struct smb_com_logoff_andx_req {
 	struct smb_hdr hdr;	/* wct = 2 */
 	__u8 AndXCommand;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4d81f0e..3cd6474 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -63,6 +63,7 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
+extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int cifs_call_async(struct TCP_Server_Info *server,
 			   struct smb_hdr *in_buf, mid_callback_t *callback,
 			   void *cbdata);
@@ -352,6 +353,7 @@ extern int CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			const __u64 len, struct file_lock *,
 			const __u16 lock_type, const bool waitFlag);
 extern int CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon);
+extern int CIFSSMBEcho(struct TCP_Server_Info *server);
 extern int CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses);
 
 extern struct cifsSesInfo *sesInfoAlloc(void);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9af98f6..fc8145f 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -706,6 +706,53 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
 	return rc;
 }
 
+/*
+ * This is a no-op for now. We're not really interested in the reply, but
+ * rather in the fact that the server sent one and that server->lstrp
+ * gets updated.
+ *
+ * FIXME: maybe we should consider checking that the reply matches request?
+ */
+static void
+cifs_echo_callback(struct mid_q_entry *mid)
+{
+	struct TCP_Server_Info *server = mid->callback_data;
+
+	DeleteMidQEntry(mid);
+	atomic_dec(&server->inFlight);
+	wake_up(&server->request_q);
+}
+
+int
+CIFSSMBEcho(struct TCP_Server_Info *server)
+{
+	ECHO_REQ *smb;
+	int rc = 0;
+
+	cFYI(1, "In echo request");
+
+	rc = small_smb_init(SMB_COM_ECHO, 0, NULL, (void **)&smb);
+	if (rc)
+		return rc;
+
+	/* set up echo request */
+	smb->hdr.Tid = cpu_to_le16(0xffff);
+	smb->hdr.WordCount = cpu_to_le16(1);
+	smb->EchoCount = cpu_to_le16(1);
+	smb->ByteCount = cpu_to_le16(1);
+	smb->Data[0] = 'a';
+	smb->hdr.smb_buf_length += 3;
+
+	rc = cifs_call_async(server, (struct smb_hdr *)smb,
+				cifs_echo_callback, server);
+	if (rc)
+		cFYI(1, "Echo request failed: %d", rc);
+
+	cifs_small_buf_release(smb);
+
+	return rc;
+}
+
 int
 CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
 {
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index cf8c64d..db29f80 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -78,7 +78,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	return temp;
 }
 
-static void
+void
 DeleteMidQEntry(struct mid_q_entry *midEntry)
 {
 #ifdef CONFIG_CIFS_STATS2
-- 
1.7.3.3
