From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Set UID in sess_auth_rawntlmssp_authenticate too
Date: Wed,  3 Dec 2014 12:26:36 +0000
Message-ID: <1417609596-23002-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A user complained that they were unable to login to their cifs share
after a kernel update. From the wiretrace we can see that the server
returns different UIDs as response to NTLMSSP_NEGOTIATE and NTLMSSP_AUTH
phases.

With changes in the authentication code, we no longer set the
cifs_sess->Suid returned in response to the NTLM_AUTH phase and continue
to use the UID sent in response to the NTLMSSP_NEGOTIATE phase. This
results in the server denying access to the user when the user attempts
to do a tcon connect.

A test kernel containing patch was tested successfully by the user.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 57db63f..446cb7f 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1303,6 +1303,11 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
 	if (le16_to_cpu(pSMB->resp.Action) & GUEST_LOGIN)
 		cifs_dbg(FYI, "Guest login\n"); /* BB mark SesInfo struct? */
 
+	if (ses->Suid != smb_buf->Uid) {
+		ses->Suid = smb_buf->Uid;
+		cifs_dbg(FYI, "UID changed! new UID = %llu\n", ses->Suid);
+	}
+
 	bytes_remaining = get_bcc(smb_buf);
 	bcc_ptr = pByteArea(smb_buf);
 	blob_len = le16_to_cpu(pSMB->resp.SecurityBlobLength);
-- 
2.1.0
