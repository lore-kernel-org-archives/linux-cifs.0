From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] SMB2: Enforce sec= mount option
Date: Thu,  8 Dec 2016 12:16:17 +0530
Message-ID: <1481179577-15995-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the security type specified using a mount option is not supported,
the SMB2 session setup code changes the security type to RawNTLMSSP. We
should instead fail the mount and return an error.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5ca5ea46..e66fad6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -955,7 +955,8 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 static int
 SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data *sess_data)
 {
-	if (ses->sectype != Kerberos && ses->sectype != RawNTLMSSP)
+	/* Default sec type is set to RawNTLMSSP */
+	if (ses->sectype == Unspecified)
 		ses->sectype = RawNTLMSSP;
 
 	switch (ses->sectype) {
-- 
2.7.4
