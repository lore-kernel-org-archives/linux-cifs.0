From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v4 3/3] CIFS: Add direct I/O functions to file_operations
Date: Wed, 31 Oct 2018 22:13:11 +0000
Message-ID: <20181031221311.2596-3-longli@linuxonhyperv.com>
References: <20181031221311.2596-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181031221311.2596-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

With direct read/write functions implemented, add them to file_operations.

Dircet I/O is used under two conditions:
1. When mounting with "cache=none", CIFS uses direct I/O for all user file
data transfer.
2. When opening a file with O_DIRECT, CIFS uses direct I/O for all data
transfer on this file.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsfs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 62f1662..f18091b 100644
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
@@ -1169,9 +1168,8 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 };
 
 const struct file_operations cifs_file_direct_nobrl_ops = {
-	/* BB reevaluate whether they can be done with directio, no cache */
-	.read_iter = cifs_user_readv,
-	.write_iter = cifs_user_writev,
+	.read_iter = cifs_direct_readv,
+	.write_iter = cifs_direct_writev,
 	.open = cifs_open,
 	.release = cifs_close,
 	.fsync = cifs_fsync,
-- 
2.7.4
