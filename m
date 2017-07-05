From: Colin King <colin.king@canonical.com>
Subject: [PATCH][cifs-next] cifs: set oparms.create_options rather than or'ing in CREATE_OPEN_BACKUP_INTENT
Date: Wed,  5 Jul 2017 13:47:34 +0100
Message-ID: <20170705124734.12816-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently oparms.create_options is uninitialized and the code is logically
or'ing in CREATE_OPEN_BACKUP_INTENT onto a garbage value of
oparms.create_options from the stack.  Fix this by just setting the value
rather than or'ing in the setting.

Detected by CoverityScan, CID#1447220 ("Unitialized scale value")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 941c40b7a870..c805b7619083 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1339,7 +1339,7 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 	xid = get_xid();
 
 	if (backup_cred(cifs_sb))
-		oparms.create_options |= CREATE_OPEN_BACKUP_INTENT;
+		oparms.create_options = CREATE_OPEN_BACKUP_INTENT;
 	else
 		oparms.create_options = 0;
 
-- 
2.11.0

