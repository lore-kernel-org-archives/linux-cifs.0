From: Colin King <colin.king@canonical.com>
Subject: [PATCH] cifs: fix memory leak of an allocated cifs_ntsd structure
Date: Mon,  7 Jan 2019 17:15:15 +0000
Message-ID: <20190107171515.4537-1-colin.king@canonical.com>
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

The call to SMB2_queary_acl can allocate memory to pntsd and also
return a failure via a call to SMB2_query_acl (and then query_info).
This occurs when query_info allocates the structure and then in
query_info the call to smb2_validate_and_copy_iov fails. Currently the
failure just returns without kfree'ing pntsd hence causing a memory
leak.  Fix this by kfree'ing pntsd before returning.

Detected by CoverityScan, CID#1457059 ("Resource Leak")

Fixes: 2f1afe25997f ("cifs: Use smb 2 - 3 and cifsacl mount options getacl functions")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/smb2ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index cf7eb891804f..6d71958ad2cb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2238,8 +2238,10 @@ get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
 	cifs_put_tlink(tlink);
 
 	cifs_dbg(FYI, "%s: rc = %d ACL len %d\n", __func__, rc, *pacllen);
-	if (rc)
+	if (rc) {
+		kfree(pntsd);
 		return ERR_PTR(rc);
+	}
 	return pntsd;
 
 }
-- 
2.19.1
