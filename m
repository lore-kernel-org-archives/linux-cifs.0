From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v3 04/19] CIFS: SMBD: Add SMBDirect transport to SMB connection and Makefile
Date: Tue, 29 Aug 2017 12:29:00 -0700
Message-ID: <20170829192915.26251-5-longli@exchange.microsoft.com>
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

Add SMBDirect as an optional connection to the SMB session structure in CIFS.
When SMB session is connected through SMBDirect, upper layer uses this
connection to carry payloads.

With the transport code hooked up to upper layer, add SMBDirect code to
Makefile.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/Makefile   | 2 +-
 fs/cifs/cifsglob.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index eed7eb0..6bb9863 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -18,4 +18,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
 cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
 
 cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o \
-			    smb2misc.o smb2pdu.o smb2inode.o smb2file.o
+			    smb2misc.o smb2pdu.o smb2inode.o smb2file.o smbdirect.o
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 703c2fb..dc5404d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -652,6 +652,8 @@ struct TCP_Server_Info {
 	bool	large_buf;		/* is current buffer large? */
 	/* use SMBD connection instead of socket */
 	bool	rdma;
+	/* point to the SMBD connection if RDMA is used instead of socket */
+	struct smbd_connection *smbd_conn;
 	struct delayed_work	echo; /* echo ping workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
-- 
2.7.4
