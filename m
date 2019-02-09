From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 3.18 4/4] cifs: Limit memory used by lock request calls to a page
Date: Sat,  9 Feb 2019 13:50:14 -0500
Message-ID: <20190209185014.127264-4-sashal@kernel.org>
References: <20190209185014.127264-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Ross Lagerwall <ross.lagerwall@citrix.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190209185014.127264-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 92a8109e4d3a34fb6b115c9098b51767dc933444 ]

The code tries to allocate a contiguous buffer with a size supplied by
the server (maxBuf). This could fail if memory is fragmented since it
results in high order allocations for commonly used server
implementations. It is also wasteful since there are probably
few locks in the usual case. Limit the buffer to be no larger than a
page to avoid memory allocation failures due to fragmentation.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c     | 8 ++++++++
 fs/cifs/smb2file.c | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 338c92620d07..5dd8165a5429 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1075,6 +1075,10 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 		return -EINVAL;
 	}
 
+	BUILD_BUG_ON(sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE) >
+		     PAGE_SIZE);
+	max_buf = min_t(unsigned int, max_buf - sizeof(struct smb_hdr),
+			PAGE_SIZE);
 	max_num = (max_buf - sizeof(struct smb_hdr)) /
 						sizeof(LOCKING_ANDX_RANGE);
 	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
@@ -1410,6 +1414,10 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	if (max_buf < (sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE)))
 		return -EINVAL;
 
+	BUILD_BUG_ON(sizeof(struct smb_hdr) + sizeof(LOCKING_ANDX_RANGE) >
+		     PAGE_SIZE);
+	max_buf = min_t(unsigned int, max_buf - sizeof(struct smb_hdr),
+			PAGE_SIZE);
 	max_num = (max_buf - sizeof(struct smb_hdr)) /
 						sizeof(LOCKING_ANDX_RANGE);
 	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index fabeaa0ff1bf..df7f4515c63d 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -110,6 +110,8 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 	if (max_buf < sizeof(struct smb2_lock_element))
 		return -EINVAL;
 
+	BUILD_BUG_ON(sizeof(struct smb2_lock_element) > PAGE_SIZE);
+	max_buf = min_t(unsigned int, max_buf, PAGE_SIZE);
 	max_num = max_buf / sizeof(struct smb2_lock_element);
 	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf)
@@ -246,6 +248,8 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 		return -EINVAL;
 	}
 
+	BUILD_BUG_ON(sizeof(struct smb2_lock_element) > PAGE_SIZE);
+	max_buf = min_t(unsigned int, max_buf, PAGE_SIZE);
 	max_num = max_buf / sizeof(struct smb2_lock_element);
 	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf) {
-- 
2.19.1
