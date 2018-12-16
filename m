From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH] CIFS: use the correct length when pinning memory for direct I/O for write
Date: Sun, 16 Dec 2018 23:17:04 +0000
Message-ID: <20181216231704.16761-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Long Li <longli@microsoft.com>, stable@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

The current code attempts to pin memory using the largest possible wsize
based on the currect SMB credits. This doesn't cause kernel oops but this is
not optimal as we may pin more pages then actually needed.

Fix this by only pinning what are needed for doing this write I/O.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 3467351..c23bf9d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2617,11 +2617,13 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		if (rc)
 			break;
 
+		cur_len = min_t(const size_t, len, wsize);
+
 		if (ctx->direct_io) {
 			ssize_t result;
 
 			result = iov_iter_get_pages_alloc(
-				from, &pagevec, wsize, &start);
+				from, &pagevec, cur_len, &start);
 			if (result < 0) {
 				cifs_dbg(VFS,
 					"direct_writev couldn't get user pages "
-- 
2.7.4
