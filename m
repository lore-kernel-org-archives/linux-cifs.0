From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 15/15] CIFS: Add direct I/O functions to file_operations
Date: Wed, 30 May 2018 12:48:07 -0700
Message-ID: <20180530194807.31657-16-longli@linuxonhyperv.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

With direct read/write functions implemented, add them to file_operations.
When mounting with "cache=none", CIFS uses direct I/O.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 62f1662..e84f8c2 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1113,9 +1113,8 @@ const struct file_operations cifs_file_strict_ops = {
 };
 
 const struct file_operations cifs_file_direct_ops = {
-	/* BB reevaluate whether they can be done with directio, no cache */
-	.read_iter = cifs_user_readv,
-	.write_iter = cifs_user_writev,
+	.read_iter = cifs_direct_readv,
+	.write_iter = cifs_direct_writev,
 	.open = cifs_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
-- 
2.7.4
