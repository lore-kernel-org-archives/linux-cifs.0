From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: [PATCH] CIFS: Fix memory leaks in SMB2_open
Date: Sat, 24 May 2014 16:42:02 +0400
Message-ID: <1400935322-5157-1-git-send-email-pshilovsky@samba.org>
Cc: stable@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Cc: <stable@vger.kernel.org> # v3.12+
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
---
 fs/cifs/smb2pdu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b0037b6..b0b260d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1097,6 +1097,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int rc = 0;
 	unsigned int num_iovecs = 2;
 	__u32 file_attributes = 0;
+	char *dhc_buf = NULL, *lc_buf = NULL;
 
 	cifs_dbg(FYI, "create/open\n");
 
@@ -1163,6 +1164,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			kfree(copy_path);
 			return rc;
 		}
+		lc_buf = iov[num_iovecs-1].iov_base;
 	}
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
@@ -1177,9 +1179,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		if (rc) {
 			cifs_small_buf_release(req);
 			kfree(copy_path);
-			kfree(iov[num_iovecs-1].iov_base);
+			kfree(lc_buf);
 			return rc;
 		}
+		dhc_buf = iov[num_iovecs-1].iov_base;
 	}
 
 	rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
@@ -1211,6 +1214,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		*oplock = rsp->OplockLevel;
 creat_exit:
 	kfree(copy_path);
+	kfree(lc_buf);
+	kfree(dhc_buf);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
-- 
1.7.10.4
