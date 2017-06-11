From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] CIFS: Fix some return values in case of error in 'crypt_message'
Date: Sun, 11 Jun 2017 09:12:47 +0200
Message-ID: <20170611071247.2038-1-christophe.jaillet@wanadoo.fr>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: sfrench@samba.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

'rc' is known to be 0 at this point. So if 'init_sg' or 'kzalloc' fails, we
should return -ENOMEM instead.

Also remove a useless 'rc' in a debug message as it is meaningless here.

Fixes: 026e93dc0a3ee ("CIFS: Encrypt SMB3 requests before sending")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/cifs/smb2ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c58691834eb2..cdcb3d95add8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1809,7 +1809,8 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 
 	sg = init_sg(rqst, sign);
 	if (!sg) {
-		cifs_dbg(VFS, "%s: Failed to init sg %d", __func__, rc);
+		cifs_dbg(VFS, "%s: Failed to init sg", __func__);
+		rc = -ENOMEM;
 		goto free_req;
 	}
 
@@ -1817,6 +1818,7 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 	iv = kzalloc(iv_len, GFP_KERNEL);
 	if (!iv) {
 		cifs_dbg(VFS, "%s: Failed to alloc IV", __func__);
+		rc = -ENOMEM;
 		goto free_sg;
 	}
 	iv[0] = 3;
-- 
2.11.0

