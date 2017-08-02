From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 36/37] [CIFS] Read from SMBD transport when it's used
Date: Wed,  2 Aug 2017 13:10:47 -0700
Message-ID: <1501704648-20159-37-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When receiving data, upper layer looks at which transport is being used. If SMBD is used, read from SMBD.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cc58cd8..5ac8af0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -584,6 +584,10 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 {
 	struct msghdr smb_msg;
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
+
+       if (server->rdma_ses)
+               return cifs_rdma_read(server->rdma_ses, buf, to_read);
+
 	iov_iter_kvec(&smb_msg.msg_iter, READ | ITER_KVEC, &iov, 1, to_read);
 
 	return cifs_readv_from_socket(server, &smb_msg);
@@ -595,6 +599,10 @@ cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 {
 	struct msghdr smb_msg;
 	struct bio_vec bv = {.bv_page = page, .bv_len = to_read};
+
+       if (server->rdma_ses)
+               return cifs_rdma_read_page(server->rdma_ses, page, to_read);
+
 	iov_iter_bvec(&smb_msg.msg_iter, READ | ITER_BVEC, &bv, 1, to_read);
 	return cifs_readv_from_socket(server, &smb_msg);
 }
-- 
2.7.4
