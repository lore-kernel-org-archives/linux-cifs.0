From: Dan Aloni <dan@kernelim.com>
Subject: [PATCH] [CIFS] fix auth_key cleanup in SMB2_sess_setup() for possible crash
Date: Mon, 20 Oct 2014 18:00:05 +0300
Message-ID: <1413817205-6319-1-git-send-email-dan@kernelim.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The ses->auth_key.len field should be zeroed out during error paths,
along with the 'response' field.

Rationale:

It is possible with a specially crafted SMB2 server to cause the setup
to free the key but keep the session. When the session is recovered
(after a connection drop, for example), the following condition turn
out to be true:

     ses->auth_key.len != 0  &&  ses->auth_key.response == NULL

This will cause the following memcpy() in setup_ntlmv2_rsp() to GPF,
because tiblob == NULL and tilen != 0 (these are the old auth_key values):

     memcpy(ses->auth_key.response + baselen, tiblob, tilen);

As seen here (Fedora 20 kernel build 3.16.3-200.fc20.x86_64):

[985673.540019] BUG: unable to handle kernel NULL pointer dereference at           (null)
[985673.540049] IP: [<ffffffff8136b7a6>] memcpy+0x6/0x110
[...]
[985673.540957]  [<ffffffffa09d28e5>] ? setup_ntlmv2_rsp+0x235/0x9d0 [cifs]
[985673.540980]  [<ffffffffa09ccc8a>] ? cifs_small_buf_get+0x1a/0x30 [cifs]
[985673.541003]  [<ffffffffa09dfe05>] ? small_smb2_init+0x285/0x510 [cifs]
[985673.541025]  [<ffffffffa09d5331>] build_ntlmssp_auth_blob+0x91/0x290 [cifs]
[985673.541047]  [<ffffffffa09e06a0>] SMB2_sess_setup+0x1f0/0x590 [cifs]
[...]

Commit applies to 3.18-rc1 and various preceding stable versions.

Signed-off-by: Dan Aloni <dan@kernelim.com>
CC: Steve French <smfrench@gmail.com>
CC: linux-cifs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 fs/cifs/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8f1672bb82d5..e0304f258533 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -551,6 +551,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	kfree(ses->auth_key.response);
 	ses->auth_key.response = NULL;
+	ses->auth_key.len = 0;
 
 	/*
 	 * If memory allocation is successful, caller of this function
@@ -713,6 +714,7 @@ ssetup_exit:
 			rc = server->ops->generate_signingkey(ses);
 			kfree(ses->auth_key.response);
 			ses->auth_key.response = NULL;
+			ses->auth_key.len = 0;
 			if (rc) {
 				cifs_dbg(FYI,
 					"SMB3 session key generation failed\n");
@@ -737,6 +739,7 @@ keygen_exit:
 	if (!server->sign) {
 		kfree(ses->auth_key.response);
 		ses->auth_key.response = NULL;
+		ses->auth_key.len = 0;
 	}
 	kfree(ses->ntlmssp);
 
-- 
1.9.3
