From: Paulo Alcantara <paulo@paulo.ac>
Subject: [PATCH] cifs: Fix memory leak in smb2_set_ea()
Date: Wed,  4 Jul 2018 14:16:16 -0300
Message-ID: <20180704171616.17359-1-paulo@paulo.ac>
Cc: smfrench@gmail.com, Paulo Alcantara <paulo@paulo.ac>,
        Paulo Alcantara <palcantara@suse.de>, stable@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This patch fixes a memory leak when doing a setxattr(2) in SMB2+.

Signed-off-by: Paulo Alcantara <palcantara@suse.de>
Cc: stable@vger.kernel.org
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0356b5559c71..957ea2a5cf1d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -855,6 +855,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_set_ea(xid, tcon, fid.persistent_fid, fid.volatile_fid, ea,
 			 len);
+	kfree(ea);
+
 	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 
 	return rc;
-- 
2.18.0
