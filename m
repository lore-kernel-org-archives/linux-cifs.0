From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 1/2] SMB: fix leak of validate negotiate info response buffer
Date: Fri, 20 Oct 2017 14:49:37 +0200
Message-ID: <20171020124938.9913-2-ddiss@suse.de>
References: <20171020102033.22936-1-shuwang@redhat.com>
 <20171020124938.9913-1-ddiss@suse.de>
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020124938.9913-1-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixes: ff1c038addc4 ("Check SMB3 dialects against downgrade attacks")
Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6f0e6343c15e..052ab5dee6b6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -648,7 +648,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 {
 	int rc = 0;
 	struct validate_negotiate_info_req vneg_inbuf;
-	struct validate_negotiate_info_rsp *pneg_rsp;
+	struct validate_negotiate_info_rsp *pneg_rsp = NULL;
 	u32 rsplen;
 	u32 inbuflen; /* max of 4 dialects */
 
@@ -728,7 +728,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 		/* relax check since Mac returns max bufsize allowed on ioctl */
 		if (rsplen > CIFSMaxBufSize)
-			return -EIO;
+			goto err_rsp_free;
 	}
 
 	/* check validate negotiate info response matches what we got earlier */
@@ -747,10 +747,13 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	/* validate negotiate successful */
 	cifs_dbg(FYI, "validate negotiate info successful\n");
+	kfree(pneg_rsp);
 	return 0;
 
 vneg_out:
 	cifs_dbg(VFS, "protocol revalidation - security settings mismatch\n");
+err_rsp_free:
+	kfree(pneg_rsp);
 	return -EIO;
 }
 
-- 
2.13.6
