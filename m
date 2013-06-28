From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: fill TRANS2_QUERY_FILE_INFO ByteCount fields
Date: Fri, 28 Jun 2013 11:47:33 +0200
Message-ID: <1372412853-25917-1-git-send-email-ddiss@suse.de>
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently the trans2 ByteCount field is incorrectly left zero in
TRANS2_QUERY_FILE_INFO info_level=SMB_QUERY_FILE_ALL_INFO and
info_level=SMB_QUERY_FILE_UNIX_BASIC requests. The field should properly
reflect the FID, information_level and padding bytes carried in these
requests.

Leaving this field zero causes such requests to fail against Novell CIFS
servers. Other SMB servers (e.g. Samba) use the parameter count fields
for data length calculations instead, so do not suffer the same fate.

Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifssmb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a58dc77..efe794d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3940,6 +3940,7 @@ QFileInfoRetry:
 	pSMB->Pad = 0;
 	pSMB->Fid = netfid;
 	inc_rfc1001_len(pSMB, byte_count);
+	pSMB->t2.ByteCount = cpu_to_le16(byte_count);
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
@@ -4108,6 +4109,7 @@ UnixQFileInfoRetry:
 	pSMB->Pad = 0;
 	pSMB->Fid = netfid;
 	inc_rfc1001_len(pSMB, byte_count);
+	pSMB->t2.ByteCount = cpu_to_le16(byte_count);
 
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-- 
1.8.1.4
