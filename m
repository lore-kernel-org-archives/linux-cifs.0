From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 29/45] CIFS: Add writepage support for SMB2
Date: Wed, 18 Jul 2012 19:48:45 +0400
Message-ID: <1342626541-29872-30-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c   |   12 ++++++++++
 fs/cifs/smb2pdu.c   |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    2 +
 3 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4dca13d..82852fc 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -395,6 +395,17 @@ smb2_sync_read(const unsigned int xid, struct cifsFileInfo *cfile,
 	return SMB2_read(xid, parms, bytes_read, buf, buf_type);
 }
 
+static int
+smb2_sync_write(const unsigned int xid, struct cifsFileInfo *cfile,
+		struct cifs_io_parms *parms, unsigned int *written,
+		struct kvec *iov, unsigned long nr_segs)
+{
+
+	parms->persistent_fid = cfile->fid.persistent_fid;
+	parms->volatile_fid = cfile->fid.volatile_fid;
+	return SMB2_write(xid, parms, written, iov, nr_segs);
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -438,6 +449,7 @@ struct smb_version_operations smb21_operations = {
 	.async_readv = smb2_async_readv,
 	.async_writev = smb2_async_writev,
 	.sync_read = smb2_sync_read,
+	.sync_write = smb2_sync_write,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 15b9b08..cb7d672 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1500,3 +1500,64 @@ async_writev_out:
 	kfree(iov);
 	return rc;
 }
+
+/*
+ * SMB2_write function gets iov pointer to kvec array with n_vec as a length.
+ * The length field from io_parms must be at least 1 and indicates a number of
+ * elements with data to write that begins with position 1 in iov array. All
+ * data length is specified by count.
+ */
+int
+SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
+	   unsigned int *nbytes, struct kvec *iov, int n_vec)
+{
+	int rc = 0;
+	struct smb2_write_req *req = NULL;
+	struct smb2_write_rsp *rsp = NULL;
+	int resp_buftype;
+	*nbytes = 0;
+
+	if (n_vec < 1)
+		return rc;
+
+	rc = small_smb2_init(SMB2_WRITE, io_parms->tcon, (void **) &req);
+	if (rc)
+		return rc;
+
+	if (io_parms->tcon->ses->server == NULL)
+		return -ECONNABORTED;
+
+	req->hdr.ProcessId = cpu_to_le32(io_parms->pid);
+
+	req->PersistentFileId = io_parms->persistent_fid;
+	req->VolatileFileId = io_parms->volatile_fid;
+	req->WriteChannelInfoOffset = 0;
+	req->WriteChannelInfoLength = 0;
+	req->Channel = 0;
+	req->Length = cpu_to_le32(io_parms->length);
+	req->Offset = cpu_to_le64(io_parms->offset);
+	/* 4 for rfc1002 length field */
+	req->DataOffset = cpu_to_le16(
+				offsetof(struct smb2_write_req, Buffer) - 4);
+	req->RemainingBytes = 0;
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for rfc1002 length field and 1 for Buffer */
+	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+
+	/* length of entire message including data to be written */
+	inc_rfc1001_len(req, io_parms->length - 1 /* Buffer */);
+
+	rc = SendReceive2(xid, io_parms->tcon->ses, iov, n_vec + 1,
+			  &resp_buftype, 0);
+
+	if (rc) {
+		cifs_stats_fail_inc(io_parms->tcon, SMB2_WRITE_HE);
+		cERROR(1, "Send error in write = %d", rc);
+	} else {
+		rsp = (struct smb2_write_rsp *)iov[0].iov_base;
+		*nbytes = le32_to_cpu(rsp->DataLength);
+		free_rsp_buf(resp_buftype, rsp);
+	}
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 97e62f3..192d0c7 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -101,6 +101,8 @@ extern int smb2_async_readv(struct cifs_readdata *rdata);
 extern int SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 		     unsigned int *nbytes, char **buf, int *buf_type);
 extern int smb2_async_writev(struct cifs_writedata *wdata);
+extern int SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
+		      unsigned int *nbytes, struct kvec *iov, int n_vec);
 extern int SMB2_echo(struct TCP_Server_Info *server);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
