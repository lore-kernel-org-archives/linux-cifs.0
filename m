From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH 10/14] cifs: add ability to send an echo request
Date: Sat, 27 Nov 2010 08:01:22 -0500
Message-ID: <1290862886-2914-11-git-send-email-jlayton@redhat.com>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290862886-2914-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifspdu.h   |   15 +++++++++++++++
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/cifssmb.c   |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 0 deletions(-)

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
index 280e356..f351cf3 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -358,6 +358,7 @@ extern int CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 			const __u64 len, struct file_lock *,
 			const __u16 lock_type, const bool waitFlag);
 extern int CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon);
+extern int CIFSSMBEcho(struct TCP_Server_Info *server);
 extern int CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses);
 
 extern struct cifsSesInfo *sesInfoAlloc(void);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0ef7c3a..bcaa4ac 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -709,6 +709,53 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon)
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
-- 
1.7.3.2
