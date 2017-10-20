From: shuwang@redhat.com
Subject: [PATCH] SMB: fix memory leak in smb3_validate_negotiate
Date: Fri, 20 Oct 2017 18:20:33 +0800
Message-ID: <20171020102033.22936-1-shuwang@redhat.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, chuhu@redhat.com, yizhan@redhat.com,
        Shu Wang <shuwang@redhat.com>
To: sfrench@samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Shu Wang <shuwang@redhat.com>

Found the issue by kmemleak. The pointer pneg_rsp stores the
pointer kmalloced from SMB2_ioctl, and should be release
before function return.

unreferenced object 0xffff88018c2b1900 (size 32):
  backtrace:
    kmemleak_alloc+0x4a/0xa0
    __kmalloc+0xec/0x220
    SMB2_ioctl+0x27a/0x3c0 [cifs]
    smb3_validate_negotiate+0x135/0x370 [cifs]
    SMB2_tcon+0x308/0xae0 [cifs]
    cifs_put_tcp_session+0x4a5/0x900 [cifs]
    cifs_mount+0x6f4/0x15f0 [cifs]

Signed-off-by: Shu Wang <shuwang@redhat.com>
---
 fs/cifs/smb2pdu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6f0e6343c15e..4785ed8e1589 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -727,8 +727,10 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 			 rsplen);
 
 		/* relax check since Mac returns max bufsize allowed on ioctl */
-		if (rsplen > CIFSMaxBufSize)
+		if (rsplen > CIFSMaxBufSize) {
+			kfree(pneg_rsp);
 			return -EIO;
+		}
 	}
 
 	/* check validate negotiate info response matches what we got earlier */
@@ -747,10 +749,12 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	/* validate negotiate successful */
 	cifs_dbg(FYI, "validate negotiate info successful\n");
+	kfree(pneg_rsp);
 	return 0;
 
 vneg_out:
 	cifs_dbg(VFS, "protocol revalidation - security settings mismatch\n");
+	kfree(pneg_rsp);
 	return -EIO;
 }
 
-- 
2.13.5
