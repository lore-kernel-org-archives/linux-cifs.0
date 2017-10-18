From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v5 19/21] CIFS: SMBD: Read correct returned data length for RDMA write (SMB read) I/O
Date: Wed, 18 Oct 2017 16:09:18 -0700
Message-ID: <20171018230920.21042-20-longli@exchange.microsoft.com>
References: <20171018230920.21042-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171018230920.21042-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

This patch is for preparing upper layer doing SMB read via RDMA write.

When RDMA write is used for SMB read, the returned data length is in
DataRemaining in the response packet. Reading it properly by adding a
parameter to specifiy where the returned data length is.

Add the defition for memory registration to wdata and return the correct
length based on if RDMA write is used.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h | 13 +++++++++++--
 fs/cifs/cifssmb.c  |  7 ++++++-
 fs/cifs/smb1ops.c  |  6 +++++-
 fs/cifs/smb2ops.c  | 12 ++++++++++--
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2ae7d02..ddf83d8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -228,8 +228,14 @@ struct smb_version_operations {
 	__u64 (*get_next_mid)(struct TCP_Server_Info *);
 	/* data offset from read response message */
 	unsigned int (*read_data_offset)(char *);
-	/* data length from read response message */
-	unsigned int (*read_data_length)(char *);
+	/*
+	 * Data length from read response message
+	 * When in_remaining is true, the returned data length is in
+	 * message field DataRemaining for out-of-band data read (e.g through
+	 * Memory Registration RDMA write in SMBD).
+	 * Otherwise, the returned data length is in message field DataLength.
+	 */
+	unsigned int (*read_data_length)(char *, bool in_remaining);
 	/* map smb to linux error */
 	int (*map_error)(char *, bool);
 	/* find mid corresponding to the response message */
@@ -1148,6 +1154,9 @@ struct cifs_readdata {
 				struct cifs_readdata *rdata,
 				struct iov_iter *iter);
 	struct kvec			iov[2];
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	struct smbd_mr			*mr;
+#endif
 	unsigned int			pagesz;
 	unsigned int			tailsz;
 	unsigned int			credits;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 08ff56a..a343db4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1533,8 +1533,13 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		 rdata->iov[0].iov_base, server->total_read);
 
 	/* how much data is in the response? */
-	data_len = server->ops->read_data_length(buf);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	data_len = server->ops->read_data_length(buf, rdata->mr);
+	if (!rdata->mr && (data_offset + data_len > buflen)) {
+#else
+	data_len = server->ops->read_data_length(buf, false);
 	if (data_offset + data_len > buflen) {
+#endif
 		/* data_len is corrupt -- discard frame */
 		rdata->result = -EIO;
 		return cifs_readv_discard(server, mid);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index a723df3..b718bb8 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -87,9 +87,13 @@ cifs_read_data_offset(char *buf)
 }
 
 static unsigned int
-cifs_read_data_length(char *buf)
+cifs_read_data_length(char *buf, bool in_remaining)
 {
 	READ_RSP *rsp = (READ_RSP *)buf;
+	if (in_remaining) {
+		cifs_dbg(VFS, "Invalid SMB1 calling path, check code\n");
+		return 0;
+	}
 	return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
 	       le16_to_cpu(rsp->DataLength);
 }
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 25028da..1bbd248 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -938,9 +938,13 @@ smb2_read_data_offset(char *buf)
 }
 
 static unsigned int
-smb2_read_data_length(char *buf)
+smb2_read_data_length(char *buf, bool in_remaining)
 {
 	struct smb2_read_rsp *rsp = (struct smb2_read_rsp *)buf;
+
+	if (in_remaining)
+		return le32_to_cpu(rsp->DataRemaining);
+
 	return le32_to_cpu(rsp->DataLength);
 }
 
@@ -2449,7 +2453,11 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	}
 
 	data_offset = server->ops->read_data_offset(buf) + 4;
-	data_len = server->ops->read_data_length(buf);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	data_len = server->ops->read_data_length(buf, rdata->mr);
+#else
+	data_len = server->ops->read_data_length(buf, false);
+#endif
 
 	if (data_offset < server->vals->read_rsp_size) {
 		/*
-- 
2.7.4
