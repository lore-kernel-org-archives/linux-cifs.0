From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v3 15/19] CIFS: SMBD: Add parameter rdata to smb2_new_read_req
Date: Tue, 29 Aug 2017 12:29:11 -0700
Message-ID: <20170829192915.26251-16-longli@exchange.microsoft.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170829192915.26251-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When we assemble the SMB read packet header, we need to know the I/O layout
if this request is to use a RDMA write. rdata has all the information we need
for memory registration. Add rdata to smb2_new_read_req.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5551053..fbad987 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2363,18 +2363,21 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
  */
 static int
 smb2_new_read_req(void **buf, unsigned int *total_len,
-		  struct cifs_io_parms *io_parms, unsigned int remaining_bytes,
-		  int request_type)
+	struct cifs_io_parms *io_parms, struct cifs_readdata *rdata,
+	unsigned int remaining_bytes, int request_type)
 {
 	int rc = -EACCES;
 	struct smb2_read_plain_req *req = NULL;
 	struct smb2_sync_hdr *shdr;
+	struct TCP_Server_Info *server;
 
 	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, (void **) &req,
 				 total_len);
 	if (rc)
 		return rc;
-	if (io_parms->tcon->ses->server == NULL)
+
+	server = io_parms->tcon->ses->server;
+	if (server == NULL)
 		return -ECONNABORTED;
 
 	shdr = &req->sync_hdr;
@@ -2502,7 +2505,8 @@ smb2_async_readv(struct cifs_readdata *rdata)
 
 	server = io_parms.tcon->ses->server;
 
-	rc = smb2_new_read_req((void **) &buf, &total_len, &io_parms, 0, 0);
+	rc = smb2_new_read_req(
+		(void **) &buf, &total_len, &io_parms, rdata, 0, 0);
 	if (rc) {
 		if (rc == -EAGAIN && rdata->credits) {
 			/* credits was reset by reconnect */
@@ -2570,7 +2574,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	struct cifs_ses *ses = io_parms->tcon->ses;
 
 	*nbytes = 0;
-	rc = smb2_new_read_req((void **)&req, &total_len, io_parms, 0, 0);
+	rc = smb2_new_read_req((void **)&req, &total_len, io_parms, NULL, 0, 0);
 	if (rc)
 		return rc;
 
-- 
2.7.4
