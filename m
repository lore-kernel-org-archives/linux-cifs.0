From: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Subject: [PATCH] cifs: fix uninitialized variable warning
Date: Tue,  3 Aug 2010 15:18:10 -0400
Message-ID: <1280863090-636-1-git-send-email-wfp5p@virginia.edu>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

quiet the warning:
fs/cifs/cifssmb.c:3082: warning: 'pdata' may be used uninitialized in
this function

pdata is set by validate_ntransact()

Signed-off-by: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
---
 fs/cifs/cifssmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..56fac6c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3079,7 +3079,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 		__u32 parm_len;
 		__u32 acl_len;
 		struct smb_com_ntransact_rsp *pSMBr;
-		char *pdata;
+		char *uninitialized_var(pdata);
 
 /* validate_nttransact */
 		rc = validate_ntransact(iov[0].iov_base, (char **)&parm,
-- 
1.7.2
