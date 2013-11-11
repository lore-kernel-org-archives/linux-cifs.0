From: Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 7/7] Cifs: Uncaching no-data page in readpage()
Date: Mon, 11 Nov 2013 23:27:29 +0800
Message-ID: <00261f7875c015f1a466ec69745d695efe43ac5d.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	Milosz Tanski <milosz@adfin.com>,
	Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Currently, if one page allocated into fscache in readpage(), however, with
no-data read, it is not uncached. This patch fixes this.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/cifs/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7ddddf2..153bc58 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3406,8 +3406,10 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 
 	rc = cifs_read(file, read_data, PAGE_CACHE_SIZE, poffset);
 
-	if (rc < 0)
+	if (rc < 0) {
+		cifs_fscache_readpage_cancel(file_inode(file), page);
 		goto io_error;
+	}
 	else
 		cifs_dbg(FYI, "Bytes read %d\n", rc);
 
-- 
1.7.9.5

