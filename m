From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 09/19] CIFS: SMBD: Read data from SMBDirect
Date: Sun, 20 Aug 2017 12:04:33 -0700
Message-ID: <1503255883-3041-10-git-send-email-longli@exchange.microsoft.com>
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

With SMBDirect connected, use it for receiving data via RDMA recv.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f65950f..9b0da7f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -584,6 +584,10 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 {
 	struct msghdr smb_msg;
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
+
+	if (server->smbd_conn)
+		return smbd_recv(server->smbd_conn, buf, to_read);
+
 	iov_iter_kvec(&smb_msg.msg_iter, READ | ITER_KVEC, &iov, 1, to_read);
 
 	return cifs_readv_from_socket(server, &smb_msg);
@@ -595,6 +599,10 @@ cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 {
 	struct msghdr smb_msg;
 	struct bio_vec bv = {.bv_page = page, .bv_len = to_read};
+
+	if (server->smbd_conn)
+		return smbd_recv_page(server->smbd_conn, page, to_read);
+
 	iov_iter_bvec(&smb_msg.msg_iter, READ | ITER_BVEC, &bv, 1, to_read);
 	return cifs_readv_from_socket(server, &smb_msg);
 }
-- 
2.7.4
