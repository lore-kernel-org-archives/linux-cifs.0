From: Colin King <colin.king@canonical.com>
Subject: [PATCH] cifs: remove redundant duplicated assignment of pointer 'node'
Date: Wed, 17 Jan 2018 09:52:39 +0000
Message-ID: <20180117095239.10670-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Node is assigned twice to rb_first(root), first during declaration
time and second after a taking a spin lock, so we have a duplicated
assignment.  Remove the first assignment because it is redundant and
also not protected by the spin lock.

Cleans up clang warning:
fs/cifs/connect.c:4435:18: warning: Value stored to 'node' during
its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0efd22e75ac7..63c5d85fe25e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4432,7 +4432,7 @@ cifs_prune_tlinks(struct work_struct *work)
 	struct cifs_sb_info *cifs_sb = container_of(work, struct cifs_sb_info,
 						    prune_tlinks.work);
 	struct rb_root *root = &cifs_sb->tlink_tree;
-	struct rb_node *node = rb_first(root);
+	struct rb_node *node;
 	struct rb_node *tmp;
 	struct tcon_link *tlink;
 
-- 
2.15.1
