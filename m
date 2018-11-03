From: Colin King <colin.king@canonical.com>
Subject: [PATCH] cifs: clean up indentation, replace spaces with tab
Date: Sat,  3 Nov 2018 15:59:44 +0000
Message-ID: <20181103155944.3028-1-colin.king@canonical.com>
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

Trivial fix to clean up indentation, replace spaces with tab

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/cifsencrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 85b31cfa2f3c..ecdff344e8fe 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -224,7 +224,7 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 	if (cifs_pdu->Command == SMB_COM_LOCKING_ANDX) {
 		struct smb_com_lock_req *pSMB =
 			(struct smb_com_lock_req *)cifs_pdu;
-	    if (pSMB->LockType & LOCKING_ANDX_OPLOCK_RELEASE)
+		if (pSMB->LockType & LOCKING_ANDX_OPLOCK_RELEASE)
 			return 0;
 	}
 
-- 
2.19.1
