From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] CIFS: fix structurally dead code in smb311_posix_mkdir
Date: Thu, 21 Jun 2018 08:35:23 -0500
Message-ID: <20180621133523.GA30313@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Aurelien Aptel <aaptel@suse.com>, Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Code at line: 1950: rc = -EIO; is unreachable. Hence, the function
returns rc with a value of zero and, this is not the actual intention
of this particular piece of code.

Fix this by placing the goto instruction just after the update to rc.

Addresses-Coverity-ID: 1470124 ("Structurally dead code")
Fixes: 5539e9b24a38 ("CIFS: fix memory leak and remove dead code")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 062a2a5..c9489b1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1946,8 +1946,8 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	if (ses && (ses->server))
 		server = ses->server;
 	else {
-		goto err_free_path;
 		rc = -EIO;
+		goto err_free_path;
 	}
 
 	/* resource #2: request */
-- 
2.7.4
