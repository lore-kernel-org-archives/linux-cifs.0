From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 7/8] CIFS: Delete an unnecessary variable initialisation in
 cifs_do_create()
Date: Sun, 20 Aug 2017 18:41:12 +0200
Message-ID: <fd13371d-c582-39b0-9ec7-dddf8cccf5ff@users.sourceforge.net>
References: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Aug 2017 17:20:36 +0200

The local variable "full_path" will be set to an appropriate pointer
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/cifs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 248aead1f3f4..69babcf4f653 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -227,7 +227,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	int desired_access;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_tcon *tcon = tlink_tcon(tlink);
-	char *full_path = NULL;
+	char *full_path;
 	FILE_ALL_INFO *buf = NULL;
 	struct inode *newinode = NULL;
 	int disposition;
-- 
2.14.0
