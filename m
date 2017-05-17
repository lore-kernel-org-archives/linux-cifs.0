From: Colin King <colin.king@canonical.com>
Subject: [PATCH] CIFS: check if pages is null rather than bv for a failed allocation
Date: Wed, 17 May 2017 19:24:15 +0100
Message-ID: <20170517182415.12081-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

pages is being allocated however a null check on bv is being used
to see if the allocation failed. Fix this by checking if pages is
null.

Detected by CoverityScan, CID#1432974 ("Logically dead code")

Fixes: ccf7f4088af2dd ("CIFS: Add asynchronous context to support kernel AIO")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index b08531977daa..3b147dc6af63 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -810,7 +810,7 @@ setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw)
 
 	if (!pages) {
 		pages = vmalloc(max_pages * sizeof(struct page *));
-		if (!bv) {
+		if (!pages) {
 			kvfree(bv);
 			return -ENOMEM;
 		}
-- 
2.11.0
