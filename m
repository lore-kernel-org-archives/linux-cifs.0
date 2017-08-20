From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 16/19] CIFS: SMBD: Read correct returned data length for RDMA write (SMB READ) I/O
Date: Sun, 20 Aug 2017 12:04:40 -0700
Message-ID: <1503255883-3041-17-git-send-email-longli@exchange.microsoft.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When RDMA write is used for SMB READ, the returned data length is returned in DataRemaining in the response packet. Reading it properly by adding a parameter to specifiy where the returned data length is.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsglob.h | 10 ++++++++--
 fs/cifs/cifssmb.c  |  4 ++--
 fs/cifs/smb1ops.c  |  2 +-
 fs/cifs/smb2ops.c  |  8 ++++++--
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dcd2b63..d391767 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -231,8 +231,14 @@ struct smb_version_operations {
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
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index fbb0d4c..9030fb5 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1523,8 +1523,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		 rdata->iov[0].iov_base, server->total_read);
 
 	/* how much data is in the response? */
-	data_len = server->ops->read_data_length(buf);
-	if (data_offset + data_len > buflen) {
+	data_len = server->ops->read_data_length(buf, rdata->mr);
+	if (!rdata->mr && (data_offset + data_len > buflen)) {
 		/* data_len is corrupt -- discard frame */
 		rdata->result = -EIO;
 		return cifs_readv_discard(server, mid);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index a723df3..27a8280 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -87,7 +87,7 @@ cifs_read_data_offset(char *buf)
 }
 
 static unsigned int
-cifs_read_data_length(char *buf)
+cifs_read_data_length(char *buf, bool in_remaining)
 {
 	READ_RSP *rsp = (READ_RSP *)buf;
 	return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e67f5f0..4067629 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -747,9 +747,13 @@ smb2_read_data_offset(char *buf)
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
 
@@ -2181,7 +2185,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	}
 
 	data_offset = server->ops->read_data_offset(buf) + 4;
-	data_len = server->ops->read_data_length(buf);
+	data_len = server->ops->read_data_length(buf, rdata->mr);
 
 	if (data_offset < server->vals->read_rsp_size) {
 		/*
-- 
2.7.4
